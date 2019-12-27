import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'create_peserta.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Kelola Peserta Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }
  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Kelola Peserta Event",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyManagePeserta,
      appBar: buildBar(context),
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
                child: Text(
                  'Menunggu Konfirmasi',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ButtonTheme(
                      minWidth: 0.0,
                      child: FlatButton(
                        color: Colors.white,
                        textColor: Colors.red,
                        disabledColor: Colors.green[400],
                        disabledTextColor: Colors.white,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.blueAccent,
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () async {
                          Fluttertoast.showToast(msg:"Terima kasih telah melakukan konfirmasi");
                        },
                      )),
                      ButtonTheme(
                      minWidth: 0.0,
                      child: FlatButton(
                        color: Colors.white,
                        textColor: Colors.green,
                        disabledColor: Colors.green[400],
                        disabledTextColor: Colors.white,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.blueAccent,
                        child: Icon(
                          Icons.check,
                        ),
                        onPressed: () async {
                          Fluttertoast.showToast(msg:"Terima kasih telah melakukan konfirmasi");
                        },
                      )),
                ],
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
                child: Text(
                  'Pendaftaran Ditolak',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
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
                child: Text(
                  'Sudah Terdaftar',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w500),
                ),
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

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                // ignore: new_with_non_type
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = TextField(
                  controller: _searchQuery,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: InputBorder.none,
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Cari Peserta Berdasarkan Nama",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                );
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ],
    );
  }
}
