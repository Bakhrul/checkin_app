import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class CountDown extends StatefulWidget{
  CountDown({Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _CountDown();
  }
}

class _CountDown extends State<CountDown>{

Timer _timer;
int _minutes = 2;
int _seconds = 0;
var _count = '00:00';
bool disable;

void initState() {
        _seconds = _minutes * 60;
        var _time = Duration(seconds: _seconds);
        _count = '${(_time.inMinutes).toString().padLeft(2,'0')}:${(_time.inSeconds % 60).toString().padLeft(2,'0')}';
        startTimer();
    super.initState();
  }

void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
    if (this.mounted) {
        return setState(
          () {
            if (_seconds < 1) {
              timer.cancel();
            } else {
              _seconds -= 1;
              var _time = Duration(seconds: _seconds);
              
              _count = '${(_time.inMinutes).toString().padLeft(2,'0')}:${(_time.inSeconds % 60).toString().padLeft(2,'0')}';
            }
          },
        );
      }
    }
  );
}

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              Container(
                padding: EdgeInsets.only(top:50,bottom:50),
                child: Text(this._count,style: TextStyle(fontSize: 70))
              ),
              Container(
                margin: EdgeInsets.only(top:8.0,bottom: 8.0),
                child: 
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code Checkin',
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
                    child:Text('Send'),
                    onPressed:(){}
                  )
                )
              ])
            ])
        )
     );
  }


}