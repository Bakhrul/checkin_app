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
import 'create_event-category.dart' as category;
import 'package:image_picker/image_picker.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

String tokenType, accessToken, idEventFinalX;
Map<String, dynamic> formSerialize;
TextEditingController _tanggalakhireventController = TextEditingController();
TextEditingController _tanggalawaleventController = TextEditingController();
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
  ProgressDialog progressApiAction;
  TabController _tabController;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _tanggalawaleventController.text = '';
    _tanggalakhireventController.text = '';
    firstdate = FocusNode();
    lastdate = FocusNode();
    _tanggalawalevent = null;
    _image = null;
    _tanggalakhirevent = null;
    idEventFinalX = null;
    isCreate = false;
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
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    timeSetToMinute();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  void timeSetToMinute() {
    var time = DateTime.now();
    var newHour = 0;
    var newMinute = 0;
    var newSecond = 0;
    time = time.toLocal();
    timeReplacement = new DateTime(time.year, time.month, time.day, newHour,
        newMinute, newSecond, time.millisecond, time.microsecond);
  }

  @override
  Widget build(BuildContext context) {
    progressApiAction = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressApiAction.style(
        message: 'Tunggu Sebentar...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600));
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryAppBarColor,
          title: Text('Event Baru - Informasi Event',
              style: TextStyle(fontSize: 14)),
          actions: <Widget>[],
        ), //
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
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
                          width: double.infinity,
                          height: 200.0,
                          margin: EdgeInsets.only(bottom: 20.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey[200],
                              )),
                          child: Text('Tidak ada gambar yang dipilih.')),
                    )
                  : Container(
                      width: double.infinity,
                      height: 200.0,
                      margin: EdgeInsets.only(bottom: 20.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1.0,
                        color: Colors.grey[200],
                      )),
                      child: Image.file(_image),
                    ),
            ),
            Card(
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(
                    Icons.assignment_ind,
                  ),
                  title: TextField(
                    controller: _namaeventController,
                    decoration: InputDecoration(
                        hintText: 'Nama Event / Acara',
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                )),
            Card(
                elevation: 0.5,
                child: ListTile(
                    leading: Icon(
                      Icons.access_time,
                    ),
                    title: DateTimeField(
                      controller: _tanggalawaleventController,
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
                          _tanggalakhireventController.text = '';
                          _tanggalakhirevent = 'kosong';
                        });
                      },
                    ))),
            Card(
                elevation: 0.5,
                child: ListTile(
                    leading: Icon(
                      Icons.access_time,
                    ),
                    title: DateTimeField(
                      controller: _tanggalakhireventController,
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
                            firstDate: _tanggalawalevent == 'kosong'
                                ? DateTime.now()
                                : DateTime.parse(_tanggalawalevent),
                            initialDate: _tanggalawalevent == 'kosong'
                                ? DateTime.now()
                                : DateTime.parse(_tanggalawalevent),
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
                elevation: 0.5,
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
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                )),
            Card(
                elevation: 0.5,
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
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black)),
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
        onPressed: () async {
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
    } else if (_deskripsieventController.text == null ||
        _deskripsieventController.text == '') {
      Fluttertoast.showToast(msg: "Deskripsi Event Tidak Boleh Kosong");
    } else if (_alamateventController.text == null ||
        _alamateventController.text == '') {
      Fluttertoast.showToast(msg: "Alamat Event Tidak Boleh Kosong");
    } else if (_tanggalawalevent == null || _tanggalawalevent == 'kosong') {
      Fluttertoast.showToast(msg: "Tanggal Awal Event Tidak Boleh Kosong");
    } else if (_tanggalakhirevent == null || _tanggalakhirevent == 'kosong') {
      Fluttertoast.showToast(msg: "Tanggal Akhir Event Tidak Boleh Kosong");
    } else {
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

      formSerialize['event'] = idEventFinalX == null || idEventFinalX == ''
          ? null
          : idEventFinalX.toString();
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

      Map<String, dynamic> requestHeadersX = requestHeaders;

      requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
      try {
        await progressApiAction.show();
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
            progressApiAction.hide().then((isHidden) {
              print(isHidden);
            });
            setState(() {
              idEventFinalX = idEventFromDB;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => category.ManajemenCreateEventCategory(
                          event: idEventFinalX,
                        )));
          }
        } else {
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
          Fluttertoast.showToast(
              msg: "Gagal Menambahkan Event, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        Fluttertoast.showToast(msg: "Time Out, Try Again");
      } catch (e) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        Fluttertoast.showToast(
            msg: "Gagal Menambahkan Event, Silahkan Coba Kembali");
        print(e);
      }
    }
  }
}
