import 'package:checkin_app/model/search_event.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/register_event/step_register_one.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';


String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class RegisterEvents extends StatefulWidget {
  final int id;
  final bool selfEvent;
  final String creatorId;

  RegisterEvents({Key key, this.id, this.creatorId, this.selfEvent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterEvent();
  }
}

class _RegisterEvent extends State<RegisterEvents> {

  SearchEvent searchEvent = new SearchEvent();
  SearchEvent dataEvent;
  bool _isLoading = true;

  @override
  void initState(){
    _getAll();
    super.initState();
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

    final ongoingevent = await http.get(
        url('api/event/${id}'),
        headers: requestHeaders,
      );

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);
        setState((){
           dataEvent = SearchEvent.fromJson(rawData['data']);
           _isLoading = false;
        });
      }else{
        print('ok');
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
      body: _isLoading ? 
              Center(
                  child:CircularProgressIndicator()
              ):SingleChildScrollView(
          child:Column(children: <Widget>[
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
                        child: Text(dataEvent.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        width: double.infinity,
                        child: Row(children: <Widget>[
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey[500]),
                          Text(dataEvent.location,
                              style: TextStyle(color: Colors.grey[500]))
                        ])),
                    Container(
                        padding: EdgeInsets.only(bottom: 25.0),
                        width: double.infinity,
                        child: Row(children: <Widget>[
                          Icon(Icons.date_range,
                              size: 16, color: Colors.grey[500]),
                          Text(dataEvent.start+' - '+dataEvent.end,
                              style: TextStyle(color: Colors.grey[500]))
                        ])),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                            dataEvent.detail,
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
                    if(!widget.selfEvent)
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
                            Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterEventMethod(id:dataEvent.id,creatorId:widget.creatorId),
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
                    child:Text(dataEvent.start,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  ),
                  Container(
                    margin:EdgeInsets.only(left:10),
                    child:Text(dataEvent.hour, style: TextStyle(color: Colors.white))
                  )
                ])),
               )
              ]
             ),
      ])),
    );
  }
}
