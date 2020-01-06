import 'package:checkin_app/pages/event_following/detail.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:checkin_app/routes/env.dart';
import 'count_down.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:checkin_app/pages/register_event/step_register_six.dart';
import 'package:checkin_app/pages/register_event/step_register_three.dart';
import '../events_all/detail_event.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/pages/register_event/detail_event_afterregist.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventAll;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
List<ListFollowingEvent> listItemFollowing = [];
List<ListKategoriEvent> listkategoriEvent = [];
bool isLoading, isError, isFilter;
String filterX;
void showInSnackBar(String value) {
  _scaffoldKeyEventAll.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

enum PageEnum {
  kelolaCheckinPage,
  kelolaHistoryPage,
}

class ManajemenEventFollowing extends StatefulWidget {
  ManajemenEventFollowing({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventFollowingState();
  }
}

class _ManajemenEventFollowingState extends State<ManajemenEventFollowing> {
  @override
  void initState() {
    _scaffoldKeyEventAll = GlobalKey<ScaffoldState>();
    isLoading = true;
    filterX = 'all';
    isError = false;
    isFilter = false;
    listDoneEvent();
    super.initState();
  }

  Future<List<ListFollowingEvent>> listDoneEvent() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
      filterX = 'all';
    });
    try {
      final followevent = await http.post(
        url('api/getfollowingevent'),
        body: {'filter': filterX},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        // return nota;
        var eventfollowingJson = json.decode(followevent.body);
        var followevents = eventfollowingJson['eventfollow'];

        listItemFollowing = [];
        for (var i in followevents) {
          ListFollowingEvent followX = ListFollowingEvent(
            id: '${i['ev_id']}',
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            fullday: i['ev_allday'],
            alamat: i['ev_location'],
            wishlist: i['ew_event'].toString(),
            statusdaftar: i['ep_status'].toString(),
          );
          listItemFollowing.add(followX);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
        listKategoriEvent();
      } else if (followevent.statusCode == 401) {
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

  Future<List<ListFollowingEvent>> listFilterFollowingEvent() async {
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
        url('api/getfollowingevent'),
        body: {'filter': filterX},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        var eventfollowingJson = json.decode(followevent.body);
        var followevents = eventfollowingJson['eventfollow'];

        listItemFollowing = [];
        for (var i in followevents) {
          ListFollowingEvent followX = ListFollowingEvent(
            id: '${i['ev_id']}',
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: i['ev_time_start'],
            waktuakhir: i['ev_time_end'],
            fullday: i['ev_allday'],
            alamat: i['ev_address'],
            wishlist: i['ew_event'],
            statusdaftar: i['ep_status'],
          );
          listItemFollowing.add(followX);
        }
        setState(() {
          isFilter = false;
          isError = false;
        });
      } else if (followevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isFilter = false;
          isError = true;
        });
      } else {
        print(followevent.body);
        setState(() {
          isFilter = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isFilter = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isFilter = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }

  Future<List<ListKategoriEvent>> listKategoriEvent() async {
    print('cek');
    setState(() {
      isLoading = true;
    });
    try {
      final kategorievent = await http.get(
        url('api/listkategorievent'),
        // headers: requestHeaders,
      );

      if (kategorievent.statusCode == 200) {
        // return nota;
        var kategorieventJson = json.decode(kategorievent.body);
        var kategorievents = kategorieventJson['kategori'];

        listkategoriEvent = [];
        for (var i in kategorievents) {
          ListKategoriEvent donex = ListKategoriEvent(
            id: '${i['c_id']}',
            nama: i['c_name'],
            color: false,
          );
          listkategoriEvent.add(donex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else {
        print(kategorievent.body);
        print(kategorievent.statusCode);
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

  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Mengikuti Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Mengikuti Event",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.kelolaCheckinPage:
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => CountDown()));
        break;
      case PageEnum.kelolaHistoryPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) =>
                ManajemenEventDetailFollowing()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyEventAll,
      appBar: buildBar(context),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
              child: RefreshIndicator(
                onRefresh: () => listDoneEvent(),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                ('Cari Event Berdasarkan Kategori')
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 5, bottom: 5.0),
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        itemCount: listkategoriEvent.length == 0
                            ? 0
                            : listkategoriEvent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: ButtonTheme(
                                minWidth: 0.0,
                                height: 0,
                                child: RaisedButton(
                                  color: listkategoriEvent[index].color == true
                                      ? Color.fromRGBO(41, 30, 47, 1)
                                      : Colors.white,
                                  elevation: 0.0,
                                  highlightColor: Colors.transparent,
                                  highlightElevation: 0.0,
                                  onPressed: () {
                                    if (listkategoriEvent[index].color ==
                                        true) {
                                      setState(() {
                                        filterX = 'all';
                                        ListKategoriEvent(
                                          color: false,
                                        );
                                        // listkategoriEvent[index].color = false;
                                      });
                                    } else {
                                      setState(() {
                                        filterX = listkategoriEvent[index].id;
                                        ListKategoriEvent(
                                          color: false,
                                        );
                                        // listkategoriEvent[index].color = true;
                                      });
                                    }
                                    listFilterFollowingEvent();
                                  },
                                  padding: EdgeInsets.only(
                                      top: 7.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 7.0),
                                  child: Text(
                                    listkategoriEvent[index].nama == null
                                        ? 'Unknown Kategori'
                                        : listkategoriEvent[index].nama,
                                    style: TextStyle(
                                        color: listkategoriEvent[index].color ==
                                                true
                                            ? Colors.white
                                            : Color.fromRGBO(41, 30, 47, 1),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: listkategoriEvent[index].color ==
                                                true
                                            ? Color.fromRGBO(41, 30, 47, 1)
                                            : Color.fromRGBO(41, 30, 47, 1),
                                      )),
                                ),
                              ));
                        },
                      ),
                    ),
                    isFilter == true
                        ? Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                // scrollDirection: Axis.horizontal,
                                itemCount: listItemFollowing.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime waktuawal = DateTime.parse(
                                      listItemFollowing[index].waktuawal);
                                  DateTime waktuakhir = DateTime.parse(
                                      listItemFollowing[index].waktuakhir);
                                  String timestart =
                                      DateFormat('dd-MM-y HH:mm:ss')
                                          .format(waktuawal);
                                  String timeend =
                                      DateFormat('dd-MM-y HH:mm:ss')
                                          .format(waktuakhir);
                                  return InkWell(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                            top: 5.0,
                                            bottom: 5.0,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                elevation: 1,
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
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
                                                                      topLeft:
                                                                          const Radius.circular(
                                                                              5.0),
                                                                      topRight:
                                                                          const Radius.circular(
                                                                              5.0),
                                                                      bottomLeft:
                                                                          const Radius.circular(
                                                                              5.0),
                                                                      bottomRight:
                                                                          const Radius.circular(
                                                                              5.0)),
                                                                  image:
                                                                      new DecorationImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    image:
                                                                        AssetImage(
                                                                      'images/bg-header.jpg',
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 7,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0,
                                                                      right:
                                                                          5.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '${timestart} - ${timeend}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0),
                                                                    child: Text(
                                                                        listItemFollowing[index].title ==
                                                                                null
                                                                            ? 'Unknown Event'
                                                                            : listItemFollowing[index]
                                                                                .title,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              16,
                                                                        )),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0),
                                                                    child: Text(
                                                                      listItemFollowing[index].alamat ==
                                                                              null
                                                                          ? 'Lokasi Event Tidak Diketahui'
                                                                          : listItemFollowing[index]
                                                                              .alamat,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Divider()),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0,
                                                              bottom: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(),
                                                          // Container(
                                                          //     decoration:
                                                          //         new BoxDecoration(
                                                          //       color:
                                                          //           Colors.blue,
                                                          //       borderRadius: new BorderRadius
                                                          //               .only(
                                                          //           topLeft:
                                                          //               const Radius.circular(
                                                          //                   5.0),
                                                          //           topRight:
                                                          //               const Radius.circular(
                                                          //                   5.0),
                                                          //           bottomLeft:
                                                          //               const Radius.circular(
                                                          //                   5.0),
                                                          //           bottomRight:
                                                          //               const Radius.circular(
                                                          //                   5.0)),
                                                          //     ),
                                                          //     padding:
                                                          //         EdgeInsets
                                                          //             .all(5.0),
                                                          //     width: 120.0,
                                                          //     child: Text(
                                                          //       'Proses Daftar',
                                                          //       style:
                                                          //           TextStyle(
                                                          //         color: Colors
                                                          //             .white,
                                                          //         fontSize: 12,
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w500,
                                                          //       ),
                                                          //       textAlign:
                                                          //           TextAlign
                                                          //               .center,
                                                          //     )),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 0),
                                                            child: ButtonTheme(
                                                              minWidth:
                                                                  0, //wraps child's width
                                                              height: 0,
                                                              child: FlatButton(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: listItemFollowing[index].wishlist ==
                                                                              null
                                                                          ? Colors
                                                                              .grey
                                                                          : Colors
                                                                              .pink,
                                                                      size: 18,
                                                                    ),
                                                                  ],
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15.0),
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Mohon Tunggu Sebentar");
                                                                    final hapuswishlist = await http.post(
                                                                        url(
                                                                            'api/actionwishlist'),
                                                                        headers:
                                                                            requestHeaders,
                                                                        body: {
                                                                          'event':
                                                                              listItemFollowing[index].id,
                                                                        });

                                                                    if (hapuswishlist
                                                                            .statusCode ==
                                                                        200) {
                                                                      var hapuswishlistJson =
                                                                          json.decode(
                                                                              hapuswishlist.body);
                                                                      if (hapuswishlistJson[
                                                                              'status'] ==
                                                                          'tambah') {
                                                                        setState(
                                                                            () {
                                                                          listItemFollowing[index].wishlist =
                                                                              listItemFollowing[index].id;
                                                                        });
                                                                      } else if (hapuswishlistJson[
                                                                              'status'] ==
                                                                          'hapus') {
                                                                        setState(
                                                                            () {
                                                                          listItemFollowing[index].wishlist =
                                                                              null;
                                                                        });
                                                                      }
                                                                    } else {
                                                                      print(hapuswishlist
                                                                          .body);
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Request failed with status: ${hapuswishlist.statusCode}");
                                                                    }
                                                                  } on TimeoutException catch (_) {
                                                                    Fluttertoast
                                                                        .showToast(
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
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      onTap: () async {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           WaitingEvent(),
                                        //     ));
                                      });
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                // ignore: new_with_non_type
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = TextField(
                  controller: _searchQuery,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: InputBorder.none,
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Cari Berdasarkan Nama, Kategori , Tempat",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                );
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ],
    );
  }
}
