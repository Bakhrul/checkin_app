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
  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Kelola Hasil Absen Peserta",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }

  final TextEditingController _searchQuery = new TextEditingController();

  
  Widget appBarTitle = Text("Kelola Hasil Absen Peserta",style: TextStyle(fontSize: 16),);
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyPointPerson,
      appBar: buildBar(context),
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
  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor:Color.fromRGBO(41, 30, 47, 1),
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
                      hintText: "Cari Berdasarkan Nama",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 14,)),
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
