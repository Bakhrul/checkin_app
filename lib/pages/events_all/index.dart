import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'detail_event.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/model/search_event.dart';
import '../register_event/step_register_three.dart';
import '../register_event/step_register_six.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import "dart:convert";
import "dart:io";
import 'package:shimmer/shimmer.dart';

import 'package:checkin_app/utils/utils.dart';

enum PageEnum {
  kelolaRegisterPage,
}

String tokenType, accessToken;
bool actionBackAppBar, iconButtonAppbarColor;
Map<String, String> requestHeaders = Map();

class ManajemenEvent extends StatefulWidget {
  ManajemenEvent({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventState();
  }
}

class _ManajemenEventState extends State<ManajemenEvent> {
  List<SearchEvent> _event = [];
  SearchEvent searchEvent = new SearchEvent();
  int page = 1;
  bool _isLoading = true;
  bool _isLoadingCategory = true;
  bool _isLoadingPagination = false;
  bool _isDisconnect = false;
  ScrollController pageScroll = new ScrollController();
  int manyPage = 0;
  Timer _debouncer;
  String _searchQuery = '';
  String userId;
  List listCategory = [];
  int categoryNow = 0;
  Map dataUser;
  bool delay = false;
  bool _isPageDisconnect = false;
  bool _isGetAllDisconnect = false;

  @override
  void initState() {
    _getUserData();
    getHeaderHTTP();
    _getCategory();
      actionBackAppBar = true;
    iconButtonAppbarColor = true;
    _getAll(0, _searchQuery);
    super.initState();
    pageScroll.addListener(() async {
      if (pageScroll.position.pixels == pageScroll.position.maxScrollExtent) {
        _getPage(categoryNow, _searchQuery);
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
      }
    } catch (e) {
      print(e);
    }
  }

  _getAll(int type, String query) async {
    print('_getAll()');

    setState(() {
      delay = false;
      page = 1;
      _isGetAllDisconnect = false;
    });

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    Map<String, dynamic> body = {
      'category_id': type.toString(),
      'query_search': query.toString()
    };

    try {
      final ongoingevent = await http.post(url('api/event/page/$page'),
          headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);
        print(rawData);

        if (mounted) {
          setState(() {
            userId = rawData['user_id'].toString();
            manyPage = rawData['num_page'];

            _event.clear();

            for (var x in rawData['data']) {
              _event.add(SearchEvent.fromJson(x));
            }
            _isLoading = false;
          });
        }
      } else if (ongoingevent.statusCode == 401) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        _isLoading = false;
        _isDisconnect = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
        _isGetAllDisconnect = true;
      });
      Fluttertoast.showToast(msg: "Koneksi Internet Terputus");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _isGetAllDisconnect = true;
      print('$e');
    }
  }

  Future _getPage(int type, String query) async {
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
          _isLoadingPagination = true;
          _isPageDisconnect = false;
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

    Map<String, dynamic> body = {
      'category_id': type.toString(),
      'query_search': query.toString()
    };

    try {
      final ongoingevent = await http.post(url('api/event/page/$page'),
          headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);
        print(rawData);
        print(page);
        if (mounted) {
          List<SearchEvent> temp = new List();
          for (var x in rawData['data']) {
            temp.add(SearchEvent.fromJson(x));
          }

          _event.addAll(temp);

          setState(() {
            delay = false;
            _isLoadingPagination = false;
          });
        }
      }
    } on TimeoutException catch (_) {
      setState(() {
        _isLoadingPagination = false;
        _isPageDisconnect = true;
        page -= 1;
        delay = false;
      });
      Fluttertoast.showToast(msg: "Time out");
    } on SocketException catch (_) {
      setState(() {
        _isLoadingPagination = false;
        _isPageDisconnect = true;
        page -= 1;
        delay = false;
      });
      Fluttertoast.showToast(msg: "Koneksi Internet Terputus");
    } catch (e) {
      print(e);
    }

    return _event;
  }

  _getCategory() async {
    print('_getCategory');

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final ongoingevent = await http.get(
        url('api/listkategorievent'),
        headers: requestHeaders,
      );

      if (ongoingevent.statusCode == 200) {
        listCategory.clear();
        var dataRaw = json.decode(ongoingevent.body);
        listCategory.add({'c_name': 'Semua', 'c_id': 0});
        for (var x in dataRaw['kategori']) {
          listCategory.add(x);
        }
        setState(() {
          _isLoadingCategory = false;
        });
      } else if (ongoingevent.statusCode == 401) {
        setState(() {
          _isLoadingCategory = false;
        });
      } else {
        setState(() {
          _isLoadingCategory = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Timed out, Try again");
      setState(() {
        _isLoadingCategory = false;
        _isDisconnect = true;
      });
    } on SocketException catch (_) {
      setState(() {
        _isLoadingCategory = false;
        _isDisconnect = true;
      });
      Fluttertoast.showToast(msg: "Koneksi Internet Terputus");
    } catch (e) {
      setState(() {
        _isLoadingCategory = false;
      });
      print(e);
    }
  }

  Future<dynamic> _wish(String wish, int eventId, int index) async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    int newWish = wish == '1' ? 0 : 1;
    Map<String, dynamic> body = {
      'event_id': eventId.toString(),
      'wish': newWish.toString()
    };

    try {
      final ongoingevent =
          await http.post(url('api/wish'), headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        setState(() {
          _event[index].wish = newWish.toString();
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time out , please try again later");
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "Koneksi Internet Terputus");
    } catch (e) {
      print(e);
    }
  }

  _reload() {
    setState(() {
      _isLoading = true;
      _isLoadingCategory = true;
      _isDisconnect = false;
      categoryNow = 0;
    });

    _getUserData();
    _getCategory();
    _getAll(categoryNow, _searchQuery);
  }

  _changeSearch(value) async {
    setState(() {
      page = 1;
      _isLoading = true;
      _searchQuery = value;
    });
    _getAll(categoryNow, _searchQuery);
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
        "Semua Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );

      _searchQuery = '';
      _isLoading = true;
      page = 1;
      _getAll(categoryNow, _searchQuery);
    });
  }

  Widget appBarTitle = Text(
    "Semua Event",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void dispose() {
    pageScroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildBar(context),
      body: _isLoadingCategory
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
                                    padding: const EdgeInsets.only(bottom: 15.0),
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
          : _isDisconnect
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
                              _reload();
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
              : RefreshIndicator(
                  onRefresh: () async {
                    await _getUserData();
                    await _getCategory();
                    await _getAll(categoryNow, _searchQuery);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10.0, bottom: 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  for (var x in listCategory)
                                    Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: ButtonTheme(
                                          minWidth: 0.0,
                                          height: 0,
                                          child: RaisedButton(
                                            color: categoryNow == x['c_id']
                                                ? Color.fromRGBO(254, 86, 14, 1)
                                                : Colors.grey[100],
                                            elevation: 0.0,
                                            highlightColor: Colors.transparent,
                                            highlightElevation: 0.0,
                                            padding: EdgeInsets.only(
                                                top: 7.0,
                                                left: 15.0,
                                                right: 15.0,
                                                bottom: 7.0),
                                            onPressed: () {
                                              setState(() {
                                                _isLoading = true;
                                                page = 1;
                                                delay = false;
                                                categoryNow = x['c_id'];
                                                _getAll(
                                                    x['c_id'], _searchQuery);
                                              });
                                            },
                                            child: Text(
                                              x['c_name'] == null
                                                  ? 'memuat'
                                                  : x['c_name'],
                                              style: TextStyle(
                                                  color:
                                                      categoryNow == x['c_id']
                                                          ? Colors.white
                                                          : Colors.black54,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        18.0),
                                                side: BorderSide(
                                                  color: Colors.transparent,
                                                )),
                                          ),
                                        )),
                                ]),
                          ),
                        ),
                        Expanded(
                            child: _isGetAllDisconnect
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: RefreshIndicator(
                                      onRefresh: () => getHeaderHTTP(),
                                      child: Column(children: <Widget>[
                                        new Container(
                                          width: 100.0,
                                          height: 100.0,
                                          child: Image.asset(
                                              "images/system-eror.png"),
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
                                              top: 20.0,
                                              left: 15.0,
                                              right: 15.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: RaisedButton(
                                              color: Colors.white,
                                              textColor:
                                                  Color.fromRGBO(41, 30, 47, 1),
                                              disabledColor: Colors.grey,
                                              disabledTextColor: Colors.black,
                                              padding: EdgeInsets.all(15.0),
                                              splashColor: Colors.blueAccent,
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                _getAll(
                                                    categoryNow, _searchQuery);
                                              },
                                              child: Text(
                                                "Muat Ulang Halaman",
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  )
                                : _isLoading
                                    ? Container(
                                         
                                          child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.grey[100],
                                          child: Column(
                                            children: [0, 1,2,3,4,5]
                                                .map((_) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 25.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 120.0,
                                                            height: 70.0,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 8.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                                ),
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 8.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                                ),
                                                                Container(
                                                                  width: 40.0,
                                                                  height: 8.0,
                                                                  color: Colors
                                                                      .white,
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
                                      ))
                                    : Container(
                                        child: SingleChildScrollView(
                                            controller: pageScroll,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            child: Column(children: <Widget>[
                                              for (var x = 0;
                                                  x < _event.length;
                                                  ++x)
                                                new InkWell(
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 5.0,
                                                            left: 5.0,
                                                            right: 5.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Card(
                                                              elevation: 1,
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
                                                                          flex:
                                                                              5,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                80.0,
                                                                            width:
                                                                                80.0,
                                                                            child:
                                                                                FadeInImage.assetNetwork(
                                                                              placeholder: 'images/loading-event.png',
                                                                              image: _event[x].image == null || _event[x].image == '' || _event[x].image == 'null' ? url('assets/images/noimage.jpg') : url('storage/image/event/event_thumbnail/${_event[x].image}'),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              7,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 15.0, right: 5.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  _event[x].start == null ? 'memuat' : _event[x].start + ' - ' + _event[x].end,
                                                                                  style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                                  child: Text(_event[x].title == null ? 'memuat' : _event[x].title,
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      softWrap: true,
                                                                                      maxLines: 2),
                                                                                ),
                                                                                Padding(
                                                                                    padding: const EdgeInsets.only(top: 10.0),
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        if (_event[x].follow == "Y") Container(width: 50, padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 3.0, right: 3.0), margin: EdgeInsets.only(left: 1.0, right: 2.0), child: Text('Di ikuti', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue)), decoration: BoxDecoration(border: Border.all(color: Colors.lightBlueAccent), borderRadius: BorderRadius.circular(10))),
                                                                                        Expanded(
                                                                                            child: Container(
                                                                                                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                                                                                                child: Text(
                                                                                                  _event[x].creatorName == null ? 'memuat' : _event[x].creatorName,
                                                                                                  style: TextStyle(color: Colors.grey),
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  softWrap: true,
                                                                                                )))
                                                                                      ],
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                            padding:
                                                                                EdgeInsets.only(left: 10.0, right: 10.0),
                                                                            child: Divider()),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 10.0,
                                                                              right: 10.0,
                                                                              bottom: 10.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                  decoration: new BoxDecoration(
                                                                                    color: _event[x].statusRegistered == 'Event Selesai' ? _event[x].color : userId == _event[x].userEvent ? Colors.blue : _event[x].color,
                                                                                    borderRadius: new BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0), bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0)),
                                                                                  ),
                                                                                  padding: EdgeInsets.all(5.0),
                                                                                  width: 120.0,
                                                                                  child: Text(
                                                                                    _event[x].statusRegistered == 'Event Selesai' ? _event[x].statusRegistered : userId == _event[x].userEvent ? "Event Saya" : _event[x].statusRegistered,
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                  )),
                                                                              _event[x].userEvent == userId
                                                                                  ? Container()
                                                                                  : Padding(
                                                                                      padding: const EdgeInsets.only(right: 0),
                                                                                      child: ButtonTheme(
                                                                                        minWidth: 0, //wraps child's width
                                                                                        height: 0,
                                                                                        child: FlatButton(
                                                                                            child: Row(
                                                                                              children: <Widget>[
                                                                                                Icon(
                                                                                                  Icons.favorite,
                                                                                                  color: _event[x].wish == '1' ? Colors.pink : Colors.grey,
                                                                                                  size: 18,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            color: Colors.white,
                                                                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                            padding: EdgeInsets.all(5.0),
                                                                                            onPressed: () async {
                                                                                              _wish(_event[x].wish, _event[x].id, x);
                                                                                            }),
                                                                                      ),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ])
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    onTap: () async {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        switch (_event[x]
                                                            .statusRegistered) {
                                                          case 'Sudah Terdaftar':
                                                            return SuccesRegisteredEvent(
                                                                id: _event[x]
                                                                    .id,
                                                                creatorId: _event[
                                                                        x]
                                                                    .userEvent,
                                                                dataUser:
                                                                    dataUser,
                                                                selfEvent: userId ==
                                                                        _event[x]
                                                                            .userEvent
                                                                    ? true
                                                                    : false);
                                                            break;
                                                          case 'Menunggu Verifikasi':
                                                            return WaitingEvent(
                                                              id: _event[x].id,
                                                              creatorId: _event[
                                                                      x]
                                                                  .userEvent,
                                                              dataUser:
                                                                    dataUser,
                                                              selfEvent: userId ==
                                                                      _event[x]
                                                                          .userEvent
                                                                  ? true
                                                                  : false,
                                                            );
                                                            break;
                                                          case 'Belum Konfirmasi Admin':
                                                            return RegisterEvents(
                                                                id: _event[x]
                                                                    .id,
                                                                creatorId: _event[
                                                                        x]
                                                                    .userEvent,
                                                                selfEvent: true,
                                                                dataUser:
                                                                    dataUser);
                                                            break;
                                                          case 'Pendaftaran Ditolak':
                                                            return RegisterEvents(
                                                                id: _event[x]
                                                                    .id,
                                                                creatorId: _event[
                                                                        x]
                                                                    .userEvent,
                                                                selfEvent: userId ==
                                                                        _event[x]
                                                                            .userEvent
                                                                    ? true
                                                                    : false,
                                                                dataUser:
                                                                    dataUser);
                                                            break;
                                                          case 'Admin / Co-Host':
                                                            return RegisterEvents(
                                                                id: _event[x]
                                                                    .id,
                                                                creatorId: _event[
                                                                        x]
                                                                    .userEvent,
                                                                dataUser:
                                                                    dataUser,
                                                                selfEvent:
                                                                    true);
                                                            break;
                                                            case 'Dilarang Mendaftar Event':
                                                            return RegisterEvents(
                                                                id: _event[x]
                                                                    .id,
                                                                creatorId: _event[
                                                                        x]
                                                                    .userEvent,
                                                                dataUser:
                                                                    dataUser,
                                                                selfEvent:
                                                                    true);
                                                            break;
                                                          default:
                                                            return RegisterEvents(
                                                                id: _event[x]
                                                                    .id,
                                                                creatorId: _event[
                                                                        x]
                                                                    .userEvent,
                                                                dataUser:
                                                                    dataUser,
                                                                selfEvent: userId ==
                                                                        _event[x]
                                                                            .userEvent
                                                                    ? true
                                                                    : false);
                                                            break;
                                                        }
                                                      }));
                                                    }),
                                              _isPageDisconnect
                                                  ? Container(
                                                      height: 50,
                                                      child: Center(
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    _getPage(
                                                                        categoryNow,
                                                                        _searchQuery);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                          padding: EdgeInsets.all(
                                                                              5.0),
                                                                          child: Icon(Icons.refresh,
                                                                              color: Colors
                                                                                  .blueAccent,
                                                                              size:
                                                                                  25),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors
                                                                                  .white,
                                                                              borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(
                                                                                      20.0),
                                                                                  topRight: Radius.circular(
                                                                                      20.0),
                                                                                  bottomLeft: Radius.circular(
                                                                                      20.0),
                                                                                  bottomRight: Radius.circular(
                                                                                      20.0)),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.grey.withOpacity(0.5),
                                                                                  spreadRadius: 1,
                                                                                  blurRadius: 1,
                                                                                  offset: Offset(0, 1), // changes position of shadow
                                                                                ),
                                                                              ])))))
                                                  : Container(
                                                      height:
                                                          _isLoadingPagination
                                                              ? 50
                                                              : 0,
                                                      child: Center(
                                                          child: CircularProgressIndicator()))
                                            ])),
                                      ))
                      ],
                    ),
                  )),
    );
  }

  Widget buildBar(BuildContext context) {
    return PreferredSize( preferredSize: Size.fromHeight(50.0),
     child : AppBar(
      title: appBarTitle,
      titleSpacing: 0.0,
      centerTitle: true,
      backgroundColor: primaryAppBarColor,
      automaticallyImplyLeading: actionBackAppBar,
      actions: <Widget>[
        Container(
          color: iconButtonAppbarColor == true ? primaryAppBarColor : Colors.white,
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
                      onChanged: (value) {
                         if (_debouncer != null) {
                      _debouncer.cancel();
                    }

                    _debouncer = new Timer(new Duration(milliseconds: 500), () {
                      _changeSearch(value);
                    });
                      },
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: new Icon(Icons.search, color: Colors.grey),
                          hintText: "Cari Berdasarkan Nama Event",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            
                          ),),
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
    )
    );
  }
}

 
