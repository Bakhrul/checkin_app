import 'package:flutter/material.dart';



GlobalKey<ScaffoldState> _scaffoldKeykabupaten;

void showInSnackBar(String value) {
  _scaffoldKeykabupaten.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class Kabupaten extends StatefulWidget {
  Kabupaten({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _KabupatenState();
  }
}

class _KabupatenState extends State<Kabupaten> {
  

  @override
  void initState() {
    _scaffoldKeykabupaten = GlobalKey<ScaffoldState>();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeykabupaten,
      appBar: new AppBar(
        
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Pilih Kabupaten",
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
            tooltip: 'Cari Kabupaten',
            onPressed: () {},
          ),
        ],
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),),
      body: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Colors.blue),
                  title: Text('Pasuruan'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Colors.blue),
                  title: Text('Surabaya'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_pin_circle, color: Colors.blue),
                  title: Text('Malang'),
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

