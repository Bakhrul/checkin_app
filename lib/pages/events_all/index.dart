import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventAll;

void showInSnackBar(String value) {
  _scaffoldKeyEventAll.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEvent extends StatefulWidget {
  ManajemenEvent({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventState();
  }
}

class _ManajemenEventState extends State<ManajemenEvent> {
  @override
  void initState() {
    _scaffoldKeyEventAll = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyEventAll,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Semua Event",
            style: TextStyle(
              color: Color(0xff25282b),
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              tooltip: 'Notifikasi',
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top:10.0,bottom: 10.0,right: 5.0,left: 5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Image.asset("images/noimage.jpg",width: 50.0,height: 50.0,),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Text('Nama Event',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    100.0),
                                                topRight: const Radius.circular(
                                                    100.0),
                                                bottomLeft:
                                                    const Radius.circular(
                                                        100.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        100.0))),
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            Container(
                              child: Text(
                                'Sukorejo Pasuruan Jawa Timur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Category : Technology',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Text(
                                '12 hari lagi',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("tapped on container");
                },
              ),
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Image.asset("images/noimage.jpg",width: 50.0,height: 50.0,),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Text('Nama Events',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    100.0),
                                                topRight: const Radius.circular(
                                                    100.0),
                                                bottomLeft:
                                                    const Radius.circular(
                                                        100.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        100.0))),
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            Container(
                              child: Text(
                                'Sukorejo Pasuruan Jawa Timur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Category : Technology',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Text(
                                '12 hari lagi',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("tapped on container");
                },
              ),
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Image.asset("images/noimage.jpg",width: 50.0,height: 50.0,),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text('Nama Event',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    100.0),
                                                topRight: const Radius.circular(
                                                    100.0),
                                                bottomLeft:
                                                    const Radius.circular(
                                                        100.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        100.0))),
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            Container(
                              child: Text(
                                'Sukorejo Pasuruan Jawa Timur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Category : Technology',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Text(
                                'Event berlangsung hari ini',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("tapped on container");
                },
              ),
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Image.asset("images/noimage.jpg",width: 50.0,height: 50.0,),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text('Nama Event',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    100.0),
                                                topRight: const Radius.circular(
                                                    100.0),
                                                bottomLeft:
                                                    const Radius.circular(
                                                        100.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        100.0))),
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            Container(
                              child: Text(
                                'Sukorejo Pasuruan Jawa Timur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Category : Technology',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Text(
                                '12 hari yang lalu',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("tapped on container");
                },
              ),
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Image.asset("images/noimage.jpg",width: 50.0,height: 50.0,),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text('Nama Event',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    100.0),
                                                topRight: const Radius.circular(
                                                    100.0),
                                                bottomLeft:
                                                    const Radius.circular(
                                                        100.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        100.0))),
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            Container(
                              child: Text(
                                'Sukorejo Pasuruan Jawa Timur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Category : Technology',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Text(
                                '12 hari lagi',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("tapped on container");
                },
              ),
              InkWell(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Image.asset("images/noimage.jpg",width: 50.0,height: 50.0,),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text('Nama Event',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    100.0),
                                                topRight: const Radius.circular(
                                                    100.0),
                                                bottomLeft:
                                                    const Radius.circular(
                                                        100.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        100.0))),
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            Container(
                              child: Text(
                                'Sukorejo Pasuruan Jawa Timur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Category : Technology',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Text(
                                '12 hari lagi',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("tapped on container");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
