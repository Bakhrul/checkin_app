import 'package:flutter/material.dart';

import 'dart:ui';
import 'dart:core';
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
DateTime _date = new DateTime.now();
int _minutes = 1;
int _seconds = 0;
var _count = '00:00';
bool disable = false;

  void initState() {
    getDifTime();
        startTimer();
    super.initState();
  }

  void getDifTime(){
        DateTime _getDateExp = DateTime.parse('2019-12-19 12:00:00');
        DateTime _dateExp = _getDateExp.add(Duration(seconds:300));
        _seconds = _dateExp.difference(_date).inSeconds;
        var _time = Duration(seconds: _seconds);
        _count = _seconds < 1 ? "00:00":'${(_time.inMinutes).toString().padLeft(2,'0')}:${(_time.inSeconds % 60).toString().padLeft(2,'0')}';
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
              disable = true;
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
                    color: this.disable ? Colors.grey[400]:Colors.green,
                    textColor: Colors.white,
                    child:Text('Send'),
                    onPressed:(){
                      if(disable){
                        print('gagal absen');
                      }else{
                        print('berhasil absen');
                      }
                    }
                  )
                )
              ])
            ])
        )
     );
  }


}
