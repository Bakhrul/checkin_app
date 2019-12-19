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
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Pilih Kecamatan",
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
            tooltip: 'Cari Kecamatan',
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
                    title: Text('Sukorejo'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person_pin_circle, color: Colors.green),
                    title: Text('Pandaan'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person_pin_circle, color: Colors.green),
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

