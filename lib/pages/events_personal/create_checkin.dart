import 'package:checkin_app/pages/events_personal/create_event-information.dart';
import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'model.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';

import 'create_event-checkin.dart';
import 'package:checkin_app/utils/utils.dart';

bool isSame, isBottomDate, isCreate;
TextEditingController _namacheckinController = new TextEditingController();
TextEditingController _kodecheckinController = new TextEditingController();
var firstdate, lastdate, _tanggalawal, _tanggalakhir;
String tokenType, accessToken;

Map<String, String> requestHeaders = Map();

class ManajemeCreateCheckin extends StatefulWidget {
  ManajemeCreateCheckin({Key key, this.title, this.event, this.listCheckinadd})
      : super(key: key);
  final String title, event;
  final listCheckinadd;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateCheckinState();
  }
}

class _ManajemeCreateCheckinState extends State<ManajemeCreateCheckin> {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime timeReplacement;
  @override
  void initState() {
    firstdate = FocusNode();
    lastdate = FocusNode();
    isSame = false;
    isBottomDate = false;
    isCreate = false;
    isDelete = false;
    _namacheckinController.text = '';
    _kodecheckinController.text = '';
    _tanggalawal = 'kosong';
    _tanggalakhir = 'kosong';
    timeSetToMinute();
    getHeaderHTTP();
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

  void timeSetToMinute() {
    var timeNow = DateTime.now();
    var timeString = timeNow.toString();
    var minutes = timeNow.minute;
    var hours = timeNow.hour;
    timeReplacement =
        DateTime.parse(timeString.replaceAll("$hours:$minutes:", "00:00:"));
        print(timeReplacement);
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: primaryAppBarColor,
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
              isCreate == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: 15.0,
                            margin: EdgeInsets.only(top: 10.0, right: 15.0),
                            height: 15.0,
                            child: CircularProgressIndicator()),
                      ],
                    )
                  : Container(),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.create,
                ),
                title: TextField(
                  controller: _namacheckinController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nama CheckIn',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.access_time,
                ),
                title: DateTimeField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Waktu Awal Dimulainya CheckIn',
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
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? timeReplacement),
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
                      ),
                      title: DateTimeField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Waktu Akhir CheckIn',
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
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? timeReplacement),
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
                ),
                title: TextField(
                  controller: _kodecheckinController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'KODE UNIK CHECKIN',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isCreate == true ? null : () async {
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
            if (isSame == true) {
              Fluttertoast.showToast(msg: 'Kode Unik Checkin Tidak Boleh Sama');
              setState(() {
                isSame = false;
              });
            } else {
              _tambahCheckin(
                  _namacheckinController.text,
                  _kodecheckinController.text,
                  DateFormat('dd-MM-y HH:mm:ss')
                      .format(DateTime.parse(_tanggalawal)),
                  DateFormat('dd-MM-y HH:mm:ss')
                      .format(DateTime.parse(_tanggalakhir)));
            }
          }
        },
        child: Icon(Icons.check),
        backgroundColor: primaryButtonColor,
      ),
    );
  }

  void _tambahCheckin(
      nama, kode, tanggalawalCheckin, tanggalakhirCheckin) async {
    setState(() {
      isCreate = true;
    });
    Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
    formSerialize = Map<String, dynamic>();
    formSerialize['event'] = null;
    formSerialize['checkin'] = null;
    formSerialize['keyword'] = null;
    formSerialize['timestartcheckin'] = null;
    formSerialize['timeendcheckin'] = null;

    formSerialize['typeinformasi'] = null;
    formSerialize['typekategori'] = null;
    formSerialize['typeadmin'] = null;
    formSerialize['typecheckin'] = null;

    formSerialize['event'] = widget.event == null || widget.event == ''
        ? null
        : widget.event.toString();
    formSerialize['checkin'] = nama;
    formSerialize['keyword'] = kode;
    formSerialize['timestartcheckin'] = tanggalawalCheckin;
    formSerialize['timeendcheckin'] = tanggalakhirCheckin;
    formSerialize['typecheckin'] = 'checkin';

    print(formSerialize);

    Map<String, dynamic> requestHeadersX = requestHeaders;

    requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
    try {
      final response = await http.post(
        url('api/createcheckin'),
        headers: requestHeadersX,
        body: {
          'type_platform': 'android',
          'data': jsonEncode(formSerialize),
        },
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        print(responseJson);
        String idEventFromDB = responseJson['finalidevent'].toString();
        if (responseJson['status'] == 'success') {
          setState(() {
            idEventFinalX = idEventFromDB;
            isCreate = false;
          });
          setState(() {
            ListCheckinAdd notax = ListCheckinAdd(
              nama: nama,
              keyword: kode,
              timestart: tanggalawalCheckin,
              timeend: tanggalakhirCheckin,
            );
            listcheckinAdd.add(notax);
          });
          Navigator.pop(context);
        } else if (responseJson['status'] == 'keywordsudahdigunakan') {
          setState(() {
            isCreate = false;
          });
          Fluttertoast.showToast(
              msg:
                  "kode unik sudah digunakan, mohon gunakan kode unik yang lain");
        } else if (responseJson['status'] == 'tanggalkurang') {
          setState(() {
            isCreate = false;
          });
          Fluttertoast.showToast(
              msg:
                  "Waktu berlangsungnya checkin tersebut sudah ada, mohon gunakan lainnya");
        }
      } else {
        print('${response.body}');
        Fluttertoast.showToast(
            msg: "Gagal Menambahkan Checkin, Silahkan Coba Kembali");
        setState(() {
          isCreate = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time Out, Try Again");
      setState(() {
        isCreate = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Menambahkan Checkin, Silahkan Coba Kembali");
      setState(() {
        isCreate = false;
      });
      print(e);
    }
  }
}
