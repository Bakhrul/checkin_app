import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:checkin_app/api/checkin_service.dart';
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/pages/management_checkin/dashboard_checkin.dart';
import 'package:checkin_app/pages/management_checkin/direct_checkin.dart';
import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

var datepicker;

class ManajemeCreateCheckin extends StatefulWidget {
  Checkin checkin;
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
  UserCheckinService _checkinService = UserCheckinService();
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;
  GlobalKey globalKey = new GlobalKey();
  var ui;
  String _dataString;
  String _inputErrorText;
  bool _isFieldDateValid;
  bool _isFieldTimeStartlValid;
  bool _isFieldTimeEndValid;
  final TextEditingController _controllerGenerate = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _controllerTimeStart = TextEditingController();
  TextEditingController _controllerTimeEnd = TextEditingController();
  TextEditingController _controllerSessionname = TextEditingController();

   getDataChekinId() async {
    listPeserta = [];
    dynamic response =
        await RequestGet(name: "checkin/getdata/getcodeqr/", customrequest: "${widget.idevent.toString()}")
            .getdata();
            _dataString = response.toString();

            print(_dataString);
  }

  postDataCheckin() async {
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
    if (response == "success") {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => DashboardCheckin(idevent: widget.idevent,)));
    }
  }

  @override
  void initState() {
    // _scaffoldKeycreatecheckin = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
    if (widget.checkin != null) {
      _isFieldDateValid = true;
      // _controllerDate.text = widget.checkin.checkin_date;
      // _isFieldEmailValid = true;
      // _controllerEmail.text = widget.profile.email;
      // _isFieldAgeValid = true;
      // _controllerAge.text = widget.profile.age.toString();
    }
    // postDataCheckin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      // key: _scaffoldKeycreatecheckin,
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
                  Icons.brightness_1,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  controller: _controllerSessionname,
                  decoration: InputDecoration(
                      hintText: 'Nama Sesi',
                      errorText: _inputErrorText,
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              // Card(
              //     child: ListTile(
              //         leading: Icon(
              //           Icons.date_range,
              //           color: Color.fromRGBO(41, 30, 47, 1),
              //         ),
              //         title: _buildTextFieldDateCheckin())),
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
                        Icons.timeline,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                      title: _buildTextFieldTimeEnd())),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                trailing: FlatButton(
                  child: Text("SUBMIT"),
                  textColor: Colors.green,
                  color: Color.fromRGBO(220, 237, 193, 99),
                  onPressed: () {
                    setState(() {
                      var uuid = new Uuid();
                      // _dataString =
                          // uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
                      getDataChekinId();
                      print(_dataString);
                      _inputErrorText = null;
                    });
                  },
                ),
                title: TextField(
                  controller: _controllerGenerate,
                  decoration: InputDecoration(
                      hintText: 'Keyword',
                      errorText: _inputErrorText,
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: _builderGenerate(bodyHeight),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _isLoading = true);
          postDataCheckin();
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }

  Widget _buildTextFieldTimeEnd() {
    return DateTimeField(
      controller: _controllerTimeEnd,
      format: format,
      decoration: InputDecoration(
        hintText: 'Tanggal Berakhirnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
      onShowPicker: (context, currentValue) async {
         final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
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
      decoration: InputDecoration(
        hintText: 'Tanggal Berlangsungnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget _builderGenerate(bodyHeight) {
    if (_dataString != null) {
      return Column(
        children: <Widget>[
RepaintBoundary(
        key: globalKey,
        child: QrImage(
          data: _dataString,
          size: 0.5 * bodyHeight,
          // onError: (ex) {
          //   print("[QR] ERROR - $ex");
          //   setState((){
          //     _inputErrorText = "Error! Maybe your input value is too long?";
          //   });
          // },
        ),

      ),
      RaisedButton(
        child: Text("shared"),
        onPressed: () {
          toQrImageData("hj");
        },
      )
        ],
      );
      
    } else {
      return RepaintBoundary(
          child: Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DirectCheckin(idevent: widget.idevent)));
                },
                child: Text("Direct Checkin"),
              ))
        ],
      ));
    }
  }

Future<Uint8List> toQrImageData(String text) async {
  try {
    final image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.cyan,
      emptyColor: Colors.green,
    ).toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return a.buffer.asUint8List();
  } catch (e) {
    throw e;
  }
}


}
// =========================================================================
