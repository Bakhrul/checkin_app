import 'package:checkin_app/pages/events_personal/model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'create.dart';
import 'package:checkin_app/routes/env.dart';
import 'manage_absenpeserta.dart';
import 'package:http/http.dart' as http;
import 'manage_checkin.dart';
import 'list_multicheckin.dart';
import 'dart:async';
import 'dart:convert';
import 'model.dart';
import 'point_person.dart';
import 'manage_peserta.dart';

GlobalKey<ScaffoldState> _scaffoldKeypersonalevent;
bool isLoading, isError;
String jumlahongoingX, jumlahwillcomeX, jumlahdoneeventX;
List<ListOngoingEvent> listItemOngoing = [];
List<ListWillComeEvent> listItemWillCome = [];
List<ListDoneEvent> listItemDoneEvent = [];
enum PageEnum {
  kelolaPesertaPage,
  kelolaWaktuCheckinPage,
  kelolaAbsenPesertaPage,
  kelolaCheckinPesertaPage,
  kelolaHasilAKhirPage,
}

void showInSnackBar(String value) {
  _scaffoldKeypersonalevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
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
    _scaffoldKeypersonalevent = new GlobalKey<ScaffoldState>();
    super.initState();
    listOngoingEvent();
    isLoading = true;
    jumlahongoingX = null;
    jumlahwillcomeX = null;
    jumlahdoneeventX = null;
    isError = false;
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

  void pastEvent() {
    setState(() {
      if (pastheight == 0.0) {
        pastheight = null;
      } else {
        pastheight = 0.0;
      }
    });
  }

  Future<List<List>> listOngoingEvent() async {
    setState(() {
      isLoading = true;
    });
    try {
      final ongoingevent = await http.post(
        url('api/getongoingmyevent'),
        // headers: requestHeaders,
      );

      if (ongoingevent.statusCode == 200) {
        // return nota;
        var ongoingeventJson = json.decode(ongoingevent.body);
        var ongoingevents = ongoingeventJson['eventongoing'];
        String jumlahongoing = ongoingeventJson['jumlahongoing'].toString();
        listItemOngoing = [];
        for (var i in ongoingevents) {
          ListOngoingEvent notax = ListOngoingEvent(
            id: '${i['ev_id']}',
            title: i['ev_title'],
            waktuawal: i['tanggalawal'],
            waktuakhir: i['tanggalakhir'],
            fullday: i['ev_allday'],
          );
          listItemOngoing.add(notax);
        }
        setState(() {
          isLoading = false;
          jumlahongoingX = jumlahongoing;
          isError = false;
        });
        listWillComeEvent();
      } else {
        print('error');
        print(ongoingevent.body);
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
      showInSnackBar('Timed out, Try again');
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
    setState(() {
      isLoading = true;
    });
    try {
      final willcomeevent = await http.post(
        url('api/getwillcomemyevent'),
        // headers: requestHeaders,
      );

      if (willcomeevent.statusCode == 200) {
        // return nota;
        var willcomeeventJson = json.decode(willcomeevent.body);
        var willcomeEvents = willcomeeventJson['eventakandatang'];
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
            fullday: i['ev_allday'],
          );
          listItemWillCome.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          jumlahwillcomeX = jumlahwillcome;
        });
        listDoneEvent();
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
      showInSnackBar('Timed out, Try again');
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
    setState(() {
      isLoading = true;
    });
    try {
      final doneevent = await http.post(
        url('api/getdonemyevent'),
        // headers: requestHeaders,
      );

      if (doneevent.statusCode == 200) {
        // return nota;
        var doneeventJson = json.decode(doneevent.body);
        var doneEvents = doneeventJson['eventselesai'];
        String jumlahdoneevent = doneeventJson['jumlahselesai'].toString();

        listItemDoneEvent = [];
        for (var i in doneEvents) {
          ListDoneEvent donex = ListDoneEvent(
            id: '${i['ev_id']}',
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            fullday: i['ev_allday'],
          );
          listItemDoneEvent.add(donex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          jumlahdoneeventX = jumlahdoneevent;
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
      showInSnackBar('Timed out, Try again');
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }
  

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.kelolaPesertaPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManagePeserta()));
        break;
      case PageEnum.kelolaWaktuCheckinPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManageCheckin()));
        break;
      case PageEnum.kelolaAbsenPesertaPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManageAbsenPeserta()));
        break;
      case PageEnum.kelolaCheckinPesertaPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ListMultiCheckin()));
        break;
      case PageEnum.kelolaHasilAKhirPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => PointEvents()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeypersonalevent,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Event yang anda buat",
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
      body:
      isLoading == true ?
      Center(
                        child: CircularProgressIndicator(),
                      ):
       Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RefreshIndicator(
                      onRefresh: () => listOngoingEvent(),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                              onTap: currentEvent,
                              child: Container(
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
                                  .map((ListOngoingEvent item) => Container(
                                        height: height,
                                        child: Card(
                                          child: ListTile(
                                            leading: Container(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                color: Colors.lightBlue,
                                                width: 2.0,
                                              ))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '12/31/2019',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Text(
                                                      '12/31/2019',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            title: Text(
                                              item.title == null
                                                  ? 'Unknown Nama Event'
                                                  : item.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Text('12:00 - 13:00'),
                                            ),
                                            trailing: PopupMenuButton<PageEnum>(
                                              onSelected: _onSelect,
                                              icon: Icon(Icons.more_vert),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: PageEnum
                                                      .kelolaPesertaPage,
                                                  child: Text("Kelola Peserta"),
                                                ),
                                                PopupMenuItem(
                                                  value: PageEnum
                                                      .kelolaWaktuCheckinPage,
                                                  child: Text(
                                                      "Kelola waktu checkin"),
                                                ),
                                                PopupMenuItem(
                                                  value: PageEnum
                                                      .kelolaAbsenPesertaPage,
                                                  child: Text(
                                                      "Kelola absen peserta"),
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
                                                PopupMenuItem(
                                                  child: Text("Hapus Event"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Divider(),
                          ),
                          InkWell(
                            onTap: futureEvent,
                            child: Container(
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
                                                ? 'Event Yang Akan Datang  ( 0 Event )'
                                                : 'Event Yang Akan Datang  ( $jumlahwillcomeX Event )')
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
                                  .map((ListWillComeEvent item) => Container(
                                      height: futureheight,
                                      child: Card(
                                          child: ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.only(right: 10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 2.0,
                                          ))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                item.waktuawal == null ?'12/31/2019' : item.waktuawal,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       top: 10.0),
                                              //   child: Text(
                                              //     '12/31/2019',
                                              //     style: TextStyle(
                                              //         fontWeight:
                                              //             FontWeight.bold),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          item.title == null ? 'Unknown Nama Event' : item.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text('12:00 - 13:00'),
                                        ),
                                        trailing: PopupMenuButton<PageEnum>(
                                          onSelected: _onSelect,
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: PageEnum.kelolaPesertaPage,
                                              child: Text("Kelola Peserta"),
                                            ),
                                            PopupMenuItem(
                                              value: PageEnum
                                                  .kelolaWaktuCheckinPage,
                                              child:
                                                  Text("Kelola waktu checkin"),
                                            ),
                                            PopupMenuItem(
                                              value: PageEnum
                                                  .kelolaAbsenPesertaPage,
                                              child:
                                                  Text("Kelola absen peserta"),
                                            ),
                                            PopupMenuItem(
                                              value: PageEnum
                                                  .kelolaCheckinPesertaPage,
                                              child: Text(
                                                  "Kelola checkin peserta"),
                                            ),
                                            PopupMenuItem(
                                              value:
                                                  PageEnum.kelolaHasilAKhirPage,
                                              child: Text(
                                                  "Hasil akhir checkin peserta"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Hapus Event"),
                                            ),
                                          ],
                                        ),
                                      ))))
                                  .toList(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Divider(),
                          ),
                          InkWell(
                              onTap: pastEvent,
                              child: Container(
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
                                  padding: EdgeInsets.only(right: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                    color: Colors.lightBlue,
                                    width: 2.0,
                                  ))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '12/31/2019',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          '12/31/2019',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  item.title == null ? 'Unknown Nama Event' : item.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text('12:00 - 13:00'),
                                ),
                                trailing: PopupMenuButton<PageEnum>(
                                  onSelected: _onSelect,
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: PageEnum.kelolaPesertaPage,
                                      child: Text("Kelola Peserta"),
                                    ),
                                    PopupMenuItem(
                                      value: PageEnum.kelolaWaktuCheckinPage,
                                      child: Text("Kelola waktu checkin"),
                                    ),
                                    PopupMenuItem(
                                      value: PageEnum.kelolaAbsenPesertaPage,
                                      child: Text("Kelola absen peserta"),
                                    ),
                                    PopupMenuItem(
                                      value: PageEnum.kelolaCheckinPesertaPage,
                                      child: Text("Kelola checkin peserta"),
                                    ),
                                    PopupMenuItem(
                                      value: PageEnum.kelolaHasilAKhirPage,
                                      child:
                                          Text("Hasil akhir checkin peserta"),
                                    ),
                                    PopupMenuItem(
                                      child: Text("Hapus Event"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                                  ))
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
}
