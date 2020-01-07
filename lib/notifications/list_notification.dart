import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
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
bool isLoading, isError;
Map<String, String> requestHeaders = Map();
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
    getHeaderHTTP();
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
      final willcomeevent = await http.get(
        url('api/getnotification_event'),
        headers: requestHeaders,
      );

      if (willcomeevent.statusCode == 200) {
        var listuserJson = json.decode(willcomeevent.body);
        var listUsers = listuserJson['notifikasi'];
        listnotifications = [];
        for (var i in listUsers) {
          ListNotifications willcomex = ListNotifications(
            id: '${i['nev_id']}',
            idcreator: i['nev_toperson'].toString(),
            idtoperson: i['nev_toperson'].toString(),
            idfromperson: i['nev_fromperson'].toString(),
            idevent: i['nev_event'].toString(),
            title: i['n_title'],
            message: i['n_message'],
            confirmation: i['n_confirmation'],
          );
          listnotifications.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (willcomeevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(willcomeevent.body);
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
          ),
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.delete_outline,color:Colors.white),
              onPressed: listnotifications.length == 0 ? null : () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Peringatan!'),
                    content: Text('Apakah Anda Ingin Menhapus Semua Pesan?'),
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
                          try {
                            Fluttertoast.showToast(
                                msg: "Mohon Tunggu Sebentar");
                            final accConfirmation = await http.post(
                              url('api/removeall_notification'),
                              headers: requestHeaders,
                            );
                            print(accConfirmation);
                            if (accConfirmation.statusCode == 200) {
                              var hapuswishlistJson =
                                  json.decode(accConfirmation.body);
                              if (hapuswishlistJson['status'] == 'success') {
                                getHeaderHTTP();
                                Fluttertoast.showToast(msg: "Berhasil");
                              } else if (hapuswishlistJson['status'] ==
                                  'Error') {
                                Fluttertoast.showToast(
                                    msg:
                                        "Request failed with status: ${accConfirmation.statusCode}");
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Request failed with status: ${accConfirmation.statusCode}");
                            }
                          } on TimeoutException catch (_) {
                            Fluttertoast.showToast(msg: "Timed out, Try again");
                          } catch (e) {
                            print(e);
                          }
                        },
                      )
                    ],
                  ),
                );
              }),
        ],
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
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
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                // scrollDirection: Axis.horizontal,
                                itemCount: listnotifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
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
                                                              selfEvent: true,
                                                            )));
                                                break;
                                              case PageEnum.setujuiConfirmation:
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: Text('Peringatan!'),
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
                                                        textColor: Colors.green,
                                                        child: Text('Ya'),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          try {
                                                            Fluttertoast.showToast(
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
                                                                      .idtoperson,
                                                                  'idnotif':
                                                                      listnotifications[
                                                                              index]
                                                                          .id,
                                                                });
                                                            print(
                                                                accConfirmation);
                                                            if (accConfirmation
                                                                    .statusCode ==
                                                                200) {
                                                              var hapuswishlistJson =
                                                                  json.decode(
                                                                      accConfirmation
                                                                          .body);
                                                              if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'success') {
                                                                setState(() {
                                                                  listnotifications.remove(
                                                                      listnotifications[
                                                                          index]);
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Berhasil");
                                                              } else if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'Error') {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Request failed with status: ${accConfirmation.statusCode}");
                                                              }
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Request failed with status: ${accConfirmation.statusCode}");
                                                            }
                                                          } on TimeoutException catch (_) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Timed out, Try again");
                                                          } catch (e) {
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
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: Text('Peringatan!'),
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
                                                        textColor: Colors.green,
                                                        child: Text('Ya'),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          try {
                                                            Fluttertoast.showToast(
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
                                                                      .idtoperson,
                                                                  'idnotif':
                                                                      listnotifications[
                                                                              index]
                                                                          .id,
                                                                });
                                                            print(
                                                                tolakConfirmation);
                                                            if (tolakConfirmation
                                                                    .statusCode ==
                                                                200) {
                                                              var hapuswishlistJson =
                                                                  json.decode(
                                                                      tolakConfirmation
                                                                          .body);
                                                              if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'success') {
                                                                setState(() {
                                                                  listnotifications.remove(
                                                                      listnotifications[
                                                                          index]);
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Berhasil");
                                                              } else if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'Error') {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Request failed with status: ${tolakConfirmation.statusCode}");
                                                              }
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Request failed with status: ${tolakConfirmation.statusCode}");
                                                            }
                                                          } on TimeoutException catch (_) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Timed out, Try again");
                                                          } catch (e) {
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
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: Text('Peringatan!'),
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
                                                        textColor: Colors.green,
                                                        child: Text('Ya'),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          try {
                                                            Fluttertoast.showToast(
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
                                                                      listnotifications[
                                                                              index]
                                                                          .id,
                                                                });
                                                            print(
                                                                removeConfirmation);
                                                            if (removeConfirmation
                                                                    .statusCode ==
                                                                200) {
                                                              var hapuswishlistJson =
                                                                  json.decode(
                                                                      removeConfirmation
                                                                          .body);
                                                              if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'success') {
                                                                setState(() {
                                                                  listnotifications.remove(
                                                                      listnotifications[
                                                                          index]);
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Berhasil");
                                                              } else if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'Error') {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Request failed with status: ${removeConfirmation.statusCode}");
                                                              }
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Request failed with status: ${removeConfirmation.statusCode}");
                                                            }
                                                          } on TimeoutException catch (_) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Timed out, Try again");
                                                          } catch (e) {
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
                                              child: Text("Lihat Detail Event"),
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
                                            PopupMenuItem(
                                              value: PageEnum.deletePesan,
                                              child: Text("Hapus Pesan"),
                                            ),
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
                                              bottom: 10.0),
                                          child: Text(listnotifications[index]
                                                          .title ==
                                                      null ||
                                                  listnotifications[index]
                                                          .title ==
                                                      ''
                                              ? 'Pesan Tidak Diketahui'
                                              : listnotifications[index].title),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            listnotifications[index].message ==
                                                        null ||
                                                    listnotifications[index]
                                                            .message ==
                                                        ''
                                                ? 'Pesan Tidak Diketahui'
                                                : listnotifications[index]
                                                    .message,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
    );
  }
}
