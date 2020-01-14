import 'dart:io';

import 'package:checkin_app/model/search_event.dart';
import 'package:checkin_app/pages/profile/model.dart';
import '../events_all/detail_event.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/pages/register_event/step_register_six.dart';
import 'package:checkin_app/pages/register_event/step_register_three.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:checkin_app/storage/storage.dart';

String tokenType,
    accessToken,
    eventberlangsungX,
    eventakandatangX,
    eventselesaiX,
    namaOrganizerX;
Map<String, String> requestHeaders = Map();
String getNowfilter;
List<EventOrganizer> listItemFollowing = [];
bool isLoading, isError, isFilter, isErrorfilter;
Map dataUser;

class ProfileOrganizer extends StatefulWidget {
  ProfileOrganizer({Key key, this.iduser}) : super(key: key);
  final String iduser;

  @override
  State<StatefulWidget> createState() {
    return _ProfileOrganizerState();
  }
}

class _ProfileOrganizerState extends State<ProfileOrganizer> {
  SearchEvent searchEvent = new SearchEvent();
  SearchEvent dataEvent;
  String creatorEmail;
  String creatorName;
  ScrollController scrollPage = new ScrollController();
  double offset = 0; //12.5

  @override
  void initState() {
    super.initState();
    eventOrganizeGet();
    isFilter = false;
    isErrorfilter = false;
    eventberlangsungX = '0';
    eventakandatangX = '0';
    namaOrganizerX = 'Loading...';
    eventselesaiX = '0';
    getNowfilter = 'berlangsung';
  }

  _getUserData() async {
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
      final ongoingevent =
          await http.get(url('api/user'), headers: requestHeaders);

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);

        if (mounted) {
          setState(() {
            dataUser = rawData;
          });
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (ongoingevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = false;
        });
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
  }

  Future<List<EventOrganizer>> eventOrganizeGet() async {
    print(widget.iduser);
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
      final followevent = await http.post(
        url('api/geteventorganizer'),
        body: {'creator': widget.iduser, 'filter': getNowfilter},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        var eventfollowingJson = json.decode(followevent.body);
        var followevents = eventfollowingJson['event'];
        String jumlaheventberlangsung =
            eventfollowingJson['jumlaheventberlangsung'].toString();
        String jumlaheventakandatang =
            eventfollowingJson['jumlaheventakandatang'].toString();
        print(jumlaheventakandatang);
        String jumlaheventselesai =
            eventfollowingJson['jumlaheventselesai'].toString();
        String usersorganizer = eventfollowingJson['namaorganizer'];
        setState(() {
          eventberlangsungX = jumlaheventberlangsung;
          eventakandatangX = jumlaheventakandatang;
          eventselesaiX = jumlaheventselesai;
          namaOrganizerX = usersorganizer;
        });
        listItemFollowing = [];
        for (var i in followevents) {
          EventOrganizer followX = EventOrganizer(
            id: '${i['ev_id']}',
            idcreator: i['ev_create_user'].toString(),
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            fullday: i['ev_allday'].toString(),
            alamat: i['ev_location'],
            wishlist: i['ew_wish'].toString(),
            statusdaftar: i['ep_status'],
            posisi: i['ep_position'].toString(),
          );
          listItemFollowing.add(followX);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
        _getUserData();
      } else if (followevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(followevent.body);
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

  Future<List<EventOrganizer>> filtereventOrganizeGet() async {
    print(widget.iduser);
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
      final followevent = await http.post(
        url('api/geteventorganizer'),
        body: {'creator': widget.iduser, 'filter': getNowfilter},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        var eventfollowingJson = json.decode(followevent.body);
        var followevents = eventfollowingJson['event'];
        String jumlaheventberlangsung =
            eventfollowingJson['jumlaheventberlangsung'].toString();
        String jumlaheventakandatang =
            eventfollowingJson['jumlaheventakandatang'].toString();
        print(jumlaheventakandatang);
        String jumlaheventselesai =
            eventfollowingJson['jumlaheventselesai'].toString();
        String usersorganizer = eventfollowingJson['namaorganizer'];
        setState(() {
          eventberlangsungX = jumlaheventberlangsung;
          eventakandatangX = jumlaheventakandatang;
          eventselesaiX = jumlaheventselesai;
          namaOrganizerX = usersorganizer;
        });
        listItemFollowing = [];
        for (var i in followevents) {
          EventOrganizer followX = EventOrganizer(
            id: '${i['ev_id']}',
            idcreator: i['ev_create_user'].toString(),
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            fullday: i['ev_allday'].toString(),
            alamat: i['ev_location'],
            wishlist: i['ew_wish'].toString(),
            statusdaftar: i['ep_status'],
            posisi: i['ep_position'].toString(),
          );
          listItemFollowing.add(followX);
        }
        setState(() {
          isErrorfilter = false;
          isFilter = false;
        });
      } else if (followevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isFilter = false;
          isErrorfilter = true;
        });
      } else {
        print(followevent.body);
        setState(() {
          isFilter = false;
          isErrorfilter = true;
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

  testing() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  eventOrganizeGet();
                },
                child: ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          padding: EdgeInsets.only(left: 40.0, right: 40.0),
                          color: Colors.blue,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      'images/imgavatar.png',
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Center(
                            child: Text(
                              namaOrganizerX,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 150.0),
                                color: Colors.white,
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(0),
                                child: Card(
                                  margin: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 1.0,
                                          ))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                height: 80.0,
                                                child: Text(
                                                  'Sedang Berlangsung',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                child: Text(
                                                  eventberlangsungX,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 1.0,
                                          ))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                height: 80.0,
                                                child: Text(
                                                  'Akan Datang',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                child: Text(
                                                  eventakandatangX,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                height: 80.0,
                                                child: Text(
                                                  'Sudah Selesai',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                child: Text(
                                                  eventselesaiX,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 30.0, right: 15.0, left: 15.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    getNowfilter = 'berlangsung';
                                  });
                                  filtereventOrganizeGet();
                                },
                                child: Container(
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: getNowfilter == 'berlangsung'
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.0,
                                  ))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Text(
                                          'Sedang Berlangsung',
                                          style: TextStyle(
                                              color:
                                                  getNowfilter == 'berlangsung'
                                                      ? Colors.blue
                                                      : Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 4,
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    getNowfilter = 'akan datang';
                                  });
                                  filtereventOrganizeGet();
                                },
                                child: Container(
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: getNowfilter == 'akan datang'
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.0,
                                  ))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Text(
                                          'Akan Datang',
                                          style: TextStyle(
                                              color:
                                                  getNowfilter == 'akan datang'
                                                      ? Colors.blue
                                                      : Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 4,
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    getNowfilter = 'selesai';
                                  });
                                  filtereventOrganizeGet();
                                },
                                child: Container(
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: getNowfilter == 'selesai'
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.0,
                                  ))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Text(
                                          'Sudah Selesai',
                                          style: TextStyle(
                                              color: getNowfilter == 'selesai'
                                                  ? Colors.blue
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    isFilter == true
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            margin: EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: listItemFollowing
                                  .map(
                                    (EventOrganizer item) => InkWell(
                                        child: Container(
                                            child: Card(
                                      elevation: 1,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                      width: 80.0,
                                                      height: 80.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                        borderRadius: new BorderRadius
                                                                .only(
                                                            topLeft: const Radius
                                                                .circular(5.0),
                                                            topRight: const Radius
                                                                .circular(5.0),
                                                            bottomLeft:
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                            bottomRight:
                                                                const Radius
                                                                        .circular(
                                                                    5.0)),
                                                        image:
                                                            new DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(
                                                            'images/bg-header.jpg',
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 7,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 5.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '${item.waktuawal} - ${item.waktuakhir}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0),
                                                          child: Text(
                                                              item.title ==
                                                                          null ||
                                                                      item.title ==
                                                                          ''
                                                                  ? 'Event Tidak Diketahui'
                                                                  : item.title,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child: Text(
                                                            item.alamat ==
                                                                        null ||
                                                                    item.alamat ==
                                                                        ''
                                                                ? 'Alamat Tidak Diketahui'
                                                                : item.alamat,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(children: <Widget>[
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Divider()),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  bottom: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: item.statusdaftar ==
                                                                null
                                                            ? Colors.grey
                                                            : item.statusdaftar == 'P'
                                                                ? Colors.orange
                                                                : item.statusdaftar ==
                                                                        'C'
                                                                    ? Colors.red
                                                                    : item.statusdaftar ==
                                                                            'A'
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .blue,
                                                        borderRadius: new BorderRadius
                                                                .only(
                                                            topLeft: const Radius
                                                                .circular(5.0),
                                                            topRight: const Radius
                                                                .circular(5.0),
                                                            bottomLeft:
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                            bottomRight:
                                                                const Radius
                                                                        .circular(
                                                                    5.0)),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      width: 120.0,
                                                      child: Text(
                                                        item.statusdaftar ==
                                                                null
                                                            ? 'Belum Terdaftar'
                                                            : item.statusdaftar ==
                                                                        'P' &&
                                                                    item.posisi ==
                                                                        '3'
                                                                ? 'Proses Daftar'
                                                                : item.statusdaftar ==
                                                                            'C' &&
                                                                        item.posisi ==
                                                                            '3'
                                                                    ? 'Pendaftaran Ditolak'
                                                                    : item.statusdaftar ==
                                                                                'A' &&
                                                                            item.posisi ==
                                                                                '3'
                                                                        ? 'Sudah Terdaftar'
                                                                        : item.statusdaftar == 'P' && item.posisi == '2'
                                                                            ? 'Proses Daftar Admin'
                                                                            : item.statusdaftar == 'C' && item.posisi == '2'
                                                                                ? 'Tolak Pendaftaran Admin'
                                                                                : item.statusdaftar == 'A' && item.posisi == '2' ? 'Sudah Terdaftar Admin' : 'Status Tidak Diketahui',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0),
                                                    child: ButtonTheme(
                                                      minWidth:
                                                          0, //wraps child's width
                                                      height: 0,
                                                      child: FlatButton(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.favorite,
                                                              color: item
                                                                              .wishlist ==
                                                                          null ||
                                                                      item.wishlist ==
                                                                          'null' ||
                                                                      item.wishlist ==
                                                                          '0'
                                                                  ? Colors.grey
                                                                  : Colors.pink,
                                                              size: 18,
                                                            ),
                                                          ],
                                                        ),
                                                        color: Colors.white,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15.0),
                                                        onPressed: () async {
                                                          try {
                                                            final hapuswishlist =
                                                                await http.post(
                                                                    url(
                                                                        'api/actionwishlist'),
                                                                    headers:
                                                                        requestHeaders,
                                                                    body: {
                                                                  'event':
                                                                      item.id,
                                                                });

                                                            if (hapuswishlist
                                                                    .statusCode ==
                                                                200) {
                                                              var hapuswishlistJson =
                                                                  json.decode(
                                                                      hapuswishlist
                                                                          .body);
                                                              if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'tambah') {
                                                                setState(() {
                                                                  item.wishlist =
                                                                      item.id;
                                                                });
                                                              } else if (hapuswishlistJson[
                                                                      'status'] ==
                                                                  'hapus') {
                                                                setState(() {
                                                                  item.wishlist =
                                                                      null;
                                                                });
                                                              }
                                                            } else {
                                                              print(
                                                                  hapuswishlist
                                                                      .body);
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Request failed with status: ${hapuswishlist.statusCode}");
                                                            }
                                                          } on TimeoutException catch (_) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Timed out, Try again");
                                                          } catch (e) {
                                                            print(e);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])
                                        ],
                                      ),
                                    )),
                                    onTap: () async {
                                        switch (item
                                            .statusdaftar) {
                                          case 'P':
                                            if (item
                                                    .posisi ==
                                                '2') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterEvents(
                                                      id: int.parse(
                                                          item
                                                              .id),
                                                      selfEvent: true,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          item
                                                              .idcreator,
                                                    ),
                                                  ));
                                            } else if (item
                                                    .posisi ==
                                                '3') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WaitingEvent(
                                                      id: int.parse(
                                                          item
                                                              .id),
                                                      selfEvent: true,
                                                      creatorId:
                                                          item
                                                              .idcreator,
                                                    ),
                                                  ));
                                            } else {}
                                            break;
                                          case 'C':
                                            if (item
                                                    .posisi ==
                                                '2') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterEvents(
                                                      id: int.parse(
                                                          item
                                                              .id),
                                                      selfEvent: false,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          item
                                                              .idcreator,
                                                    ),
                                                  ));
                                            } else if (item
                                                    .posisi ==
                                                '3') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterEvents(
                                                      id: int.parse(
                                                          item
                                                              .id),
                                                      selfEvent: false,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          item
                                                              .idcreator,
                                                    ),
                                                  ));
                                            } else {}
                                            break;
                                          case 'A':
                                            if (item
                                                    .posisi ==
                                                '2') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterEvents(
                                                      id: int.parse(
                                                          item
                                                              .id),
                                                      selfEvent: true,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          item
                                                              .idcreator,
                                                    ),
                                                  ));
                                            } else if (item
                                                    .posisi ==
                                                '3') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SuccesRegisteredEvent(
                                                      id: int.parse(
                                                          item
                                                              .id),
                                                      selfEvent: true,
                                                      creatorId:
                                                          item
                                                              .idcreator,
                                                    ),
                                                  ));
                                            } else {}
                                            break;
                                          default:
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterEvents(
                                                    id: int.parse(
                                                        item
                                                            .id),
                                                    selfEvent: false,
                                                    dataUser: dataUser,
                                                    creatorId:
                                                        item
                                                            .idcreator,
                                                  ),
                                                ));
                                            break;
                                        }
                                      }),
                                  )
                                  .toList(),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
