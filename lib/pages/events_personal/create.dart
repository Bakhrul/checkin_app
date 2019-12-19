import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'listprovinsi.dart';
import 'listkabupaten.dart';
import 'listkecamatan.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreateevent;
var datepicker;
File _image;
String category = 'Technology';
void showInSnackBar(String value) {
  _scaffoldKeycreateevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeCreateEvent extends StatefulWidget {
  ManajemeCreateEvent({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateEventState();
  }
}

class _ManajemeCreateEventState extends State<ManajemeCreateEvent> {
  @override
  void initState() {
    _scaffoldKeycreateevent = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeycreateevent,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Buat Event Sekarang",
            style: TextStyle(
              color: Color(0xff25282b),
              fontSize: 14,
            ),
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _image == null
                  ? Image.asset('images/add-image-icon-sm.png',
                      width: 120.0, height: 120.0)
                  : Image.file(
                      _image,
                      width: 120.0,
                      height: 120.0,
                    ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.green[400],
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(10.0),
                    splashColor: Colors.blueAccent,
                    onPressed: getImage,
                    child: Text(
                      'Ambil Gambar Sekarang',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, left: 10.0, bottom: 20.0, right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    disabledColor: Colors.red[300],
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(10.0),
                    splashColor: Colors.blueAccent,
                    onPressed: _image == null
                        ? null
                        : () async {
                            setState(() {
                              _image = null;
                            });
                          },
                    child: Text(
                      'Hapus Gambar Terpilih',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Informasi Tentang Event',
                  textAlign: TextAlign.left,
                ),
              ),
              Card(
                  child: ListTile(
                leading: Icon(Icons.assignment_ind, color: Colors.green),
                title: TextField(
                  decoration: InputDecoration(
                      hintText: 'Nama Event / Acara',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.category, color: Colors.green),
                title: DropdownButton<String>(
                  isExpanded: true,
                  value: category,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                  items: <String>[
                    'Technology',
                    'Financial',
                    'Keuangan',
                    'Analisa'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.date_range, color: Colors.green),
                title: DateTimeField(
                  readOnly: true,
                  format: DateFormat('dd-MM-yyy'),
                  focusNode: datepicker,
                  decoration: InputDecoration(
                    hintText: 'Tanggal berlangsungnya event',
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
                leading: Icon(Icons.access_time, color: Colors.green),
                title: DateTimeField(
                  format: DateFormat("HH:mm"),
                  decoration: InputDecoration(
                    hintText: 'Jam berlangsungnya event',
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
                leading: Icon(Icons.create, color: Colors.green),
                title: TextField(
                  maxLines: 8,
                  decoration: InputDecoration(
                      hintText: 'Deskripsi Event',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 10.0,
                ),
                child: new Text(
                  'Alamat Berlangsungnya Event',
                  textAlign: TextAlign.left,
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.domain, color: Colors.green),
                  title: Text(
                    'Pilih Alamat Provinsi',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Provinsi()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.domain, color: Colors.green),
                  title: Text(
                    'Pilih Alamat Kabupaten',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Kabupaten()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.domain, color: Colors.green),
                  title: Text('Pilih Alamat Kecamatan',
                      style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Kecamatan()));
                  },
                ),
              ),
              Card(
                  child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.green),
                title: TextField(
                  maxLines: 8,
                  decoration: InputDecoration(
                      hintText: 'Alamat Lengkap',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.green[400],
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      setState(() {
                        _image = null;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Buat Event Sekarang',
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
                    textColor: Colors.green,
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.green[400],
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      setState(() {
                        _image = null;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Batal Membuat Event / Acara",
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
