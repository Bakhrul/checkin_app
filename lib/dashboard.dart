import 'package:flutter/material.dart';
import 'dart:ui';
import 'pages/events_all/detail_event.dart';
import 'package:flutter/cupertino.dart';
import 'pages/register_event/step_register_six.dart';
import 'pages/register_event/step_register_three.dart';
import 'pages/events_all/detail_event.dart';
import 'pages/register_event/detail_event_afterregist.dart';
import 'utils/utils.dart';
import 'pages/management_checkin/dashboard_checkin.dart';

GlobalKey<ScaffoldState> _scaffoldKeyDashboard;
bool wishlistone, wishlisttwo, wishlistthree, wishlistfour, wishlistfive;
enum PageEnum {
  kelolaRegisterPage,
}

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  var height;
  var futureheight;
  var pastheight, heightmyevent;

  @override
  void initState() {
    _scaffoldKeyDashboard = GlobalKey<ScaffoldState>();
    super.initState();
    wishlisttwo = true;
    wishlistthree = true;
    wishlistfive = true;
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

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Dashboard",
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
        key: _scaffoldKeyDashboard,
        appBar: buildBar(context),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: <Widget>[
                // Profil Drawer Here
                UserAccountsDrawerHeader(
                  accountName: Text("Muhammad Bakhrul Bila Sakhil"),
                  accountEmail: Text("bakhrulrpl@gmail.com"),
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
                            'Semua Event',
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
                              onPressed: () {},
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
              child: Column(children: <Widget>[
            InkWell(
                onTap: currentmyEvent,
                child: Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(('Event Anda').toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Icon(heightmyevent == null
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                      ],
                    ),
                  ),
                )),
            InkWell(
              child: Container(
                  margin: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                  height: heightmyevent,
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
                                            '12 Agustus 2019',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text('Komunitas Dev Junior',
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
                                              'Lemahbang Sukorejo Pasuruan',
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
                          ],
                        ),
                      ),
                    ],
                  )),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardCheckin(),
                    ));
              },
            ),
          ])),
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
            InkWell(
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
                                                  '12 Agustus 2019',
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
                                                      'Komunitas Dev Junior',
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
                                                    'Lemahbang Sukorejo Pasuruan',
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
                                            child: Text(
                                              'Sudah Terdaftar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
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
            InkWell(
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
                                            '12 Agustus 2019',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text('Komunitas Dev Junior',
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
                                              'Lemahbang Sukorejo Pasuruan',
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
                                      child: Text(
                                        'Proses Daftar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
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
            InkWell(
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
                                            '12 Agustus 2019',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text('Komunitas Dev Junior',
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
                                              'Lemahbang Sukorejo Pasuruan',
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
                                        color: Colors.grey,
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
                                      child: Text(
                                        'Belum Terdaftar',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
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
                                              color: wishlistthree == true
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
                                            if (wishlistthree == true) {
                                              wishlistthree = false;
                                            } else {
                                              wishlistthree = true;
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
                      builder: (context) => RegisterEvents(),
                    ));
              },
            ),
          ]),
          Container(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
            child: Divider(),
          ),
          Column(children: <Widget>[
            InkWell(
                onTap: pastEvent,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(('Event Selesai').toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Icon(pastheight == null
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                      ],
                    ),
                  ),
                )),
            InkWell(
                child: Container(
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                    height: pastheight,
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
                                              '12 Agustus 2019',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                  'Komunitas Dev Junior',
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
                                                'Lemahbang Sukorejo Pasuruan',
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
                                          color: Colors.grey,
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(5.0),
                                              topRight:
                                                  const Radius.circular(5.0),
                                              bottomLeft:
                                                  const Radius.circular(5.0),
                                              bottomRight:
                                                  const Radius.circular(5.0)),
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        width: 120.0,
                                        child: Text(
                                          'Event Batal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
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
                                                color: wishlistfour == true
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
                                              if (wishlistfour == true) {
                                                wishlistfour = false;
                                              } else {
                                                wishlistfour = true;
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
                        builder: (context) => AfterRegisterEvents(),
                      ));
                }),
            InkWell(
                child: Container(
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                    height: pastheight,
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
                                              '12 Agustus 2019',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                  'Komunitas Dev Junior',
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
                                                'Lemahbang Sukorejo Pasuruan',
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
                                          color: Colors.grey,
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(5.0),
                                              topRight:
                                                  const Radius.circular(5.0),
                                              bottomLeft:
                                                  const Radius.circular(5.0),
                                              bottomRight:
                                                  const Radius.circular(5.0)),
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
                                        )),
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
                                                color: wishlistfive == true
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
                                          onPressed: () async {},
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
                        builder: (context) => SuccesRegisteredEvent(),
                      ));
                }),
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
      ],
    );
  }
}
