import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'edit_event.dart';
import 'manage_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'manage_checkin.dart';
import 'list_multicheckin.dart';
import 'dart:async';
import 'dart:convert';
import 'model.dart';
import 'point_person.dart';
import 'manage_peserta.dart';

bool isLoading, isError, isDelete;
String tokenType, accessToken;
String jumlahongoingX, jumlahwillcomeX, jumlahdoneeventX;
Map<String, String> requestHeaders = Map();
List<ListMoreMyEvent> listMoreMyEvent = [];
enum PageEnum {
  kelolaeditEventPage,
  kelolaPesertaPage,
  kelolaWaktuCheckinPage,
  kelolaAbsenPesertaPage,
  kelolaCheckinPesertaPage,
  kelolaHasilAKhirPage,
  kelolaadminPage,
  deleteEvent,
}

class ManajemenMoreMyEvent extends StatefulWidget {
  ManajemenMoreMyEvent({Key key, this.title, this.type, this.textEvent, this.eventEnd}) : super(key: key);
  final String title, type, textEvent;
  final bool eventEnd;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenMoreMyEventState();
  }
}

class _ManajemenMoreMyEventState extends State<ManajemenMoreMyEvent> {
  var height;
  var futureheight;
  var pastheight;

  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    isLoading = true;
    jumlahongoingX = null;
    jumlahwillcomeX = null;
    jumlahdoneeventX = null;
    isError = false;
    isDelete = false;
  }

  void dispose() {
    super.dispose();
  }

  void konfirmasidelete(idevent, index, indexid) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Peringatan!'),
        content:
            Text('Apakah Anda Ingin Menghapus Event Ini Secara Permanen? '),
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
              Navigator.pop(context);
              _deleteEvent(idevent);
            },
          )
        ],
      ),
    );
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
    return listOngoingEvent();
  }

  Future<List<List>> listOngoingEvent() async {
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
      final getOngoningMyEvent = await http.post(
        url('api/more_resourcemyevent'),
        headers: requestHeaders,
        body: {'type' : widget.type}
      );

      if (getOngoningMyEvent.statusCode == 200) {
        // return nota;
        var ongoingeventJson = json.decode(getOngoningMyEvent.body);
        var ongoingevents = ongoingeventJson['more_event'];
        listMoreMyEvent = [];
        for (var i in ongoingevents) {
          ListMoreMyEvent notax = ListMoreMyEvent(
            id: '${i['ev_id']}',
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            deskripsi: i['ev_detail'],
            lokasi: i['ev_location'],
            fullday: i['ev_allday'],
            status: i['status'],
          );
          listMoreMyEvent.add(notax);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getOngoningMyEvent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(getOngoningMyEvent.body);
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

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          'Semua ${widget.textEvent}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
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
              : Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        isDelete == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      width: 15.0,
                                      margin: EdgeInsets.only(
                                          top: 10.0, right: 15.0,bottom: 20.0),
                                      height: 15.0,
                                      child: CircularProgressIndicator()),
                                ],
                              )
                            : Container(),
                        RefreshIndicator(
                            onRefresh: () => listOngoingEvent(),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: listMoreMyEvent
                                        .map((ListMoreMyEvent item) =>
                                            Container(
                                                height: futureheight,
                                                child: Card(
                                                    child: ListTile(
                                                  leading: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 2.0,
                                                    ))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          item.waktuawal == null
                                                              ? 'Unknown Date'
                                                              : DateFormat(
                                                                      'dd-MM-y')
                                                                  .format(DateTime
                                                                      .parse(item
                                                                          .waktuawal)),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child: Text(
                                                            item.waktuakhir ==
                                                                    null
                                                                ? 'Unknown Date'
                                                                : DateFormat(
                                                                        'dd-MM-y')
                                                                    .format(DateTime
                                                                        .parse(item
                                                                            .waktuakhir)),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  title: Text(
                                                    item.title == null ||
                                                            item.title == ''
                                                        ? 'Nama Event Tidak Diketahui'
                                                        : item.title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  trailing:
                                                      PopupMenuButton<PageEnum>(
                                                    onSelected:
                                                        (PageEnum value) {
                                                      switch (value) {
                                                        case PageEnum
                                                            .kelolaeditEventPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManajemeEditEvent(
                                                                        idevent:
                                                                            item.id,
                                                                        nama: item
                                                                            .title,
                                                                        lokasi:
                                                                            item.lokasi,
                                                                        waktuawal:
                                                                            item.waktuawal,
                                                                        waktuakhir:
                                                                            item.waktuakhir,
                                                                        deskripsi:
                                                                            item.deskripsi,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaadminPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManageAdmin(
                                                                          event:
                                                                              item.id,
                                                                              eventEnd: widget.eventEnd)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaPesertaPage:
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ManagePeserta(
                                                                      event: item
                                                                          .id,
                                                                          eventEnd: widget.eventEnd,)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaWaktuCheckinPage:
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ManageCheckin(
                                                                      event: item
                                                                          .id,
                                                                          eventEnd:  widget.eventEnd,)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaCheckinPesertaPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ListMultiCheckin(event:item.id)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaHasilAKhirPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      PointEvents(
                                                                          idevent:
                                                                              item.id)));
                                                          break;
                                                        case PageEnum
                                                            .deleteEvent:
                                                          konfirmasidelete(
                                                              item.id,
                                                              listMoreMyEvent,
                                                              item);
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                    icon: Icon(Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                      item.status == 'creator'
                                                          ? widget.eventEnd == true ? null : PopupMenuItem(
                                                              value: PageEnum
                                                                  .kelolaeditEventPage,
                                                              child: Text(
                                                                  "Edit Data Event"),
                                                            )
                                                          : null,
                                                      item.status == 'creator'
                                                          ? PopupMenuItem(
                                                              value: PageEnum
                                                                  .kelolaadminPage,
                                                              child: Text(
                                                                  "Kelola Admin / Co - Host"),
                                                            )
                                                          : null,
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaPesertaPage,
                                                        child: Text(
                                                            "Kelola Peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaWaktuCheckinPage,
                                                        child: Text(
                                                            "Kelola waktu checkin"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaCheckinPesertaPage,
                                                        child: Text(
                                                            "Kelola checkin peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaHasilAKhirPage,
                                                        child: Text(
                                                            "Hasil akhir checkin peserta"),
                                                      ),
                                                      item.status == 'creator'
                                                          ? PopupMenuItem(
                                                              value: PageEnum
                                                                  .deleteEvent,
                                                              child: Text(
                                                                  "Hapus Event"),
                                                            )
                                                          : null,
                                                    ],
                                                  ),
                                                ))))
                                        .toList(),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
    );
  }

  void _deleteEvent(idevent) async {
    try {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      final deleteEvent = await http
          .post(url('api/deleteevent'), headers: requestHeaders, body: {
        'event': idevent,
      });

      if (deleteEvent.statusCode == 200) {
        var deleteEventJson = json.decode(deleteEvent.body);
        if (deleteEventJson['status'] == 'success') {
          setState(() {
            isDelete = false;
          });
          listOngoingEvent();
          Fluttertoast.showToast(msg: "Berhasil Menghapus Event");
        }
      } else {
        setState(() {
          isDelete = false;
        });
        print(deleteEvent.body);
   Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
      }
    } on TimeoutException catch (_) {
      setState(() {
        isDelete = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isDelete = false;
      });
      Fluttertoast.showToast(msg: "${e.toString()}");
      print(e);
    }
  }
}
