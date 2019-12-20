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
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Points Member Events",
            style: TextStyle(
              color: Color(0xff25282b),
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(
                Icons.search,
                color: Colors.black,
              ),
              tooltip: 'Cari Provinsi',
              onPressed: () {
              },
            ),
          ],
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Jumlah Checkin Event',style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('18 Orang',style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              Divider(),
              Card(
                child: ListTile(
                  leading: Image.asset('images/noimage.jpg',width: 60.0,height: 60.0,),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset('images/noimage.jpg',width: 60.0,height: 60.0,),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset('images/noimage.jpg',width: 60.0,height: 60.0,),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset('images/noimage.jpg',width: 60.0,height: 60.0,),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset('images/noimage.jpg',width: 60.0,height: 60.0,),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset('images/noimage.jpg',width: 60.0,height: 60.0,),
                  title: Text('Muhammad Bakhrul Bila Sakhil'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text('7 / 10 Total Absen'),
                  ),
                  trailing: Text('87%',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,)),
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
