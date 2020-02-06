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
import 'dart:core';
import 'package:draggable_fab/draggable_fab.dart';

import 'package:checkin_app/utils/utils.dart';
import 'detail_user_checkin.dart';

String tokenType, accessToken, jumlahPesertaActive;
final _debouncer = Debouncer(milliseconds: 500);
List<ListPesertaEvent> listpesertaevent = [];
TextEditingController _pesanController = TextEditingController();
bool actionBackAppBar, iconButtonAppbarColor, isSendingMessage;
bool isLoading, isError, isFilter, isErrorfilter, isDelete, isDenied, isAccept;
Map<String, String> requestHeaders = Map();

class ManagePeserta extends StatefulWidget {
  ManagePeserta({Key key, this.title, this.event, this.eventEnd})
      : super(key: key);
  final String title, event;
  final bool eventEnd;
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
  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
    isSendingMessage = false;
    isFilter = false;
    isErrorfilter = false;
    isDelete = false;
    isDenied = false;
    isAccept = false;
    jumlahPesertaActive = '0';
    actionBackAppBar = true;
    iconButtonAppbarColor = true;
    getHeaderHTTP();
    print(requestHeaders);
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
      setState(() {
        isSendingMessage = true;
      });
      try {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
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
              isSendingMessage = false;
              _pesanController.text = '';
            });
          }
        } else {
          setState(() {
            isSendingMessage = false;
            _pesanController.text = '';
          });
          print(sendMessagePesertaEvent.body);
          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        }
      } on TimeoutException catch (_) {
        setState(() {
          isSendingMessage = false;
          _pesanController.text = '';
        });
        Fluttertoast.showToast(msg: "Timed out, Try again");
      } catch (e) {
        setState(() {
          isSendingMessage = false;
          _pesanController.text = '';
        });
        Fluttertoast.showToast(msg: "${e.toString()}");
        print(e);
      }
    }
  }

  void _showModalSendingMessage(event) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            margin: EdgeInsets.only(top: 40.0),
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text('Kirim Pesan Ke Semua Peserta Terdaftar',
                        style: TextStyle(color: Colors.black45))),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
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
                            onPressed: isSendingMessage == true
                                ? null
                                : () async {
                                    _kirimPesanPeserta(event);
                                  },
                            color: primaryAppBarColor,
                            textColor: Colors.white,
                            disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                            disabledTextColor: Colors.white,
                            splashColor: Colors.blueAccent,
                            child: isSendingMessage == true
                                ? Container(
                                    height: 25.0,
                                    width: 25.0,
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white)))
                                : Text("Kirim Pesan Sekarang",
                                    style: TextStyle(color: Colors.white)))))
              ],
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
    print(requestHeaders);
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
        print(listUsers);
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
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(getParticipantEvent.body);
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
        print(listUsers);
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
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(getParticipantEventFilter.body);
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
        "Kelola Peserta Event",
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

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Kelola Peserta Event",
    style: TextStyle(fontSize: 14),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildBar(context),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isError == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RefreshIndicator(
                      onRefresh: () => getHeaderHTTP(),
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
                              top: 20.0, left: 15.0, right: 15.0),
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
                                getHeaderHTTP();
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
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : isErrorfilter == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: RefreshIndicator(
                              onRefresh: () => filterlistpeserta(),
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
                                    ? Padding(
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
                                      )
                                    : isDelete ||
                                            isDenied ||
                                            isAccept ||
                                            isSendingMessage == true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                  width: 15.0,
                                                  margin: EdgeInsets.only(
                                                      top: 10.0, right: 15.0),
                                                  height: 15.0,
                                                  child:
                                                      CircularProgressIndicator()),
                                            ],
                                          )
                                        : Container(),
                                Expanded(
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      // scrollDirection: Axis.horizontal,
                                      itemCount: listpesertaevent.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DateTime waktuditerima = DateTime.parse(
                                            listpesertaevent[index].updateAt);
                                        String waktuDiterimaFinal =
                                            DateFormat('dd-MM-y HH:mm:ss')
                                                .format(waktuditerima);
                                        return InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailUserCheckin(
                                                            idUser:
                                                                listpesertaevent[
                                                                        index]
                                                                    .idpeserta,
                                                            idevent:
                                                                widget.event,
                                                            namaParticipant:
                                                                listpesertaevent[
                                                                        index]
                                                                    .nama),
                                                  ));
                                            },
                                            child: Card(
                                                child: ListTile(
                                              leading: Container(
                                                width: 40.0,
                                                height: 40.0,
                                                child: ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'images/loading.gif',
                                                    image: listpesertaevent[
                                                                        index]
                                                                    .image ==
                                                                null ||
                                                            listpesertaevent[
                                                                        index]
                                                                    .image ==
                                                                '' ||
                                                            listpesertaevent[
                                                                        index]
                                                                    .image ==
                                                                'null'
                                                        ? url(
                                                            'assets/images/imgavatar.png')
                                                        : url(
                                                            'storage/image/profile/${listpesertaevent[index].image}'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
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
                                                      : listpesertaevent[index]
                                                          .nama,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      listpesertaevent[index]
                                                                  .status ==
                                                              'P'
                                                          ? 'Menunggu Konfirmasi'
                                                          : listpesertaevent[
                                                                          index]
                                                                      .status ==
                                                                  'C'
                                                              ? 'Pendaftaran Ditolak'
                                                              : listpesertaevent[
                                                                              index]
                                                                          .status ==
                                                                      'A'
                                                                  ? 'Pendaftaran Diterima'
                                                                  : listpesertaevent[index]
                                                                              .status ==
                                                                          'B'
                                                                      ? 'Dihapus dari daftar peserta'
                                                                      : 'Status Tidak Diketahui',
                                                      style: listpesertaevent[index]
                                                                  .status ==
                                                              'B'
                                                          ? TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors.red)
                                                          : listpesertaevent[index]
                                                                      .status ==
                                                                  'P'
                                                              ? TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)
                                                              : listpesertaevent[index]
                                                                          .status ==
                                                                      'C'
                                                                  ? TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors
                                                                          .red)
                                                                  : listpesertaevent[index].status ==
                                                                          'A'
                                                                      ? TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.green)
                                                                      : TextStyle(fontWeight: FontWeight.w500),
                                                    ),
                                                    listpesertaevent[index]
                                                                .status ==
                                                            'A'
                                                        ? Padding(
                                                          padding: const EdgeInsets.only(top:5.0,bottom:10.0),
                                                          child: Text(
                                                              'Diterima : $waktuDiterimaFinal'),
                                                        )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  listpesertaevent[index]
                                                              .status ==
                                                          'B'
                                                      ? Container()
                                                      : listpesertaevent[index]
                                                                  .status ==
                                                              'P'
                                                          ? widget.eventEnd ==
                                                                  true
                                                              ? Container()
                                                              : ButtonTheme(
                                                                  minWidth: 0.0,
                                                                  child:
                                                                      FlatButton(
                                                                    color: Colors
                                                                        .white,
                                                                    textColor:
                                                                        Colors
                                                                            .red,
                                                                    disabledColor:
                                                                        Colors
                                                                            .white,
                                                                    disabledTextColor:
                                                                        Colors.red[
                                                                            400],
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    splashColor:
                                                                        Colors
                                                                            .blueAccent,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                    ),
                                                                    onPressed: isDelete ||
                                                                            isAccept ||
                                                                            isDenied ==
                                                                                true
                                                                        ? null
                                                                        : () async {
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
                                                                                      setState(() {
                                                                                        isDenied = true;
                                                                                      });
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
                                                                                            setState(() {
                                                                                              isDenied = false;
                                                                                            });
                                                                                            setState(() {
                                                                                              listpesertaevent[index].status = 'C';
                                                                                              jumlahnotifX = deniedParticipantEventJson['jumlahnotif'].toString();
                                                                                            });
                                                                                          } else if (deniedParticipantEventJson['status'] == 'error') {
                                                                                            Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                            setState(() {
                                                                                              isDenied = false;
                                                                                            });
                                                                                          }
                                                                                        } else {
                                                                                          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                          setState(() {
                                                                                            isDenied = false;
                                                                                          });
                                                                                        }
                                                                                      } on TimeoutException catch (_) {
                                                                                        Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                        setState(() {
                                                                                          isDenied = false;
                                                                                        });
                                                                                      } catch (e) {
                                                                                        setState(() {
                                                                                          isDenied = false;
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
                                                              : ButtonTheme(
                                                                  minWidth: 0.0,
                                                                  child:
                                                                      FlatButton(
                                                                    color: Colors
                                                                        .white,
                                                                    textColor:
                                                                        Colors
                                                                            .red,
                                                                    disabledColor:
                                                                        Colors
                                                                            .white,
                                                                    disabledTextColor:
                                                                        Colors.red[
                                                                            400],
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    splashColor:
                                                                        Colors
                                                                            .blueAccent,
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                    ),
                                                                    onPressed: isDelete ||
                                                                            isAccept ||
                                                                            isDenied ==
                                                                                true
                                                                        ? null
                                                                        : () async {
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
                                                                                      setState(() {
                                                                                        isDelete = true;
                                                                                      });
                                                                                      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
                                                                                      Navigator.pop(context);
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
                                                                                            setState(() {
                                                                                              isDelete = false;
                                                                                            });
                                                                                            setState(() {
                                                                                              listpesertaevent.remove(listpesertaevent[index]);
                                                                                            });
                                                                                          } else if (deletePesertaEventJson['status'] == 'error') {
                                                                                            Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                            setState(() {
                                                                                              isDelete = false;
                                                                                            });
                                                                                          }
                                                                                        } else {
                                                                                          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                          setState(() {
                                                                                            isDelete = false;
                                                                                          });
                                                                                        }
                                                                                      } on TimeoutException catch (_) {
                                                                                        Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                        setState(() {
                                                                                          isDelete = false;
                                                                                        });
                                                                                      } catch (e) {
                                                                                        setState(() {
                                                                                          isDelete = false;
                                                                                        });
                                                                                        print(e);
                                                                                      }
                                                                                    },
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                  )),
                                                  listpesertaevent[index]
                                                              .status ==
                                                          'B'
                                                      ? Container()
                                                      : listpesertaevent[index]
                                                                  .status ==
                                                              'P'
                                                          ? widget.eventEnd ==
                                                                  true
                                                              ? Container()
                                                              : ButtonTheme(
                                                                  minWidth: 0.0,
                                                                  child:
                                                                      FlatButton(
                                                                    color: Colors
                                                                        .white,
                                                                    textColor:
                                                                        Colors
                                                                            .green,
                                                                    disabledColor:
                                                                        Colors
                                                                            .white,
                                                                    disabledTextColor:
                                                                        Colors.green[
                                                                            400],
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    splashColor:
                                                                        Colors
                                                                            .blueAccent,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check,
                                                                    ),
                                                                    onPressed: isDelete ||
                                                                            isAccept ||
                                                                            isDenied ==
                                                                                true
                                                                        ? null
                                                                        : () async {
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
                                                                                      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
                                                                                      Navigator.pop(context);
                                                                                      setState(() {
                                                                                        isAccept = true;
                                                                                      });
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
                                                                                            setState(() {
                                                                                              isAccept = false;
                                                                                            });
                                                                                            setState(() {
                                                                                              listpesertaevent[index].status = 'A';
                                                                                              jumlahnotifX = accPesertaJson['jumlahnotif'].toString();
                                                                                            });
                                                                                          } else if (accPesertaJson['status'] == 'Error') {
                                                                                            Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                            setState(() {
                                                                                              isAccept = false;
                                                                                            });
                                                                                          }
                                                                                        } else {
                                                                                          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
                                                                                          setState(() {
                                                                                            isAccept = false;
                                                                                          });
                                                                                          print(accpeserta.body);
                                                                                        }
                                                                                      } on TimeoutException catch (_) {
                                                                                        Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                        setState(() {
                                                                                          isAccept = false;
                                                                                        });
                                                                                      } catch (e) {
                                                                                        setState(() {
                                                                                          isAccept = false;
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
                              ],
                            ),
                          ),
        floatingActionButton: widget.eventEnd == true
            ? null
            : DraggableFab(
                child: FloatingActionButton(
                    shape: StadiumBorder(),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ManajemeCreatePeserta(event: widget.event)));
                    },
                    backgroundColor: primaryButtonColor,
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                    ))));
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
