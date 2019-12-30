import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyListCheckin;
void showInSnackBar(String value) {
  _scaffoldKeyListCheckin.currentState.showSnackBar(new SnackBar(
    content: new Text(value),
  ));
}

class ListPesertaCheckin extends StatefulWidget {
  @override
  _ListPesertaCheckinState createState() => _ListPesertaCheckinState();
}

class _ListPesertaCheckinState extends State<ListPesertaCheckin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _scaffoldKeyListCheckin = GlobalKey<ScaffoldState>();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyListCheckin,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "List User Checkin",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
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
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                    hintText: " Berdasarkan Nama Lengkap",
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
                          ))),
                ),
                trailing: Text(
                  "14:00:10",
                  style: TextStyle(color: Colors.grey),
                ),
                title: Text('Peserta Satu'),
                subtitle: Text('09900898'),
              ),
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
                          ))),
                ),
                trailing: Text(
                  "15:00:10",
                  style: TextStyle(color: Colors.grey),
                ),
                title: Text('Peserta dua'),
                subtitle: Text('09900898'),
              ),
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
                          ))),
                ),
                trailing: Text(
                  "15:01:10",
                  style: TextStyle(color: Colors.grey),
                ),
                title: Text('Peserta tiga'),
                subtitle: Text('09900898'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
