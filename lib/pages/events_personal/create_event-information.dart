import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'dart:convert';
import 'dart:io';
import 'create_event-category.dart';
import 'package:image_picker/image_picker.dart';

import 'package:checkin_app/utils/utils.dart';

String tokenType, accessToken, idEventFinalX;
Map<String, dynamic> formSerialize;
File _image;
bool isCreate;
Map<String, String> requestHeaders = Map();
String tipe = 'Public';
TextEditingController _namaeventController = new TextEditingController();
TextEditingController _alamateventController = new TextEditingController();
TextEditingController _deskripsieventController = new TextEditingController();
var firstdate, lastdate, _tanggalawalevent, _tanggalakhirevent;

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
  DateTime timeReplacement;
  TabController _tabController;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    firstdate = FocusNode();
    lastdate = FocusNode();
    _tanggalawalevent = null;
    _image = null;
    _tanggalakhirevent = null;
    idEventFinalX = null;
    isCreate = false;
    isDelete = false;
    _namaeventController.text = '';
    _alamateventController.text = '';
    timeSetToMinute();
    _deskripsieventController.text = '';
  }
  
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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

  void timeSetToMinute() {
    var timeNow = DateTime.now();
    var timeString = timeNow.toString();
    var minutes = timeNow.minute;
    var hours = timeNow.hour;
    timeReplacement =
        DateTime.parse(timeString.replaceAll("$hours:$minutes:", "00:00:"));
    print(timeReplacement);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryAppBarColor,
          title: Text('Event Baru - Informasi Event', style: TextStyle(fontSize: 14)),
          actions: <Widget>[],
        ), //
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(5.0),
          child: Column(children: <Widget>[
            isCreate == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          width: 20.0,
                          margin: EdgeInsets.all(15.0),
                          height: 20.0,
                          child: CircularProgressIndicator()),
                    ],
                  )
                : Container(),
            _image == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(right: 5.0, bottom: 5.0, top: 10.0),
                        width: 30.0,
                        height: 30.0,
                        child: FlatButton(
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          color: Colors.red,
                          child: Icon(
                            Icons.close,
                            size: 14.0,
                          ),
                          onPressed: () async {
                            setState(() {
                              _image = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            Center(
              child: _image == null
                  ? InkWell(
                      onTap: getImage,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 20.0, top: 10.0),
                          width: double.infinity,
                          height: 250.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey,
                              )),
                          child: Text('Tidak ada gambar yang dipilih.')),
                    )
                  : Container(
                      width: double.infinity,
                      height: 250.0,
                      margin:
                          EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      )),
                      child: Image.file(_image),
                    ),
            ),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.assignment_ind,
              ),
              title: TextField(
                controller: _namaeventController,
                decoration: InputDecoration(
                    hintText: 'Nama Event / Acara',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            )),
            Card(
                child: ListTile(
                    leading: Icon(
                      Icons.access_time,
                    ),
                    title: DateTimeField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tanggal Awal Event',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      readOnly: true,
                      format: format,
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
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? timeReplacement),
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
                    ),
                    title: DateTimeField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tanggal Akhir Event',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      readOnly: true,
                      format: format,
                      focusNode: lastdate,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? timeReplacement),
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
              ),
              title: TextField(
                controller: _deskripsieventController,
                maxLines: 8,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Deskripsi Event',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            )),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.location_on,
              ),
              title: TextField(
                controller: _alamateventController,
                maxLines: 8,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Alamat Lengkap',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            )),
          ]),
        ),     
        floatingActionButton: _bottomButtons(),
      ),
    );
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: isCreate == true
            ? null
            : () async {
              setState(() {
                isCreate = true;
              });
                _tambahevent();
              },
        backgroundColor: primaryButtonColor,
        child: Icon(
          Icons.chevron_right,
          size: 25.0,
        ));
  }

  void _tambahevent() async {
    if (_namaeventController.text == null || _namaeventController.text == '') {
      Fluttertoast.showToast(msg: "Nama Event Tidak Boleh Kosong");
      setState(() {
        isCreate = false;
      });
    } else if (_deskripsieventController.text == null ||
        _deskripsieventController.text == '') {
      Fluttertoast.showToast(msg: "Deskripsi Event Tidak Boleh Kosong");
      setState(() {
        isCreate = false;
      });
    } else if (_alamateventController.text == '' ||
        _alamateventController.text == '') {
      Fluttertoast.showToast(msg: "Alamat Event Tidak Boleh Kosong");
      setState(() {
        isCreate = false;
      });
    } else if (_tanggalawalevent == null) {
      Fluttertoast.showToast(msg: "Tanggal Awal Event Tidak Boleh Kosong");
      setState(() {
        isCreate = false;
      });
    } else if (_tanggalakhirevent == null) {
      Fluttertoast.showToast(msg: "Tanggal Akhir Event Tidak Boleh Kosong");
      setState(() {
        isCreate = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      formSerialize = Map<String, dynamic>();
      formSerialize['title'] = null;
      formSerialize['deskripsi'] = null;
      formSerialize['lokasi'] = null;
      formSerialize['time_start'] = null;
      formSerialize['time_end'] = null;
      formSerialize['gambar'] = null;
      formSerialize['event'] = null;
      formSerialize['typeinformasi'] = null;
      formSerialize['typekategori'] = null;
      formSerialize['typeadmin'] = null;
      formSerialize['typecheckin'] = null;

      formSerialize['event'] = idEventFinalX == null || idEventFinalX == '' ? null : idEventFinalX.toString();
      formSerialize['title'] = _namaeventController.text;
      formSerialize['deskripsi'] = _deskripsieventController.text;
      formSerialize['lokasi'] = _alamateventController.text;
      formSerialize['typeinformasi'] = 'informasi';
      if (_image != null) {
        formSerialize['gambar'] = base64Encode(_image.readAsBytesSync());
      }
      formSerialize['tanggalawalevent'] = _tanggalawalevent == null
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalawalevent));
      formSerialize['tanggalakhirevent'] = _tanggalakhirevent == null
          ? null
          : DateFormat('dd-MM-y HH:mm:ss')
              .format(DateTime.parse(_tanggalakhirevent));

      

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
          String idEventFromDB = responseJson['finalidevent'].toString();
          if (responseJson['status'] == 'success') {
            setState(() {
              idEventFinalX = idEventFromDB;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManajemenCreateEventCategory(
                          event: idEventFinalX,
                        )));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ManajemenCreateCategory(
            //           listKategoriadd: ListKategoriEventAdd),
            //     ));
          }
          print('response decoded $responseJson');
        } else {
          print('${response.body}');
          Fluttertoast.showToast(
              msg: "Gagal Menambahkan Event, Silahkan Coba Kembali");
          setState(() {
            isCreate = false;
          });
        }
      } on TimeoutException catch (_) {
        Fluttertoast.showToast(msg: "Time Out, Try Again");
        setState(() {
          isCreate = false;
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Gagal Menambahkan Event, Silahkan Coba Kembali");
        setState(() {
          isCreate = false;
        });
        print(e);
      }
    }
  }
}
