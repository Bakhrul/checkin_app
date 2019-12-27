import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:unicorndial/unicorndial.dart';
import 'create_checkin.dart';
// import 'listprovinsi.dart';
// import 'listkabupaten.dart';
// import 'listkecamatan.dart';
// import 'create_checkin.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreateevent;
String sifat = 'VIP';
String tipe = 'Public';
var datepicker;

void showInSnackBar(String value) {
  _scaffoldKeycreateevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class DashboardCheckin extends StatefulWidget {
  DashboardCheckin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardCheckinState();
  }
}

class _DashboardCheckinState extends State<DashboardCheckin>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _scaffoldKeycreateevent = GlobalKey<ScaffoldState>();
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    datepicker = FocusNode();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  bool monVal = false;
  bool monVal2 = false;
  bool monVal3 = false;
  bool monVal4 = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Choo choo",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {},
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "airplane",
      backgroundColor: Colors.greenAccent,
      mini: true,
      child: Icon(Icons.airplanemode_active),
      onPressed: () {},
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "directions",
      backgroundColor: Colors.blueAccent,
      mini: true,
      child: Icon(Icons.directions_car),
      onPressed: () {},
    )));

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          title: Text('Manajemen Event', style: TextStyle(fontSize: 14)),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Peserta'),
              Tab(icon: Icon(Icons.schedule), text: 'Checkin'),
            ],
          ),
        ), //
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: TextField(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color.fromRGBO(41, 30, 47, 1),
                          ),
                          hintText: "Cari Berdasarkan Nama Lengkap",
                          border: InputBorder.none,
                        )),
                  ),
                  Card(
                      child: ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/imgavatar.png',
                            ),
                          ),
                        )),
                    title: Text('Muhammad Bakhrul Bila Sakhil'),
                    subtitle: Text('081285270793'),
                  )),
                  Card(
                      child: ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/imgavatar.png',
                            ),
                          ),
                        )),
                    title: Text('Muhammad Bakhrul Bila Sakhil'),
                    subtitle: Text('081285270793'),
                  )),
                  Card(
                      child: ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/imgavatar.png',
                            ),
                          ),
                        )),
                    title: Text('Muhammad Bakhrul Bila Sakhil'),
                    subtitle: Text('081285270793'),
                  )),
                  Card(
                      child: ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/imgavatar.png',
                            ),
                          ),
                        )),
                    title: Text('Muhammad Bakhrul Bila Sakhil'),
                    subtitle: Text('081285270793'),
                  )),
                  Card(
                      child: ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/imgavatar.png',
                            ),
                          ),
                        )),
                    title: Text('Muhammad Bakhrul Bila Sakhil'),
                    subtitle: Text('081285270793'),
                  )),
                  Card(
                      child: ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/imgavatar.png',
                            ),
                          ),
                        )),
                    title: Text('Muhammad Bakhrul Bila Sakhil'),
                    subtitle: Text('081285270793'),
                  )),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 15.0,
                right: 5.0,
                left: 5.0,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 4, 10, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            '12 September 2019',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 15.0,
                                  alignment: Alignment.center,
                                  width: 15.0,
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                ),
                              ),
                            ),
                            title: Text(
                              'KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            // onTap: Navigator.push(context,MaterialPageRoute(builder: (context) => context)),
                            trailing: ButtonTheme(
                                minWidth: 0.0,
                                child: FlatButton(
                                  color: Colors.white,
                                  textColor: Colors.red,
                                  disabledColor: Colors.green[400],
                                  disabledTextColor: Colors.white,
                                  padding: EdgeInsets.all(15.0),
                                  splashColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.close,
                                  ),
                                  onPressed: () async {},
                                )),
                            subtitle: Text('04:00 - 04:30'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 15.0,
                                  alignment: Alignment.center,
                                  width: 15.0,
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                ),
                              ),
                            ),
                            title: Text(
                              'KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            trailing: ButtonTheme(
                                minWidth: 0.0,
                                child: FlatButton(
                                  color: Colors.white,
                                  textColor: Colors.red,
                                  disabledColor: Colors.green[400],
                                  disabledTextColor: Colors.white,
                                  padding: EdgeInsets.all(15.0),
                                  splashColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.close,
                                  ),
                                  onPressed: () async {},
                                )),
                            subtitle: Text('04:00 - 04:30'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, top: 10.0),
                          child: Text(
                            '13 September 2019',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 15.0,
                                  alignment: Alignment.center,
                                  width: 15.0,
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                ),
                              ),
                            ),
                            title: Text(
                              'KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            trailing: ButtonTheme(
                                minWidth: 0.0,
                                child: FlatButton(
                                  color: Colors.white,
                                  textColor: Colors.red,
                                  disabledColor: Colors.green[400],
                                  disabledTextColor: Colors.white,
                                  padding: EdgeInsets.all(15.0),
                                  splashColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.close,
                                  ),
                                  onPressed: () async {},
                                )),
                            subtitle: Text('04:00 - 04:30'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 15.0,
                                  alignment: Alignment.center,
                                  width: 15.0,
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                ),
                              ),
                            ),
                            title: Text(
                              'KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            trailing: ButtonTheme(
                                minWidth: 0.0,
                                child: FlatButton(
                                  color: Colors.white,
                                  textColor: Colors.red,
                                  disabledColor: Colors.green[400],
                                  disabledTextColor: Colors.white,
                                  padding: EdgeInsets.all(15.0),
                                  splashColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.close,
                                  ),
                                  onPressed: () async {},
                                )),
                            subtitle: Text('04:00 - 04:30'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _bottomButtons(),
      ),
    );
  }

  Widget _bottomButtons() {
    return _tabController.index == 1
        ? FloatingActionButton(
            shape: StadiumBorder(),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManajemeCreateCheckin(),
                  ));
            },
            backgroundColor: Color.fromRGBO(41, 30, 47, 1),
            child: Icon(
              Icons.add,
              size: 20.0,
            ))
        : null;
  }
}
