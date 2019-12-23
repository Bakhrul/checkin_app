import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyprovinsi;

void showInSnackBar(String value) {
  _scaffoldKeyprovinsi.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class Provinsi extends StatefulWidget {
  Provinsi({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ProvinsiState();
  }
}

class _ProvinsiState extends State<Provinsi> {
  @override
  void initState() {
    _scaffoldKeyprovinsi = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyprovinsi,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Pilih Provinsi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              tooltip: 'Cari Provinsi',
              onPressed: () {},
            ),
          ],
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),),
      body: Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Color.fromRGBO(41, 30, 47, 1),),
                  title: Text('Jawa Timur'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Color.fromRGBO(41, 30, 47, 1),),
                  title: Text('Jawa Tengah'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Color.fromRGBO(41, 30, 47, 1),),
                  title: Text('Jawa Barat'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
