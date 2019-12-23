import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

GlobalKey<ScaffoldState> _scaffoldKeyeditcheckin;
var datepicker;
void showInSnackBar(String value) {
  _scaffoldKeyeditcheckin.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeEditCheckin extends StatefulWidget {
  ManajemeEditCheckin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeEditCheckinState();
  }
}

class _ManajemeEditCheckinState extends State<ManajemeEditCheckin> {
  @override
  void initState() {
    _scaffoldKeyeditcheckin = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyeditcheckin,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
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
                leading: Icon(Icons.date_range, color: Color.fromRGBO(41, 30, 47, 1),),
                title: DateTimeField(
                  readOnly: true,
                  format: DateFormat('dd-MM-yyy'),
                  focusNode: datepicker,
                  decoration: InputDecoration(
                    hintText: 'Tanggal Berlangsungnya Checkin',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        firstDate: DateTime.now(),
                        context: context,
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  onChanged: (ini) {},
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.access_time, color: Color.fromRGBO(41, 30, 47, 1),),
                title: DateTimeField(
                  format: DateFormat("HH:mm"),
                  decoration: InputDecoration(
                    hintText: 'Jam Berlangsungnya CheckIn',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.timeline, color: Color.fromRGBO(41, 30, 47, 1),),
                title: TextField(
                  decoration: InputDecoration(
                      hintText: 'Durasi Checkin ( Menit )',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.create, color: Color.fromRGBO(41, 30, 47, 1),),
                title: TextField(
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
                    color: Color.fromRGBO(41, 30, 47, 1),
                    textColor: Colors.white,
                    disabledColor: Colors.green[400],
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
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
