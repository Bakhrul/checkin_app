import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyPointPerson;

void showInSnackBar(String value) {
  _scaffoldKeyPointPerson.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class PointEvents extends StatefulWidget {
  PointEvents({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _PointEventsState();
  }
}

class _PointEventsState extends State<PointEvents> {
  @override
  void initState() {
    _scaffoldKeyPointPerson = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyPointPerson,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Points Member Events",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(
                Icons.search,
                color: Colors.white,
              ),
              tooltip: 'Cari Provinsi',
              onPressed: () {},
            ),
          ],
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Jumlah Checkin Event',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '18 Orang',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(41, 30, 47, 1),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Divider(),
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
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',
                      style: TextStyle(
                        color: Color.fromRGBO(41, 30, 47, 1),
                        fontWeight: FontWeight.w500,
                      )),
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
                          ),
                        ),
                      )),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',
                      style: TextStyle(
                        color: Color.fromRGBO(41, 30, 47, 1),
                        fontWeight: FontWeight.w500,
                      )),
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
                          ),
                        ),
                      )),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',
                      style: TextStyle(
                        color: Color.fromRGBO(41, 30, 47, 1),
                        fontWeight: FontWeight.w500,
                      )),
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
                          ),
                        ),
                      )),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',
                      style: TextStyle(
                        color: Color.fromRGBO(41, 30, 47, 1),
                        fontWeight: FontWeight.w500,
                      )),
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
                          ),
                        ),
                      )),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',
                      style: TextStyle(
                        color: Color.fromRGBO(41, 30, 47, 1),
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
