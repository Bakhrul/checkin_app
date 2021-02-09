import 'package:checkin_app/pages/events_personal/create_event-information.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'dart:convert';
import 'manage_checkin.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'package:checkin_app/utils/utils.dart';

TextEditingController _namacheckinController = new TextEditingController();
TextEditingController _kodecheckinController = new TextEditingController();

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
var firstdate, lastdate, _tanggalawal, _tanggalakhir;

class ManajemenTambahCheckin extends StatefulWidget {
  ManajemenTambahCheckin({Key key, this.title, this.event, this.namaEvent})
      : super(key: key);
  final String title, event;
  final String namaEvent;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeTambahCheckinState();
  }
}

class _ManajemeTambahCheckinState extends State<ManajemenTambahCheckin> {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  ProgressDialog progressApiAction;
  DateTime timeReplacement;
  @override
  void initState() {
    firstdate = FocusNode();
    lastdate = FocusNode();
    _namacheckinController.text = '';
    _kodecheckinController.text = '';
    _tanggalawal = 'kosong';
    getHeaderHTTP();
    timeSetToMinute();
    _tanggalakhir = 'kosong';
    super.initState();
  }

  void timeSetToMinute() {
    var time = DateTime.now();
    var newHour = 0;
    var newMinute = 0;
    var newSecond = 0;
    time = time.toLocal();
    timeReplacement = new DateTime(time.year, time.month, time.day, newHour,
        newMinute, newSecond, time.millisecond, time.microsecond);
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
    timeSetToMinute();
    super.dispose();
  }

  void _tambahcheckin() async {
    if (_namacheckinController.text == null ||
        _namacheckinController.text == '') {
      Fluttertoast.showToast(msg: "Nama Checkin Tidak Boleh Kosong");
    } else if (_kodecheckinController.text == null ||
        _kodecheckinController.text == '') {
      Fluttertoast.showToast(msg: "Kata Kunci Checkin Tidak Boleh Kosong");
    } else if (_tanggalawal == 'kosong') {
      Fluttertoast.showToast(msg: "Waktu Awal Checkin Tidak Boleh Kosong");
    } else if (_tanggalakhir == 'kosong') {
      Fluttertoast.showToast(msg: "Waktu Akhir Checkin Tidak Boleh Kosong");
    } else {
      await progressApiAction.show();
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
      formSerialize['typecheckin'] = 'S';
      formSerialize['time_start'] = _tanggalawal == 'kosong'
          ? null
          : DateFormat('dd-MM-y HH:mm:ss').format(DateTime.parse(_tanggalawal));
      formSerialize['time_end'] = _tanggalakhir == 'kosong'
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalakhir));

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
            progressApiAction.hide().then((isHidden) {
              print(isHidden);
            });
            Fluttertoast.showToast(msg: "Berhasil");
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageCheckin(
                        event: widget.event, namaEvent: widget.namaEvent)));
          } else if (responseJson['status'] == 'keywordsudahdigunakan') {
            progressApiAction.hide().then((isHidden) {
              print(isHidden);
            });
            Fluttertoast.showToast(
                msg:
                    "kode unik sudah digunakan, mohon gunakan kode unik yang lain");
          } else if (responseJson['status'] == 'tanggalkurang') {
            progressApiAction.hide().then((isHidden) {
              print(isHidden);
            });
            Fluttertoast.showToast(
                msg:
                    "Waktu berlangsungnya checkin tersebut sudah ada, mohon gunakan lainnya");
          }
          print('response decoded $responseJson');
        } else {
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
          print('${response.body}');
          Fluttertoast.showToast(
              msg: "Gagal Menambahkan Checkin, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        Fluttertoast.showToast(msg: "Timed out, Try again");
      } catch (e) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    progressApiAction = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressApiAction.style(
        message: 'Tunggu Sebentar...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: primaryAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Tambah Checkin Event ${widget.namaEvent}",
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
              isCreate == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: 20.0,
                            margin: EdgeInsets.all(15.0),
                            height: 20.0,
                            child: CircularProgressIndicator()),
                      ],
                    )
                  : Container(),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  controller: _namacheckinController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
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
                    border: InputBorder.none,
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
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(timeReplacement),
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
                          border: InputBorder.none,
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
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(timeReplacement),
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
                      border: InputBorder.none,
                      hintText: 'Kata Kunci',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _tambahcheckin();
        },
        child: Icon(Icons.check),
        backgroundColor: primaryButtonColor,
      ),
    );
  }
}
