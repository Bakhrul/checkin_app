import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'edit_checkin.dart';
import 'package:flutter/cupertino.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'detail_qrcodecheckin.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'tambah_checkin.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'manage_absenpeserta.dart';

bool isLoading, isError, isDelete;
String tokenType, accessToken;
List<ListCheckinEvent> listcheckinevent = [];
Map<String, String> requestHeaders = Map();
String namaeventX;
enum PageEnum {
  editCheckinPage,
  deleteCheckinPage,
  detailQrCodePage,
  listUsersCheckinPage,
}

class ManageCheckin extends StatefulWidget {
  ManageCheckin({Key key, this.title, this.event, this.eventEnd}) : super(key: key);
  final String title, event;
  final bool eventEnd;
  @override
  State<StatefulWidget> createState() {
    return _ManageCheckinState();
  }
}

class _ManageCheckinState extends State<ManageCheckin> {
  @override
  void initState() {
    super.initState();
    namaeventX = '';
    isDelete = false;
    isError = false;
    isLoading = true;
    getHeaderHTTP();
  }

  void dispose() {
    super.dispose();
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
    return listcheckin();
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
      final getCheckinEvent = await http.post(
        url('api/listcheckinevent'),
        body: {'event': widget.event},
        headers: requestHeaders,
      );

      if (getCheckinEvent.statusCode == 200) {
        var listCheckinJson = json.decode(getCheckinEvent.body);
        var listCheckins = listCheckinJson['checkin'];
        String namaevent = listCheckinJson['namaevent'];
        setState(() {
          namaeventX = namaevent;
        });
        print(listCheckins);
        listcheckinevent = [];
        for (var i in listCheckins) {
          ListCheckinEvent willcomex = ListCheckinEvent(
            idevent: '${i['ec_eventsid']}',
            id: '${i['ec_checkid']}',
            name: i['ec_name'],
            code: i['ec_keyword'],
            timestart: i['ec_time_start'],
            timeend: i['ec_time_end'],
            typecheckin: i['ec_type'],
            checkin: i['uc_time'],
          );
          listcheckinevent.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getCheckinEvent.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(getCheckinEvent.body);
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

  Widget appBarTitle = Text(
    "Kelola Waktu Checkin Event",
    style: TextStyle(fontSize: 16),
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
              : listcheckinevent.length == 0
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
                              "Event Belum Memiliki Checkin Sama Sekali",
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
                          isDelete == true
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
                                itemCount: listcheckinevent.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime waktuawal = DateTime.parse(
                                      listcheckinevent[index].timestart);
                                  DateTime waktuakhir = DateTime.parse(
                                      listcheckinevent[index].timeend);
                                  String timestart =
                                      DateFormat('dd-MM-y HH:mm:ss')
                                          .format(waktuawal);
                                  String timeend =
                                      DateFormat('dd-MM-y HH:mm:ss')
                                          .format(waktuakhir);
                                  return Card(
                                    child: ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Container(
                                            height: 15.0,
                                            alignment: Alignment.center,
                                            width: 15.0,
                                            color:
                                                Color.fromRGBO(41, 30, 47, 1),
                                          ),
                                        ),
                                      ),
                                      trailing: PopupMenuButton<PageEnum>(
                                        onSelected: isDelete == true ? null : (PageEnum value) async {
                                          switch (value) {
                                            case PageEnum.editCheckinPage:
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ManajemeEditCheckin(
                                                            event:
                                                                listcheckinevent[
                                                                        index]
                                                                    .idevent,
                                                            idcheckin:
                                                                listcheckinevent[
                                                                        index]
                                                                    .id,
                                                            namacheckin:
                                                                listcheckinevent[
                                                                        index]
                                                                    .name,
                                                            kodecheckin:
                                                                listcheckinevent[
                                                                        index]
                                                                    .code,
                                                            timestart:
                                                                listcheckinevent[
                                                                        index]
                                                                    .timestart,
                                                            typecheckin:
                                                                listcheckinevent[
                                                                        index]
                                                                    .typecheckin,
                                                            timeend:
                                                                listcheckinevent[
                                                                        index]
                                                                    .timeend,
                                                          )));
                                              break;
                                            case PageEnum.detailQrCodePage:
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          DetailQrCheckin(
                                                            event:
                                                                listcheckinevent[
                                                                        index]
                                                                    .idevent,
                                                            checkin:
                                                                listcheckinevent[
                                                                        index]
                                                                    .id,
                                                            kodecheckin:
                                                                listcheckinevent[
                                                                        index]
                                                                    .code,
                                                            namaEvent:
                                                                namaeventX,
                                                          )));
                                              break;
                                            case PageEnum.deleteCheckinPage:
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: Text('Peringatan!'),
                                                  content: Text(
                                                      'Apakah Anda Ingin Menghapus Checkin Event?'),
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
                                                          isDelete = true;
                                                        });
                                                        try {
                                                          final removeCheckin =
                                                              await http.post(
                                                                  url('api/deletecheckin_event'),
                                                                  headers: requestHeaders,
                                                                  body: {
                                                                'event':
                                                                    listcheckinevent[
                                                                            index]
                                                                        .idevent,
                                                                'checkin':
                                                                    listcheckinevent[
                                                                            index]
                                                                        .id
                                                              });
                                                          print(removeCheckin);
                                                          if (removeCheckin
                                                                  .statusCode ==
                                                              200) {
                                                            var removeCheckinJson =
                                                                json.decode(
                                                                    removeCheckin
                                                                        .body);
                                                            if (removeCheckinJson[
                                                                    'status'] ==
                                                                'success') {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Berhasil Menghapus Checkin Event");
                                                              setState(() {
                                                                isDelete =
                                                                    false;
                                                              });
                                                              setState(() {
                                                                listcheckinevent.remove(
                                                                    listcheckinevent[
                                                                        index]);
                                                              });
                                                            } else if (removeCheckinJson[
                                                                    'status'] ==
                                                                'Error') {
                                                              setState(() {
                                                                isDelete =
                                                                    false;
                                                              });
                                                         Fluttertoast.showToast(
                                                                              msg: "Gagal, Silahkan Coba Kembali");
                                                            }
                                                          } else {
                                                            print(removeCheckin
                                                                .body);
                                                            setState(() {
                                                              isDelete = false;
                                                            });
                                                             Fluttertoast.showToast(
                                                                              msg: "Gagal, Silahkan Coba Kembali");
                                                          }
                                                        } on TimeoutException catch (_) {
                                                          setState(() {
                                                            isDelete = false;
                                                          });
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Timed out, Try again");
                                                        } catch (e) {
                                                          setState(() {
                                                            isDelete = false;
                                                          });
                                                          Fluttertoast.showToast(
                                                                              msg: "Gagal, Silahkan Coba Kembali");
                                                          print(e);
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );

                                              break;
                                            case PageEnum.listUsersCheckinPage:
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ManageAbsenPeserta(
                                                              idevent:
                                                                  listcheckinevent[
                                                                          index]
                                                                      .idevent,
                                                              idcheckin:
                                                                  listcheckinevent[
                                                                          index]
                                                                      .id)));
                                              break;
                                            default:
                                              break;
                                          }
                                        },
                                        icon: Icon(Icons.more_vert),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value:
                                                PageEnum.listUsersCheckinPage,
                                            child: Text("List Peserta Checkin"),
                                          ),
                                          PopupMenuItem(
                                            value: PageEnum.detailQrCodePage,
                                            child: Text('Download QRImage'),
                                          ),
                                          listcheckinevent[index].checkin == null ||
                                                  listcheckinevent[index] .checkin == ''
                                              ? widget.eventEnd == true ? null : PopupMenuItem(
                                                  value:
                                                      PageEnum.editCheckinPage,
                                                  child: Text("Edit"),
                                                )
                                              : null,
                                          listcheckinevent[index].checkin ==
                                                      null ||
                                                  listcheckinevent[index]
                                                          .checkin ==
                                                      ''
                                              ? widget.eventEnd == true ? null : PopupMenuItem(
                                                  value: PageEnum
                                                      .deleteCheckinPage,
                                                  child: Text("Delete"),
                                                )
                                              : null,
                                        ],
                                      ),
                                      title: Text(
                                        '${listcheckinevent[index].name} - ${listcheckinevent[index].code}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      subtitle: Text('$timestart - $timeend'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
      floatingActionButton: widget.eventEnd == true ? null : FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ManajemenTambahCheckin(event: widget.event)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
      ],
    );
  }
}
