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
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Pilih Provinsi",
            style: TextStyle(
              color: Color(0xff25282b),
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              tooltip: 'Cari Provinsi',
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Colors.green),
                  title: Text('Jawa Timur'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Colors.green),
                  title: Text('Jawa Tengah'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Colors.green),
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
