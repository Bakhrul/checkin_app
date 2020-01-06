import 'package:checkin_app/pages/events_personal/create.dart';
import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'dart:convert';
import 'manage_checkin.dart';
import 'package:checkin_app/storage/storage.dart';

TextEditingController _namacheckinController = new TextEditingController();
TextEditingController _kodecheckinController = new TextEditingController();
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
var firstdate, lastdate, _tanggalawal, _tanggalakhir;

class ManajemenTambahCheckin extends StatefulWidget {
  ManajemenTambahCheckin({Key key, this.title, this.event}) : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeTambahCheckinState();
  }
}

class _ManajemeTambahCheckinState extends State<ManajemenTambahCheckin> {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  void initState() {
    firstdate = FocusNode();
    lastdate = FocusNode();
    _namacheckinController.text = '';
    _kodecheckinController.text = '';
    _tanggalawal = 'kosong';
    getHeaderHTTP();
    _tanggalakhir = 'kosong';
    super.initState();
  }
  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);
  }

  void dispose() {
    super.dispose();
  }

  void _tambahcheckin() async {
    if (_namacheckinController.text == null ||
        _namacheckinController.text == '') {
      Fluttertoast.showToast(msg: "Nama Checkin Tidak Boleh Kosong");
    } else if (_kodecheckinController.text == null ||
        _kodecheckinController.text == '') {
      Fluttertoast.showToast(msg: "Kode Unik Checkin Tidak Boleh Kosong");
    } else if (_tanggalawal == 'kosong') {
      Fluttertoast.showToast(msg: "Waktu Awal Checkin Tidak Boleh Kosong");
    } else if (_tanggalakhir == 'kosong') {
      Fluttertoast.showToast(msg: "Waktu Akhir Checkin Tidak Boleh Kosong");
    } else {
      formSerialize = Map<String, dynamic>();
      formSerialize['event'] = null;
      formSerialize['namacheckin'] = null;
      formSerialize['keyword'] = null;
      formSerialize['typecheckin'] = null;
      formSerialize['time_start'] = null;
      formSerialize['time_end'] = null;

      formSerialize['event'] = widget.event;
      formSerialize['namacheckin'] = _namacheckinController.text;
      formSerialize['keyword'] = _kodecheckinController.text;
      formSerialize['typecheckin'] = 'T';
      formSerialize['time_start'] = _tanggalawal == 'kosong'
          ? null
          : DateFormat('dd-MM-y HH:mm:ss').format(DateTime.parse(_tanggalawal));
      formSerialize['time_end'] = _tanggalawal == 'kosong'
          ? null
          : DateFormat('dd-MM-y HH:mm:ss').format(DateTime.parse(_tanggalawal));

      print(formSerialize);

      Map<String, dynamic> requestHeadersX = requestHeaders;

      requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
      try {
        final response = await http.post(
          url('api/create_checkinevent'),
          headers: requestHeadersX,
          body: {
            'type_platform': 'android',
            'data': jsonEncode(formSerialize),
          },
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == 200) {
          dynamic responseJson = jsonDecode(response.body);
          if (responseJson['status'] == 'success') {
            Fluttertoast.showToast(msg: "Berhasil Membuat Checkin");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageCheckin(event: widget.event)));
          }
          print('response decoded $responseJson');
        } else {
          print('${response.body}');
          Fluttertoast.showToast(
              msg: "Gagal Menambahkan Event, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        Fluttertoast.showToast(msg: "Timed out, Try again");
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Buat Checkin Sekarang",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  controller: _namacheckinController,
                  decoration: InputDecoration(
                      hintText: 'Nama Checkin',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.access_time,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: DateTimeField(
                  decoration: InputDecoration(
                    hintText: 'Waktu Awal dimulainya checkin',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  readOnly: true,
                  format: format,
                  focusNode: firstdate,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  onChanged: (ini) {
                    setState(() {
                      _tanggalawal = ini == null ? 'kosong' : ini.toString();
                    });
                  },
                ),
              )),
              Card(
                  child: ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                      title: DateTimeField(
                        decoration: InputDecoration(
                          hintText: 'Waktu Akhir Checkin',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        readOnly: true,
                        format: format,
                        focusNode: lastdate,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                        onChanged: (ini) {
                          setState(() {
                            _tanggalakhir =
                                ini == null ? 'kosong' : ini.toString();
                          });
                        },
                      ))),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  controller: _kodecheckinController,
                  decoration: InputDecoration(
                      hintText: 'KODE UNIK CHECKIN',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_namacheckinController.text == null ||
              _namacheckinController.text == '') {
            Fluttertoast.showToast(msg: "Nama Checkin Tidak Boleh Kosong");
          } else if (_kodecheckinController.text == null ||
              _kodecheckinController.text == '') {
            Fluttertoast.showToast(msg: "Kode Unik Checkin Tidak Boleh Kosong");
          } else if (_tanggalawal == 'kosong') {
            Fluttertoast.showToast(
                msg: "Waktu Awal Checkin Tidak Boleh Kosong");
          } else if (_tanggalakhir == 'kosong') {
            Fluttertoast.showToast(
                msg: "Waktu Akhir Checkin Tidak Boleh Kosong");
          } else {
            _tambahcheckin();
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }
}