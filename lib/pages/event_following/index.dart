import 'package:checkin_app/pages/event_following/detail.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'count_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:checkin_app/pages/register_event/step_register_six.dart';
import 'package:checkin_app/pages/register_event/step_register_three.dart';
import '../events_all/detail_event.dart';
import 'package:checkin_app/pages/register_event/detail_event_afterregist.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventAll;

void showInSnackBar(String value) {
  _scaffoldKeyEventAll.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

enum PageEnum {
  kelolaCheckinPage,
  kelolaHistoryPage,
}

class ManajemenEventFollowing extends StatefulWidget {
  ManajemenEventFollowing({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventFollowingState();
  }
}

class _ManajemenEventFollowingState extends State<ManajemenEventFollowing> {
  @override
  void initState() {
    _scaffoldKeyEventAll = GlobalKey<ScaffoldState>();
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
        "Mengikuti Event",
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
    "Mengikuti Event",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.kelolaCheckinPage:
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => CountDown()));
        break;
      case PageEnum.kelolaHistoryPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) =>
                ManajemenEventDetailFollowing()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyEventAll,
      appBar: buildBar(context),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(('Cari Event Berdasarkan Kategori').toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, bottom: 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: Color.fromRGBO(41, 30, 47, 1),
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {},
                            child: Text(
                              'Semua',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {},
                            child: Text(
                              'Teknologi',
                              style: TextStyle(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {},
                            child: Text(
                              'Kesehatan',
                              style: TextStyle(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {},
                            child: Text(
                              'Financial',
                              style: TextStyle(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {},
                            child: Text(
                              'Keuangan',
                              style: TextStyle(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {},
                            child: Text(
                              'Pertambangan',
                              style: TextStyle(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                  ]),
                ),
              ),
              InkWell(
                  child: Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft: const Radius
                                                          .circular(5.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomRight: const Radius
                                                          .circular(5.0)),
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                  'images/bg-header.jpg',
                                                ),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '12 Agustus 2019',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child:
                                                    Text('Komunitas Dev Junior',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  'Lemahbang Sukorejo Pasuruan',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(5.0),
                                                topRight:
                                                    const Radius.circular(5.0),
                                                bottomLeft:
                                                    const Radius.circular(5.0),
                                                bottomRight:
                                                    const Radius.circular(5.0)),
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          width: 120.0,
                                          child: Text(
                                            'Proses Daftar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: ButtonTheme(
                                          minWidth: 0, //wraps child's width
                                          height: 0,
                                          child: FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.pink,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                            color: Colors.white,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            padding: EdgeInsets.all(0),
                                            onPressed: () async {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingEvent(),
                        ));
                  }),
              InkWell(
                  child: Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft: const Radius
                                                          .circular(5.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomRight: const Radius
                                                          .circular(5.0)),
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                  'images/bg-header.jpg',
                                                ),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '12 Agustus 2019',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child:
                                                    Text('Komunitas Dev Junior',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  'Lemahbang Sukorejo Pasuruan',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(5.0),
                                                topRight:
                                                    const Radius.circular(5.0),
                                                bottomLeft:
                                                    const Radius.circular(5.0),
                                                bottomRight:
                                                    const Radius.circular(5.0)),
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          width: 120.0,
                                          child: Text(
                                            'Belum Terdaftar',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: ButtonTheme(
                                          minWidth: 0, //wraps child's width
                                          height: 0,
                                          child: FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.pink,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                            color: Colors.white,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            padding: EdgeInsets.all(0),
                                            onPressed: () async {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterEvents(),
                        ));
                  }),
              InkWell(
                  child: Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft: const Radius
                                                          .circular(5.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomRight: const Radius
                                                          .circular(5.0)),
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                  'images/bg-header.jpg',
                                                ),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '12 Agustus 2019',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child:
                                                    Text('Komunitas Dev Junior',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  'Lemahbang Sukorejo Pasuruan',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(5.0),
                                                topRight:
                                                    const Radius.circular(5.0),
                                                bottomLeft:
                                                    const Radius.circular(5.0),
                                                bottomRight:
                                                    const Radius.circular(5.0)),
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          width: 120.0,
                                          child: Text(
                                            'Sudah Terdaftar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: ButtonTheme(
                                          minWidth: 0, //wraps child's width
                                          height: 0,
                                          child: FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.pink,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                            color: Colors.white,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            padding: EdgeInsets.all(0),
                                            onPressed: () async {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuccesRegisteredEvent(),
                        ));
                  }),
              InkWell(
                  child: Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft: const Radius
                                                          .circular(5.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              5.0),
                                                      bottomRight: const Radius
                                                          .circular(5.0)),
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                  'images/bg-header.jpg',
                                                ),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '12 Agustus 2019',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child:
                                                    Text('Komunitas Dev Junior',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  'Lemahbang Sukorejo Pasuruan',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(5.0),
                                                topRight:
                                                    const Radius.circular(5.0),
                                                bottomLeft:
                                                    const Radius.circular(5.0),
                                                bottomRight:
                                                    const Radius.circular(5.0)),
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          width: 120.0,
                                          child: Text(
                                            'Event Selesai',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: ButtonTheme(
                                          minWidth: 0, //wraps child's width
                                          height: 0,
                                          child: FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.pink,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                            color: Colors.white,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            padding: EdgeInsets.all(0),
                                            onPressed: () async {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AfterRegisterEvents(),
                        ));
                  }),
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
                      hintText: "Cari Berdasarkan Nama, Kategori , Tempat",
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
