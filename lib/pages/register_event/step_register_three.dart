import 'dart:async';

import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'step_register_someone.dart';
import 'step_not_register.dart';

String tokenType, accessToken;
String typePrimary, userPrimary;
Map<String, String> requestHeaders = Map();

class WaitingEvent extends StatefulWidget {
  WaitingEvent(
      {Key key,
      this.id,
      this.creatorId,
      this.selfEvent,
      this.userId,
      this.type,
      this.dataUser})
      : super(key: key);
  final int id;
  final Map dataUser;
  String type;
  final String creatorId;
  final String userId;
  final bool selfEvent;
  State<StatefulWidget> createState() {
    return _WaitingEventState();
  }
}

class _WaitingEventState extends State<WaitingEvent> {
  bool _isLoading = false;
  bool _isLoadingReminder = false;

  Future _cancelRegisterEvent() async {
    setState(() {
      _isLoading = true;
    });

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    Map body = {
      'event_id': widget.id.toString(),
      'user_id': userPrimary,
      'type': typePrimary
    };

    try {
      final ongoingevent = await http.post(url('api/event/cancelregisterevent'),
          headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        Fluttertoast.showToast(msg: "Anda Membatalkan Pendaftaran Anda");
        await new Future.delayed(new Duration(seconds: 1));

        return Navigator.pop(context);
      } else if (ongoingevent.statusCode == 401) {
        Fluttertoast.showToast(msg: "Gagal Membatalkan Event");
        setState(() {
          _isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time out, silahkan coba lagi nanti");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _sendnotificationsevent() async {
    setState(() {
      _isLoadingReminder = true;
    });

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    Map body = {
      'event': widget.id.toString(),
      'type': typePrimary,
      'peserta': userPrimary
    };
    try {
      final ongoingevent = await http.post(
          url('api/event/reminder_notifications'),
          headers: requestHeaders,
          body: body);
      if (ongoingevent.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Berhasil Mengirimkan Notifikasi kepada Pembuat Event");
        setState(() {
          _isLoadingReminder = false;
        });
      } else if (ongoingevent.statusCode == 401) {
        Fluttertoast.showToast(msg: "Gagal Mengirim Notifikasi");
        setState(() {
          _isLoadingReminder = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Gagal Mengirim Notifikasi");
        print(ongoingevent.body);
        setState(() {
          _isLoadingReminder = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time out, silahkan coba lagi nanti");
      setState(() {
        _isLoadingReminder = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      setState(() {
        _isLoadingReminder = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    typePrimary =
        widget.type == null || widget.type == '' ? 'self' : widget.type;
    userPrimary = widget.type == null || widget.type == ''
        ? widget.dataUser['us_code'].toString()
        : widget.userId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Menunggu Verifikasi",
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
                        child: Image.asset("images/like.png",
                            height: 150.0, width: 150.0))),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text("Terima Kasih Telah Mendaftar Event",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                        "Pendaftaran Sebagai Peserta Event Yang Anda Kirimkan Telah Kami Terima, Tunggu Verifikasi Dari Pembuat Event Terkait Dengan Pendaftaran Anda.",
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.5, fontSize: 17))),
                Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                                color: Colors.white,
                                textColor: Colors.white,
                                child: Text("Daftarkan Orang Lain",
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    builder: (context) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Colors.white),
                                          width: double.infinity,
                                          height: 150,
                                          padding: EdgeInsets.only(top: 20),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ConfirmEventGuest(
                                                                    id:
                                                                        widget
                                                                            .id,
                                                                    creatorId:
                                                                        widget
                                                                            .creatorId,
                                                                    dataUser: widget
                                                                        .dataUser),
                                                          ));
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 10,
                                                                top: 15,
                                                                bottom: 15),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                                width: 20,
                                                                height: 20,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            20),
                                                                child: Image.asset(
                                                                    'images/not_have_account.png',
                                                                    fit: BoxFit
                                                                        .contain)),
                                                            Container(
                                                                child: Text(
                                                                    'Belum Memiliki Akun',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    )))
                                                          ],
                                                        ))),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                GuestNotRegistered(
                                                                    creatorId:
                                                                        widget
                                                                            .creatorId,
                                                                    eventId:
                                                                        widget
                                                                            .id,
                                                                    dataUser: widget
                                                                        .dataUser),
                                                          ));
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 10,
                                                                top: 15,
                                                                bottom: 15),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                                width: 20,
                                                                height: 20,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            20),
                                                                child: Image.asset(
                                                                    'images/have_account.png',
                                                                    fit: BoxFit
                                                                        .contain)),
                                                            Container(
                                                                child: Text(
                                                                    'Sudah Memiliki Akun',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    )))
                                                          ],
                                                        ))),
                                              ]));
                                    },
                                  );
                                })),
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                                color: Colors.green,
                                disabledColor: Colors.green[400],
                                child: _isLoadingReminder == true
                                    ? Container(
                                        height: 25.0,
                                        width: 25.0,
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(Colors.white)))
                                    : Text("Kirim Notifikasi Pembuat Event",
                                        style: TextStyle(color: Colors.white)),
                                onPressed: _isLoading == true ||
                                        _isLoadingReminder == true
                                    ? null
                                    : () {
                                        _sendnotificationsevent();
                                      })),
                        typePrimary == 'someone'
                            ? Container()
                            : Container(
                                width: double.infinity,
                                child: RaisedButton(
                                    color: Colors.red,
                                    disabledColor: Colors.red[400],
                                    child: _isLoading == true
                                        ? Container(
                                            height: 25.0,
                                            width: 25.0,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.blue)))
                                        : Text("Batal Mendaftar Event",
                                            style:
                                                TextStyle(color: Colors.white)),
                                    onPressed: _isLoading == true ||
                                            _isLoadingReminder == true
                                        ? null
                                        : () {
                                            _cancelRegisterEvent();
                                          }))
                      ],
                    ))
              ],
            )
          ],
        )));
  }
}
