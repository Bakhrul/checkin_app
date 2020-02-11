import 'dart:math' as math;
import 'dart:typed_data';
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';

import 'package:checkin_app/pages/management_checkin/generate_qrcode.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:checkin_app/utils/utils.dart';

var datepicker;

class ManajemeCreateCheckin extends StatefulWidget {
  final Checkin checkin;
  final String title;
  final idevent;

  ManajemeCreateCheckin({Key key, this.title, this.checkin, this.idevent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateCheckinState();
  }
}

class _ManajemeCreateCheckinState extends State<ManajemeCreateCheckin> {
  bool _isLoading = false;
  GlobalKey globalKey = new GlobalKey();
  String _dataString;
  String _inputErrorText;
  final TextEditingController _controllerGenerate = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController _controllerTimeStart = TextEditingController();
  TextEditingController _controllerTimeEnd = TextEditingController();
  TextEditingController _controllerSessionname = TextEditingController();
  bool inside = false;
  Uint8List imageInMemory;
  DateTime timeReplacement;
  randomNumberGenerator() {
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 10000;
    while (next < 1000) {
      next *= 10;
    }
    return _dataString = next.toInt().toString();
  }

  //  getDataChekinId() async {
  //   listPeserta = [];
  //   dynamic response =
  //       await RequestGet(name: "checkin/getdata/getcodeqr/", customrequest: "${widget.idevent.toString()}")
  //           .getdata();
  //           _dataString = response.toString();

  //           print(_dataString);
  // }
  void timeSetToMinute() {
    var time = DateTime.now();
    var newHour = 0;
    var newMinute = 0;
    var newSecond = 0;
    time = time.toLocal();
    timeReplacement = new DateTime(time.year, time.month, time.day, newHour,
        newMinute, newSecond, time.millisecond, time.microsecond);
  }

  postDataCheckin() async {
    _isLoading = true;
    dynamic body = {
      "event_id": widget.idevent.toString(),
      "checkin_keyword": _controllerGenerate.text.toString(),
      "chekin_id": _dataString,
      "start_time": _controllerTimeStart.text.toString(),
      "end_time": _controllerTimeEnd.text.toString(),
      "session_name": _controllerSessionname.text.toString(),
      "types": "S"
    };

    dynamic response =
        await RequestPost(name: "checkin/postdata/checkinreguler", body: body)
            .sendrequest();

    print(response);
    if (response != 'gagal' && response != "tanggal kurang") {
      Fluttertoast.showToast(
          msg: "Sukses",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green[100],
          textColor: Colors.white,
          fontSize: 16.0);

      _isLoading = false;
      var codeQr = response['checkin'];
      var eventName = response['event'];
      var checkinCode = response['keyword'];
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GenerateScreen(
                  idEvent: widget.idevent,
                  codeQr: codeQr,
                  eventName: eventName,
                  checkinKeyword: checkinCode)));
    } else if (response == "tanggal kurang") {
      _isLoading = false;
      Fluttertoast.showToast(
          msg: "Checkin pada waktu tersebut sudah ada, mohon gunakan lainnya",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      _isLoading = false;
      Fluttertoast.showToast(
          msg: "Terjadi Kesalahan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    timeSetToMinute();
    datepicker = FocusNode();
    super.initState();
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
            "Buat CheckIn Sekarang",
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
                _isLoading == true
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
                    Icons.brightness_1,
                    color: Color.fromRGBO(41, 30, 47, 1),
                  ),
                  title: TextField(
                    controller: _controllerSessionname,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nama Sesi',
                        errorText: _inputErrorText,
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                )),
                Card(
                    child: ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: Color.fromRGBO(41, 30, 47, 1),
                        ),
                        title: _buildTextFieldTimeStart())),
                Card(
                    child: ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: Color.fromRGBO(41, 30, 47, 1),
                        ),
                        title: _buildTextFieldTimeEnd())),
                Card(
                    child: ListTile(
                  leading: Icon(
                    Icons.create,
                    color: Color.fromRGBO(41, 30, 47, 1),
                  ),
                  title: TextField(
                    controller: _controllerGenerate,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Kata Kunci',
                        errorText: _inputErrorText,
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                )),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isLoading == true
              ? null
              : () {
                  setState(() => _isLoading = true);
                  if (_controllerSessionname.text == '' ||
                      _controllerSessionname.text == null) {
                    Fluttertoast.showToast(msg: "Nama sesi tidak boleh kosong");
                    setState(() {
                      _isLoading = false;
                    });
                  } else if (_controllerTimeStart.text == '' ||
                      _controllerTimeStart.text == null) {
                    Fluttertoast.showToast(
                        msg:
                            "Tanggal berlangsungnya checkin tidak boleh kosong");
                    setState(() {
                      _isLoading = false;
                    });
                  } else if (_controllerTimeEnd.text == '' ||
                      _controllerTimeEnd.text == null) {
                    Fluttertoast.showToast(
                        msg: "Tanggal berakhirnya checkin tidak boleh kosong");
                    setState(() {
                      _isLoading = false;
                    });
                  } else if (_controllerGenerate.text == '' ||
                      _controllerGenerate.text == null) {
                    Fluttertoast.showToast(
                        msg: "Keyword checkin tidak boleh kosong");
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    randomNumberGenerator();
                    postDataCheckin();
                  }
                },
          child: Icon(Icons.check),
          backgroundColor: primaryAppBarColor,
        ));
  }

  Widget _buildTextFieldTimeEnd() {
    return DateTimeField(
      controller: _controllerTimeEnd,
      format: format,
      readOnly: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Tanggal Berakhirnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
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
                TimeOfDay.fromDateTime(currentValue ?? timeReplacement),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget _buildTextFieldTimeStart() {
    return DateTimeField(
      controller: _controllerTimeStart,
      format: format,
      readOnly: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Tanggal Berlangsungnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
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
                TimeOfDay.fromDateTime(currentValue ?? timeReplacement),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }
}
