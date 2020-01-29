import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'dart:convert';
import 'manage_checkin.dart';
import 'package:checkin_app/storage/storage.dart';

import 'package:checkin_app/utils/utils.dart';

GlobalKey<ScaffoldState> _scaffoldKeyeditcheckin;
Map<String, dynamic> formSerialize;
TextEditingController _namacheckinController = new TextEditingController();
TextEditingController _kodecheckinController = new TextEditingController();
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
var firstdate, lastdate, _tanggalawal, _tanggalakhir;
var datepicker;
bool isUpdate;
void showInSnackBar(String value) {
  _scaffoldKeyeditcheckin.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeEditCheckin extends StatefulWidget {
  ManajemeEditCheckin(
      {Key key,
      this.title,
      this.event,
      this.namacheckin,
      this.idcheckin,
      this.kodecheckin,
      this.timestart,
      this.typecheckin,
      this.timeend})
      : super(key: key);
  final String title,
      event,
      idcheckin,
      timestart,
      timeend,
      namacheckin,
      typecheckin,
      kodecheckin;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeEditCheckinState();
  }
}

class _ManajemeEditCheckinState extends State<ManajemeEditCheckin> {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  void initState() {
    _scaffoldKeyeditcheckin = GlobalKey<ScaffoldState>();
    firstdate = FocusNode();
    lastdate = FocusNode();
    getHeaderHTTP();
    isUpdate = false;
    _namacheckinController.text = widget.namacheckin;
    _kodecheckinController.text = widget.kodecheckin;
    print(widget.namacheckin);
    _tanggalawal = widget.timestart == 'kosong' ||
            widget.timestart == '' ||
            widget.timestart == null
        ? DateTime.now()
        : widget.timestart;
    _tanggalakhir = widget.timeend == 'kosong' ||
            widget.timeend == '' ||
            widget.timeend == null
        ? DateTime.now()
        : widget.timeend;
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

  void _updatecheckin() async {
    if (_namacheckinController.text == null ||
        _namacheckinController.text == '') {
      Fluttertoast.showToast(msg: "Nama Checkin Tidak Boleh Kosong");
      setState(() {
        isUpdate = false;
      });
    } else if (_kodecheckinController.text == null ||
        _kodecheckinController.text == '') {
      Fluttertoast.showToast(msg: "Kode Unik Checkin Tidak Boleh Kosong");
      setState(() {
        isUpdate = false;
      });
    } else if (_tanggalawal == 'kosong' ||
        _tanggalawal == '' ||
        _tanggalawal == null) {
      Fluttertoast.showToast(msg: "Waktu Awal Checkin Tidak Boleh Kosong");
      setState(() {
        isUpdate = false;
      });
    } else if (_tanggalakhir == 'kosong' ||
        _tanggalakhir == '' ||
        _tanggalakhir == null) {
      Fluttertoast.showToast(msg: "Waktu Akhir Checkin Tidak Boleh Kosong");
      setState(() {
        isUpdate = false;
      });
    } else {
      formSerialize = Map<String, dynamic>();
      formSerialize['event'] = null;
      formSerialize['namacheckin'] = null;
      formSerialize['checkin'] = null;
      formSerialize['keyword'] = null;
      formSerialize['typecheckin'] = null;
      formSerialize['time_start'] = null;
      formSerialize['time_end'] = null;

      formSerialize['event'] = widget.event;
      formSerialize['checkin'] = widget.idcheckin;
      formSerialize['namacheckin'] = _namacheckinController.text;
      formSerialize['keyword'] = _kodecheckinController.text;
      formSerialize['typecheckin'] = widget.typecheckin;
      formSerialize['time_start'] = widget.timestart == 'kosong' ||
              widget.timestart == null ||
              widget.timestart == ''
          ? null
          : DateFormat('dd-MM-y HH:mm:ss').format(DateTime.parse(_tanggalawal));
      formSerialize['time_end'] = widget.timeend == 'kosong' ||
              widget.timeend == null ||
              widget.timeend == ''
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalakhir));

      print(formSerialize);

      Map<String, dynamic> requestHeadersX = requestHeaders;

      requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
      try {
        final response = await http.post(
          url('api/updatecheckin_event'),
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
            Fluttertoast.showToast(msg: "Berhasil Update Data Checkin");
            setState(() {
              isUpdate = false;
            });
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageCheckin(event: widget.event)));
          } else if (responseJson['status'] == 'keywordsudahdigunakan') {
            setState(() {
              isUpdate = false;
            });
            Fluttertoast.showToast(
                msg:
                    "kode unik sudah digunakan, mohon gunakan kode unik yang lain");
          }
          print('response decoded $responseJson');
        } else {
          print('${response.body}');
          Fluttertoast.showToast(
              msg: "Gagal Update Checkin, Silahkan Coba Kembali");
          setState(() {
            isUpdate = false;
          });
        }
      } on TimeoutException catch (_) {
        Fluttertoast.showToast(msg: "Timed out, Try again");
        setState(() {
          isUpdate = false;
        });
      } catch (e) {
        setState(() {
          isUpdate = false;
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyeditcheckin,
      appBar: new AppBar(
        backgroundColor: primaryAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Edit Checkin Sekarang",
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
                  initialValue: widget.timestart == 'kosong' ||
                          widget.timestart == '' ||
                          widget.timestart == null
                      ? null
                      : DateTime.parse(widget.timestart),
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
                        initialValue: widget.timeend == 'kosong' ||
                                widget.timeend == '' ||
                                widget.timeend == null
                            ? null
                            : DateTime.parse(widget.timeend),
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
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: primaryButtonColor,
                    textColor: Colors.white,
                    disabledColor: primaryButtonColor,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.blueAccent,
                    onPressed: isUpdate == true
                        ? null
                        : () async {
                            setState(() {
                              isUpdate = true;
                            });
                            _updatecheckin();
                          },
                    child: isUpdate == true
                        ? Container(
                            width: 25.0,
                            height: 25.0,
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white)))
                        : Text(
                            'Update data checkin',
                            style: TextStyle(fontSize: 14.0),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 10.0, right: 10.0, bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.white,
                    textColor: Color.fromRGBO(41, 30, 47, 1),
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.green[400],
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Batal update data checkin",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
