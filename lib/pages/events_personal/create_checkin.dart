import 'package:checkin_app/pages/events_personal/create.dart';
import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'model.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreatecheckin;
bool isSame;
TextEditingController _namacheckinController = new TextEditingController();
TextEditingController _kodecheckinController = new TextEditingController();
var firstdate, lastdate, _tanggalawal, _tanggalakhir;
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
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  void initState() {
    _scaffoldKeycreatecheckin = GlobalKey<ScaffoldState>();
    firstdate = FocusNode();
    lastdate = FocusNode();
    isSame = false;
    _namacheckinController.text = '';
    _kodecheckinController.text = '';
    _tanggalawal = 'kosong';
    _tanggalakhir = 'kosong';
    super.initState();
  }

  void dispose() {
    super.dispose();
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
            for (int i = 0; i < listcheckinAdd.length; i++) {
              if (_kodecheckinController.text == listcheckinAdd[i].keyword) {
                setState(() {
                  isSame = true;
                });
              }
            }
            if (isSame == true) {
              Fluttertoast.showToast(msg: 'Kode Unik Checkin Tidak Boleh Sama');
              setState(() {
                isSame = false;
              });
            } else {
              setState(() {
                ListCheckinAdd notax = ListCheckinAdd(
                  nama: _namacheckinController.text,
                  keyword: _kodecheckinController.text,
                  timestart: _tanggalawal == 'kosong'
                      ? null
                      : DateFormat('dd-MM-y HH:mm:ss')
                          .format(DateTime.parse(_tanggalawal)),
                  timeend: _tanggalakhir == 'kosong'
                      ? null
                      : DateFormat('dd-MM-y HH:mm:ss')
                          .format(DateTime.parse(_tanggalakhir)),
                );
                listcheckinAdd.add(notax);
              });
              Navigator.pop(context);
            }
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }
}
