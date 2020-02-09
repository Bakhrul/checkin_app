import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:checkin_app/dashboard.dart';

class SuccesRegisteredCheckin extends StatefulWidget {
  SuccesRegisteredCheckin({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return _SuccesRegisteredCheckinState();
  }
}

class _SuccesRegisteredCheckinState extends State<SuccesRegisteredCheckin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Berhasil Melakukan Checkin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: primaryAppBarColor,
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                    child: Center(
                        child: Image.asset("images/checked.png",
                            height: 150.0, width: 150.0))),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text("Terima kasih Telah Melakukan Checkin!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                        "Pastikan Anda Tetap Konsisten Checkin Pada Tiap Sesi Event ",
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.5, fontSize: 14))),
                Container(
                    padding: EdgeInsets.all(20.0),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                                padding: EdgeInsets.all(15.0),
                                color: Colors.indigo,
                                child: Text("Kembali Ke Beranda",
                                    style: TextStyle(color: Colors.white,fontSize: 14)),
                                onPressed: () async {
                                  Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Dashboard(),
                                                  ));
                                })),
                      ],
                    ))
              ],
            )
          ],
        )));
  }
}
