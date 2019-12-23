import 'package:flutter/material.dart';



GlobalKey<ScaffoldState> _scaffoldKeykecamatan;

void showInSnackBar(String value) {
  _scaffoldKeykecamatan.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class Kecamatan extends StatefulWidget {
  Kecamatan({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _KecamatanState();
  }
}

class _KecamatanState extends State<Kecamatan> {
  

  @override
  void initState() {
    _scaffoldKeykecamatan = GlobalKey<ScaffoldState>();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeykecamatan,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Pilih Kecamatan",
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
            tooltip: 'Cari Kecamatan',
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
                    title: Text('Sukorejo'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person_pin_circle, color: Color.fromRGBO(41, 30, 47, 1),),
                    title: Text('Pandaan'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person_pin_circle, color: Color.fromRGBO(41, 30, 47, 1),),
                    title: Text('Purwosari'),
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

