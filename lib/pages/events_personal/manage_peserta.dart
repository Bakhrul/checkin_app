import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'create_peserta.dart';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:intl/intl.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:core';
import 'package:draggable_fab/draggable_fab.dart';

import 'package:checkin_app/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shimmer/shimmer.dart';
import 'detail_user_checkin.dart';

String tokenType, accessToken, jumlahPesertaActive;
final _debouncer = Debouncer(milliseconds: 500);
List<ListPesertaEvent> listpesertaevent = [];
TextEditingController _pesanController = TextEditingController();
TextEditingController _controllerAddpeserta = TextEditingController();
TextEditingController _pesanPribadiController = TextEditingController();
bool actionBackAppBar, iconButtonAppbarColor;
bool isLoading, isError, isFilter, isErrorfilter;
Map<String, String> requestHeaders = Map();
String namaEventX;
enum PageEnum {
  kirimPesanPribadi,
  deletePeserta,
}

class ManagePeserta extends StatefulWidget {
  ManagePeserta(
      {Key key, this.title, this.event, this.namaEvent, this.eventEnd})
      : super(key: key);
  final String title, event;
  final bool eventEnd;
  final String namaEvent;
  @override
  State<StatefulWidget> createState() {
    return _ManagePesertaState();
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ManagePesertaState extends State<ManagePeserta> {
  ProgressDialog progressApiAction;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
    isFilter = false;
    isErrorfilter = false;
    _pesanPribadiController.text = '';
    _pesanController.text = '';
    namaEventX = widget.namaEvent;
    jumlahPesertaActive = '0';
    actionBackAppBar = true;
    iconButtonAppbarColor = true;
    getHeaderHTTP();
    listcheckin();
  }

  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _kirimPesanPeserta(event) async {
    if (_pesanController.text == null || _pesanController.text == '') {
      Fluttertoast.showToast(msg: "Silahkan Isi Pesan Terlebih Dahulu");
    } else {
      try {
        Navigator.pop(context);
        await progressApiAction.show();
        final sendMessagePesertaEvent = await http.post(
            url('api/sendmessageallpeserta'),
            headers: requestHeaders,
            body: {
              'event': event,
              'pesan': _pesanController.text,
            });

        if (sendMessagePesertaEvent.statusCode == 200) {
          var sendMessagePesertaEventJson =
              json.decode(sendMessagePesertaEvent.body);
          if (sendMessagePesertaEventJson['status'] == 'success') {
            Fluttertoast.showToast(
                msg: "Berhasil Mengirimkan Pesan Ke Semua Peserta");
            setState(() {
              _pesanController.text = '';
            });
            progressApiAction.hide().then((isHidden) {
              print(isHidden);
            });
          }
        } else {
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
          setState(() {
            _pesanController.text = '';
          });
          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        setState(() {
          _pesanController.text = '';
        });
        Fluttertoast.showToast(msg: "Timed out, Try again");
      } catch (e) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        setState(() {
          _pesanController.text = '';
        });
        Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        print(e);
      }
    }
  }

  void _kirimPesanPersonal(event, peserta, namapeserta) async {
    if (_pesanPribadiController.text == null ||
        _pesanPribadiController.text == '') {
      Fluttertoast.showToast(msg: "Silahkan Isi Pesan Terlebih Dahulu");
    } else {
      try {
        Navigator.pop(context);
        await progressApiAction.show();
        final sendMessagePesertaEvent = await http.post(
            url('api/sendpersonalmessage'),
            headers: requestHeaders,
            body: {
              'event': event,
              'pesan': _pesanPribadiController.text,
              'user': peserta,
            });

        if (sendMessagePesertaEvent.statusCode == 200) {
          var sendMessagePesertaEventJson =
              json.decode(sendMessagePesertaEvent.body);
          if (sendMessagePesertaEventJson['status'] == 'success') {
            Fluttertoast.showToast(
                msg: "Berhasil Mengirimkan Pesan Ke $namapeserta");
            progressApiAction.hide().then((isHidden) {
              print(isHidden);
            });
            setState(() {
              _pesanPribadiController.text = '';
            });
          }
        } else {
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
          setState(() {
            _pesanPribadiController.text = '';
          });
          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        setState(() {
          _pesanPribadiController.text = '';
        });
        Fluttertoast.showToast(msg: "Timed out, Try again");
      } catch (e) {
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
        setState(() {
          _pesanPribadiController.text = '';
        });
        Fluttertoast.showToast(msg: "Gagal, Silahkan Coba kembali");
        print(e);
      }
    }
  }

  void _showModalSendingMessage(event) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              height: 210.0 + MediaQuery.of(context).viewInsets.bottom,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 15.0,
                  left: 15.0,
                  top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 20.0,
                      child: Text('Kirim Pesan Ke Semua Peserta',
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14))),
                  Container(
                      height: 80.0,
                      margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                      child: TextField(
                        maxLines: 5,
                        controller: _pesanController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan Pesan Disini',
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                      )),
                  Center(
                      child: Container(
                          width: double.infinity,
                          height: 45.0,
                          child: RaisedButton(
                              onPressed: () async {
                                _kirimPesanPeserta(event);
                              },
                              color: primaryAppBarColor,
                              textColor: Colors.white,
                              disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                              disabledTextColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              child: Text("Kirim Pesan Sekarang",
                                  style: TextStyle(color: Colors.white)))))
                ],
              ),
            ),
          );
        });
  }

  void _showModalSendingMessagePersonal(event, peserta, namapeserta) {
    setState(() {
      _pesanPribadiController.text = '';
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              height: 210.0 + MediaQuery.of(context).viewInsets.bottom,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 15.0,
                  left: 15.0,
                  top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 20.0,
                      child: Text('Kirim Pesan Ke $namapeserta',
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14))),
                  Container(
                      height: 80.0,
                      margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                      child: TextField(
                        maxLines: 5,
                        controller: _pesanPribadiController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan Pesan Disini',
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                      )),
                  Center(
                      child: Container(
                          width: double.infinity,
                          height: 45.0,
                          child: RaisedButton(
                              onPressed: () async {
                                _kirimPesanPersonal(
                                    event, peserta, namapeserta);
                              },
                              color: primaryAppBarColor,
                              textColor: Colors.white,
                              disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                              disabledTextColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              child: Text("Kirim Pesan Sekarang",
                                  style: TextStyle(color: Colors.white)))))
                ],
              ),
            ),
          );
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

  Future<List<List>> listcheckin() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
      isError = false;
      isErrorfilter = false;
      isFilter = false;
      this.appBarTitle = Text(
        "Kelola Peserta Event $namaEventX",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
    });
    try {
      final getParticipantEvent = await http.post(
        url('api/listpesertaevent'),
        body: {'event': widget.event},
        headers: requestHeaders,
      );

      if (getParticipantEvent.statusCode == 200) {
        var listuserJson = json.decode(getParticipantEvent.body);
        var listUsers = listuserJson['peserta'];
        String jumlahPeserta = listuserJson['jumlahpesertaaktif'].toString();
        setState(() {
          jumlahPesertaActive = jumlahPeserta;
        });
        listpesertaevent = [];
        for (var i in listUsers) {
          ListPesertaEvent willcomex = ListPesertaEvent(
            idevent: '${i['ep_events']}',
            idpeserta: '${i['ep_participants']}',
            nama: i['us_name'],
            posisi: i['ep_position'].toString(),
            status: i['ep_status'],
            email: i['us_email'],
            image: i['us_image'],
            updateAt: i['ep_update_time'],
          );
          listpesertaevent.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (getParticipantEvent.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
          isFilter = false;
          isErrorfilter = false;
        });
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          isFilter = false;
          isErrorfilter = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
        isFilter = false;
        isErrorfilter = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        isFilter = false;
        isErrorfilter = false;
      });
      debugPrint('$e');
    }
    return null;
  }

  Future<List<List>> filterlistpeserta() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = false;
      isError = false;
      isErrorfilter = false;
      isFilter = true;
    });
    try {
      final getParticipantEventFilter = await http.post(
        url('api/listpesertaevent'),
        body: {'event': widget.event, 'filter': _searchQuery.text},
        headers: requestHeaders,
      );

      if (getParticipantEventFilter.statusCode == 200) {
        var listuserJson = json.decode(getParticipantEventFilter.body);
        var listUsers = listuserJson['peserta'];
        listpesertaevent = [];
        for (var i in listUsers) {
          ListPesertaEvent willcomex = ListPesertaEvent(
            idevent: '${i['ep_events']}',
            idpeserta: '${i['ep_participants']}',
            nama: i['us_name'],
            posisi: i['ep_position'].toString(),
            status: i['ep_status'],
            email: i['us_email'],
            updateAt: i['ep_update_time'],
          );
          listpesertaevent.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
          isLoading = false;
          isError = false;
        });
      } else if (getParticipantEventFilter.statusCode == 401) {
        setState(() {
          isFilter = false;
          isErrorfilter = true;
          isLoading = false;
          isError = false;
        });
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
      } else {
        setState(() {
          isFilter = false;
          isErrorfilter = true;
          isLoading = false;
          isError = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isFilter = false;
        isErrorfilter = true;
        isLoading = false;
        isError = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isFilter = false;
        isErrorfilter = true;
        isLoading = false;
        isError = false;
      });
      debugPrint('$e');
    }
    return null;
  }

  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      actionBackAppBar = true;
      iconButtonAppbarColor = true;
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        namaEventX == null
            ? "Kelola Peserta Event"
            : "Kelola Peserta Event $namaEventX",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
      listcheckin();
      _debouncer.run(() {
        _searchQuery.clear();
      });
    });
  }

  void showAddModalPeserta() {
    setState(() {
      _controllerAddpeserta.text = '';
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              height: 170.0 + MediaQuery.of(context).viewInsets.bottom,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 15.0,
                  left: 15.0,
                  top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 80.0,
                      margin: EdgeInsets.only(bottom: 0.0, top: 10.0),
                      child: TextField(
                        controller: _controllerAddpeserta,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Masukkan Email Peserta',
                            hintStyle: TextStyle(
                              fontSize: 12,
                            )),
                      )),
                  Center(
                      child: Container(
                          width: double.infinity,
                          height: 45.0,
                          child: RaisedButton(
                              onPressed: isCreate == true
                                  ? null
                                  : () async {
                                      String emailValid =
                                          _controllerAddpeserta.text;
                                      final bool isValid =
                                          EmailValidator.validate(emailValid);

                                      print('Email is valid? ' +
                                          (isValid ? 'yes' : 'no'));
                                      if (_controllerAddpeserta.text == null ||
                                          _controllerAddpeserta.text == '') {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Email Tidak Boleh Kosong");
                                      } else if (!isValid) {
                                        Fluttertoast.showToast(
                                            msg: "Masukkan Email Yang Valid");
                                      } else {
                                        _tambahpeserta(
                                            _controllerAddpeserta.text);
                                      }
                                    },
                              color: primaryAppBarColor,
                              textColor: Colors.white,
                              disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                              disabledTextColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              child: isCreate == true
                                  ? Container(
                                      height: 25.0,
                                      width: 25.0,
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.white)))
                                  : Text("Tambahkan Peserta",
                                      style: TextStyle(color: Colors.white)))))
                ],
              ),
            ),
          );
        });
  }

  void _tambahpeserta(peserta) async {
    try {
      Navigator.pop(context);
      await progressApiAction.show();
      final addadminevent = await http
          .post(url('api/addpeserta_event'), headers: requestHeaders, body: {
        'event': widget.event,
        'peserta': peserta,
      });

      if (addadminevent.statusCode == 200) {
        var addpesertaJson = json.decode(addadminevent.body);
        if (addpesertaJson['status'] == 'success') {
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
          Fluttertoast.showToast(msg: "Berhasil!");
          filterlistpeserta();
        } else if (addpesertaJson['status'] == 'user tidak ada') {
          Fluttertoast.showToast(
              msg: "Email Ini Belum Terdaftar Pada Akun EventZhee");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else if (addpesertaJson['status'] == 'creator') {
          Fluttertoast.showToast(msg: "Member ini merupakan pembuat event");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else if (addpesertaJson['status'] == 'sudah ada') {
          Fluttertoast.showToast(
              msg: "Member ini sudah terdaftar pada event anda");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else if (addpesertaJson['status'] == 'pending') {
          Fluttertoast.showToast(
              msg: "Pendaftaran member ini menunggu persetujuan dari anda");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else if (addpesertaJson['status'] == 'sudahadmin') {
          Fluttertoast.showToast(
              msg: "member ini sudah terdaftar menjadi admin event anda");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else if (addpesertaJson['status'] == 'adminpending') {
          Fluttertoast.showToast(
              msg:
                  "Anda sudah memninta member ini untuk menjadi admin event dan saat ini menunggu persetujuan");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else {
          Fluttertoast.showToast(msg: "Status tidak diketahui");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        }
      } else {
        print(addadminevent.body);
        Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Timed out, Try again");
      progressApiAction.hide().then((isHidden) {
        print(isHidden);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
      progressApiAction.hide().then((isHidden) {
        print(isHidden);
      });
      print(e);
    }
  }

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    namaEventX == null
        ? "Kelola Peserta Event "
        : "Kelola Peserta Event $namaEventX",
    style: TextStyle(fontSize: 14),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildBar(context),
        body: isLoading == true
            ? loadingView()
            : isError == true
                ? RefreshIndicator(
                    onRefresh: () => filterlistpeserta(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(children: <Widget>[
                        new Container(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset("images/system-eror.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30.0,
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Center(
                            child: Text(
                              "Gagal memuat halaman, tekan tombol muat ulang halaman untuk refresh halaman",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom:20.0, left: 15.0, right: 15.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.white,
                              textColor: Color.fromRGBO(41, 30, 47, 1),
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(15.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () async {
                                filterlistpeserta();
                              },
                              child: Text(
                                "Muat Ulang Halaman",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )
                : isFilter == true
                    ? loadingView()
                    : isErrorfilter == true
                        ? RefreshIndicator(
                            onRefresh: () => filterlistpeserta(),
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(children: <Widget>[
                                new Container(
                                  width: 80.0,
                                  height: 80.0,
                                  child: Image.asset("images/system-eror.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Gagal Memuat Data, Silahkan Coba Kembali",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Column(
                              children: <Widget>[
                                listpesertaevent.length == 0
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(
                                            right: 5.0,
                                            left: 5.0,
                                            bottom: 10.0),
                                        padding: EdgeInsets.only(
                                            top: 15.0, bottom: 15.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.grey[300],
                                          width: 1.0,
                                        ))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                                child: Text(
                                                    'Jumlah Peserta Terdaftar',
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                            Text(
                                              '$jumlahPesertaActive Peserta',
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                listpesertaevent.length == 0
                                    ? RefreshIndicator(
                                        onRefresh: () async {
                                          filterlistpeserta();
                                        },
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Column(children: <Widget>[
                                            new Container(
                                              width: 100.0,
                                              height: 100.0,
                                              child: Image.asset(
                                                  "images/empty-white-box.png"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 20.0,
                                                left: 15.0,
                                                right: 15.0,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Peserta Tidak ada / tidak ditemukan",
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
                                        ))
                                    : Expanded(
                                        child: Scrollbar(
                                          child: RefreshIndicator(
                                            onRefresh: () async {
                                              filterlistpeserta();
                                            },
                                            child: ListView.builder(
                                              // scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  listpesertaevent.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                DateTime waktuditerima =
                                                    DateTime.parse(
                                                        listpesertaevent[index]
                                                            .updateAt);
                                                String waktuDiterimaFinal =
                                                    DateFormat(
                                                            'dd MMM yyyy HH:mm')
                                                        .format(waktuditerima);
                                                return InkWell(
                                                    onTap:
                                                        listpesertaevent[index]
                                                                    .status !=
                                                                'A'
                                                            ? null
                                                            : () async {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => DetailUserCheckin(
                                                                          idUser: listpesertaevent[index]
                                                                              .idpeserta,
                                                                          idevent: widget
                                                                              .event,
                                                                          namaParticipant:
                                                                              listpesertaevent[index].nama),
                                                                    ));
                                                              },
                                                    child: Card(
                                                        child: ListTile(
                                                      leading: Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        child: ClipOval(
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                'images/loading.gif',
                                                            image: listpesertaevent[index]
                                                                            .image ==
                                                                        null ||
                                                                    listpesertaevent[index]
                                                                            .image ==
                                                                        '' ||
                                                                    listpesertaevent[index]
                                                                            .image ==
                                                                        'null'
                                                                ? url(
                                                                    'assets/images/imgavatar.png')
                                                                : url(
                                                                    'storage/image/profile/${listpesertaevent[index].image}'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      title: Text(
                                                          listpesertaevent[index]
                                                                          .nama ==
                                                                      null ||
                                                                  listpesertaevent[
                                                                              index]
                                                                          .nama ==
                                                                      ''
                                                              ? 'Nama Tidak Diketahui'
                                                              : listpesertaevent[
                                                                      index]
                                                                  .nama,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15.0,
                                                                bottom: 10.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              listpesertaevent[
                                                                              index]
                                                                          .status ==
                                                                      'P'
                                                                  ? 'Menunggu Konfirmasi'
                                                                  : listpesertaevent[index]
                                                                              .status ==
                                                                          'C'
                                                                      ? 'Pendaftaran Ditolak'
                                                                      : listpesertaevent[index].status ==
                                                                              'A'
                                                                          ? 'Pendaftaran Diterima'
                                                                          : listpesertaevent[index].status == 'B'
                                                                              ? 'Dihapus dari daftar peserta'
                                                                              : 'Status Tidak Diketahui',
                                                              style: listpesertaevent[
                                                                              index]
                                                                          .status ==
                                                                      'B'
                                                                  ? TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          Colors
                                                                              .red)
                                                                  : listpesertaevent[index]
                                                                              .status ==
                                                                          'P'
                                                                      ? TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500)
                                                                      : listpesertaevent[index].status ==
                                                                              'C'
                                                                          ? TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.red)
                                                                          : listpesertaevent[index].status == 'A' ? TextStyle(fontWeight: FontWeight.w500, color: Colors.green) : TextStyle(fontWeight: FontWeight.w500),
                                                            ),
                                                            listpesertaevent[
                                                                            index]
                                                                        .status ==
                                                                    'A'
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        bottom:
                                                                            10.0),
                                                                    child: Text(
                                                                        'Diterima : $waktuDiterimaFinal'),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          listpesertaevent[index]
                                                                      .status ==
                                                                  'B'
                                                              ? Container()
                                                              : listpesertaevent[
                                                                              index]
                                                                          .status ==
                                                                      'P'
                                                                  ? widget.eventEnd ==
                                                                          true
                                                                      ? Container()
                                                                      : ButtonTheme(
                                                                          minWidth:
                                                                              0.0,
                                                                          child:
                                                                              FlatButton(
                                                                            color:
                                                                                Colors.white,
                                                                            textColor:
                                                                                Colors.red,
                                                                            disabledColor:
                                                                                Colors.white,
                                                                            disabledTextColor:
                                                                                Colors.red[400],
                                                                            padding:
                                                                                EdgeInsets.all(0.0),
                                                                            splashColor:
                                                                                Colors.blueAccent,
                                                                            child:
                                                                                Icon(
                                                                              Icons.close,
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                  title: Text('Peringatan!'),
                                                                                  content: Text('Apakah Anda Ingin Menolak Pendaftaran Event?'),
                                                                                  actions: <Widget>[
                                                                                    FlatButton(
                                                                                      child: Text('Tidak'),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    FlatButton(
                                                                                      textColor: Colors.green,
                                                                                      child: Text('Ya'),
                                                                                      onPressed: () async {
                                                                                        Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
                                                                                        Navigator.pop(context);
                                                                                        await progressApiAction.show();
                                                                                        try {
                                                                                          final deniedParticipantEvent = await http.post(url('api/tolakpeserta_event'), headers: requestHeaders, body: {
                                                                                            'peserta': listpesertaevent[index].idpeserta,
                                                                                            'event': listpesertaevent[index].idevent
                                                                                          });
                                                                                          print(deniedParticipantEvent);
                                                                                          if (deniedParticipantEvent.statusCode == 200) {
                                                                                            var deniedParticipantEventJson = json.decode(deniedParticipantEvent.body);
                                                                                            if (deniedParticipantEventJson['status'] == 'success') {
                                                                                              Fluttertoast.showToast(msg: "Berhasil");
                                                                                              progressApiAction.hide().then((isHidden) {
                                                                                                print(isHidden);
                                                                                              });
                                                                                              setState(() {
                                                                                                listpesertaevent[index].status = 'C';
                                                                                                jumlahnotifX = deniedParticipantEventJson['jumlahnotif'].toString();
                                                                                              });
                                                                                            } else if (deniedParticipantEventJson['status'] == 'error') {
                                                                                              Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                              progressApiAction.hide().then((isHidden) {
                                                                                                print(isHidden);
                                                                                              });
                                                                                            }
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                            progressApiAction.hide().then((isHidden) {
                                                                                              print(isHidden);
                                                                                            });
                                                                                          }
                                                                                        } on TimeoutException catch (_) {
                                                                                          Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                          progressApiAction.hide().then((isHidden) {
                                                                                            print(isHidden);
                                                                                          });
                                                                                        } catch (e) {
                                                                                          progressApiAction.hide().then((isHidden) {
                                                                                            print(isHidden);
                                                                                          });
                                                                                          print(e);
                                                                                        }
                                                                                      },
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ))
                                                                  : widget.eventEnd ==
                                                                          true
                                                                      ? Container()
                                                                      : PopupMenuButton<
                                                                          PageEnum>(
                                                                          onSelected:
                                                                              (PageEnum value) {
                                                                            switch (value) {
                                                                              case PageEnum.kirimPesanPribadi:
                                                                                _showModalSendingMessagePersonal(listpesertaevent[index].idevent, listpesertaevent[index].idpeserta, listpesertaevent[index].nama);
                                                                                break;
                                                                              case PageEnum.deletePeserta:
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) => AlertDialog(
                                                                                          title: Text('Peringatan!'),
                                                                                          content: Text('Apakah Anda Ingin Menghapus Secara Permanen?'),
                                                                                          actions: <Widget>[
                                                                                            FlatButton(
                                                                                              child: Text('Tidak'),
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                            ),
                                                                                            FlatButton(
                                                                                              textColor: Colors.green,
                                                                                              child: Text('Ya'),
                                                                                              onPressed: () async {
                                                                                                Navigator.pop(context);
                                                                                                await progressApiAction.show();
                                                                                                try {
                                                                                                  final deletePesertaEvent = await http.post(url('api/deletepeserta_event'), headers: requestHeaders, body: {
                                                                                                    'peserta': listpesertaevent[index].idpeserta,
                                                                                                    'event': listpesertaevent[index].idevent
                                                                                                  });
                                                                                                  print(deletePesertaEvent);
                                                                                                  if (deletePesertaEvent.statusCode == 200) {
                                                                                                    var deletePesertaEventJson = json.decode(deletePesertaEvent.body);
                                                                                                    if (deletePesertaEventJson['status'] == 'success') {
                                                                                                      Fluttertoast.showToast(msg: "Berhasil");
                                                                                                      progressApiAction.hide().then((isHidden) {
                                                                                                        print(isHidden);
                                                                                                      });
                                                                                                      setState(() {
                                                                                                        jumlahPesertaActive = deletePesertaEventJson['countPesertaActive'].toString();
                                                                                                      });
                                                                                                      setState(() {
                                                                                                        listpesertaevent.remove(listpesertaevent[index]);
                                                                                                      });
                                                                                                    } else if (deletePesertaEventJson['status'] == 'error') {
                                                                                                      Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                                      progressApiAction.hide().then((isHidden) {
                                                                                                        print(isHidden);
                                                                                                      });
                                                                                                    }
                                                                                                  } else {
                                                                                                    Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                                    progressApiAction.hide().then((isHidden) {
                                                                                                      print(isHidden);
                                                                                                    });
                                                                                                  }
                                                                                                } on TimeoutException catch (_) {
                                                                                                  Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                                  progressApiAction.hide().then((isHidden) {
                                                                                                    print(isHidden);
                                                                                                  });
                                                                                                } catch (e) {
                                                                                                  progressApiAction.hide().then((isHidden) {
                                                                                                    print(isHidden);
                                                                                                  });
                                                                                                  print(e);
                                                                                                  Fluttertoast.showToast(msg: 'Gagal, Silahkan Coba Kembali');
                                                                                                }
                                                                                              },
                                                                                            )
                                                                                          ],
                                                                                        ));
                                                                                break;

                                                                              default:
                                                                                break;
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.more_vert),
                                                                          itemBuilder:
                                                                              (context) => [
                                                                            listpesertaevent[index].status == 'A'
                                                                                ? PopupMenuItem(
                                                                                    value: PageEnum.kirimPesanPribadi,
                                                                                    child: Text("Kirim Pesan Pribadi"),
                                                                                  )
                                                                                : null,
                                                                            PopupMenuItem(
                                                                              value: PageEnum.deletePeserta,
                                                                              child: Text("Hapus Peserta"),
                                                                            ),
                                                                          ],
                                                                        ),
                                                          listpesertaevent[
                                                                          index]
                                                                      .status ==
                                                                  'B'
                                                              ? Container()
                                                              : listpesertaevent[
                                                                              index]
                                                                          .status ==
                                                                      'P'
                                                                  ? widget.eventEnd ==
                                                                          true
                                                                      ? Container()
                                                                      : ButtonTheme(
                                                                          minWidth:
                                                                              0.0,
                                                                          child:
                                                                              FlatButton(
                                                                            color:
                                                                                Colors.white,
                                                                            textColor:
                                                                                Colors.green,
                                                                            disabledColor:
                                                                                Colors.white,
                                                                            disabledTextColor:
                                                                                Colors.green[400],
                                                                            padding:
                                                                                EdgeInsets.all(0.0),
                                                                            splashColor:
                                                                                Colors.blueAccent,
                                                                            child:
                                                                                Icon(
                                                                              Icons.check,
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                  title: Text('Peringatan!'),
                                                                                  content: Text('Apakah Anda Ingin Menerima Pendaftaran Event?'),
                                                                                  actions: <Widget>[
                                                                                    FlatButton(
                                                                                      child: Text('Tidak'),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    FlatButton(
                                                                                      textColor: Colors.green,
                                                                                      child: Text('Ya'),
                                                                                      onPressed: () async {
                                                                                        Navigator.pop(context);
                                                                                        await progressApiAction.show();
                                                                                        try {
                                                                                          final accpeserta = await http.post(url('api/accpeserta_event'), headers: requestHeaders, body: {
                                                                                            'peserta': listpesertaevent[index].idpeserta,
                                                                                            'event': listpesertaevent[index].idevent
                                                                                          });

                                                                                          if (accpeserta.statusCode == 200) {
                                                                                            var accPesertaJson = json.decode(accpeserta.body);
                                                                                            print(accPesertaJson);
                                                                                            if (accPesertaJson['status'] == 'success') {
                                                                                              Fluttertoast.showToast(msg: "Berhasil");
                                                                                              progressApiAction.hide().then((isHidden) {
                                                                                                print(isHidden);
                                                                                              });
                                                                                              setState(() {
                                                                                                listpesertaevent[index].status = 'A';
                                                                                                jumlahnotifX = accPesertaJson['jumlahnotif'].toString();
                                                                                                jumlahPesertaActive = accPesertaJson['countPesertaActive'].toString();
                                                                                              });
                                                                                            } else if (accPesertaJson['status'] == 'Error') {
                                                                                              Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                              progressApiAction.hide().then((isHidden) {
                                                                                                print(isHidden);
                                                                                              });
                                                                                            }
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                            progressApiAction.hide().then((isHidden) {
                                                                                              print(isHidden);
                                                                                            });
                                                                                            print(accpeserta.body);
                                                                                          }
                                                                                        } on TimeoutException catch (_) {
                                                                                          Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                          progressApiAction.hide().then((isHidden) {
                                                                                            print(isHidden);
                                                                                          });
                                                                                        } catch (e) {
                                                                                          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                          progressApiAction.hide().then((isHidden) {
                                                                                            print(isHidden);
                                                                                          });
                                                                                          print(e);
                                                                                        }
                                                                                      },
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ))
                                                                  : Container(),
                                                        ],
                                                      ),
                                                    )));
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
        floatingActionButton: widget.eventEnd == true
            ? null
            : DraggableFab(
                child: FloatingActionButton(
                    shape: StadiumBorder(),
                    onPressed: () async {
                      showAddModalPeserta();
                    },
                    backgroundColor: primaryButtonColor,
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                    ))));
  }

  Widget loadingView() {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 25.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8]
                    .map((_) => Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRect(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.white,
                                  ),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                    ),
                                    Container(
                                      width: 100.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          )),
    );
  }

  Widget buildBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: appBarTitle,
          titleSpacing: 0.0,
          centerTitle: true,
          backgroundColor: primaryAppBarColor,
          automaticallyImplyLeading: actionBackAppBar,
          actions: <Widget>[
            Container(
              color: iconButtonAppbarColor == true
                  ? primaryAppBarColor
                  : Colors.white,
              child: IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      actionBackAppBar = false;
                      iconButtonAppbarColor = false;
                      this.actionIcon = new Icon(
                        Icons.close,
                        color: Colors.grey,
                      );
                      this.appBarTitle = Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: _searchQuery,
                          onChanged: (string) {
                            if (string != null || string != '') {
                              _debouncer.run(() {
                                filterlistpeserta();
                              });
                            }
                          },
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.grey),
                            hintText: "Cari Berdasarkan Nama Peserta",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    } else {
                      _handleSearchEnd();
                    }
                  });
                },
              ),
            ),
            actionIcon.icon == Icons.close
                ? Container()
                : jumlahPesertaActive == '0'
                    ? Container()
                    : Container(
                        child: IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () async {
                          _showModalSendingMessage(widget.event);
                        },
                      )),
          ],
        ));
  }
}
