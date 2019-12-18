import 'package:flutter/material.dart';
import 'dart:ui';

class CheckIn extends StatefulWidget {
  CheckIn({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _CheckInState();
  }
}

class _CheckInState extends State<CheckIn>{
   
   Widget build(BuildContext context){
     return Scaffold(
       appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Check In",
            style: TextStyle(
              color: Color(0xff25282b),
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
          backgroundColor: Colors.white
          ),
        body:
            Padding(
              padding: EdgeInsets.all(9.0),
              child:
            Column (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              Container(
                child: 
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Durasi Checkin',
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(top:8.0,bottom: 8.0),
                child: 
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code Checkinr',
                    ),
                  )
              ),
              Row(
                children: <Widget>[
                  Expanded(
                  child:
                  RaisedButton(
                    padding : EdgeInsets.all(15.0),
                    color: Colors.green,
                    textColor: Colors.white,
                    child:Text('send'),
                    onPressed:(){}
                  )
                )
              ])
            ])
        )
     );
   }
}