import 'dart:io';

import 'package:checkin_app/model/search_event.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:checkin_app/pages/register_event/step_register_one.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/profile/profile_organizer.dart';
import 'package:checkin_app/storage/storage.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class RegisterEvents extends StatefulWidget {
  final int id;
  final bool selfEvent;
  final String creatorId;
  final Map dataUser;

  RegisterEvents(
      {Key key, this.id, this.creatorId, this.selfEvent, this.dataUser})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterEvent();
  }
}

class _RegisterEvent extends State<RegisterEvents> {
  SearchEvent searchEvent = new SearchEvent();
  SearchEvent dataEvent;
  bool _isLoading = true;
  String creatorEmail;
  String creatorName;
  bool _isDisconnect = false;
  ScrollController scrollPage = new ScrollController();
  double offset = 0; //12.5
  bool expired;

  @override
  void initState() {
    _getAll();
    scrollPage.addListener(_parallax);
    super.initState();
  }

  _parallax() {
    if (scrollPage.position.userScrollDirection == ScrollDirection.reverse) {
      setState(() {
        offset = scrollPage.position.pixels;
      });
    } else {
      setState(() {
        offset = scrollPage.position.pixels;
      });
    }
  }

  _reload() {
    setState(() {
      _isDisconnect = false;
      _isLoading = true;
    });

    _getAll();
  }

  _getAll() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    String id = widget.id.toString();

    try {
      final ongoingevent = await http.get(
        url('api/event/${id}'),
        headers: requestHeaders,
      );

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);
        setState((){
           dataEvent = SearchEvent.fromJson(rawData['data']);
           _isLoading = false;
           expired = dataEvent.expired;
           creatorEmail = rawData['creator_email'];
           creatorName = rawData['creator_name'];
        });
      } else {
        print('ok');
      }
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
        _isDisconnect = true;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isDisconnect
              ? Center(
                  child: GestureDetector(
                      onTap: _reload,
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.refresh,
                              color: Colors.blueAccent, size: 25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]))))
              : SingleChildScrollView(
                  controller: scrollPage,
                  child: Column(children: <Widget>[
                    Stack(children: <Widget>[
                      Column(
                        children: <Widget>[
                          //  Container(
                          //           width: double.infinity,
                          //           height: 200.0,
                          //           decoration: new BoxDecoration(
                          //             shape: BoxShape.rectangle,
                          //             image: new DecorationImage(
                          //               fit: BoxFit.fill,
                          //               image: AssetImage(
                          //                 'images/noimage.jpg',
                          //               ),
                          //             ),
                          //           )
                          //         ),

                          ClipRect(
                              child: Container(
                                  height: 300.0,
                                  padding: EdgeInsets.only(top: offset),
                                  child: Image.asset(
                                    'images/noimage.jpg',
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.none,
                                    alignment: Alignment.topCenter,
                                  ))),
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        width: double.infinity,
                                        child: Text(dataEvent.title == null ? 'Memuat..':dataEvent.title ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        width: double.infinity,
                                        child: Row(children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.location_on,
                                                size: 16,
                                                color: Colors.grey[600]),
                                          ),
                                          Text(dataEvent.location == null ? 'Memuat ...':dataEvent.location,
                                              style: TextStyle(
                                                  color: Colors.grey[600]))
                                        ])),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        width: double.infinity,
                                        child: Row(children: <Widget>[
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(Icons.date_range,
                                                  size: 16,
                                                  color: Colors.grey[600])),
                                          Text(dataEvent.start == null ? "Memuat ...":
                                              dataEvent.start +
                                                  ' - ' +
                                                  dataEvent.end,
                                              style: TextStyle(
                                                  color: Colors.grey[600]))
                                        ])),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 25.0),
                                        width: double.infinity,
                                        child: Row(children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.access_time,
                                                size: 16,
                                                color: Colors.grey[600]),
                                          ),
                                          Text(dataEvent.hour == null ? 'Memuat ...':dataEvent.hour,
                                              style: TextStyle(
                                                  color: Colors.grey[600]))
                                        ])),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Text(dataEvent.detail,
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                height: 1.5))),
                                    Container(
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        child: Text("Posted By",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileOrganizer(iduser : widget.creatorId),
                                            ));
                                      },
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 20.0, right: 5.0),
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
                                                margin: EdgeInsets.only(
                                                    bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(creatorName,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                    Text(creatorEmail,
                                                        textAlign:
                                                            TextAlign.left)
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (!widget.selfEvent)
                                       if(expired == false)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: RaisedButton(
                                            color:
                                                Color.fromRGBO(41, 30, 47, 1),
                                            textColor: Colors.white,
                                            disabledColor: Colors.green[400],
                                            disabledTextColor: Colors.white,
                                            padding: EdgeInsets.all(15.0),
                                            splashColor: Colors.blueAccent,
                                            onPressed: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterEventMethod(
                                                            id: dataEvent.id,
                                                            creatorId: widget
                                                                .creatorId,
                                                            dataUser: widget
                                                                .dataUser),
                                                  ));
                                            },
                                            child: Text(
                                              "Daftar Sekarang",
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ]))
                        ],
                      ),
                      // Positioned(
                      //   top: 180.0,
                      //   right:0.0,
                      //   child: Container(
                      //       width: 140.0,
                      //       padding: EdgeInsets.only(
                      //           top: 10.0, bottom: 10.0, left: 30.0, right: 20.0),
                      //       decoration: BoxDecoration(
                      //         color: Color.fromRGBO(41, 30, 47, 1),
                      //         borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(12),
                      //             bottomLeft: Radius.circular(12)),
                      //       ),
                      //       child: Row(children: <Widget>[
                      //         Container(
                      //           child:Text(dataEvent.start,
                      //             style: TextStyle(
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.white)),
                      //         ),
                      //         Container(
                      //           margin:EdgeInsets.only(left:10),
                      //           child:Text(dataEvent.hour, style: TextStyle(color: Colors.white))
                      //         )
                      //       ])),
                      //      )
                    ]),
                  ])),
    );
  }
}
