import 'package:checkin_app/routes/env.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'model/event.dart';
import 'pages/events_all/detail_event.dart';
import 'package:flutter/cupertino.dart';
import 'pages/register_event/step_register_six.dart';
import 'pages/register_event/step_register_three.dart';
import 'package:checkin_app/storage/storage.dart';
import 'pages/register_event/detail_event_afterregist.dart';
import 'pages/management_checkin/dashboard_checkin.dart';
import 'pages/management_checkin/create_checkin.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';
bool wishlistone, wishlisttwo, wishlistthree, wishlistfour, wishlistfive;
bool isLoading, isError;
String tokenType, accessToken;
String jumlahnotifX;
List<Event> listEventSelf = [];
List<Event> listEventUpComming = [];
List<Event> listEventNow = [];

enum PageEnum {
  kelolaRegisterPage,
}

class Dashboard extends StatefulWidget {
  // final IkiIndex _indexIki;

  // Dashboard({@required IkiIndex indexIki}) : _indexIki = indexIki;
  Dashboard({Key key, this.title}) : super(key: key);
  // final String title;
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDashboard =
      GlobalKey<ScaffoldState>();
  var height;
  var futureheight;
  var pastheight, heightmyevent;

  @override
  void initState() {
    super.initState();
    eventUpComing();
    eventNow();
    getvaluenotif();
    dataProfile();
    // eventSelf();
    emailprofile = 'Email Anda';
    usernameprofile = 'Username';
    jumlahnotifX = '0';
    wishlisttwo = true;
    wishlistthree = true;
    wishlistfive = true;
    isLoading = true;
    isError = false;
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

  void currentmyEvent() {
    setState(() {
      if (heightmyevent == 0.0) {
        heightmyevent = null;
      } else {
        heightmyevent = 0.0;
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

  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Dashboard",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }

  // Future<List<Event>> eventSelf() async {
  //   var storage = new DataStore();
  //   var tokenTypeStorage = await storage.getDataString('token_type');
  //   var accessTokenStorage = await storage.getDataString('access_token');

  //   tokenType = tokenTypeStorage;
  //   accessToken = accessTokenStorage;
  //   requestHeaders['Accept'] = 'application/json';
  //   requestHeaders['Authorization'] = '$tokenType $accessToken';

  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final selfevent = await http.get(
  //       url('api/event/getdata/dashboard/eventanda'),
  //       headers: requestHeaders,
  //     );

  //     if (selfevent.statusCode == 200) {
  //       // return nota;
  //       var selfeventJson = json.decode(selfevent.body);
  //       var selfevents = selfeventJson;

  //       print('willcome $selfevents');
  //       listEventSelf = [];
  //       for (var i in selfevents) {
  //         Event willcomex = Event(
  //           // id: '${i['ev_id']}',
  //           title: i['title'],
  //           dateEvent: i['date_event'],
  //           subtitle: i['subtitle'],
  //           location: i['location'],
  //           image: i['image'],
  //         );
  //         listEventSelf.add(willcomex);
  //       }
  //       setState(() {
  //         isLoading = false;
  //         isError = false;
  //       });
  //       // listDoneEvent();
  //     } else if (selfevent.statusCode == 401) {
  //       Fluttertoast.showToast(
  //           msg: "Token telah kadaluwarsa, silahkan login kembali");
  //       setState(() {
  //         isLoading = false;
  //         isError = true;
  //       });
  //     } else {
  //       print(selfevent.body);
  //       setState(() {
  //         isLoading = false;
  //         isError = true;
  //       });
  //       return null;
  //     }
  //   } on TimeoutException catch (_) {
  //     setState(() {
  //       isLoading = false;
  //       isError = true;
  //     });
  //     Fluttertoast.showToast(msg: "Timed out, Try again");
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       isError = true;
  //     });
  //     debugPrint('$e');
  //   }
  //   return null;
  // }

  Future<List<Event>> eventNow() async {
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
      final nowevent = await http.get(
        url('api/event/getdata/dashboard/eventsekarang'),
        headers: requestHeaders,
      );

      if (nowevent.statusCode == 200) {
        // return nota;
        var noweventJson = json.decode(nowevent.body);
        var nowevents = noweventJson;

        print('willcome $nowevents');
        listEventNow = [];
        for (var i in nowevents) {
          Event willcomex = Event(
            // id: '${i['ev_id']}',
            title: i['title'],
            dateEvent: i['date_event'],
            subtitle: i['subtitle'],
            location: i['location'],
            image: i['image'],
            userStatus: i['user_status'],

          );
          listEventNow.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
        // listDoneEvent();
      } else if (nowevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(nowevent.body);
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

 Future<List<Event>> eventUpComing() async {
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
        url('api/event/getdata/dashboard/eventakandatang'),
        headers: requestHeaders,
      );

      if (willcomeevent.statusCode == 200) {
        // return nota;
        var willcomeeventJson = json.decode(willcomeevent.body);
        var willcomeEvents = willcomeeventJson;

        print('willcome $willcomeEvents');
        listEventUpComming = [];
        for (var i in willcomeEvents) {
          Event willcomex = Event(
            // id: '${i['ev_id']}',
            title: i['title'],
            dateEvent: i['date_event'],
            subtitle: i['subtitle'],
            location: i['location'],
            image: i['image'],
            userStatus: i['user_status'],
          );
          listEventUpComming.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
        // listDoneEvent();
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

  Future<void> getvaluenotif() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final response = await http.post(
        url('api/check_notification'),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        var notifJson = json.decode(response.body);
        String notifvalue = notifJson['jumlahnotif'].toString();

        setState(() {
          jumlahnotifX = notifvalue;
        });
      } else if (response.statusCode == 401) {
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  String usernameprofile, emailprofile;
  Future<void> dataProfile() async {
    var storage = new DataStore();

    usernameprofile = await storage.getDataString("name");
    emailprofile = await storage.getDataString('email');
  }

  String _username;
  Future<Null> removeSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
    _username = await dataStore.getDataString("name");
    print(_username);
  }

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Dashboard",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  Icon notifIcon = Icon(
    Icons.more_vert,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKeyDashboard,
        appBar: buildBar(context),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: <Widget>[
                // Profil Drawer Here
                UserAccountsDrawerHeader(
                  // accountName: Text("Muhammad Bakhrul Bila Sakhil"),
                  accountName: Text(usernameprofile),
                  accountEmail: Text(emailprofile),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(41, 30, 47, 1),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      "A",
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                    ),
                  ),
                ),
                //  Menu Section Here
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Cari Event',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: Color(0xff25282b),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/semua_event");
                          },
                        ),
                        ListTile(
                          title: Text(
                            'Event Anda',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: Color(0xff25282b),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/personal_event");
                          },
                        ),
                        ListTile(
                          title: Text(
                            'Event Yang di Ikuti',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: Color(0xff25282b),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/follow_event");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        color: Color(0xff25282b),
                      ),
                    ),
                    trailing: Icon(Icons.exit_to_app),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Peringatan!'),
                          content: Text('Apa anda yakin ingin logout?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'Tidak',
                                style: TextStyle(color: Colors.black54),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Ya',
                                style: TextStyle(color: Colors.cyan),
                              ),
                              onPressed: () {
                                removeSharedPrefs();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, "/login");
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(('Cari Event Berdasarkan Kategori').toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ButtonTheme(
                      minWidth: 0.0,
                      height: 0,
                      child: RaisedButton(
                        color: Color.fromRGBO(41, 30, 47, 1),
                        elevation: 0.0,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0.0,
                        padding: EdgeInsets.only(
                            top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                        onPressed: () {},
                        child: Text(
                          'Semua',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(41, 30, 47, 1),
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ButtonTheme(
                      minWidth: 0.0,
                      height: 0,
                      child: RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0.0,
                        padding: EdgeInsets.only(
                            top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                        onPressed: () {},
                        child: Text(
                          'Teknologi',
                          style: TextStyle(
                              color: Color.fromRGBO(41, 30, 47, 1),
                              fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(41, 30, 47, 1),
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ButtonTheme(
                      minWidth: 0.0,
                      height: 0,
                      child: RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0.0,
                        padding: EdgeInsets.only(
                            top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                        onPressed: () {},
                        child: Text(
                          'Kesehatan',
                          style: TextStyle(
                              color: Color.fromRGBO(41, 30, 47, 1),
                              fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(41, 30, 47, 1),
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ButtonTheme(
                      minWidth: 0.0,
                      height: 0,
                      child: RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0.0,
                        padding: EdgeInsets.only(
                            top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                        onPressed: () {},
                        child: Text(
                          'Financial',
                          style: TextStyle(
                              color: Color.fromRGBO(41, 30, 47, 1),
                              fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(41, 30, 47, 1),
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ButtonTheme(
                      minWidth: 0.0,
                      height: 0,
                      child: RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0.0,
                        padding: EdgeInsets.only(
                            top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                        onPressed: () {},
                        child: Text(
                          'Keuangan',
                          style: TextStyle(
                              color: Color.fromRGBO(41, 30, 47, 1),
                              fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(41, 30, 47, 1),
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ButtonTheme(
                      minWidth: 0.0,
                      height: 0,
                      child: RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0.0,
                        padding: EdgeInsets.only(
                            top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                        onPressed: () {},
                        child: Text(
                          'Pertambangan',
                          style: TextStyle(
                              color: Color.fromRGBO(41, 30, 47, 1),
                              fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(41, 30, 47, 1),
                            )),
                      ),
                    )),
              ]),
            ),
          ),
          
          Container(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 15.0, bottom: 0.0),
            child: Divider(),
          ),
          Container(
              child: Column(children: <Widget>[
            InkWell(
                onTap: currentEvent,
                child: Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(('Event Berlangsung').toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Icon(height == null
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                      ],
                    ),
                  ),
                )),
            Column(children: listEventNow.map((Event f) => Container(
              child: InkWell(
              child: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                        child: Column(
                          children: <Widget>[
                            Card(
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
                                              decoration: new BoxDecoration(
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
                                                image: new DecorationImage(
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
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  f.dateEvent,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(
                                                      f.title,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                    f.location,
                                                    style: TextStyle(
                                                        color: Colors.grey),
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
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft: const Radius
                                                          .circular(5.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomRight: const Radius
                                                          .circular(5.0)),
                                            ),
                                            padding: EdgeInsets.all(5.0),
                                            width: 120.0,
                                            child: _buildTextStatus(f.userStatus)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: ButtonTheme(
                                            minWidth: 0, //wraps child's width
                                            height: 0,
                                            child: FlatButton(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.favorite,
                                                    color: wishlistone == true
                                                        ? Colors.pink
                                                        : Colors.grey,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                              color: Colors.white,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding: EdgeInsets.all(5.0),
                                              onPressed: () async {
                                                setState(() {
                                                  if (wishlistone == true) {
                                                    wishlistone = false;
                                                  } else {
                                                    wishlistone = true;
                                                  }
                                                });
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
                    Positioned(
                        width: 30.0,
                        right: 10,
                        top: -7,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0)),
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.star_border,
                              color: Colors.orangeAccent),
                        )),
                  ],
                ),
              ),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccesRegisteredEvent(),
                    ));
              },
            ),
            )).toList(),)
          ])),
          Container(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 15.0, bottom: 0.0),
            child: Divider(),
          ),
          Column(children: <Widget>[
            InkWell(
                onTap: futureEvent,
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(('Event yang akan datang').toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Icon(futureheight == null
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                      ],
                    ),
                  ),
                )),
                Column(children: listEventUpComming.map((Event item) => Container(

            child: InkWell(
              child: Container(
                  margin: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                  height: futureheight,
                  child: Column(
                    children: <Widget>[
                      
                      Card(
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
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(5.0),
                                              topRight:
                                                  const Radius.circular(5.0),
                                              bottomLeft:
                                                  const Radius.circular(5.0),
                                              bottomRight:
                                                  const Radius.circular(5.0)),
                                          image: new DecorationImage(
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
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item.dateEvent,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(item.title,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              item.location,
                                              style:
                                                  TextStyle(color: Colors.grey),
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
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Divider()),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(5.0),
                                            topRight:
                                                const Radius.circular(5.0),
                                            bottomLeft:
                                                const Radius.circular(5.0),
                                            bottomRight:
                                                const Radius.circular(5.0)),
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      width: 120.0,
                                      child: _buildTextStatus(item.userStatus)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: ButtonTheme(
                                      minWidth: 0, //wraps child's width
                                      height: 0,
                                      child: FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite,
                                              color: wishlisttwo == true
                                                  ? Colors.pink
                                                  : Colors.grey,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                        color: Colors.white,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.all(5.0),
                                        onPressed: () async {
                                          setState(() {
                                            if (wishlisttwo == true) {
                                              wishlisttwo = false;
                                            } else {
                                              wishlisttwo = true;
                                            }
                                          });
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaitingEvent(),
                    ));
              },
            ),
                                    )).toList()),
            
          ]),
          
          
        ])));
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
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(context, "/notifications");
                }),
            new Positioned(
              right: 6,
              top: 2,
              child: new Container(
                height: 20.0,
                alignment: Alignment.center,
                width: 20.0,
                decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                constraints: BoxConstraints(),
                child: Text(
                  jumlahnotifX == null || jumlahnotifX == ''
                      ? '0'
                      : jumlahnotifX,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildTextStatus(status) {
print(status);
    if (status == "A") {
    return Text(
        'Sudah Terdaftar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      );
                                              
    }else if(status == "P"){
        return Text(
        'Proses Daftar',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}
