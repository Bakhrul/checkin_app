import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'generate_qrcode.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreatecheckin;
var datepicker;
void showInSnackBar(String value) {
  _scaffoldKeycreatecheckin.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeCreateCheckin extends StatefulWidget {
  ManajemeCreateCheckin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateCheckinState();
  }
}

class _ManajemeCreateCheckinState extends State<ManajemeCreateCheckin> {
  @override
  void initState() {
    _scaffoldKeycreatecheckin = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                leading: Icon(
                  Icons.access_time,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
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
                leading: Icon(
                  Icons.timeline,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  decoration: InputDecoration(
                      hintText: 'Durasi Checkin ( Menit )',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                trailing: FlatButton(
                  child: Text("qr"), onPressed: () {Navigator.push(context, MaterialPageRoute( builder: (context) => GenerateScreen() ));},
                ) ,
                title: TextField(
                  decoration: InputDecoration(
                      hintText: 'KODE UNIK CHECKIN',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              FlatButton(
                onPressed: () {
                  /*...*/
                },
                child: Text(
                  "simpan",
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     Navigator.pop(context);
      //   },
      //   child: Icon(Icons.arrow_forward_ios),
      //   backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      // ),
    );
  }
}
