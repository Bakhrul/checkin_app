import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'edit_event.dart';
import 'manage_admin.dart';
import 'package:flutter/cupertino.dart';
import 'create.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'manage_checkin.dart';
import 'list_multicheckin.dart';
import 'dart:async';
import 'dart:convert';
import 'model.dart';
import 'detail_index.dart';
import 'point_person.dart';
import 'manage_peserta.dart';

import 'package:checkin_app/utils/utils.dart';

bool isLoading, isError, isDelete;
String tokenType, accessToken;
String jumlahongoingX, jumlahwillcomeX, jumlahdoneeventX;
Map<String, String> requestHeaders = Map();
List<ListOngoingEvent> listItemOngoing = [];
List<ListWillComeEvent> listItemWillCome = [];
List<ListDoneEvent> listItemDoneEvent = [];
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

class ManajemenEventPersonal extends StatefulWidget {
  ManajemenEventPersonal({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventPersonalState();
  }
}

class _ManajemenEventPersonalState extends State<ManajemenEventPersonal> {
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

  void currentEvent() {
    setState(() {
      if (height == 0.0) {
        height = null;
      } else {
        height = 0.0;
      }
    });
  }

  void futureEvent() {
    setState(() {
      if (futureheight == 0.0) {
        futureheight = null;
      } else {
        futureheight = 0.0;
      }
    });
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

  void pastEvent() {
    setState(() {
      if (pastheight == 0.0) {
        pastheight = null;
      } else {
        pastheight = 0.0;
      }
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
        url('api/getongoingmyevent'),
        headers: requestHeaders,
      );

      if (getOngoningMyEvent.statusCode == 200) {
        // return nota;
        var ongoingeventJson = json.decode(getOngoningMyEvent.body);
        var ongoingevents = ongoingeventJson['eventongoing'];
        String jumlahongoing = ongoingeventJson['jumlahongoing'].toString();
        listItemOngoing = [];
        for (var i in ongoingevents) {
          ListOngoingEvent notax = ListOngoingEvent(
            id: '${i['ev_id']}',
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            deskripsi: i['ev_detail'],
            lokasi: i['ev_location'],
            fullday: i['ev_allday'],
            status: i['status'],
          );
          listItemOngoing.add(notax);
        }
        setState(() {
          isLoading = false;
          jumlahongoingX = jumlahongoing;
          isError = false;
        });
        listWillComeEvent();
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

  Future<List<ListWillComeEvent>> listWillComeEvent() async {
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
      final getWillComeMyEvent = await http.post(
        url('api/getwillcomemyevent'),
        headers: requestHeaders,
      );

      if (getWillComeMyEvent.statusCode == 200) {
        // return nota;
        var willcomeeventJson = json.decode(getWillComeMyEvent.body);
        var willcomeEvents = willcomeeventJson['eventakandatang'];
        print(willcomeEvents);
        String jumlahwillcome =
            willcomeeventJson['jumlahakandatang'].toString();
        print('willcome $jumlahwillcome');
        listItemWillCome = [];
        for (var i in willcomeEvents) {
          ListWillComeEvent willcomex = ListWillComeEvent(
            id: '${i['ev_id']}',
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            deskripsi: i['ev_detail'],
            lokasi: i['ev_location'],
            fullday: i['ev_allday'],
            status: i['status'],
          );
          listItemWillCome.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          jumlahwillcomeX = jumlahwillcome;
        });
        listDoneEvent();
      } else if (getWillComeMyEvent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(getWillComeMyEvent.body);
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

  Future<List<ListWillComeEvent>> listDoneEvent() async {
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
      final getDoneMyEvent = await http.post(
        url('api/getdonemyevent'),
        headers: requestHeaders,
      );

      if (getDoneMyEvent.statusCode == 200) {
        // return nota;
        var doneeventJson = json.decode(getDoneMyEvent.body);
        var doneEvents = doneeventJson['eventselesai'];
        String jumlahdoneevent = doneeventJson['jumlahselesai'].toString();

        listItemDoneEvent = [];
        for (var i in doneEvents) {
          ListDoneEvent donex = ListDoneEvent(
            id: '${i['ev_id']}',
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            deskripsi: i['ev_detail'],
            lokasi: i['ev_location'],
            fullday: i['ev_allday'],
            status: i['status'],
          );
          listItemDoneEvent.add(donex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          jumlahdoneeventX = jumlahdoneevent;
        });
      } else if (getDoneMyEvent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
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
        backgroundColor: primaryAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Event Saya",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            tooltip: 'Buat Event Sekarang',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManajemeCreateEvent(),
                  ));
            },
          ),
        ],
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
                  padding: const EdgeInsets.only(top: 30.0),
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
                                          top: 10.0, right: 15.0, bottom: 20.0),
                                      height: 15.0,
                                      child: CircularProgressIndicator()),
                                ],
                              )
                            : Container(),
                        RefreshIndicator(
                            onRefresh: () => listOngoingEvent(),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                    onTap: currentEvent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin:Alignment.topLeft,
                                          end:Alignment.bottomRight,
                                          colors: [Colors.white,Colors.grey[50]]
                                        )
                                        
                                      ),
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0, top: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                                (jumlahongoingX == null
                                                        ? 'Event Berlangsung  ( 0 Event )'
                                                        : 'Event Berlangsung  ( $jumlahongoingX Event )')
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            Icon(height == null
                                                ? Icons.arrow_drop_down
                                                : Icons.arrow_drop_up),
                                          ],
                                        ),
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: listItemOngoing
                                        .map((ListOngoingEvent item) =>
                                            Container(
                                              height: height,
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
                                                        DateFormat('dd MMM yyyy').format(DateTime.parse(item.waktuawal)) == DateFormat('dd MMM yyyy').format(DateTime.parse(item.waktuakhir)) ? 
                                                        Column():
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
                                                        ? 'Unknown Nama Event'
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
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext context) => ManajemeEditEvent(
                                                                  idevent:
                                                                      item.id,
                                                                  nama: item
                                                                      .title,
                                                                  lokasi: item
                                                                      .lokasi,
                                                                  waktuawal: item
                                                                      .waktuawal,
                                                                  waktuakhir: item
                                                                      .waktuakhir,
                                                                  deskripsi: item
                                                                      .deskripsi)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaadminPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManageAdmin(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            false,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaPesertaPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManagePeserta(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            false,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaWaktuCheckinPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManageCheckin(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            false,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaCheckinPesertaPage:
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ListMultiCheckin(
                                                                      event: item
                                                                          .id)));
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
                                                              listItemOngoing,
                                                              item);
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                    icon: Icon(Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                      // item.status == 'creator'
                                                      //     ? PopupMenuItem(
                                                      //         value: PageEnum
                                                      //             .kelolaeditEventPage,
                                                      //         child: Text(
                                                      //             "Edit Data Event"),
                                                      //       )
                                                      //     : null,
                                                      item.status == 'creator'
                                                          ? PopupMenuItem(
                                                              value: PageEnum
                                                                  .kelolaadminPage,
                                                              child: Text(
                                                                  "Kelola Admin / Co-Host"),
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
                                                            "Kelola Waktu Check-In"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaCheckinPesertaPage,
                                                        child: Text(
                                                            "Kelola Check-In Peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaHasilAKhirPage,
                                                        child: Text(
                                                            "Hasil Akhir Check-In Peserta"),
                                                      ),
                                                      // item.status == 'creator'
                                                      //     ? PopupMenuItem(
                                                      //         value: PageEnum
                                                      //             .deleteEvent,
                                                      //         child: Text(
                                                      //             "Hapus Event"),
                                                      //       )
                                                      //     : null,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                listItemOngoing.length == 5 ?
                                Container(
                                  height: height,
                                  child: FlatButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManajemenMoreMyEvent(
                                                    type: "berlangsung",
                                                    textEvent: 'Event Berlangsung',
                                                    eventEnd: false,
                                                  )));
                                    },
                                    color: Colors.transparent,
                                    textColor: Colors.black,
                                    child: Text('Lihat Semua'),
                                  ),
                                ):
                                Container(),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Divider(),
                                ),
                                InkWell(
                                  onTap: futureEvent,
                                  child: Container(
                                     decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin:Alignment.topLeft,
                                          end:Alignment.bottomRight,
                                          colors: [Colors.white,Colors.grey[50]]
                                        )
                                        
                                      ),
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              (jumlahwillcomeX == null
                                                      ? 'Event Akan Datang  ( 0 Event )'
                                                      : 'Event Akan Datang  ( $jumlahwillcomeX Event )')
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Icon(futureheight == null
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_drop_up),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: listItemWillCome
                                        .map((ListWillComeEvent item) =>
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
                                                        DateFormat('dd MMM yyyy').format(DateTime.parse(item.waktuawal)) == DateFormat('dd MMM yyyy').format(DateTime.parse(item.waktuakhir)) ? 
                                                        Column():
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
                                                        ? 'Unknown Nama Event'
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
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ManageAdmin(
                                                                      event: item
                                                                          .id,
                                                                      eventEnd:
                                                                          false)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaPesertaPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManagePeserta(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            false,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaWaktuCheckinPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManageCheckin(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            false,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaCheckinPesertaPage:
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ListMultiCheckin(
                                                                      event: item
                                                                          .id)));
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
                                                              listItemWillCome,
                                                              item);
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                    icon: Icon(Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                      item.status == 'creator'
                                                          ? PopupMenuItem(
                                                              value: PageEnum
                                                                  .kelolaeditEventPage,
                                                              child: Text(
                                                                  "Edit data event"),
                                                            )
                                                          : null,
                                                      item.status == 'creator'
                                                          ? PopupMenuItem(
                                                              value: PageEnum
                                                                  .kelolaadminPage,
                                                              child: Text(
                                                                  "K. admin / co-host"),
                                                            )
                                                          : null,
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaPesertaPage,
                                                        child: Text(
                                                            "K. peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaWaktuCheckinPage,
                                                        child: Text(
                                                            "K. waktu checkin"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaCheckinPesertaPage,
                                                        child: Text(
                                                            "K. checkin peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaHasilAKhirPage,
                                                        child: Text(
                                                            "Hasil akhir checkin peserta"),
                                                      ),
                                                      item.status == 'creator'
                                                          ?  PopupMenuItem(
                                                              value: PageEnum
                                                                  .deleteEvent,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Divider(color: Colors.black38),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top:10.0),
                                                                    child: Text('Hapus event'),
                                                                  ),
                                                                ]
                                                                  ),
                                                            )
                                                          : null,
                                                    ],
                                                  ),
                                                ))))
                                        .toList(),
                                  ),
                                ),
                                listItemWillCome.length == 5 ?
                                Container(
                                  height: futureheight,
                                  child: FlatButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManajemenMoreMyEvent(
                                                    type: "akan datang",
                                                    textEvent:
                                                        'Event Akan Datang',
                                                    eventEnd: false,
                                                  )));
                                    },
                                    color: Colors.transparent,
                                    textColor: Colors.black,
                                    child: Text('Lihat Semua'),
                                  ),
                                ): Container(),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Divider(),
                                ),
                                InkWell(
                                    onTap: pastEvent,
                                    child: Container(
                                       decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin:Alignment.topLeft,
                                          end:Alignment.bottomRight,
                                          colors: [Colors.white,Colors.grey[50]]
                                        )
                                        
                                      ),
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0, top: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                                (jumlahdoneeventX == null
                                                        ? 'Event Telah Selesai  ( 0 Event )'
                                                        : 'Event Telah Selesai ( $jumlahdoneeventX Event )')
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            Icon(pastheight == null
                                                ? Icons.arrow_drop_down
                                                : Icons.arrow_drop_up),
                                          ],
                                        ),
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: listItemDoneEvent
                                        .map((ListDoneEvent item) => Container(
                                              height: pastheight,
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
                                                        DateFormat('dd MMM yyyy').format(DateTime.parse(item.waktuawal)) == DateFormat('dd MMM yyyy').format(DateTime.parse(item.waktuakhir)) ? 
                                                        Column():
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
                                                        ? 'Unknown Nama Event'
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
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext context) => ManajemeEditEvent(
                                                                  idevent:
                                                                      item.id,
                                                                  nama: item
                                                                      .title,
                                                                  lokasi: item
                                                                      .lokasi,
                                                                  waktuawal: item
                                                                      .waktuawal,
                                                                  waktuakhir: item
                                                                      .waktuakhir,
                                                                  deskripsi: item
                                                                      .deskripsi)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaadminPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManageAdmin(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            true,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaPesertaPage:
                                                          Navigator.of(context).push(
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ManagePeserta(
                                                                        event: item
                                                                            .id,
                                                                        eventEnd:
                                                                            true,
                                                                      )));
                                                          break;
                                                        case PageEnum
                                                            .kelolaWaktuCheckinPage:
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ManageCheckin(
                                                                      event: item
                                                                          .id,
                                                                      eventEnd:
                                                                          true)));
                                                          break;
                                                        case PageEnum
                                                            .kelolaCheckinPesertaPage:
                                                          Navigator.of(context).push(CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ListMultiCheckin(
                                                                      event: item
                                                                          .id)));
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
                                                              listItemDoneEvent,
                                                              item);
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                    icon: Icon(Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                      // item.status == 'creator'
                                                      //     ? PopupMenuItem(
                                                      //         value: PageEnum
                                                      //             .kelolaeditEventPage,
                                                      //         child: Text(
                                                      //             "Edit Data Event"),
                                                      //       )
                                                      //     : null,
                                                      item.status == 'creator'
                                                          ? PopupMenuItem(
                                                              value: PageEnum
                                                                  .kelolaadminPage,
                                                              child: Text(
                                                                  "K. admin / co-host"),
                                                            )
                                                          : null,
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaPesertaPage,
                                                        child: Text(
                                                            "K. peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaWaktuCheckinPage,
                                                        child: Text(
                                                            "K. waktu Checkin"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaCheckinPesertaPage,
                                                        child: Text(
                                                            "K. Checkin peserta"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: PageEnum
                                                            .kelolaHasilAKhirPage,
                                                        child: Text(
                                                            "Hasil akhir checkin peserta"),
                                                      ),
                                                      item.status == 'creator'
                                                          ?
                                                           PopupMenuItem(
                                                              value: PageEnum
                                                                  .deleteEvent,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Divider(color: Colors.black38),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top:10.0),
                                                                    child: Text('Hapus event'),
                                                                  ),
                                                                ]
                                                                  ),
                                                            )
                                                          : null,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                listItemDoneEvent.length == 5 ?
                                Container(
                                  height: pastheight,
                                  child: FlatButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManajemenMoreMyEvent(
                                                    type: "selesai",
                                                    textEvent: 'Event Selesai',
                                                    eventEnd: true,
                                                  )));
                                    },
                                    color: Colors.transparent,
                                    textColor: Colors.black,
                                    child: Text('Lihat Semua'),
                                  ),
                                ): Container(),
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
