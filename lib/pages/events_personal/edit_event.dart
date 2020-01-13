import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'create_checkin.dart';
import 'create_admin.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'dart:convert';
import 'model.dart';
import 'index.dart';
import 'edit_categoryevent.dart';

String tokenType, accessToken;
Map<String, dynamic> formSerialize;
List<ListEditKategoriEvent> listkategoriEventEdit = [];
Map<String, String> requestHeaders = Map();
TextEditingController _namaeventController = new TextEditingController();
TextEditingController _alamateventController = new TextEditingController();
TextEditingController _deskripsieventController = new TextEditingController();
var firstdate, lastdate, _tanggalawalevent, _tanggalakhirevent;
bool isLoading, isError, isEdit;

class ManajemeEditEvent extends StatefulWidget {
  ManajemeEditEvent(
      {Key key,
      this.title,
      this.nama,
      this.idevent,
      this.deskripsi,
      this.lokasi,
      this.waktuawal,
      this.waktuakhir})
      : super(key: key);
  final String title, idevent, deskripsi, lokasi, waktuawal, waktuakhir, nama;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateEventState();
  }
}

class _ManajemeCreateEventState extends State<ManajemeEditEvent>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    isEdit = false;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    firstdate = FocusNode();
    lastdate = FocusNode();
    _tanggalawalevent = widget.waktuawal == null ||
            widget.waktuawal == '' ||
            widget.waktuawal == 'kosong'
        ? null
        : widget.waktuawal;
    _tanggalakhirevent = widget.waktuakhir == null ||
            widget.waktuakhir == '' ||
            widget.waktuakhir == 'kosong'
        ? null
        : widget.waktuakhir;
    listkategoriEventEdit = [];
    _namaeventController.text = widget.nama;
    _alamateventController.text = widget.lokasi;
    _deskripsieventController.text = widget.deskripsi;
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
    return listkategorievent();
  }

  Future<List<List>> listkategorievent() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
    });
    try {
      final checkinevent = await http.post(
        url('api/editdataevent'),
        body: {'event': widget.idevent},
        headers: requestHeaders,
      );

      if (checkinevent.statusCode == 200) {
        var listuserJson = json.decode(checkinevent.body);
        var listUsers = listuserJson['kategori'];
        print(listUsers);
        listkategoriEventEdit = [];
        for (var i in listUsers) {
          ListEditKategoriEvent willcomex = ListEditKategoriEvent(
            id: '${i['c_id']}',
            nama: '${i['c_name']}',
          );
          listkategoriEventEdit.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (checkinevent.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(checkinevent.body);
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
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
          title: Text('Edit Data Event', style: TextStyle(fontSize: 14)),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.event), text: 'Informasi'),
              Tab(icon: Icon(Icons.event), text: 'Kategori'),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Peringatan!'),
                    content: Text(
                        'Apakah Anda Ingin Update Data Event Anda Sekarang? '),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Tidak'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        textColor: Colors.green,
                        child: Text(isEdit == true ? 'Tunggu Sebentar' :'Ya'),
                        onPressed: isEdit == true ? null : () async {
                          _updateEvent();
                        },
                      )
                    ],
                  ),
                );
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
                          initialValue: widget.waktuawal == 'kosong' ||
                                  widget.waktuawal == '' ||
                                  widget.waktuawal == null
                              ? null
                              : DateTime.parse(widget.waktuawal),
                          focusNode: firstdate,
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
                                    TimeOfDay.fromDateTime(DateTime.now()),
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
                            hintText: 'Tanggal Akhir Event',
                            hintStyle:
                                TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          readOnly: true,
                          format: format,
                          focusNode: lastdate,
                          initialValue: widget.waktuakhir == 'kosong' ||
                                  widget.waktuakhir == '' ||
                                  widget.waktuakhir == null
                              ? null
                              : DateTime.parse(widget.waktuakhir),
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
                                    TimeOfDay.fromDateTime(DateTime.now()),
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
                  isLoading == true
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : listkategoriEventEdit.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(children: <Widget>[
                                new Container(
                                  width: 100.0,
                                  height: 100.0,
                                  child:
                                      Image.asset("images/empty-white-box.png"),
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
                                children: listkategoriEventEdit.reversed
                                    .map((ListEditKategoriEvent item) => Card(
                                            child: ListTile(
                                          leading: ButtonTheme(
                                              minWidth: 0.0,
                                              child: FlatButton(
                                                color: Colors.white,
                                                textColor: Colors.red,
                                                disabledColor:
                                                    Colors.green[400],
                                                disabledTextColor: Colors.white,
                                                padding: EdgeInsets.all(15.0),
                                                splashColor: Colors.blueAccent,
                                                child: Icon(
                                                  Icons.close,
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    listkategoriEventEdit
                                                        .remove(item);
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
                  builder: (context) => ManajemenEditCategoryEvent(
                      listkategoryedit: ListEditKategoriEvent),
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

  void _updateEvent() async {
    if (_namaeventController.text == null || _namaeventController.text == '') {
      Fluttertoast.showToast(msg: "Nama Event Tidak Boleh Kosong");
    } else if (_deskripsieventController.text == null ||
        _deskripsieventController.text == '') {
      Fluttertoast.showToast(msg: "Deskripsi Event Tidak Boleh Kosong");
    } else if (_alamateventController.text == '' ||
        _alamateventController.text == '') {
      Fluttertoast.showToast(msg: "Alamat Event Tidak Boleh Kosong");
    } else if (_tanggalawalevent == null ||
        _tanggalawalevent == 'kosong' ||
        _tanggalawalevent == '') {
      Fluttertoast.showToast(msg: "Tanggal Awal Event Tidak Boleh Kosong");
    } else if (_tanggalakhirevent == null ||
        _tanggalakhirevent == 'kosong' ||
        _tanggalakhirevent == '') {
      Fluttertoast.showToast(msg: "Tanggal Akhir Event Tidak Boleh Kosong");
    } else {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar!");
      setState(() {
        isEdit = true;
      });
      formSerialize = Map<String, dynamic>();
      formSerialize['event'] = null;
      formSerialize['title'] = null;
      formSerialize['deskripsi'] = null;
      formSerialize['lokasi'] = null;
      formSerialize['time_start'] = null;
      formSerialize['time_end'] = null;
      formSerialize['kategori'] = List();

      formSerialize['event'] = widget.idevent;
      formSerialize['title'] = _namaeventController.text;
      formSerialize['deskripsi'] = _deskripsieventController.text;
      formSerialize['lokasi'] = _alamateventController.text;
      formSerialize['tanggalawalevent'] = _tanggalawalevent == null ||
              _tanggalawalevent == 'kosong' ||
              _tanggalawalevent == ''
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalawalevent));
      formSerialize['tanggalakhirevent'] = _tanggalakhirevent == null ||
              _tanggalakhirevent == 'kosong' ||
              _tanggalakhirevent == ''
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalakhirevent));

      for (int i = 0; i < listkategoriEventEdit.length; i++) {
        formSerialize['kategori'].add(listkategoriEventEdit[i].id);
      }

      print(formSerialize);

      Map<String, dynamic> requestHeadersX = requestHeaders;

      requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
      try {
        final response = await http.post(
          url('api/updatedataevent'),
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
            setState(() {
              isEdit = false;
            });
            Fluttertoast.showToast(msg: "Berhasil Update Data Event");
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ManajemenEventPersonal()));
          }
          print('response decoded $responseJson');
        } else {
          setState(() {
            isEdit = false;
          });
          print('${response.body}');
          Fluttertoast.showToast(
              msg: "Gagal Update Event, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        Fluttertoast.showToast(msg: 'Timed out, Try again');
        setState(() {
          isEdit = false;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Timed out, Try again');
        setState(() {
          isEdit = false;
        });
        print(e);
      }
    }
  }
}
