import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:checkin_app/pages/management_checkin/generate_qrcode.dart';



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
              Container(
                margin: EdgeInsets.only(top: 20.0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                          bottom: BorderSide(width: 1 / 2, color: Colors.grey),
                        )),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          'Atau',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                          bottom: BorderSide(width: 1 / 2, color: Colors.grey),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 20.0, right: 10.0, bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.white,
                    textColor: Color.fromRGBO(41, 30, 47, 1),
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.green[400],
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GenerateScreen()));
                    },
                    child: Text(
                      "Dengan QR CODE",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }
}
