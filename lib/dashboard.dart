import 'package:checkin_app/routes/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'listdetail.dart';
import 'model/event.dart';
import 'pages/events_all/detail_event.dart';
import 'package:flutter/cupertino.dart';
import 'pages/register_event/step_register_six.dart';
import 'pages/register_event/step_register_three.dart';
import 'pages/profile/profile_akun.dart';
import 'package:checkin_app/storage/storage.dart';
import 'pages/management_checkin/dashboard_checkin.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';

bool wishlistone, wishlisttwo, wishlistthree, wishlistfour, wishlistfive;
bool isLoading, isError;
String tokenType, accessToken;
String jumlahnotifX;
String userId;
List<Event> listEventSelf = [];
List<Event> listParticipant = [];
List<Event> listWish = [];
List<Event> listAdmin = [];
List<Event> listCreator = [];
List<Event> listFollower = [];
List<Event> listEventNow = [];
Map dataUser;
var listFilter = [
  {'index': "1", 'name': "Hari ini"},
  {'index': "2", 'name': "3 Hari"},
  {'index': "3", 'name': "7 Hari"},
  {'index': "4", 'name': "Bulan Ini"},
  {'index': "5", 'name': "Bulan Depan"}
];

enum PageEnum {
  kelolaRegisterPage,
}

Map<String, String> requestHeaders = Map();
String usernameprofile, emailprofile;

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDashboard =
      GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var height;
  var futureheight;
  var pastheight, heightmyevent;
  var wishCount;
  var types;
  DataStore user;
  int page = 1;
  bool delay = false;
  var categoryNow;

  @override
  void initState() {
    super.initState();
    eventList(1);
    getvaluenotif();
    dataProfile();
    getHeaderHTTP();
    _getUserData();
    emailprofile = 'Email Anda';
    usernameprofile = 'Username';
    jumlahnotifX = '0';
    wishlisttwo = true;
    wishlistthree = true;
    wishlistfive = true;
    isLoading = true;
    isError = false;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    return eventList(1);
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
    }
  }

  Future<dynamic> _wish(String wish, eventId, index) async {
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
          if (newWish != 1) {
            listWish[index].wish = '0';
            listWish.remove(index);
          } else {
            listWish[index].wish = '1';
          }
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time out , please try again later");
    } catch (e) {
      // print(e);
    }
  }

  Future<List<Event>> eventList(type) async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');
    var getidUser = await storage.getDataString('access_token');
    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
      userId = getidUser;
      types = type;
    });
    try {
      final eventList = await http.get(
        url('api/event/getdata/dashboard/events/$type'),
        headers: requestHeaders,
      );
      if (eventList.statusCode == 200) {
        // return nota;
        var eventListJson = json.decode(eventList.body);
        var participants = eventListJson['participant_event'];
        var wishs = eventListJson['wish_event'];
        var admins = eventListJson['admin_event'];
        var creators = eventListJson['creator_event'];
        var followers = eventListJson['follower_organizer'];

        // print('willcome $events');
        listParticipant = [];
        listWish = [];
        listFollower = [];
        listAdmin = [];
        listCreator = [];

        // get data from api and set data to model
        //participant
        for (var i in participants) {
          Event participant = Event(
              id: i['id'],
              title: i['title'],
              dateEvent: i['date_event'],
              subtitle: i['subtitle'],
              location: i['location'],
              image: i['image'],
              userStatus: i['user_status'],
              wish: i['wish'].toString(),
              eventCreator: i['event_creator']);
          listParticipant.add(participant);
        }
        // wish
        for (var i in wishs) {
          Event wish = Event(
              id: i['id'],
              title: i['title'],
              dateEvent: i['date_event'],
              subtitle: i['subtitle'],
              location: i['location'],
              image: i['image'],
              userStatus: i['user_status'],
              wish: i['wish'],
              eventCreator: i['event_creator']);
          listWish.add(wish);
        }
        // admin
        for (var i in admins) {
          Event admin = Event(
              id: i['id'],
              title: i['title'],
              dateEvent: i['date_event'],
              subtitle: i['subtitle'],
              location: i['location'],
              image: i['image'],
              userStatus: i['user_status'],
              wish: i['wish'],
              eventCreator: i['event_creator']);
          listAdmin.add(admin);
        }

        // creator
        for (var i in creators) {
          Event creator = Event(
              id: i['id'],
              title: i['title'],
              dateEvent: i['date_event'],
              subtitle: i['subtitle'],
              location: i['location'],
              image: i['image'],
              userStatus: i['user_status'],
              eventCreator: i['event_creator']);
          listCreator.add(creator);
        }

        // followers
        for (var i in followers) {
          Event follower = Event(
              id: i['id'],
              title: i['title'],
              dateEvent: i['date_event'],
              subtitle: i['subtitle'],
              location: i['location'],
              image: i['image'],
              userStatus: i['user_status'],
              wish: i['wish'],
              eventCreator: i['event_creator']);
          listFollower.add(follower);
        }

        setState(() {
          isLoading = false;
          isError = false;
        });
        // listDoneEvent();
      } else if (eventList.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        // print(eventList.body);
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
        // print(response.body);
        return null;
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  
  Future<void> dataProfile() async {
    var storage = new DataStore();

    usernameprofile = await storage.getDataString("name");
    emailprofile = await storage.getDataString('email');
  }


  Future<Null> removeSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
  }

  Widget appBarTitle = Text(
    "Dashboard",
    style: TextStyle(fontSize: 16),
  );
  // Icon actionIcon = Icon(
  //   Icons.search,
  //   color: Colors.white,
  // );

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
          child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileUser()));
              },
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
                                'Event Saya',
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
              )),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            eventList(types != null ? types : 1);
          },
          child: _builderBody(),
        )

        // ),
        );
  }

  Widget _builderBody() {
    return SafeArea(
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  for (var x in listFilter)
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: categoryNow == x['index']
                                ? Color.fromRGBO(41, 30, 47, 1)
                                : Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                page = 1;
                                delay = false;
                                categoryNow = x['index'];
                                // _getAll(x['c_id'],_searchQuery);
                                eventList(x['index']);
                              });
                            },
                            child: Text(
                              x['name'],
                              style: TextStyle(
                                  color: categoryNow == x['index']
                                      ? Colors.white
                                      : Color.fromRGBO(41, 30, 47, 1),
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
            SafeArea(
              child: isLoading == true
                  ? Center(
                      child: SpinKitFadingCircle(
                      color: Colors.orange,
                      // size: 50.0,
                    ))
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
                      : Column(
                          children: <Widget>[
//                            ==================================Follower========================================
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 15.0,
                                  bottom: 0.0),
                              child: Divider(),
                            ),
                            Column(children: <Widget>[
//
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(('Event diIkuti').toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          InkWell(
                                              child: Container(
                                                  child: Row(
                                            children: <Widget>[
                                              Text("Lihat Lainnya"),
                                              Icon(Icons.chevron_right)
                                            ],
                                          )),
                                          onTap: () async{
                                           linkToPageDetail(types,'follow');

                                          },
                                          ),
//                                          Text(
//                                              ('Lihat Lainnya'),
//                                              style: TextStyle(
//                                                fontSize: 12 ,
//
//                                              ) ),
//                                          Icon(Icons.chevron_right )
                                        ],
                                      ),
                                    ),
                                  )),
                              Container(
                                  child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: listFollower
                                          .map(
                                            (Event item) => Container(
                                              child: InkWell(
                                                  child: Container(
                                                      width: 300,
                                                      margin: EdgeInsets.only(
//                                                    top: 5.0,
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
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height:
                                                                            100.0,
                                                                        width:
                                                                            250.0,
                                                                        child: FadeInImage
                                                                            .assetNetwork(
                                                                          placeholder:
                                                                              'images/noimage.jpg',
                                                                          image: item.image != null || item.image != ''
                                                                              ? url(
                                                                                  'storage/image/event/event_thumbnail/${item.image}',
                                                                                )
                                                                              : 'images/noimage.jpg',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Expanded(
                                                                                flex: 2,
                                                                                child: Card(
                                                                                    elevation: 0.5,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(7.0),
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Text(
                                                                                            DateFormat("dd").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                          ),
                                                                                          Text(
                                                                                            DateFormat("MMM").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                          ),
                                                                                          Text(
                                                                                            DateFormat("yyyy").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ))),
                                                                            Expanded(
                                                                                flex: 6,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: <Widget>[
                                                                                    Text("${item.title}", style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis),
                                                                                    Text(
                                                                                      "${item.location}",
                                                                                      style: TextStyle(color: Colors.grey),
                                                                                    )
                                                                                  ],
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0),
                                                                    child:
                                                                        Divider()),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0,
                                                                      bottom:
                                                                          10.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(2),
                                                                        child: _buildTextStatus(
                                                                            item.userStatus),
                                                                      ),
                                                                      item.userStatus !=
                                                                              null
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(right: 0),
                                                                            )
                                                                          : Text(
                                                                              ""),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  onTap: () {
                                                    linkToPage(
                                                        item.userStatus,
                                                        item.eventCreator,
                                                        item.id);
                                                  }),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    listFollower.length >= 115
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              child: Container(
                                                  margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                      bottom: 5.0,
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: InkWell(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons
                                                            .navigate_next),
                                                        Text("Lihat Lainnya")
                                                      ],
                                                    ),
                                                  )),
                                              onTap: () async{
                                           linkToPageDetail(types,'follow');

                                          },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )),
                            ]),
//====================================End===============================
//                            ==================================Wish========================================
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 15.0,
                                  bottom: 0.0),
                              child: Divider(),
                            ),
                            Column(children: <Widget>[
//
                              InkWell(
                                  onTap: () async{
                                           linkToPageDetail(types,'wish');

                                          },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              ('Event yang di sukai')
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          InkWell(
                                              child: Container(
                                                  child: Row(
                                            children: <Widget>[
                                              Text("Lihat Lainnya"),
                                              Icon(Icons.chevron_right)
                                            ],
                                          ))),
//                                          Text(
//                                              ('Lihat Lainnya'),
//                                              style: TextStyle(
//                                                fontSize: 12 ,
//
//                                              ) ),
//                                          Icon(Icons.chevron_right )
                                        ],
                                      ),
                                    ),
                                  )),
                              Container(
                                  child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    for (var x = 0; x < listWish.length; x++)
                                      Container(
                                        child: InkWell(
                                          child: Container(
                                              width: 300,
                                              margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                  bottom: 5.0,
                                                  left: 5.0,
                                                  right: 5.0),
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
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                height: 100.0,
                                                                width: 250.0,
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder:
                                                                      'images/noimage.jpg',
                                                                  image: listWish[x].image !=
                                                                              null ||
                                                                          listWish[x].image !=
                                                                              ''
                                                                      ? url(
                                                                          'storage/image/event/event_thumbnail/${listWish[x].image}',
                                                                        )
                                                                      : 'images/noimage.jpg',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Card(
                                                                            elevation: 0.5,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(7.0),
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    DateFormat("dd").format(DateTime.parse(listWish[x].dateEvent)).toString(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                  ),
                                                                                  Text(
                                                                                    DateFormat("MMM").format(DateTime.parse(listWish[x].dateEvent)).toString(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                  ),
                                                                                  Text(
                                                                                    DateFormat("yyyy").format(DateTime.parse(listWish[x].dateEvent)).toString(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                    Expanded(
                                                                        flex: 6,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(listWish[x].title,
                                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                                                maxLines: 2,
                                                                                softWrap: true,
                                                                                overflow: TextOverflow.ellipsis),
                                                                            Text(
                                                                              listWish[x].location,
                                                                              style: TextStyle(color: Colors.grey),
                                                                            )
                                                                          ],
                                                                        ))
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child: Divider()),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10.0,
                                                                  bottom: 10.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                child: _buildTextStatus(
                                                                    listWish[x]
                                                                        .userStatus),
                                                              ),
                                                              listWish[x].userStatus !=
                                                                      null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              0),
                                                                      child:
                                                                          ButtonTheme(
                                                                        minWidth:
                                                                            0, //wraps child's width
                                                                        height:
                                                                            0,
                                                                        child: FlatButton(
                                                                            child: Row(
                                                                              children: <Widget>[
                                                                                Icon(
                                                                                  Icons.favorite,
                                                                                  color: listWish[x].wish == '1' ? Colors.pink : Colors.grey,
                                                                                  size: 18,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            color: Colors.white,
                                                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                            padding: EdgeInsets.all(5.0),
                                                                            onPressed: () async {
                                                                              _wish(listWish[x].wish, listWish[x].id, x);
                                                                            }),
                                                                      ),
                                                                    )
                                                                  : Text(""),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          onTap: () async {
                                            linkToPage(
                                                listWish[x].userStatus,
                                                listWish[x].eventCreator,
                                                listWish[x].id);
                                          },
                                        ),
                                      ),
                                    listWish.length >= 5
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              child: Container(
                                                  margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                      bottom: 5.0,
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: InkWell(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons
                                                            .navigate_next),
                                                        Text("Lihat Lainnya")
                                                      ],
                                                    ),
                                                  )),
                                             onTap: () async{
                                           linkToPageDetail(types,'wish');

                                          },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )),
                            ]),
//====================================End===============================

//                            ==================================Participant========================================
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 15.0,
                                  bottom: 0.0),
                              child: Divider(),
                            ),
                            Column(children: <Widget>[
//
                              InkWell(
                                  onTap: () async{
                                           linkToPageDetail(types,'participant');

                                          },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              ('Event Jadi Peserta')
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          InkWell(
                                              child: Container(
                                                  child: Row(
                                            children: <Widget>[
                                              Text("Lihat Lainnya"),
                                              Icon(Icons.chevron_right)
                                            ],
                                          ))),
//                                          Text(
//                                              ('Lihat Lainnya'),
//                                              style: TextStyle(
//                                                fontSize: 12 ,
//
//                                              ) ),
//                                          Icon(Icons.chevron_right )
                                        ],
                                      ),
                                    ),
                                  )),
                              Container(
                                  child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                        children: listParticipant
                                            .map((Event item) => Container(
                                                  child: InkWell(
                                                    child: Container(
                                                        width: 300,
                                                        margin: EdgeInsets.only(
//                                                    top: 5.0,
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
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          height:
                                                                              100.0,
                                                                          width:
                                                                              250.0,
                                                                          child:
                                                                              FadeInImage.assetNetwork(
                                                                            placeholder:
                                                                                'images/noimage.jpg',
                                                                            image: item.image != null || item.image != ''
                                                                                ? url(
                                                                                    'storage/image/event/event_thumbnail/${item.image}',
                                                                                  )
                                                                                : 'images/noimage.jpg',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                  flex: 2,
                                                                                  child: Card(
                                                                                      elevation: 0.5,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(7.0),
                                                                                        child: Column(
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              DateFormat("dd").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                            ),
                                                                                            Text(
                                                                                              DateFormat("MMM").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                            ),
                                                                                            Text(
                                                                                              DateFormat("yyyy").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ))),
                                                                              Expanded(
                                                                                  flex: 6,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Text("${item.title}", style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis),
                                                                                      Text(
                                                                                        "${item.location}",
                                                                                        style: TextStyle(color: Colors.grey),
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10.0,
                                                                          right:
                                                                              10.0),
                                                                      child:
                                                                          Divider()),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child:
                                                                              _buildTextStatus(item.userStatus),
                                                                        ),
                                                                        item.userStatus !=
                                                                                null
                                                                            ? Padding(
                                                                                padding: const EdgeInsets.only(right: 0),
                                                                                child: ButtonTheme(
                                                                                  minWidth: 0, //wraps child's width
                                                                                  height: 0,
                                                                                  child: FlatButton(
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          // Icon(
                                                                                          //   Icons.favorite,
                                                                                          //   color: item.wish.toString() == '1'
                                                                                          //       ? Colors.pink
                                                                                          //       : Colors.grey,
                                                                                          //   size: 18,
                                                                                          // ),
                                                                                        ],
                                                                                      ),
                                                                                      color: Colors.white,
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      padding: EdgeInsets.all(5.0),
                                                                                      onPressed: () async {
                                                                                        // _wish(item.wish.toString(),item.id.toString(),listParticipant,item);
                                                                                      }),
                                                                                ),
                                                                              )
                                                                            : Text(""),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    onTap: () async {
                                                      linkToPage(
                                                          item.userStatus,
                                                          item.eventCreator,
                                                          item.id);
                                                    },
                                                  ),
                                                ))
                                            .toList()),
                                    listParticipant.length >= 5
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              child: Container(
                                                  margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                      bottom: 5.0,
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: InkWell(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons
                                                            .navigate_next),
                                                        Text("Lihat Lainnya")
                                                      ],
                                                    ),
                                                  )),
                                              onTap: () async{
                                           linkToPageDetail(types,'participant');

                                          },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )),
                            ]),
//====================================End===============================
                            //                            ==================================Admin========================================
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 15.0,
                                  bottom: 0.0),
                              child: Divider(),
                            ),
                            Column(children: <Widget>[
//
                              InkWell(
                                  onTap: () async{
                                           linkToPageDetail(types,'admin');

                                          },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              ('Event Jadi Admin')
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          InkWell(
                                              child: Container(
                                                  child: Row(
                                            children: <Widget>[
                                              Text("Lihat Lainnya"),
                                              Icon(Icons.chevron_right)
                                            ],
                                          ))),
//                                          Text(
//                                              ('Lihat Lainnya'),
//                                              style: TextStyle(
//                                                fontSize: 12 ,
//
//                                              ) ),
//                                          Icon(Icons.chevron_right )
                                        ],
                                      ),
                                    ),
                                  )),
                              Container(
                                  child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: listAdmin
                                          .map(
                                            (Event item) => Container(
                                              child: InkWell(
                                                child: Container(
                                                    width: 300,
                                                    margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                        bottom: 5.0,
                                                        left: 5.0,
                                                        right: 5.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Card(
                                                          elevation: 1,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      height:
                                                                          100.0,
                                                                      width:
                                                                          250.0,
                                                                      child: FadeInImage
                                                                          .assetNetwork(
                                                                        placeholder:
                                                                            'images/noimage.jpg',
                                                                        image: item.image != null ||
                                                                                item.image != ''
                                                                            ? url(
                                                                                'storage/image/event/event_thumbnail/${item.image}',
                                                                              )
                                                                            : 'images/noimage.jpg',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                              flex: 2,
                                                                              child: Card(
                                                                                  elevation: 0.5,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(7.0),
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          DateFormat("dd").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                        ),
                                                                                        Text(
                                                                                          DateFormat("MMM").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                        ),
                                                                                        Text(
                                                                                          DateFormat("yyyy").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ))),
                                                                          Expanded(
                                                                              flex: 6,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text("${item.title}", style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis),
                                                                                  Text(
                                                                                    "${item.location}",
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  )
                                                                                ],
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                  padding: EdgeInsets.only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0),
                                                                  child:
                                                                      Divider()),
                                                              Padding(
                                                                padding: const EdgeInsets
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
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2),
                                                                      child: _buildTextStatus(
                                                                          item.userStatus),
                                                                    ),
                                                                    item.userStatus !=
                                                                            null
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 0),
                                                                            child:
                                                                                ButtonTheme(
                                                                              minWidth: 0, //wraps child's width
                                                                              height: 0,
                                                                              child: FlatButton(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    // Icon(
                                                                                    //   Icons.favorite,
                                                                                    //   color: wishlisttwo == true
                                                                                    //       ? Colors.pink
                                                                                    //       : Colors.grey,
                                                                                    //   size:
                                                                                    //   18,
                                                                                    // ),
                                                                                  ],
                                                                                ),
                                                                                color: Colors.white,
                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                                                          )
                                                                        : Text(
                                                                            ""),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                onTap: () async {
                                                  linkToPage(
                                                      item.userStatus,
                                                      item.eventCreator,
                                                      item.id);
                                                },
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    listAdmin.length >= 5
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              child: Container(
                                                  margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                      bottom: 5.0,
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: InkWell(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons
                                                            .navigate_next),
                                                        Text("Lihat Lainnya")
                                                      ],
                                                    ),
                                                  )),
                                              onTap: () async{
                                           linkToPageDetail(types,'admin');

                                          },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )),
                            ]),
//====================================End===============================
                            //                            ==================================Creator========================================
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 15.0,
                                  bottom: 0.0),
                              child: Divider(),
                            ),
                            Column(children: <Widget>[
//
                              InkWell(
                                  onTap: () async{
                                           linkToPageDetail(types,'creator');

                                          },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              ('Event Yang Dibuat')
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          InkWell(
                                              child: Container(
                                                  child: Row(
                                            children: <Widget>[
                                              Text("Lihat Lainnya"),
                                              Icon(Icons.chevron_right)
                                            ],
                                          ))),
//                                          Text(
//                                              ('Lihat Lainnya'),
//                                              style: TextStyle(
//                                                fontSize: 12 ,
//
//                                              ) ),
//                                          Icon(Icons.chevron_right )
                                        ],
                                      ),
                                    ),
                                  )),
                              Container(
                                  child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: listCreator
                                          .map(
                                            (Event item) => Container(
                                              child: InkWell(
                                                child: Container(
                                                    width: 300,
                                                    margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                        bottom: 5.0,
                                                        left: 5.0,
                                                        right: 5.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Card(
                                                          elevation: 1,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      height:
                                                                          100.0,
                                                                      width:
                                                                          250.0,
                                                                      child: FadeInImage
                                                                          .assetNetwork(
                                                                        placeholder:
                                                                            'images/noimage.jpg',
                                                                        image: item.image != null 
                                                                            ? url(
                                                                                'storage/image/event/event_thumbnail/${item.image}',
                                                                              )
                                                                            : 'images/noimage.jpg',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                              flex: 2,
                                                                              child: Card(
                                                                                  elevation: 0.5,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(7.0),
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          DateFormat("dd").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                        ),
                                                                                        Text(
                                                                                          DateFormat("MMM").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                        ),
                                                                                        Text(
                                                                                          DateFormat("yyyy").format(DateTime.parse(item.dateEvent)).toString(),
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ))),
                                                                          Expanded(
                                                                              flex: 6,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text("${item.title}", style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis),
                                                                                  Text(
                                                                                    "${item.location}",
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  )
                                                                                ],
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                  padding: EdgeInsets.only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0),
                                                                  child:
                                                                      Divider()),
                                                              Padding(
                                                                padding: const EdgeInsets
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
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2),
                                                                      child: _buildTextStatus(
                                                                          item.userStatus),
                                                                    ),
                                                                    item.userStatus !=
                                                                            null
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 0),
                                                                            child:
                                                                                ButtonTheme(
                                                                              minWidth: 0, //wraps child's width
                                                                              height: 0,
                                                                              child: FlatButton(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    // Icon(
                                                                                    //   Icons.favorite,
                                                                                    //   color: wishlisttwo == true
                                                                                    //       ? Colors.pink
                                                                                    //       : Colors.grey,
                                                                                    //   size:
                                                                                    //   18,
                                                                                    // ),
                                                                                  ],
                                                                                ),
                                                                                color: Colors.white,
                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                                                          )
                                                                        : Text(
                                                                            ""),
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
                                                        builder: (context) =>
                                                            DashboardCheckin(
                                                                idevent: item.id
                                                                    .toString()),
                                                      ));
                                                },
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    listCreator.length >= 5
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              child: Container(
                                                  margin: EdgeInsets.only(
//                                                    top: 5.0,
                                                      bottom: 5.0,
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: InkWell(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons
                                                            .navigate_next),
                                                        Text("Lihat Lainnya")
                                                      ],
                                                    ),
                                                  )),
                                              onTap: () async{
                                           linkToPageDetail(types,'creator');

                                          },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )),
                            ]),
//====================================End===============================
                          ],
                        ),
            )
          ])),
    );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
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
    if (status == "Sudah Terdaftar") {
      return Container(
          decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0)),
          ),
          padding: EdgeInsets.all(5.0),
          width: 120.0,
          child: Text(
            'Sudah Terdaftar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ));
    } else if (status == "Proses Pendaftaran") {
      return Container(
          decoration: new BoxDecoration(
            color: Colors.orange,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0)),
          ),
          padding: EdgeInsets.all(5.0),
          width: 120.0,
          child: Text(
            'Proses Pendaftaran ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ));
          } else if (status == "Event Selesai") {
      return Container(
          decoration: new BoxDecoration(
            color: Color.fromRGBO(255, 191, 128,1),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0)),
          ),
          padding: EdgeInsets.all(5.0),
          width: 120.0,
          child: Text(
            'Event Selesai',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ));
    } else if (status == "Creator") {
      return null;
    } else {
      return Container(
          decoration: new BoxDecoration(
            color: Colors.grey,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0)),
          ),
          padding: EdgeInsets.all(5.0),
          width: 120.0,
          child: Text(
            'Belum Terdaftar ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ));
    }
  }
  void linkToPageDetail(types,categories){
    var type = types != null ? types:1;
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailList(type:type, typeCategory: categories) ));
  }
  void linkToPage(status, cratorId, eventId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (status) {
        case 'Sudah Terdaftar':
          return SuccesRegisteredEvent(
              id: eventId,
              creatorId: cratorId,
              dataUser: dataUser,
              selfEvent: userId == cratorId ? true : false);
          break;
        case 'Proses Pendaftaran':
          return WaitingEvent(
            id: eventId,
            creatorId: cratorId,
            selfEvent: userId == cratorId ? true : false,
          );
          break;
        case 'Ditolak':
          return RegisterEvents(
              id: eventId,
              creatorId: cratorId,
              selfEvent: userId == cratorId ? true : false,
              dataUser: dataUser);
          break;
        case 'Admin / Co-Host':
          return RegisterEvents(
              id: eventId,
              creatorId: cratorId,
              dataUser: dataUser,
              selfEvent: true);
          break;
          case 'Proses Daftar Admin':
          return RegisterEvents(
              id: eventId,
              creatorId: cratorId,
              dataUser: dataUser,
              selfEvent: userId == cratorId ? true : false);
        default:
          return RegisterEvents(
              id: eventId,
              creatorId: cratorId,
              dataUser: dataUser,
              selfEvent: userId == cratorId ? true : false);
          break;
      }
    }));
  }
}
