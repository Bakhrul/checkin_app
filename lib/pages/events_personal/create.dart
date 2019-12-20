import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'listprovinsi.dart';
import 'listkabupaten.dart';
import 'listkecamatan.dart';
import 'create_checkin.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreateevent;
String sifat = 'VIP';
String tipe = 'Public';
var datepicker;

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
    super.initState();
    datepicker = FocusNode();
  }

  bool monVal = false;
  bool monVal2 = false;
  bool monVal3 = false;
  bool monVal4 = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Buat Event Sekarang',
              style: TextStyle(fontSize: 14),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.event), text: 'Informasi Event'),
                Tab(icon: Icon(Icons.person), text: 'Tambah Wewenang'),
                Tab(
                    icon: Icon(Icons.schedule),
                    text: 'Tambah Checkin'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(5.0),
                child: Column(children: <Widget>[
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.assignment_ind, color: Colors.blue),
                    title: TextField(
                      decoration: InputDecoration(
                          hintText: 'Nama Event / Acara',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black)),
                    ),
                  )),
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.category, color: Colors.blue),
                    title: DropdownButton<String>(
                      isExpanded: true,
                      value: tipe,
                      elevation: 16,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          tipe = newValue;
                        });
                      },
                      items: <String>[
                        'Public',
                        'Privat',
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
                    leading: Icon(Icons.category, color: Colors.blue),
                    title: DropdownButton<String>(
                      isExpanded: true,
                      value: sifat,
                      elevation: 16,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          sifat = newValue;
                        });
                      },
                      items: <String>[
                        'VIP',
                        'Gold',
                        'Silver',
                        'Regular',
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
                    leading: Icon(Icons.date_range, color: Colors.blue),
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
                    leading: Icon(Icons.access_time, color: Colors.blue),
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
                    leading: Icon(Icons.create, color: Colors.blue),
                    title: TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                          hintText: 'Deskripsi Event',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black)),
                    ),
                  )),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.domain, color: Colors.blue),
                      title: Text(
                        'Pilih Alamat Provinsi',
                        style: TextStyle(fontSize: 13),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Provinsi()));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.domain, color: Colors.blue),
                      title: Text(
                        'Pilih Alamat Kabupaten',
                        style: TextStyle(fontSize: 13),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Kabupaten()));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.domain, color: Colors.blue),
                      title: Text('Pilih Alamat Kecamatan',
                          style: TextStyle(fontSize: 13)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Kecamatan()));
                      },
                    ),
                  ),
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.blue),
                    title: TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                          hintText: 'Alamat Lengkap',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black)),
                    ),
                  )),
                ]),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: TextField(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            hintText: "Cari Berdasarkan Nama Lengkap",
                            border: InputBorder.none,
                          )),
                    ),
                    Card(
                        child: ListTile(
                      leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/imgavatar.png',
                              ),
                            ),
                          )),
                      title: Text('Muhammad Bakhrul Bila Sakhil'),
                      subtitle: Text('081285270793'),
                      trailing: Checkbox(
                        value: monVal,
                        onChanged: (bool value) {
                          setState(() {
                            monVal = value;
                          });
                        },
                      ),
                    )),
                    Card(
                        child: ListTile(
                      leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/imgavatar.png',
                              ),
                            ),
                          )),
                      title: Text('Muhammad Bakhrul Bila Sakhil'),
                      subtitle: Text('081285270793'),
                      trailing: Checkbox(
                        value: monVal2,
                        onChanged: (bool value) {
                          setState(() {
                            monVal2 = value;
                          });
                        },
                      ),
                    )),
                    Card(
                        child: ListTile(
                      leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/imgavatar.png',
                              ),
                            ),
                          )),
                      title: Text('Muhammad Bakhrul Bila Sakhil'),
                      subtitle: Text('081285270793'),
                      trailing: Checkbox(
                        value: monVal3,
                        onChanged: (bool value) {
                          setState(() {
                            monVal3 = value;
                          });
                        },
                      ),
                    )),
                    Card(
                        child: ListTile(
                      leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/imgavatar.png',
                              ),
                            ),
                          )),
                      title: Text('Muhammad Bakhrul Bila Sakhil'),
                      subtitle: Text('081285270793'),
                      trailing: Checkbox(
                        value: monVal4,
                        onChanged: (bool value) {
                          setState(() {
                            monVal4 = value;
                          });
                        },
                      ),
                    )),
                    Card(
                        child: ListTile(
                      leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/imgavatar.png',
                              ),
                            ),
                          )),
                      title: Text('Muhammad Bakhrul Bila Sakhil'),
                      subtitle: Text('081285270793'),
                      trailing: Checkbox(
                        value: monVal2,
                        onChanged: (bool value) {
                          setState(() {
                            monVal2 = value;
                          });
                        },
                      ),
                    )),
                    Card(
                        child: ListTile(
                      leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/imgavatar.png',
                              ),
                            ),
                          )),
                      title: Text('Muhammad Bakhrul Bila Sakhil'),
                      subtitle: Text('081285270793'),
                      trailing: Checkbox(
                        value: monVal2,
                        onChanged: (bool value) {
                          setState(() {
                            monVal2 = value;
                          });
                        },
                      ),
                    )),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 15.0,
                  right: 5.0,
                  left: 5.0,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 10.0, right: 5.0, left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Daftar Checkin',
                            style: TextStyle(fontSize: 16),
                          ),
                          ButtonTheme(
                            minWidth: 0, //wraps child's width
                            height: 0,
                            child: FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  Text('Tambahkan Checkin',
                                      style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                              color: Colors.transparent,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.all(0),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ManajemeCreateCheckin(),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          '12 September 2019 - KODECHECKIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text('04:00 - 04:30'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
