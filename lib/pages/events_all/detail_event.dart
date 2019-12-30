import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/register_event/step_register_one.dart';

class RegisterEvents extends StatefulWidget {
  RegisterEvents({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterEvent();
  }
}

class _RegisterEvent extends State<RegisterEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Detail Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Stack(children: <Widget>[
          Column(
               children: <Widget>[
                 Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'images/noimage.jpg',
                              ),
                            ),
                          )
                        ),
             Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        width: double.infinity,
                        child: Text("Komunitas Dev Junior",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        width: double.infinity,
                        child: Row(children: <Widget>[
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey[500]),
                          Text("Rungkut Industri,Surabaya",
                              style: TextStyle(color: Colors.grey[500]))
                        ])),
                    Container(
                        padding: EdgeInsets.only(bottom: 25.0),
                        width: double.infinity,
                        child: Row(children: <Widget>[
                          Icon(Icons.date_range,
                              size: 16, color: Colors.grey[500]),
                          Text("12/31/2019 - 01/01/2019",
                              style: TextStyle(color: Colors.grey[500]))
                        ])),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate ",
                            style: TextStyle(
                                color: Colors.grey[700], height: 1.5))),
                    Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text("Posted By",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0, right: 5.0),
                            width: 30.0,
                            height: 30.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  'images/imgavatar.png',
                                ),
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('muhammad bahkrul',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('089-123456789', textAlign: TextAlign.left)
                              ],
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Color.fromRGBO(41, 30, 47, 1),
                          textColor: Colors.white,
                          disabledColor: Colors.green[400],
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () async {
                            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterEventMethod(),
                        ));
                          },
                          child: Text(
                            "Daftar Sekarang",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ]
                )
              )
               ],
             ),
          Positioned(
            top: 180.0,
            right:0.0,
            child: Container(
                width: 140.0,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 30.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(41, 30, 47, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12)),
                ),
                child: Row(children: <Widget>[
                  Container(
                    child:Text('12 Dec',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  ),
                  Container(
                    margin:EdgeInsets.only(left:10),
                    child:Text('12:00', style: TextStyle(color: Colors.white))
                  )
                ])),
               )
              ]
             ),
      ])),
    );
  }
}
