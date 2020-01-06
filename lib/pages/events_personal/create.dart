import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'create_checkin.dart';
import 'create_admin.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'create_category.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'dart:convert';
import 'model.dart';
import 'index.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreateevent;
String tokenType, accessToken;
Map<String, dynamic> formSerialize;
List<ListUserAdd> listUseradd = [];
List<ListCheckinAdd> listcheckinAdd = [];
List<ListKategoriEventAdd> listKategoriAdd = [];
Map<String, String> requestHeaders = Map();
String tipe = 'Public';
TextEditingController _namaeventController = new TextEditingController();
TextEditingController _alamateventController = new TextEditingController();
TextEditingController _deskripsieventController = new TextEditingController();
var firstdate, lastdate, _tanggalawalevent, _tanggalakhirevent;

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

class _ManajemeCreateEventState extends State<ManajemeCreateEvent>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  void initState() {
    _scaffoldKeycreateevent = GlobalKey<ScaffoldState>();
    super.initState();
    getHeaderHTTP();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    firstdate = FocusNode();
    lastdate = FocusNode();
    _tanggalawalevent = null;
    _tanggalakhirevent = null;
    listcheckinAdd = [];
    listUseradd = [];
    listKategoriAdd = [];
    _namaeventController.text = '';
    _alamateventController.text = '';
    _deskripsieventController.text = '';
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

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  bool monVal = false;
  bool monVal2 = false;
  bool monVal3 = false;
  bool monVal4 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          title: Text('Buat Event Sekarang', style: TextStyle(fontSize: 14)),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.event), text: 'Informasi'),
              Tab(icon: Icon(Icons.event), text: 'Kategori'),
              Tab(icon: Icon(Icons.person), text: 'Admin'),
              Tab(icon: Icon(Icons.schedule), text: 'Checkin'),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              tooltip: 'Simpan Data Event',
              onPressed: () {
                _tambahevent();
              },
            ),
          ],
        ), //
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(5.0),
              child: Column(children: <Widget>[
                Card(
                    child: ListTile(
                  leading: Icon(
                    Icons.assignment_ind,
                    color: Color.fromRGBO(41, 30, 47, 1),
                  ),
                  title: TextField(
                    controller: _namaeventController,
                    decoration: InputDecoration(
                        hintText: 'Nama Event / Acara',
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
                        title: DateTimeField(
                          decoration: InputDecoration(
                            hintText: 'Tanggal Awal Event',
                            hintStyle:
                                TextStyle(fontSize: 13, color: Colors.black),
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
                              _tanggalawalevent =
                                  ini == null ? 'kosong' : ini.toString();
                            });
                          },
                        ))),
                Card(
                    child: ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: Color.fromRGBO(41, 30, 47, 1),
                        ),
                        title: DateTimeField(
                          decoration: InputDecoration(
                            hintText: 'Tanggal Akhir Checkin',
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
                              _tanggalakhirevent =
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
                    controller: _deskripsieventController,
                    maxLines: 8,
                    decoration: InputDecoration(
                        hintText: 'Deskripsi Event',
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                )),
                Card(
                    child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Color.fromRGBO(41, 30, 47, 1),
                  ),
                  title: TextField(
                    controller: _alamateventController,
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
                  listKategoriAdd.length == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(children: <Widget>[
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              child: Image.asset("images/empty-white-box.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Center(
                                child: Text(
                                  "Kategori Event Belum Ditambahkan / Masih Kosong",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black45,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listKategoriAdd.reversed
                                .map((ListKategoriEventAdd item) => Card(
                                        child: ListTile(
                                      leading: ButtonTheme(
                                          minWidth: 0.0,
                                          child: FlatButton(
                                            color: Colors.white,
                                            textColor: Colors.red,
                                            disabledColor: Colors.green[400],
                                            disabledTextColor: Colors.white,
                                            padding: EdgeInsets.all(15.0),
                                            splashColor: Colors.blueAccent,
                                            child: Icon(
                                              Icons.close,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                listKategoriAdd.remove(item);
                                              });
                                            },
                                          )),
                                      title: Text(item.nama == null
                                          ? 'Unknown Nama'
                                          : item.nama),
                                    )))
                                .toList(),
                          ),
                        ),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  listUseradd.length == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(children: <Widget>[
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              child: Image.asset("images/empty-white-box.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Center(
                                child: Text(
                                  "Admin Event Belum Ditambahkan / Masih Kosong",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black45,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listUseradd.reversed
                                .map((ListUserAdd item) => Card(
                                        child: ListTile(
                                      leading: ButtonTheme(
                                          minWidth: 0.0,
                                          child: FlatButton(
                                            color: Colors.white,
                                            textColor: Colors.red,
                                            disabledColor: Colors.green[400],
                                            disabledTextColor: Colors.white,
                                            padding: EdgeInsets.all(15.0),
                                            splashColor: Colors.blueAccent,
                                            child: Icon(
                                              Icons.close,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                listUseradd.remove(item);
                                              });
                                            },
                                          )),
                                      title: Text(item.nama == null
                                          ? 'Unknown Nama'
                                          : item.nama),
                                      subtitle: Text(item.email == null
                                          ? 'Unknown Email'
                                          : item.email),
                                    )))
                                .toList(),
                          ),
                        ),
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
                  listcheckinAdd.length == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(children: <Widget>[
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              child: Image.asset("images/empty-white-box.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Center(
                                child: Text(
                                  "Checkin Event Belum Ditambahkan / Masih Kosong",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black45,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listcheckinAdd.reversed
                                .map((ListCheckinAdd item) => Card(
                                      child: ListTile(
                                        leading: ButtonTheme(
                                            minWidth: 0.0,
                                            child: FlatButton(
                                              color: Colors.white,
                                              textColor: Colors.red,
                                              disabledColor: Colors.green[400],
                                              disabledTextColor: Colors.white,
                                              padding: EdgeInsets.all(15.0),
                                              splashColor: Colors.blueAccent,
                                              child: Icon(
                                                Icons.close,
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  listcheckinAdd.remove(item);
                                                });
                                              },
                                            )),
                                        title: Text(
                                          '${item.keyword} - ${item.nama}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            '${item.timestart} - ${item.timeend}',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _bottomButtons(),
      ),
    );
  }

  Widget _bottomButtons() {
    if (_tabController.index == 1) {
      return FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManajemenCreateCategory(),
                ));
          },
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          child: Icon(
            Icons.add,
            size: 20.0,
          ));
    } else if (_tabController.index == 2) {
      return FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManajemeCreateAdmin(),
                ));
          },
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          child: Icon(
            Icons.add,
            size: 20.0,
          ));
    } else if (_tabController.index == 3) {
      return FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManajemeCreateCheckin(),
                ));
          },
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          child: Icon(
            Icons.add,
            size: 20.0,
          ));
    } else {}
    return null;
  }

  void _tambahevent() async {
    if (_namaeventController.text == null || _namaeventController.text == '') {
      Fluttertoast.showToast(msg: "Nama Event Tidak Boleh Kosong");
    } else if (_deskripsieventController.text == null ||
        _deskripsieventController.text == '') {
      Fluttertoast.showToast(msg: "Deskripsi Event Tidak Boleh Kosong");
    } else if (_alamateventController.text == '' ||
        _alamateventController.text == '') {
      Fluttertoast.showToast(msg: "Alamat Event Tidak Boleh Kosong");
    } else if (_tanggalawalevent == null) {
      Fluttertoast.showToast(msg: "Tanggal Awal Event Tidak Boleh Kosong");
    } else if (_tanggalakhirevent == null) {
      Fluttertoast.showToast(msg: "Tanggal Akhir Event Tidak Boleh Kosong");
    } else {
      formSerialize = Map<String, dynamic>();
      formSerialize['title'] = null;
      formSerialize['deskripsi'] = null;
      formSerialize['lokasi'] = null;
      formSerialize['time_start'] = null;
      formSerialize['time_end'] = null;
      formSerialize['kategori'] = List();
      formSerialize['admin'] = List();
      formSerialize['checkin'] = List();
      formSerialize['keyword'] = List();
      formSerialize['timeendcheckin'] = List();
      formSerialize['timestartcheckin'] = List();

      formSerialize['title'] = _namaeventController.text;
      formSerialize['deskripsi'] = _deskripsieventController.text;
      formSerialize['lokasi'] = _alamateventController.text;
      formSerialize['tanggalawalevent'] = _tanggalawalevent == null
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalawalevent));
      formSerialize['tanggalakhirevent'] = _tanggalakhirevent == null
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalakhirevent));

      for (int i = 0; i < listKategoriAdd.length; i++) {
        formSerialize['kategori'].add(listKategoriAdd[i].id);
      }

      for (int i = 0; i < listUseradd.length; i++) {
        formSerialize['admin'].add(listUseradd[i].id);
      }

      for (int i = 0; i < listcheckinAdd.length; i++) {
        formSerialize['checkin'].add(listcheckinAdd[i].nama);
        formSerialize['keyword'].add(listcheckinAdd[i].keyword);
        formSerialize['timestartcheckin'].add(listcheckinAdd[i].timestart);
        formSerialize['timeendcheckin'].add(listcheckinAdd[i].timeend);
      }

      print(formSerialize);

      Map<String, dynamic> requestHeadersX = requestHeaders;

      requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
      try {
        final response = await http.post(
          url('api/createcheckin'),
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
            Fluttertoast.showToast(msg: "Berhasil Membuat Event");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ManajemenEventPersonal()));
          }
          print('response decoded $responseJson');
        } else {
          print('${response.body}');
          Fluttertoast.showToast(
              msg: "Gagal Menambahkan Event, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        showInSnackBar('Timed out, Try again');
      } catch (e) {
        print(e);
      }
    }
  }
}
