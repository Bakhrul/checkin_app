import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventDetail;

void showInSnackBar(String value) {
  _scaffoldKeyEventDetail.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEventDetailFollowing extends StatefulWidget {
  ManajemenEventDetailFollowing({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventDetailFollowingState();
  }
}

class _ManajemenEventDetailFollowingState
    extends State<ManajemenEventDetailFollowing> {
  @override
  void initState() {
    _scaffoldKeyEventDetail = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyEventDetail,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryAppBarColor,
        title: Text(
          "Detail History Event",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            tooltip: 'Notifikasi',
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 1.0),
                          width: 350.0,
                          height: 200.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/noimage.jpg',
                              ),
                            ),
                          )),
                      new Container(
                        height: 20.0,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        // margin: new EdgeInsets.all(0.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius:
                                  1.0, // has the effect of softening the shadow
                              spreadRadius:
                                  1.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                -10.0, // vertical, move down 10
                              ),
                            )
                          ],
                          // borderRadius: new BorderRadius.all(...),
                          // gradient: new LinearGradient(...),
                        ),
                        // child: new Container(
                        //   child: Column(children: <Widget>[

                        //   ],),

                        // ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              right: 15.0, left: 15.0, top: 5.0),
                          child: Text(
                            'Meetup Flutter #2',
                            style: TextStyle(
                                color: Color.fromRGBO(41, 30, 47, 1),
                                fontFamily: 'RobotoMono',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: Text(
                          'By : Komunitas Alam Raya',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.lightBlue[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.date_range),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 1.0, 0.0, 4.0),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment
                                    .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                                child: Text(
                                  "Sunday,29 December 19",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Align(
                                alignment: Alignment
                                    .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                                child: Text("18 : 00 - 18 : 30"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.lightBlue[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.place),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 4.0),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment
                                    .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                                child: Text(
                                  "Dilo Surabaya",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Align(
                                alignment: Alignment
                                    .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                                child: Text(
                                    "Kompleks AJBS, Jl. Ratna No.14, Ngagel, Kec. Wonokromo"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.lightBlue[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.attach_money),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 4.0),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment
                                    .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                                child: Text(
                                  "Free",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),

                              // Text("Kompleks AJBS, Jl. Ratna No.14, Ngagel, Kec. Wonokromo"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       top: 10.0,
                //       right: 15.0,
                //       left: 15.0,
                //     ),
                //     child: Text(
                //       'Tentang Event',
                //       style: TextStyle(fontSize: 20),
                //     ),
                //   ),
                // ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(15.0),
                //     child: Text(
                //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           height: 2,
                //         )),
                //   ),
                // ),
                Divider(),
                Container(
                    margin: EdgeInsets.only(top: 2.0),
                    child: SizedBox(
                      width: double.infinity,
                      //height: 40,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("History Absensi",
                                style: TextStyle(fontSize: 20.0)),
                          ),
                          Divider(),
                          Card(
                              child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(0, 204, 65, 1.0),
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            100.0) //                 <--- border radius here
                                        ),
                                    color: Color.fromRGBO(153, 255, 185, 1.0),
                                  ),
                                  child: Icon(Icons.check,
                                      color: Color.fromRGBO(0, 204, 65, 1.0)),
                                ),
                              ),
                            ),
                            title: Text(
                              '12 September 2019 - KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('12 September 2019'),
                            ),
                          )),
                          Card(
                              child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(204, 204, 204, 1.0),
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            100.0) //                 <--- border radius here
                                        ),
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.check,
                                      color:
                                          Color.fromRGBO(204, 204, 204, 1.0)),
                                ),
                              ),
                            ),
                            title: Text(
                              '12 September 2019 - KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('12 September 2019'),
                            ),
                          )),
                          Card(
                              child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(0, 204, 65, 1.0),
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            100.0) //                 <--- border radius here
                                        ),
                                    color: Color.fromRGBO(153, 255, 185, 1.0),
                                  ),
                                  child: Icon(Icons.check,
                                      color: Color.fromRGBO(0, 204, 65, 1.0)),
                                ),
                              ),
                            ),
                            title: Text(
                              '12 September 2019 - KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('12 September 2019'),
                            ),
                          )),
                          Card(
                              child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(0, 204, 65, 1.0),
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            100.0) //                 <--- border radius here
                                        ),
                                    color: Color.fromRGBO(153, 255, 185, 1.0),
                                  ),
                                  child: Icon(Icons.check,
                                      color: Color.fromRGBO(0, 204, 65, 1.0)),
                                ),
                              ),
                            ),
                            title: Text(
                              '12 September 2019 - KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('12 September 2019'),
                            ),
                          )),
                          Card(
                              child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(204, 204, 204, 1.0),
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            100.0) //                 <--- border radius here
                                        ),
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.check,
                                      color:
                                          Color.fromRGBO(204, 204, 204, 1.0)),
                                ),
                              ),
                            ),
                            title: Text(
                              '12 September 2019 - KODECHECKIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('12 September 2019'),
                            ),
                          )),
                        ],
                      ),
                    )),
                // Container(
                //   child: Text('Jl Lemahbang Kecamatan Sukorejo Pasuruan'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
