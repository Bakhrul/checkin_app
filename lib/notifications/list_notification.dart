import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:checkin_app/pages/events_all/detail_event.dart';
import 'model.dart';
import 'dart:core';

String tokenType, accessToken;
List<ListNotifications> listnotifications = [];
bool isLoading, isError, isAction;
Map<String, String> requestHeaders = Map();
Map dataUser;
enum PageEnum {
  detailEvent,
  setujuiConfirmation,
  tolakConfirmation,
  deletePesan,
}

class ManajemenNotifications extends StatefulWidget {
  ManajemenNotifications({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<ManajemenNotifications> {
  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
    isAction = false;
    getHeaderHTTP();
    _getUserData();
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
    return listNotif();
  }

  _getUserData() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final ongoingevent =
          await http.get(url('api/user'), headers: requestHeaders);

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);

        if (mounted) {
          setState(() {
            dataUser = rawData;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print(e);
    }
  }

  dynamic deleteNotif(index) async{
    try {
      final removeConfirmation =
          await http.post(
              url(
                  'api/deletepesan_notifikasi'),
              headers:
                  requestHeaders,
              body: {
            'idnotif':
                listnotifications[index]
                    .id,
          });
      print(
          removeConfirmation);
      if (removeConfirmation
              .statusCode ==
          200) {
        var removeConfirmationJson =
            json.decode(
                removeConfirmation
                    .body);
        if (removeConfirmationJson[
                'status'] ==
            'success') {
          setState(() {
            isAction =
                false;
          });
          setState(() {
            listnotifications
                .remove(
                    listnotifications[index]);
          });
          String
              jumlahnotifterbaru =
              removeConfirmationJson[
                      'notifbelumbaca']
                  .toString();
          setState(() {
            jumlahnotifX =
                jumlahnotifterbaru;
          });
          Fluttertoast
              .showToast(
                  msg:
                      "Berhasil");
        } else if (removeConfirmationJson[
                'status'] ==
            'Error') {
          setState(() {
            isAction =
                false;
          });
          Fluttertoast
              .showToast(
                  msg:
                      "Gagal, Silahkan Coba Lagi");
        }
      } else {
        setState(() {
          isAction =
              false;
        });
        Fluttertoast
            .showToast(
                msg:
                    "Gagal, Silahkan Coba Lagi");
      }
    } on TimeoutException catch (_) {
      setState(() {
        isAction =
            false;
      });
      Fluttertoast
          .showToast(
              msg:
                  "Timed out, Try again");
    } catch (e) {
      setState(() {
        isAction =
            false;
      });
      Fluttertoast
          .showToast(
              msg:
                  "${e.toString()}'");
      print(e);
    }
  }
  Future<List<List>> listNotif() async {
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
      final notification = await http.get(
        url('api/getnotification_event'),
        headers: requestHeaders,
      );

      if (notification.statusCode == 200) {
        var listNotificationJson = json.decode(notification.body);
        var listNotifications = listNotificationJson['notifikasi'];
        setState(() {
          jumlahnotifX = '0';
        });
        listnotifications = [];
        for (var i in listNotifications) {
          ListNotifications willcomex = ListNotifications(
            id: '${i['nev_id']}',
            idcreator: i['ev_create_user'].toString(),
            idtoperson: i['nev_toperson'].toString(),
            idfromperson: i['nev_fromperson'].toString(),
            namafromperson: i['namafromperson'],
            namatoperson: i['namatoperson'],
            namaupdateperson: i['namaupdateperson'],
            namaCreator: i['namaCreator'],
            updatepeserta: i['nev_updateperson'].toString(),
            idevent: i['nev_event'].toString(),
            title: i['n_title'],
            idmessage: i['nev_notifications'].toString(),
            message: i['n_message'],
            confirmation: i['n_confirmation'],
            statusRead: i['nev_status'],
            namaEvent: i['ev_title'],
            messageCustom: i['nev_custom_message'],
          );
          listnotifications.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (notification.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(notification.body);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Notifikasi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.white),
              onPressed: listnotifications.length == 0
                  ? null
                  : () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Peringatan!'),
                          content:
                              Text('Apakah Anda Ingin Menhapus Semua Pesan?'),
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
                                setState(() {
                                  isAction = true;
                                });
                                try {
                                  Fluttertoast.showToast(
                                      msg: "Mohon Tunggu Sebentar");
                                  final removeAllNotifications =
                                      await http.post(
                                    url('api/removeall_notification'),
                                    headers: requestHeaders,
                                  );
                                  print(removeAllNotifications);
                                  if (removeAllNotifications.statusCode ==
                                      200) {
                                    var removeAllNotificationsJson = json
                                        .decode(removeAllNotifications.body);
                                    if (removeAllNotificationsJson['status'] ==
                                        'success') {
                                      setState(() {
                                        isAction = false;
                                        listnotifications = [];
                                      });
                                      int notifterbarucount =
                                          listnotifications.length;
                                      setState(() {
                                        jumlahnotifX =
                                            notifterbarucount.toString();
                                      });
                                      Fluttertoast.showToast(msg: "Berhasil");
                                    } else if (removeAllNotificationsJson[
                                            'status'] ==
                                        'Error') {
                                      setState(() {
                                        isAction = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg:
                                              "Gagal Menghapus Semua pesan, Silahkan Coba Lagi");
                                    }
                                  } else {
                                    setState(() {
                                      isAction = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg:
                                            "Gagal Menghapus Semua pesan, Silahkan Coba Lagi");
                                  }
                                } on TimeoutException catch (_) {
                                  setState(() {
                                    isAction = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Timed out, Try again");
                                } catch (e) {
                                  setState(() {
                                    isAction = false;
                                  });
                                  print(e);
                                }
                              },
                            )
                          ],
                        ),
                      );
                    }),
        ],
        backgroundColor: primaryAppBarColor,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isError == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => listNotif(),
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
                            "Gagal Memuat Halaman, Tekan Tombol Muat Ulang Halaman Untuk Refresh Halaman",
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
                              listNotif();
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
              : listnotifications.length == 0
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
                              "Belum Ada Notifikasi Di Akun Kamu",
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
                  : Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          isAction == true
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
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                // scrollDirection: Axis.horizontal,
                                itemCount: listnotifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Dismissible(
                                    background: stackBehindDismiss(),
                                    key: ObjectKey(listnotifications[index]),
                                    onDismissed: (direction){
                                      deleteNotif(index);

                                    },
                                    child: Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                          color: listnotifications[index]
                                                          .statusRead ==
                                                      'N' ||
                                                  listnotifications[index]
                                                          .statusRead ==
                                                      null
                                              ? Colors.red
                                              : Colors.grey,
                                          width: 2.0,
                                        ))),
                                        child: ListTile(
                                            trailing: PopupMenuButton<PageEnum>(
                                              onSelected: (PageEnum value) {
                                                switch (value) {
                                                  case PageEnum.detailEvent:
                                                    Navigator.of(context).push(
                                                        CupertinoPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                RegisterEvents(
                                                                  id: int.parse(
                                                                      listnotifications[
                                                                              index]
                                                                          .idevent),
                                                                  creatorId:
                                                                      listnotifications[
                                                                              index]
                                                                          .idcreator,
                                                                  dataUser:
                                                                      dataUser,
                                                                  selfEvent: true,
                                                                )));
                                                    break;
                                                  case PageEnum
                                                      .setujuiConfirmation:
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title:
                                                            Text('Peringatan!'),
                                                        content: Text(
                                                            'Apakah Anda Ingin Menyetujui?'),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('Tidak'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            textColor:
                                                                Colors.green,
                                                            child: Text('Ya'),
                                                            onPressed: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                isAction = true;
                                                              });
                                                              try {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Mohon Tunggu Sebentar");
                                                                final accConfirmation =
                                                                    await http.post(
                                                                        url(
                                                                            'api/accconfirmation_person'),
                                                                        headers:
                                                                            requestHeaders,
                                                                        body: {
                                                                      'event': listnotifications[
                                                                              index]
                                                                          .idevent,
                                                                      'peserta': listnotifications[
                                                                              index]
                                                                          .updatepeserta,
                                                                      'idnotif':
                                                                          listnotifications[index]
                                                                              .id,
                                                                    });
                                                                print(
                                                                    accConfirmation);
                                                                if (accConfirmation
                                                                        .statusCode ==
                                                                    200) {
                                                                  var accConfirmationJson =
                                                                      json.decode(
                                                                          accConfirmation
                                                                              .body);
                                                                  if (accConfirmationJson[
                                                                          'status'] ==
                                                                      'success') {
                                                                    setState(() {
                                                                      isAction =
                                                                          false;
                                                                    });
                                                                    setState(() {
                                                                      listnotifications
                                                                          .remove(
                                                                              listnotifications[index]);
                                                                    });
                                                                    String
                                                                        jumlahnotifterbaru =
                                                                        accConfirmationJson[
                                                                                'notifbelumbaca']
                                                                            .toString();
                                                                    setState(() {
                                                                      jumlahnotifX =
                                                                          jumlahnotifterbaru;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Berhasil");
                                                                  } else if (accConfirmationJson[
                                                                          'status'] ==
                                                                      'Error') {
                                                                    setState(() {
                                                                      isAction =
                                                                          false;
                                                                    });
                                                                    print(
                                                                        accConfirmationJson
                                                                            .body);
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Gagal, Silahkan Coba Lagi");
                                                                  }
                                                                } else {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Gagal, Silahkan Coba Lagi");
                                                                  setState(() {
                                                                    isAction =
                                                                        false;
                                                                  });
                                                                  print(
                                                                      accConfirmation
                                                                          .body);
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Gagal, Silahkan Coba Lagi");
                                                                }
                                                              } on TimeoutException catch (_) {
                                                                setState(() {
                                                                  isAction =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Timed out, Try again");
                                                              } catch (e) {
                                                                setState(() {
                                                                  isAction =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "${e.toString()}");
                                                                print(e);
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                    break;
                                                  case PageEnum.tolakConfirmation:
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title:
                                                            Text('Peringatan!'),
                                                        content: Text(
                                                            'Apakah Anda Ingin Menolak ?'),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('Tidak'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            textColor:
                                                                Colors.green,
                                                            child: Text('Ya'),
                                                            onPressed: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                isAction = true;
                                                              });
                                                              try {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Tunggu Sebentar");
                                                                final tolakConfirmation =
                                                                    await http.post(
                                                                        url(
                                                                            'api/tolakconfirmation_person'),
                                                                        headers:
                                                                            requestHeaders,
                                                                        body: {
                                                                      'event': listnotifications[
                                                                              index]
                                                                          .idevent,
                                                                      'peserta': listnotifications[
                                                                              index]
                                                                          .updatepeserta,
                                                                      'idnotif':
                                                                          listnotifications[index]
                                                                              .id,
                                                                    });
                                                                print(
                                                                    tolakConfirmation);
                                                                if (tolakConfirmation
                                                                        .statusCode ==
                                                                    200) {
                                                                  var tolakConfirmationJson =
                                                                      json.decode(
                                                                          tolakConfirmation
                                                                              .body);
                                                                  if (tolakConfirmationJson[
                                                                          'status'] ==
                                                                      'success') {
                                                                    setState(() {
                                                                      isAction =
                                                                          false;
                                                                    });
                                                                    setState(() {
                                                                      listnotifications
                                                                          .remove(
                                                                              listnotifications[index]);
                                                                    });
                                                                    String
                                                                        jumlahnotifterbaru =
                                                                        tolakConfirmationJson[
                                                                                'notifbelumbaca']
                                                                            .toString();
                                                                    setState(() {
                                                                      jumlahnotifX =
                                                                          jumlahnotifterbaru;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Berhasil");
                                                                  } else if (tolakConfirmationJson[
                                                                          'status'] ==
                                                                      'Error') {
                                                                    setState(() {
                                                                      isAction =
                                                                          false;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Gagal, Silahkan Coba Lagi");
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    isAction =
                                                                        false;
                                                                  });
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Gagal, Silahkan Coba Lagi");
                                                                }
                                                              } on TimeoutException catch (_) {
                                                                setState(() {
                                                                  isAction =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Timed out, Try again");
                                                              } catch (e) {
                                                                setState(() {
                                                                  isAction =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "${e.toString()}");
                                                                print(e);
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                    break;
                                                  case PageEnum.deletePesan:
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title:
                                                            Text('Peringatan!'),
                                                        content: Text(
                                                            'Apakah Anda Ingin Menghapus Pesan?'),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('Tidak'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            textColor:
                                                                Colors.green,
                                                            child: Text('Ya'),
                                                            onPressed: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                isAction = true;
                                                              });
                                                              try {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Tunggu Sebentar");
                                                                final removeConfirmation =
                                                                    await http.post(
                                                                        url(
                                                                            'api/deletepesan_notifikasi'),
                                                                        headers:
                                                                            requestHeaders,
                                                                        body: {
                                                                      'idnotif':
                                                                          listnotifications[index]
                                                                              .id,
                                                                    });
                                                                print(
                                                                    removeConfirmation);
                                                                if (removeConfirmation
                                                                        .statusCode ==
                                                                    200) {
                                                                  var removeConfirmationJson =
                                                                      json.decode(
                                                                          removeConfirmation
                                                                              .body);
                                                                  if (removeConfirmationJson[
                                                                          'status'] ==
                                                                      'success') {
                                                                    setState(() {
                                                                      isAction =
                                                                          false;
                                                                    });
                                                                    setState(() {
                                                                      listnotifications
                                                                          .remove(
                                                                              listnotifications[index]);
                                                                    });
                                                                    String
                                                                        jumlahnotifterbaru =
                                                                        removeConfirmationJson[
                                                                                'notifbelumbaca']
                                                                            .toString();
                                                                    setState(() {
                                                                      jumlahnotifX =
                                                                          jumlahnotifterbaru;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Berhasil");
                                                                  } else if (removeConfirmationJson[
                                                                          'status'] ==
                                                                      'Error') {
                                                                    setState(() {
                                                                      isAction =
                                                                          false;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Gagal, Silahkan Coba Lagi");
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    isAction =
                                                                        false;
                                                                  });
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Gagal, Silahkan Coba Lagi");
                                                                }
                                                              } on TimeoutException catch (_) {
                                                                setState(() {
                                                                  isAction =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Timed out, Try again");
                                                              } catch (e) {
                                                                setState(() {
                                                                  isAction =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "${e.toString()}'");
                                                                print(e);
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                    break;
                                                  default:
                                                    break;
                                                }
                                              },
                                              icon: Icon(Icons.more_vert),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: PageEnum.detailEvent,
                                                  child:
                                                      Text("Lihat Detail Event"),
                                                ),
                                                listnotifications[index]
                                                            .confirmation ==
                                                        'Y'
                                                    ? PopupMenuItem(
                                                        value: PageEnum
                                                            .setujuiConfirmation,
                                                        child: Text("Menyetujui"),
                                                      )
                                                    : null,
                                                listnotifications[index]
                                                            .confirmation ==
                                                        'Y'
                                                    ? PopupMenuItem(
                                                        value: PageEnum
                                                            .tolakConfirmation,
                                                        child: Text("Menolak"),
                                                      )
                                                    : null,
                                                // PopupMenuItem(
                                                //   value: PageEnum.deletePesan,
                                                //   child: Text("Hapus Pesan"),
                                                // ),
                                              ],
                                            ),
                                            leading: Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100.0),
                                                child: Container(
                                                  height: 30.0,
                                                  alignment: Alignment.center,
                                                  width: 30.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            100.0) //                 <--- border radius here
                                                        ),
                                                    color: Color.fromRGBO(
                                                        0, 204, 65, 1.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.message,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: Text(listnotifications[index]
                                                              .title ==
                                                          null ||
                                                      listnotifications[index]
                                                              .title ==
                                                          ''
                                                  ? 'Pesan Tidak Diketahui'
                                                  : listnotifications[index].idmessage == '14'? 
                                                  '${listnotifications[index].namafromperson} - ${listnotifications[index].title}':
                                                  listnotifications[index]
                                                      .title),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: messageEvent(
                                                  listnotifications[index]
                                                      .idmessage,
                                                  listnotifications[index]
                                                      .namaupdateperson,
                                                  listnotifications[index]
                                                      .message,
                                                  listnotifications[index]
                                                      .namaCreator,
                                                  listnotifications[index]
                                                      .namaEvent,
                                                  listnotifications[index]
                                                      .namafromperson,
                                                  listnotifications[index].messageCustom),
                                            )),
                                      ),
                                    ), 
                                  );
                                  
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
    );
  }

  Widget messageEvent(
      idpesan, namaUpdate, pesan, namaCreator, event, namaFrom, pesanCustom) {
    String finalNamaPeserta;

    if (idpesan == '1' || idpesan == '7') {
      finalNamaPeserta = namaCreator;
    } else if (idpesan == '2' ||
        idpesan == '8' ||
        idpesan == '9' ||
        idpesan == '11' ||
        idpesan == '12') {
      finalNamaPeserta = namaUpdate;
    } else if (idpesan == '3' ||
        idpesan == '4' ||
        idpesan == '5' ||
        idpesan == '6') {
      finalNamaPeserta = namaFrom;
    } else if (idpesan == '10') {
      finalNamaPeserta = null;
    } else if (idpesan == '13') {
      finalNamaPeserta = namaFrom;
    }else if(idpesan == '14'){
      finalNamaPeserta = namaFrom;
    } else {
      finalNamaPeserta = null;
    }
    return Text(
        finalNamaPeserta == null
            ? 'Pesan Tidak Diketahui'
            : idpesan == '14' ? '$pesanCustom' : '$finalNamaPeserta $pesan $event',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      );
  }
    Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
