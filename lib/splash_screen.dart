
import 'package:flutter/material.dart';

import 'dart:async';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<Null> getSharedPrefs() async {
      Timer(Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, "/dashboard"));
  }

  @override
  void initState() {
    // initPlatformState();
    
    getSharedPrefs();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Text(
                      "MOCIN",
                      style: TextStyle(
                          color: Color.fromRGBO(41, 30, 47, 1),
                          fontFamily: 'TitilliumWeb',
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
