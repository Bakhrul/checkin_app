import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'detail_event_afterregist.dart';

class SuccesRegisteredEvent extends StatefulWidget {
  SuccesRegisteredEvent({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return _SuccesRegisteredEvent();
  }
}

class _SuccesRegisteredEvent extends State<SuccesRegisteredEvent> {
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
            "Berhasil Mendaftar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            // Positioned.fill(  //
            //     child: Image(
            //       image: AssetImage('images/party.jpg'),
            //       fit : BoxFit.,
            //   )
            // ),
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
                    child: Text("Selamat Anda Terdaftar !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                        "Pastikan datang tepat waktu jangan terlembat karena ada hal hal yang menarik untuk anda pada event tersebut",
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.5, fontSize: 12))),
                Container(
                    padding: EdgeInsets.all(20.0),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                                color: Color.fromRGBO(54, 55, 84, 1),
                                child: Text("Lihat Detail Event",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AfterRegisterEvents(),
                                      ));
                                }))
                      ],
                    ))
              ],
            )
          ],
        )));
  }
}
