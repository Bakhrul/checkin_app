import 'package:checkin_app/model/search_event.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/register_event/step_register_one.dart';
import 'package:http/http.dart' as http;

class RegisterEvents extends StatefulWidget {
  final int id;

  RegisterEvents({Key key, this.id}) : super(key: key);

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
     Map<String, String> head = {'Content-Type':'application/json','Accept':'application/json','Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MWEwNGQzM2NmNzBlNWZjMDk0MGYwMTA5NTQ4ZDFlZjc1NTdjYTNkZjc2ZGE2NTk0ZDg0OTM0ZWIxZWZmOTVmODMwNDUzYWNjMDBiOWQ2In0.eyJhdWQiOiIxIiwianRpIjoiYTQxYTA0ZDMzY2Y3MGU1ZmMwOTQwZjAxMDk1NDhkMWVmNzU1N2NhM2RmNzZkYTY1OTRkODQ5MzRlYjFlZmY5NWY4MzA0NTNhY2MwMGI5ZDYiLCJpYXQiOjE1Nzc5ODE4NzEsIm5iZiI6MTU3Nzk4MTg3MSwiZXhwIjoxNjA5NjA0MjcxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.T34QK_ocXFDmQCUQhnwMshAvHKqN0a0Jr_13Q8Bv02ez4u19KVH_h6a3Bk90HnpKOJPU3AcOTsanL0H57tGKxV9rFm8nnI1oKm-ZIoASR4MT9XrWd0T2Zj09qBJQY_-pfFRqk1r8G78ic9-_NaMmUhJxua8IdzNs_0DvySm2oIofKEDN4D14IPiSEUwlEBtMHIJXo8eKtiEGMrJbXYD0-P9tJL3vdflZGFTL72OvJdRNjpVgnCQMAuSFVTAtytQDEMnIjH41rNCbw-whyaalQBVIjWIGtwIaAtOX_3b_NcaNF0j8xtRkFMR2bV3p7cLJ77oQmvTVVcguTW15b3TPLje9K0aaYgUVwRpgiGxP3ySwJXfuoarrZ_sFNTMNA0awMlTh5J3iDgfnX33SuLnDOERu3WYd0dpx6fefGbYtbz73J9l7vY2ub5KozWJ3VxpLjIq0UbPor6m_qL7knys-NMDCDfK7uM6ZiI5ioV8W8gN3BPZ2bYYN6rqWtVqKxs5mFQJpRdS11Q-J50Qyf_wTqP3aigUzOGfeqSzmKSmmUfv1CHCQ6rs_RL8UdeHhWmvxDxnMIzdwLqZoBUG5zr1IQn6IXLkp7gwKV4gHRkxOnQuYIJwNPEi1bFm8N9y-e0Kl3ymTBODo-6B9VDGR6WmI0PYlf-yq4eXnghIkEsFnG6w'};
      String id = widget.id.toString();
      var data = await http.get('http://localhost:8000/api/event/${id}',headers:head);

      if(data.statusCode == 200){
        Map rawData = json.decode(data.body);
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
                          builder: (context) => RegisterEventMethod(id:dataEvent.id),
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
