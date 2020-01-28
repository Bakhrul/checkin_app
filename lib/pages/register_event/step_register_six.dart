import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/pages/management_checkin/checkin_manual.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../event_following/count_down.dart';
import 'package:checkin_app/pages/events_all/detail_event.dart';

class SuccesRegisteredEvent extends StatefulWidget {
  final int checkin;
  final int id;
  final String creatorId;
  final bool selfEvent;
  final Map dataUser;
  SuccesRegisteredEvent(
      {Key key,
      this.checkin = 0,
      this.id,
      this.dataUser,
      this.creatorId,
      this.selfEvent})
      : super(key: key);

  State<StatefulWidget> createState() {
    return _SuccesRegisteredEvent();
  }
}

class _SuccesRegisteredEvent extends State<SuccesRegisteredEvent> {
  bool _buttonUndo = false;

  _setUndo() {
    setState(() {
      _buttonUndo = false;
    });
  }

  _checkoutFromEvent() async {
    setState(() {
      _buttonUndo = true;
    });
    await new Future.delayed(const Duration(seconds: 5));
    if (_buttonUndo == true) {
      _deleteParticipant();
    } else {
      setState(() {
        _buttonUndo == false;
      });
    }
  }

  _deleteParticipant() async {
    try {
      dynamic body = {
        "peserta": widget.dataUser['us_code'].toString(),
        "event": widget.id.toString(),
        "admin": widget.creatorId.toString(),
        "notif": 'keluar dari event',
      };
      dynamic response =
          await RequestPost(name: "deletepeserta_event", body: body)
              .sendrequest();
      // print(response['status']);
      if (response['status'] == "success") {
        setState(() {
          _buttonUndo == false;
        });

        Fluttertoast.showToast(
            msg: "Berhasil Keluar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // isLoading = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterEvents(
                    id: widget.id,
                    creatorId: widget.creatorId,
                    dataUser: widget.dataUser,
                    selfEvent: false)));
        // getDataCheckin();
      } else {
        Fluttertoast.showToast(
            msg: "Terjadi Kesalahan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // isLoading = false;
      }
    } catch (e) {
      setState(() {
        // isLoading = false;
        // isError = true;
      });
      debugPrint('$e');
    }
  }

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
                    child: Text("Selamat Anda Terdaftar ! ",
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
                                color: Colors.indigo,
                                child: Text("Checkin",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  if (widget.checkin == 0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckinManual(
                                              idevent: widget.id.toString()),
                                        ));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CountDown(),
                                        ));
                                  }
                                })),
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
                                          builder: (context) => RegisterEvents(
                                              id: widget.id,
                                              creatorId: widget.creatorId,
                                              dataUser: widget.dataUser,
                                              selfEvent: true)));
                                })),
                        _buttonUndo == true
                            ? Container(
                                child: Column(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  FlatButton(
                                      child: Text("Batalkan"),
                                      onPressed: () async {
                                        _setUndo();
                                      }),
                                ],
                              ))
                            : Container(
                                width: double.infinity,
                                child: FlatButton(
                                    // color: Colors.redAccent[700],
                                    child: Text("Keluar Dari Event",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Warning"),
                                              content: Text(
                                                  "Are you sure want to delete data?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    _checkoutFromEvent();

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }))
                      ],
                    ))
              ],
            )
          ],
        )));
  }
}
