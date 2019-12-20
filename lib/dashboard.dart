import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:ui';
import 'pages/events_personal/point_person.dart';

GlobalKey<ScaffoldState> _scaffoldKeyDashboard;

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    _scaffoldKeyDashboard = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyDashboard,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Dashboard",
          style: prefix0.TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            tooltip: 'Notifikasi',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Profil Drawer Here
            UserAccountsDrawerHeader(
              accountName: Text("Muhammad Bakhrul Bila Sakhil"),
              accountEmail: Text("bakhrulrpl@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
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
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Color(0xff25282b),
                        ),
                      ),
                      onTap: () {},
                    ),
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
                        'Mengikuti Event',
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
      body: SingleChildScrollView(

        child:
        Column(
          children: <Widget>[
            FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed:(){
                Navigator.pushNamed(context, "/count_down");
          },
          child:Text('Check in peserta')
          ),
           FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed:(){
                Navigator.pushNamed(context, "/check_in");
          },
          child:Text('Buat Code Check In')
          ),
          FlatButton(
              child: Text('Testing'),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PointEvents(),
                    ));
              },
            ),
        ]),
      ),
    );
  }
}
