import 'package:flutter/material.dart';
import 'create.dart';
import 'manage_peserta.dart';

GlobalKey<ScaffoldState> _scaffoldKeypersonalevent;

void showInSnackBar(String value) {
  _scaffoldKeypersonalevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEventPersonal extends StatefulWidget {
  ManajemenEventPersonal({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventPersonalState();
  }
}

class _ManajemenEventPersonalState extends State<ManajemenEventPersonal> {
  @override
  void initState() {
    _scaffoldKeypersonalevent = new GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeypersonalevent,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Event yang anda buat",
            style: TextStyle(
              color: Color(0xff25282b),
              fontSize: 14,
            ),
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'Jumlah event yang dibuat',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('16 Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 15),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'Jumlah event sudah diselenggarakan',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('16 Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 15),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'Jumlah event yang dibatalkan',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('16 Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 15),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 0.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Daftar Event',
                      style: TextStyle(fontSize: 16),
                    ),
                    ButtonTheme(
                      minWidth: 0, //wraps child's width
                      height: 0,
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 16,
                            ),
                            Text('Buat Event',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        color: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManajemeCreateEvent(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  "images/noimage.jpg",
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text('Nama Event',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Lihat Detail"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Edit Event"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Tambahkan Asistan"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Batalkan Event"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 5.0),
                                    child: Text(
                                      '12 hari lagi',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Image.asset(
                                "images/noimage.jpg",
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text('Nama Event',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Lihat Detail"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 5.0),
                                    child: Text(
                                      'Sudah Berakhir',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Image.asset(
                                "images/noimage.jpg",
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text('Nama Event',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Lihat Detail"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Edit Event"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Tambahkan Asistan"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Batalkan Event"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 5.0),
                                    child: Text(
                                      'Berlangsung hari ini',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Image.asset(
                                "images/noimage.jpg",
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text('Nama Event',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Lihat Detail"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Edit Event"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Tambahkan Asistan"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Batalkan Event"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 5.0),
                                    child: Text(
                                      '12 hari lagi',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Image.asset(
                                "images/noimage.jpg",
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text('Nama Event',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Lihat Detail"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Edit Event"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Tambahkan Asistan"),
                                            ),
                                            PopupMenuItem(
                                              child: Text("Batalkan Event"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 5.0),
                                    child: Text(
                                      'Sudah Berakhir',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(15.0),
            splashColor: Colors.blueAccent,
            onPressed: () async {
              Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManagePeserta()));
            },
            child: Text(
              "Lihat Semua Event",
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }
}
