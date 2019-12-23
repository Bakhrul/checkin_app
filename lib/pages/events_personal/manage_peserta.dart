import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'create_peserta.dart';

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
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        title: Text(
          "Kelola Peserta",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
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
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
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
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
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
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
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
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManajemeCreatePeserta()));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }
}
