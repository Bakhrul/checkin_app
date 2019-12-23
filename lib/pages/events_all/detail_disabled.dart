import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventDetail;

void showInSnackBar(String value) {
  _scaffoldKeyEventDetail.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEventDetailDisabled extends StatefulWidget {
  ManajemenEventDetailDisabled({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventDetailDisabledState();
  }
}

class _ManajemenEventDetailDisabledState extends State<ManajemenEventDetailDisabled> {
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
      appBar: new AppBar(
        
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        title: new Text(
          "Detail Event",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
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
                                'images/imgavatar.png',
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
                                  5.0, // has the effect of extending the shadow
                              offset: Offset(
                                1.0, // horizontal, move right 10
                                -7.0, // vertical, move down 10
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
                              right: 15.0, left: 15.0, top: 20.0),
                          child: Text(
                            'Meetup Flutter #2',
                            style: TextStyle(
                                color: Colors.blue,
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
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
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
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 15.0,
                      left: 15.0,
                    ),
                    child: Text(
                      'Tentang Event',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 2,
                        )),
                  ),
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: double.infinity,
                      // height: double.infinity,
                      child: RaisedButton(
                        onPressed: null,
                        color: Colors.lightBlueAccent,
                        child: const Text(
                          "Registered",
                          style: TextStyle(fontSize: 20),
                        ),
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
