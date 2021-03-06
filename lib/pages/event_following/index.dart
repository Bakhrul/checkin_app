import 'package:checkin_app/pages/event_following/detail.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:checkin_app/routes/env.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:checkin_app/pages/register_event/step_register_six.dart';
import 'package:checkin_app/pages/register_event/step_register_three.dart';
import '../events_all/detail_event.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:shimmer/shimmer.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
List<ListFollowingEvent> listItemFollowing = [];
bool actionBackAppBar, iconButtonAppbarColor;
final _debouncer = Debouncer(milliseconds: 500);
List<ListKategoriEvent> listkategoriEvent = [];
bool isLoading, isError, isFilter;
String filterX;
String categoryNow;
Map dataUser;

enum PageEnum {
  kelolaCheckinPage,
  kelolaHistoryPage,
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

class ManajemenEventFollowing extends StatefulWidget {
  ManajemenEventFollowing({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventFollowingState();
  }
}

class _ManajemenEventFollowingState extends State<ManajemenEventFollowing> {
  bool isLoading = true;
  String filterX = 'all';
  String categoryNow = 'all';
  bool isError = false;
  bool isFilter = false;
  int page = 1;
  ScrollController pageScroll = new ScrollController();
  bool delay = false;
  int manyPage;
  bool _isLoadingPagination = false;
  bool _isPageDisconnect = false;
  String userId;

  @override
  void initState() {
    actionBackAppBar = true;
    iconButtonAppbarColor = true;
    _searchQuery.text = '';
    getUser();
    listDoneEvent();
    pageScroll.addListener(() {
      if (pageScroll.position.pixels == pageScroll.position.maxScrollExtent) {
        _getPage(categoryNow, _searchQuery.text);
      }
    });
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  getUser() async {
    var session = new DataStore();
    var id = await session.getDataString('id');

    setState(() {
      userId = id;
    });
  }

  _getPage(String type, String query) async {
    print('_getPage()');
    if (delay) {
      return false;
    } else {
      setState(() {
        delay = true;
      });
    }

    if (manyPage != 0) {
      if (page == manyPage) {
        return false;
      } else {
        setState(() {
          page = page + 1;
          _isPageDisconnect = false;
          _isLoadingPagination = true;
        });
      }
    }

    print(query);

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    // Map<String, dynamic> body = {'filter':type.toString(),'search_query':query.toString()};

    try {
      final followevent = await http.post(
        url('api/getfollowingevent/$page'),
        body: {'filter': filterX},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        Map rawData = json.decode(followevent.body);
        print(rawData);
        print(page);

        if (mounted) {
          for (var i in rawData['eventfollow']) {
            Duration dif =
                DateTime.parse(i['ev_time_end']).difference(DateTime.now());
            DateTime waktuawal = DateTime.parse(i['ev_time_start']);
            DateTime waktuakhir = DateTime.parse(i['ev_time_end']);
            String timestart = DateFormat('dd MMM yyyy').format(waktuawal);
            String timeend = DateFormat('dd MMM yyyy').format(waktuakhir);
            Color color;
            String status;

            if (dif.inSeconds <= 0) {
              status = 'Event Selesai';
              color = Color.fromRGBO(255, 191, 128, 1);
            } else if (i['ep_position'] != 2) {
              switch (i['ep_status']) {
                case 'C':
                  status = 'Pendaftaran Ditolak';
                  color = Colors.red;
                  break;
                case 'P':
                  status = 'Menunggu Verifikasi';
                  color = Colors.orange;
                  break;
                case 'A':
                  status = 'Sudah Terdaftar';
                  color = Colors.green;
                  break;
                case 'B':
                  status = 'Dilarang Mendaftar Event';
                  color = Colors.red;
                  break;

                default:
                  status = 'Belum Terdaftar';
                  color = Colors.grey;
                  break;
              }
            } else {
              switch (i['ep_status']) {
                case 'C':
                  status = 'Belum Terdaftar';
                  color = Colors.grey;
                  break;
                case 'P':
                  status = 'Menunggu Konfirmasi Admin';
                  color = Colors.orange;
                  break;
                case 'B':
                  status = 'Dilarang Mendaftar Event';
                  color = Colors.red;
                  break;

                default:
                  status = 'Admin / Co-Host';
                  color = Colors.green;
                  break;
              }
            }
            ListFollowingEvent followX = ListFollowingEvent(
              id: '${i['ev_id']}',
              idcreator: i['ev_create_user'].toString(),
              image: i['ev_image'],
              title: i['ev_title'],
              waktuawal: timestart,
              waktuakhir: timeend,
              fullday: i['ev_allday'].toString(),
              alamat: i['ev_location'],
              wishlist: i['ew_wish'].toString(),
              follow: i['fo_status'] == null ? "N" : i['fo_status'],
              statusdaftar: i['ep_status'],
              creatorName: i['us_name'],
              color: color,
              status: status == null ? "Memuat" : status,
              posisi: i['ep_position'].toString(),
            );
            listItemFollowing.add(followX);
          }
        }

        setState(() {
          delay = false;
          _isLoadingPagination = false;
        });
      }
    } on TimeoutException catch (_) {
      setState(() {
        _isPageDisconnect = true;
        _isLoadingPagination = false;
        page -= 1;
        delay = false;
      });
      Fluttertoast.showToast(msg: "Time out");
    } on SocketException catch (_) {
      setState(() {
        _isPageDisconnect = true;
        _isLoadingPagination = false;
        page -= 1;
        delay = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    } catch (e) {
      print(e);
    }
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
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
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
      page = 1;
      delay = false;
    });

    try {
      final followevent = await http.post(
        url('api/getfollowingevent/$page'),
        body: {'filter': categoryNow, 'search_query': _searchQuery.text},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        // return nota;
        var eventfollowingJson = json.decode(followevent.body);
        var followevents = eventfollowingJson['eventfollow'];
        manyPage = eventfollowingJson['num_page'];
        print(followevents);

        listItemFollowing = [];
        for (var i in followevents) {
          Duration dif =
              DateTime.parse(i['ev_time_end']).difference(DateTime.now());
          DateTime yearStart = DateTime.parse(i['ev_time_start']);
          DateTime yearEnd = DateTime.parse(i['ev_time_end']);
          String cekAllday = i['ev_allday'];
          String formatStart = yearStart.year == yearEnd.year
              ? cekAllday == 'N' ? "dd MMM yyyy H:m" : 'dd MMM'
              : cekAllday == 'N' ? "dd MMM yyyy H:m" : 'dd MMM';
          String formatEnd = yearStart.year == yearEnd.year
              ? cekAllday == 'N' ? "H:m" : 'dd MMM yyyy'
              : cekAllday == 'N' ? "H:m" : 'dd MMM yyyy';
          String timestart = DateFormat(formatStart)
              .format(DateTime.parse(i['ev_time_start']));
          String timeend =
              DateFormat(formatEnd).format(DateTime.parse(i['ev_time_end']));
          Color color;
          String status;

          if (dif.inSeconds <= 0) {
            status = 'Event Selesai';
            color = Color.fromRGBO(255, 191, 128, 1);
          } else if (i['ep_position'] != 2) {
            switch (i['ep_status']) {
              case 'C':
                status = 'Pendaftaran Ditolak';
                color = Colors.red;
                break;
              case 'P':
                status = 'Menunggu Verifikasi';
                color = Colors.orange;
                break;
              case 'A':
                status = 'Sudah Terdaftar';
                color = Colors.green;
                break;
              case 'B':
                status = 'Dilarang Mendaftar Event';
                color = Colors.red;
                break;

              default:
                status = 'Belum Terdaftar';
                color = Colors.grey;
                break;
            }
          } else {
            switch (i['ep_status']) {
              case 'C':
                status = 'Belum Terdaftar';
                color = Colors.grey;
                break;
              case 'P':
                status = 'Menunggu Konfirmasi Admin';
                color = Colors.orange;
                break;
              case 'B':
                status = 'Dilarang Mendaftar Event';
                color = Colors.red;
                break;
              default:
                status = 'Admin / Co-Host';
                color = Colors.green;
                break;
            }
          }
          ListFollowingEvent followX = ListFollowingEvent(
            id: '${i['ev_id']}',
            idcreator: i['ev_create_user'].toString(),
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: timestart,
            waktuakhir: timeend,
            fullday: i['ev_allday'].toString(),
            alamat: i['ev_location'],
            wishlist: i['ew_wish'].toString(),
            follow: i['fo_status'] == null ? "N" : i['fo_status'],
            statusdaftar: i['ep_status'],
            creatorName: i['us_name'],
            color: color,
            status: status == null ? "Memuat" : status,
            posisi: i['ep_position'].toString(),
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
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
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
      page = 1;
      delay = false;
    });
    try {
      final followevent = await http.post(
        url('api/getfollowingevent/$page'),
        body: {'filter': categoryNow, 'search_query': _searchQuery.text},
        headers: requestHeaders,
      );

      if (followevent.statusCode == 200) {
        var eventfollowingJson = json.decode(followevent.body);
        var followevents = eventfollowingJson['eventfollow'];
        manyPage = eventfollowingJson['num_page'];

        listItemFollowing = [];
        for (var i in followevents) {
          Duration dif =
              DateTime.parse(i['ev_time_end']).difference(DateTime.now());
          DateTime yearStart = DateTime.parse(i['ev_time_start']);
          DateTime yearEnd = DateTime.parse(i['ev_time_end']);
          String cekAllday = i['ev_allday'];
          String formatStart = yearStart.year == yearEnd.year
              ? cekAllday == 'N' ? "dd MMM yyyy H:m" : 'dd MMM'
              : cekAllday == 'N' ? "dd MMM yyyy H:m" : 'dd MMM';
          String formatEnd = yearStart.year == yearEnd.year
              ? cekAllday == 'N' ? "H:m" : 'dd MMM yyyy'
              : cekAllday == 'N' ? "H:m" : 'dd MMM yyyy';
          String timestart = DateFormat(formatStart)
              .format(DateTime.parse(i['ev_time_start']));
          String timeend =
              DateFormat(formatEnd).format(DateTime.parse(i['ev_time_end']));
          Color color;
          String status;

          if (dif.inSeconds <= 0) {
            status = 'Event Selesai';
            color = Color.fromRGBO(255, 191, 128, 1);
          } else if (i['ep_position'] != 2) {
            switch (i['ep_status']) {
              case 'C':
                status = 'Pendaftaran Ditolak';
                color = Colors.red;
                break;
              case 'P':
                status = 'Menunggu Verifikasi';
                color = Colors.orange;
                break;
              case 'A':
                status = 'Sudah Terdaftar';
                color = Colors.green;
                break;
              case 'B':
                status = 'Dilarang Mendaftar Event';
                color = Colors.red;
                break;
              default:
                status = 'Belum Terdaftar';
                color = Colors.grey;
                break;
            }
          } else {
            switch (i['ep_status']) {
              case 'C':
                status = 'Belum Terdaftar';
                color = Colors.grey;
                break;
              case 'P':
                status = 'Menunggu Konfirmasi Admin';
                color = Colors.orange;
                break;
              case 'B':
                status = 'Dilarang Mendaftar Event';
                color = Colors.red;
                break;
              default:
                status = 'Admin / Co-Host';
                color = Colors.green;
                break;
            }
          }

          ListFollowingEvent followX = ListFollowingEvent(
            id: '${i['ev_id']}',
            idcreator: i['ev_create_user'].toString(),
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: timestart,
            waktuakhir: timeend,
            fullday: i['ev_allday'].toString(),
            alamat: i['ev_location'],
            wishlist: i['ew_wish'].toString(),
            follow: i['fo_status'] == null ? "N" : i['fo_status'],
            statusdaftar: i['ep_status'],
            creatorName: i['us_name'],
            color: color,
            status: status == null ? "Memuat" : status,
            posisi: i['ep_position'].toString(),
          );
          listItemFollowing.add(followX);
        }
        setState(() {
          isFilter = false;
          isError = false;
        });
      } else if (followevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
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
        ListKategoriEvent donex = ListKategoriEvent(
          id: 'all',
          nama: 'semua',
          color: false,
        );
        listkategoriEvent.add(donex);

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
        _getUserData();
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
      actionBackAppBar = true;
      iconButtonAppbarColor = true;
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
      _debouncer.run(() {
        listFilterFollowingEvent();
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildBar(context),
      body: isLoading == true
          ? Column(
              children: <Widget>[
                Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Row(
                              children: [0, 1, 2, 3, 4]
                                  .map((_) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        margin: EdgeInsets.only(right: 15.0),
                                        width: 120.0,
                                        height: 20.0,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ))),
                Container(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      width: double.infinity,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          children: [0, 1]
                              .map((_) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 120.0,
                                          height: 70.0,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 8.0,
                                                color: Colors.white,
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
                    ),
                  ),
                ),
              ],
            )
          : isError == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => listFilterFollowingEvent(),
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
                              listFilterFollowingEvent();
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
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
                  child: RefreshIndicator(
                    onRefresh: () => listDoneEvent(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 5, bottom: 5.0),
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
                                      color: categoryNow ==
                                              listkategoriEvent[index].id
                                          ? primaryAppBarColor
                                          : Colors.grey[100],
                                      elevation: 0.0,
                                      highlightColor: Colors.transparent,
                                      highlightElevation: 0.0,
                                      onPressed: () {
                                        setState(() {
                                          categoryNow =
                                              listkategoriEvent[index].id;
                                        });
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
                                            color: categoryNow ==
                                                    listkategoriEvent[index].id
                                                ? Colors.white
                                                : Colors.black54,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                          side: BorderSide(
                                            color: listkategoriEvent[index]
                                                        .color ==
                                                    true
                                                ? Colors.transparent
                                                : Colors.transparent,
                                          )),
                                    ),
                                  ));
                            },
                          ),
                        ),
                        isFilter == true
                            ? Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: SingleChildScrollView(
                                    child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Column(
                                      children: [0, 1]
                                          .map((_) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 25.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 120.0,
                                                      height: 70.0,
                                                      color: Colors.white,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 8.0,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5.0),
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 8.0,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5.0),
                                                          ),
                                                          Container(
                                                            width: 40.0,
                                                            height: 8.0,
                                                            color: Colors.white,
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
                                )))
                            : Expanded(
                                child: Scrollbar(
                                    child: ListView(
                                        controller: pageScroll,
                                        children: <Widget>[
                                      for (var index = 0;
                                          index < listItemFollowing.length;
                                          index++)
                                        InkWell(
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
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  flex: 5,
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        80.0,
                                                                    width: 80.0,
                                                                    child: FadeInImage
                                                                        .assetNetwork(
                                                                      placeholder:
                                                                          'images/loading-event.png',
                                                                      image: listItemFollowing[index].image == null ||
                                                                              listItemFollowing[index].image ==
                                                                                  '' ||
                                                                              listItemFollowing[index].image ==
                                                                                  'null'
                                                                          ? url(
                                                                              'assets/images/noimage.jpg')
                                                                          : url(
                                                                              'storage/image/event/event_thumbnail/${listItemFollowing[index].image}'),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 7,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0,
                                                                        right:
                                                                            5.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          listItemFollowing[index].waktuawal +
                                                                              ' - ' +
                                                                              listItemFollowing[index].waktuakhir,
                                                                          style: TextStyle(
                                                                              color: Colors.blue,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 5.0),
                                                                          child: Text(
                                                                              listItemFollowing[index].title == null ? 'Unknown Event' : listItemFollowing[index].title,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              softWrap: true,
                                                                              maxLines: 2,
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w500,
                                                                              )),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 10.0),
                                                                          child:
                                                                              Row(children: <Widget>[
                                                                            if (listItemFollowing[index].follow ==
                                                                                "Y")
                                                                              Container(width: 50, padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 3.0, right: 3.0), margin: EdgeInsets.only(left: 1.0, right: 2.0), child: Text('Di ikuti', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue)), decoration: BoxDecoration(border: Border.all(color: Colors.lightBlueAccent), borderRadius: BorderRadius.circular(10))),
                                                                            Expanded(
                                                                              child: Container(
                                                                                  padding: EdgeInsets.only(left: 3.0, right: 3.0),
                                                                                  child: Text(
                                                                                    listItemFollowing[index].creatorName == null ? 'tidak tersedia' : listItemFollowing[index].creatorName,
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    softWrap: true,
                                                                                  )),
                                                                            )
                                                                          ]),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0),
                                                              child: Divider()),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 10.0,
                                                                    bottom:
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      color: listItemFollowing[
                                                                              index]
                                                                          .color,
                                                                      borderRadius: new BorderRadius
                                                                              .only(
                                                                          topLeft: const Radius.circular(
                                                                              5.0),
                                                                          topRight: const Radius.circular(
                                                                              5.0),
                                                                          bottomLeft: const Radius.circular(
                                                                              5.0),
                                                                          bottomRight:
                                                                              const Radius.circular(5.0)),
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    width:
                                                                        120.0,
                                                                    child: Text(
                                                                      listItemFollowing[
                                                                              index]
                                                                          .status,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right: 0),
                                                                  child:
                                                                      ButtonTheme(
                                                                    minWidth:
                                                                        0, //wraps child's width
                                                                    height: 0,
                                                                    child:
                                                                        FlatButton(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.favorite,
                                                                            color: listItemFollowing[index].wishlist == null || listItemFollowing[index].wishlist == 'null' || listItemFollowing[index].wishlist == '0'
                                                                                ? Colors.grey
                                                                                : Colors.pink,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      materialTapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap,
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              15.0),
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          final hapuswishlist = await http.post(
                                                                              url('api/actionwishlist'),
                                                                              headers: requestHeaders,
                                                                              body: {
                                                                                'event': listItemFollowing[index].id,
                                                                              });

                                                                          if (hapuswishlist.statusCode ==
                                                                              200) {
                                                                            var hapuswishlistJson =
                                                                                json.decode(hapuswishlist.body);
                                                                            if (hapuswishlistJson['status'] ==
                                                                                'tambah') {
                                                                              setState(() {
                                                                                listItemFollowing[index].wishlist = listItemFollowing[index].id;
                                                                              });
                                                                            } else if (hapuswishlistJson['status'] ==
                                                                                'hapus') {
                                                                              setState(() {
                                                                                listItemFollowing[index].wishlist = null;
                                                                              });
                                                                            }
                                                                          } else {
                                                                            print(hapuswishlist.body);
                                                                            Fluttertoast.showToast(msg: "Request failed with status: ${hapuswishlist.statusCode}");
                                                                          }
                                                                        } on TimeoutException catch (_) {
                                                                          Fluttertoast.showToast(
                                                                              msg: "Timed out, Try again");
                                                                        } catch (e) {
                                                                          print(
                                                                              e);
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
                                              switch (listItemFollowing[index]
                                                  .status) {
                                                case 'Event Selesai':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RegisterEvents(
                                                        id: int.parse(
                                                            listItemFollowing[
                                                                    index]
                                                                .id),
                                                        creatorId:
                                                            listItemFollowing[
                                                                    index]
                                                                .idcreator,
                                                        dataUser: dataUser,
                                                        selfEvent: true);
                                                  }));
                                                  break;
                                                case 'Belum Terdaftar':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RegisterEvents(
                                                        id: int.parse(
                                                            listItemFollowing[
                                                                    index]
                                                                .id),
                                                        creatorId:
                                                            listItemFollowing[
                                                                    index]
                                                                .idcreator,
                                                        dataUser: dataUser,
                                                        selfEvent: listItemFollowing[
                                                                        index]
                                                                    .idcreator ==
                                                                userId
                                                            ? true
                                                            : false);
                                                  }));
                                                  break;
                                                case 'Menunggu Verifikasi':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return WaitingEvent(
                                                      id: int.parse(
                                                          listItemFollowing[
                                                                  index]
                                                              .id),
                                                      selfEvent: true,
                                                      creatorId:
                                                          listItemFollowing[
                                                                  index]
                                                              .idcreator,
                                                      dataUser: dataUser,
                                                    );
                                                  }));
                                                  break;
                                                case 'Belum Konfirmasi Admin':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RegisterEvents(
                                                      id: int.parse(
                                                          listItemFollowing[
                                                                  index]
                                                              .id),
                                                      selfEvent: true,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          listItemFollowing[
                                                                  index]
                                                              .idcreator,
                                                    );
                                                  }));
                                                  break;
                                                case 'Sudah Terdaftar':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return SuccesRegisteredEvent(
                                                      id: int.parse(
                                                          listItemFollowing[
                                                                  index]
                                                              .id),
                                                      selfEvent: true,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          listItemFollowing[
                                                                  index]
                                                              .idcreator,
                                                    );
                                                  }));
                                                  break;
                                                case 'Pendaftaran Ditolak':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RegisterEvents(
                                                      id: int.parse(
                                                          listItemFollowing[
                                                                  index]
                                                              .id),
                                                      selfEvent: false,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          listItemFollowing[
                                                                  index]
                                                              .idcreator,
                                                    );
                                                  }));
                                                  break;
                                                case 'Admin / Co-Host':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RegisterEvents(
                                                      id: int.parse(
                                                          listItemFollowing[
                                                                  index]
                                                              .id),
                                                      selfEvent: true,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          listItemFollowing[
                                                                  index]
                                                              .idcreator,
                                                    );
                                                  }));
                                                  break;
                                                case 'Dilarang Mendaftar Event':
                                                  return Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RegisterEvents(
                                                      id: int.parse(
                                                          listItemFollowing[
                                                                  index]
                                                              .id),
                                                      selfEvent: true,
                                                      dataUser: dataUser,
                                                      creatorId:
                                                          listItemFollowing[
                                                                  index]
                                                              .idcreator,
                                                    );
                                                  }));
                                                  break;
                                                default:
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegisterEvents(
                                                          id: int.parse(
                                                              listItemFollowing[
                                                                      index]
                                                                  .id),
                                                          selfEvent: false,
                                                          dataUser: dataUser,
                                                          creatorId:
                                                              listItemFollowing[
                                                                      index]
                                                                  .idcreator,
                                                        ),
                                                      ));
                                                  break;
                                              }
                                            }),
                                      _isPageDisconnect
                                          ? Container(
                                              height: 50,
                                              child: Center(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _getPage(categoryNow,
                                                            _searchQuery.text);
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets.all(
                                                              5.0),
                                                          child: Icon(
                                                              Icons.refresh,
                                                              color: Colors
                                                                  .blueAccent,
                                                              size: 25),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                          20.0),
                                                                  topRight:
                                                                      Radius.circular(
                                                                          20.0),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                          20.0),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          20.0)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 1,
                                                                  offset: Offset(
                                                                      0,
                                                                      1), // changes position of shadow
                                                                ),
                                                              ])))))
                                          : Container(
                                              height: _isLoadingPagination ? 50 : 0,
                                              child: Center(child: CircularProgressIndicator()))
                                    ])),
                              ),
                      ],
                    ),
                  ),
                ),
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
                                listFilterFollowingEvent();
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
                            hintText: "Cari Berdasarkan Nama Event",
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
          ],
        ));
  }
}
