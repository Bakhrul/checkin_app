import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventDetail;

void showInSnackBar(String value) {
  _scaffoldKeyEventDetail.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEventDetail extends StatefulWidget {
  ManajemenEventDetail({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventDetailState();
  }
}

class _ManajemenEventDetailState extends State<ManajemenEventDetail> {
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
                    color: Colors.lightBlue[100],
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
                    color: Colors.lightBlue[100],
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
                    color: Colors.lightBlue[100],
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
                    // margin: EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                     child: Column(
          children: <Widget>[
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
                          color: Color.fromRGBO(0, 204, 65, 1.0), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Color.fromRGBO(153, 255, 185, 1.0),
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(0, 204, 65, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
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
                          color: Color.fromRGBO(204, 204, 204, 1.0),
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(204, 204, 204, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
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
                          color: Color.fromRGBO(0, 204, 65, 1.0), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Color.fromRGBO(153, 255, 185, 1.0),
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(0, 204, 65, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
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
                          color: Color.fromRGBO(0, 204, 65, 1.0), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Color.fromRGBO(153, 255, 185, 1.0),
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(0, 204, 65, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
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
                          color: Color.fromRGBO(204, 204, 204, 1.0),
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(204, 204, 204, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
            Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(217, 217, 217, 1.0), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(
                        10.0) //                 <--- border radius here
                    ),
                color: Color.fromRGBO(242, 242, 242, 1.0),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Indikator Absensi Peserta Event',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 8.0,
                      animation: true,
                      percent: 0.7,
                      center: new Text(
                        "70.0%",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.purple,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              margin: EdgeInsets.only(right: 3.0),
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.purple,
                                    width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        100.0) //                 <--- border radius here
                                    ),
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text('180 Peserta'),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              margin: EdgeInsets.only(right: 3.0),
                              height: 15.0,
                              alignment: Alignment.center,
                              width: 15.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                        100.0) //                 <--- border radius here
                                    ),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text('25 Peserta'),
                          ),
                        ],
                      ))
                ],
              ),
            ),
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
