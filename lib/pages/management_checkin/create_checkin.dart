import 'package:checkin_app/api/checkin_service.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/pages/management_checkin/test.dart';
import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'generate_qrcode.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreatecheckin;
var datepicker;
void showInSnackBar(String value) {
  _scaffoldKeycreatecheckin.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeCreateCheckin extends StatefulWidget {
  Checkin checkin;
  final String title;
  ManajemeCreateCheckin({Key key, this.title, this.checkin}) : super(key: key);

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
  String _dataString;
  String _inputErrorText;
  bool _isFieldDateValid;
  bool _isFieldTimeStartlValid;
  bool _isFieldTimeEndValid;
  final TextEditingController _textController = TextEditingController();
  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _controllerTimeStart = TextEditingController();
  TextEditingController _controllerTimeEnd = TextEditingController();

  @override
  void initState() {
    _scaffoldKeycreatecheckin = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
        if (widget.checkin != null) {
      _isFieldDateValid = true;
      // _controllerDate.text = widget.checkin.checkin_date;
      // _isFieldEmailValid = true;
      // _controllerEmail.text = widget.profile.email;
      // _isFieldAgeValid = true;
      // _controllerAge.text = widget.profile.age.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeycreatecheckin,
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
                        Icons.date_range,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                      title: _buildTextFieldDateCheckin())),
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
                      _dataString = _textController.text;
                      _inputErrorText = null;
                    });
                  },
                ),
                title: TextField(
                  controller: _textController,
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
          String dateCheckin = _controllerDate.text.toString();
          String timeStart = _controllerTimeStart.text.toString();
          String timeEnd = _controllerTimeEnd.text.toString();
          String keyword = "_controllerEmail.text.toString()";
          // int age = int.parse(_controllerAge.text.toString());
          // Checkin checkin = Checkin(
          //     checkin_key: keyword,
          //     checkin_date: dateCheckin,
          //     start_time: timeStart,
          //     end_time: timeEnd);

            // print(widget.checkin);
            // if (widget.checkin == null) {
            //   _checkinService.createCheckin(checkin).then( ( isSuccess ) {
            //     setState(() => _isLoading = false);
            //     // print(_scaffoldKeycreatecheckin.currentState.context);
            //     if (isSuccess) {
            //       Navigator.pop(_scaffoldKeycreatecheckin.currentState.context);
            //     } else {
            //       _scaffoldKeycreatecheckin.currentState.showSnackBar(SnackBar(
            //         content: Text("Submit data failed"),
            //       ));
            //     }
            //   });
            // }
          
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }

  Widget _buildTextFieldTimeEnd() {
    return DateTimeField(
      controller: _controllerTimeEnd,
      format: DateFormat("HH:mm:ss"),
      decoration: InputDecoration(
        hintText: 'Jam Berakhirnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },
    );
  }

  Widget _buildTextFieldTimeStart() {
    return DateTimeField(
      controller: _controllerTimeStart,
      format: DateFormat("HH:mm:ss"),
      decoration: InputDecoration(
        hintText: 'Jam Berlangsungnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },
    );
  }

  Widget _buildTextFieldDateCheckin() {
    return DateTimeField(
        controller: _controllerDate,
        readOnly: true,
        format: DateFormat('dd-MM-yyy'),
        focusNode: datepicker,
        decoration: InputDecoration(
          hintText: 'Tanggal Berlangsungnya Checkin',
          hintStyle: TextStyle(fontSize: 13, color: Colors.black),
          errorText: _isFieldDateValid == null || _isFieldDateValid
              ? null
              : "Date is required",
        ),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              firstDate: DateTime.now(),
              context: context,
              initialDate: DateTime.now(),
              lastDate: DateTime(2100));
        },
        onChanged: (value) {
          bool isFieldValid = value.toString().trim().isNotEmpty;
          if (isFieldValid != _isFieldDateValid) {
            setState(() => _isFieldDateValid = isFieldValid);
          }
        }
        // onChanged: (ini) {},
        );
  }

  // Widget _buildTextFieldName() {
  //   return TextField(
  //     controller: _controllerName,
  //     keyboardType: TextInputType.text,
  //     decoration: InputDecoration(
  //       labelText: "Full name",
  //       errorText: _isFieldNameValid == null || _isFieldNameValid
  //           ? null
  //           : "Full name is required",
  //     ),
  //     onChanged: (value) {
  //       bool isFieldValid = value.trim().isNotEmpty;
  //       if (isFieldValid != _isFieldNameValid) {
  //         setState(() => _isFieldNameValid = isFieldValid);
  //       }
  //     },
  //   );
  // }

  // Widget _buildTextFieldEmail() {
  //   return TextField(
  //     controller: _controllerEmail,
  //     keyboardType: TextInputType.emailAddress,
  //     decoration: InputDecoration(
  //       labelText: "Email",
  //       errorText: _isFieldEmailValid == null || _isFieldEmailValid
  //           ? null
  //           : "Email is required",
  //     ),
  //     onChanged: (value) {
  //       bool isFieldValid = value.trim().isNotEmpty;
  //       if (isFieldValid != _isFieldEmailValid) {
  //         setState(() => _isFieldEmailValid = isFieldValid);
  //       }
  //     },
  //   );
  // }

  // Widget _buildTextFieldAge() {
  //   return TextField(
  //     controller: _controllerAge,
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //       labelText: "Age",
  //       errorText: _isFieldAgeValid == null || _isFieldAgeValid
  //           ? null
  //           : "Age is required",
  //     ),
  //     onChanged: (value) {
  //       bool isFieldValid = value.trim().isNotEmpty;
  //       if (isFieldValid != _isFieldAgeValid) {
  //         setState(() => _isFieldAgeValid = isFieldValid);
  //       }
  //     },
  //   );
  // }

  Widget _builderGenerate(bodyHeight) {
    if (_dataString != null) {
      return RepaintBoundary(
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
      );
    } else {
      return RepaintBoundary(
          child: Text("Buatlah Keyword Untuk Mendapatkan Kode Qr"));
    }
  }
}
