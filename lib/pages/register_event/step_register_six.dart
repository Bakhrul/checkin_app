import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/pages/management_checkin/checkin_manual.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'step_register_someone.dart';
import 'package:checkin_app/pages/events_all/detail_event.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

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
bool isLoading, isError,isLoadingCategory,_isValidDate;
String emailStore, imageStore, namaStore, phoneStore, locationStore;
String tokenType, accessToken;
String jumlahnotifX;
String userId;
String endTime;
String startTime;
// List<Checkin> listEventSelf = [];
Map<String, String> requestHeaders = Map();
@override
  void initState() {
    super.initState();
    _isValidDate = false;
    getHeaderHTTP();
    
  }

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
  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    return checkinDate(widget.id);
  }
  Future<List<Checkin>> checkinDate(eventid) async {
    setState(() {
      isLoading = true;
    });
    try{
      final eventList = await http.get(
        url('api/checkin/getdata/checkdate/$eventid'),
        headers: requestHeaders,
      );
      print(eventList.statusCode);

     
      if (eventList.statusCode == 200) {
         var isValidDate = json.decode(eventList.body);

      var timesEnd = isValidDate['times_end'];
      var boolDate = isValidDate['bool'];
      var timeStart = isValidDate['times_start'];
      setState(() {
         endTime = timesEnd.toString(); 
         startTime = timeStart.toString(); 
        _isValidDate =  boolDate == "TRUE" ?  true : false;
        isLoading = false;
        isError = false;
      });
      } else if (eventList.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoadingCategory =false;
          isLoading = false;
          isError = true;
        });
      } else {
        print(eventList.body);
        setState(() {
          isLoadingCategory =false;
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoadingCategory =false;
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoadingCategory =false;
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }


  _deleteParticipant() async {
    try {
      dynamic body = {
        "peserta": widget.dataUser['us_code'].toString(),
        "event": widget.id.toString(),
        "creator": widget.creatorId.toString(),
        "notif": 'keluar dari event',
      };
      dynamic response =
          await RequestPost(name: "deletepeserta_event", body: body)
              .sendrequest();
      print(response['status']);
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
          backgroundColor: primaryAppBarColor,
        ),
        body: isLoading == true ? Center(child: CircularProgressIndicator(),): SingleChildScrollView(
            child: Stack(
          children: <Widget>[   
            isError == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => checkinDate(widget.id),
                    child: Column(children: <Widget>[
                      new Container(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset("images/system-eror.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Center(
                          child: Text(
                            "Gagal memuat halaman, tekan tombol muat ulang halaman untuk refresh halaman",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 15.0, right: 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.white,
                            textColor: Color.fromRGBO(41, 30, 47, 1),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(15.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () async {
                              checkinDate(widget.id);
                            },
                            child: Text(
                              "Muat Ulang Halaman",
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ):
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
                                color: Colors.white,
                                child: Text("Daftarkan Orang Lain",
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConfirmEventGuest(
                                            id: widget.id,
                                            creatorId: widget.creatorId,
                                            dataUser: widget.dataUser),
                                      ));
                                })),
                        _isValidDate != true ?
                        Container():
                        Container(
                            width: double.infinity,
                            
                            child: RaisedButton(
                                color: Colors.indigo,
                                disabledColor: Colors.indigo[400],
                                child: Text("Checkin",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: _isValidDate != true ? null : () async {
                                 
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckinManual(
                                            idevent: widget.id.toString(),
                                            startTime: startTime,
                                            endTime: endTime,),
                                            
                                      ));
                                 
                                })),
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                                color: Colors.green,
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
                                                  "Apakah Anda Yakin Akan Keluar Dari Event ini?"),
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
