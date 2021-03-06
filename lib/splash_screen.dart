import 'package:flutter/material.dart';
import 'storage/storage.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Null> getSharedPrefs() async {
    String _status;
    DataStore dataStore = new DataStore();
    _status = await dataStore.getDataString("name");

    if (_status == "Tidak ditemukan") {
      Timer(Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, "/login"));
    } else{
      Timer(Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, "/dashboard"));
    }
  }

  @override
  void initState() {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200.0,
                height: 80.0,
                child: Image.asset("images/logo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  'Kelola Event Anda Sekarang Juga',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Version : 1.0',style: TextStyle(color:Colors.black54),),
                ),
              ],
            )),
      ),
    );
  }
}
