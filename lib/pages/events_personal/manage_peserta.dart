import 'package:flutter/material.dart';
import 'dart:ui';

GlobalKey<ScaffoldState> _scaffoldKeyManagePeserta;

class ManagePeserta extends StatefulWidget {
  ManagePeserta({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManagePesertaState();
  }
}

class _ManagePesertaState extends State<ManagePeserta> {
  @override
  void initState() {
    _scaffoldKeyManagePeserta = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyManagePeserta,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Manage Peserta",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            tooltip: 'Cari Peserta',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Profil Drawer Here
            //  Menu Section Here
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    color: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil'),
              subtitle: Text('081285270793'),
            )),
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.red, //                   <--- border color
                        border: Border.all(
                      
                      width: 5.0,
                    )),
                    color: Colors.red,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil'),
              subtitle: Text('081285270793'),
            )),
          ],
        ),
      ),
    );
  }
}
