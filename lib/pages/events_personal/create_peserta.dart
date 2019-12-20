import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreatepeserta;
var datepicker;
String sifat = 'Regular';
bool monVal = false;
bool monVal2 = false;
bool monVal3 = false;
bool monVal4 = false;

void showInSnackBar(String value) {
  _scaffoldKeycreatepeserta.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeCreatePeserta extends StatefulWidget {
  ManajemeCreatePeserta({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreatePesertaState();
  }
}

class _ManajemeCreatePesertaState extends State<ManajemeCreatePeserta> {
  @override
  void initState() {
    _scaffoldKeycreatepeserta = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1.0),
      key: _scaffoldKeycreatepeserta,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Tambah Peserta Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 5.0, left: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                leading: Icon(Icons.category, color: Colors.blue),
                title: DropdownButton<String>(
                  isExpanded: true,
                  value: sifat,
                  elevation: 16,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      sifat = newValue;
                    });
                  },
                  items: <String>[
                    'VIP',
                    'Gold',
                    'Silver',
                    'Regular',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
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
                        color: Colors.blue,
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
                trailing: Checkbox(
                  value: monVal,
                  onChanged: (bool value) {
                    setState(() {
                      monVal = value;
                    });
                  },
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
                title: Text('Muhammad Bakhrul Bila Sakhil'),
                subtitle: Text('081285270793'),
                trailing: Checkbox(
                  value: monVal2,
                  onChanged: (bool value) {
                    setState(() {
                      monVal2 = value;
                    });
                  },
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
                title: Text('Muhammad Bakhrul Bila Sakhil'),
                subtitle: Text('081285270793'),
                trailing: Checkbox(
                  value: monVal3,
                  onChanged: (bool value) {
                    setState(() {
                      monVal3 = value;
                    });
                  },
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
                title: Text('Muhammad Bakhrul Bila Sakhil'),
                subtitle: Text('081285270793'),
                trailing: Checkbox(
                  value: monVal4,
                  onChanged: (bool value) {
                    setState(() {
                      monVal4 = value;
                    });
                  },
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
