import 'package:checkin_app/model/checkin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'checkin_success.dart';
import 'dart:async';
import 'dart:convert';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/dashboard.dart';

List<Checkin> listCheckin;
bool isCheckin, tidakadaCheckin, sudahCheckin, gagalCheckin;
String resultX;
String tokenType, accessToken;
Map<String, dynamic> formSerialize;
Map<String, String> requestHeaders = Map();
final _debouncer = Debouncer(milliseconds: 1500);

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class CheckinQRCode extends StatefulWidget {
  CheckinQRCode({Key key, this.title, this.idevent, this.idcheckin})
      : super(key: key);
  final String title, idevent, idcheckin;
  @override
  State<StatefulWidget> createState() {
    return _CheckinQRCodeState();
  }
}

class _CheckinQRCodeState extends State<CheckinQRCode> {
  @override
  void initState() {
    super.initState();
    gagalCheckin = false;
    sudahCheckin = false;
    tidakadaCheckin = false;
    resultX = widget.idcheckin;
    _debouncer.run(() {
      checkinsekarang();
      getHeaderHTTP();
    });
  }

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);
    return checkinsekarang();
  }

  void checkinsekarang() async {
    print('jaln');
    setState(() {
      isCheckin = true;
    });
    formSerialize = Map<String, dynamic>();
    formSerialize['event'] = null;
    formSerialize['idcheckin'] = null;
    formSerialize['event'] = widget.idevent;
    formSerialize['idcheckin'] = widget.idcheckin;

    print(formSerialize);

    Map<String, dynamic> requestHeadersX = requestHeaders;

    requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
    try {
      final response = await http.post(
        url('api/user_checkineventqr'),
        headers: requestHeadersX,
        body: {
          'type_platform': 'android',
          'data': jsonEncode(formSerialize),
        },
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        if (responseJson['status'] == 'success') {
          setState(() {
            isCheckin = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SuccesRegisteredCheckin(),
              ));
          Fluttertoast.showToast(msg: "Berhasil Checkin");
        } else if (responseJson['status'] == 'checkinnotavailable') {
          setState(() {
            isCheckin = false;
            tidakadaCheckin = true;
          });
          Fluttertoast.showToast(
              msg: "Checkin tidak ditemukan atau telah kadaluwarsa");
        } else if (responseJson['status'] == 'sudahcheckin') {
          setState(() {
            isCheckin = false;
            sudahCheckin = true;
          });
          Fluttertoast.showToast(
              msg: "Anda Sudah melakukan checkin pada sesi checkin tersebut");
        }
        print('response decoded $responseJson');
      } else {
        print('${response.body}');
        Fluttertoast.showToast(msg: "Gagal Melakukan Checkin");
        setState(() {
          isCheckin = false;
          gagalCheckin = true;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Timeout!!, Gagal Melakukan Checkin");
      setState(() {
        isCheckin = false;
        gagalCheckin = true;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Melakukan Checkin, Silahkan Coba kembali");
      setState(() {
        isCheckin = false;
        gagalCheckin = true;
      });
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      body: Container(
        padding: const EdgeInsets.only(top: 100.0, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                  color: Colors.white,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(50.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Result : **********',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    isCheckin == true
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text('Mohon Tunggu Sebentar'),
                              ),
                            ],
                          )
                        : tidakadaCheckin == true
                            ? Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 30.0),
                                      height: 50.0,
                                      alignment: Alignment.center,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                100.0) //                 <--- border radius here
                                            ),
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(255, 0, 0, 1.0)),
                                        color: Colors.white,
                                      ),
                                      child: Icon(Icons.close,
                                          size: 26,
                                          color:
                                              Color.fromRGBO(255, 0, 0, 1.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      'Checkin Tidak Ditemukan / Telah Kadaluwarsa',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(height: 2.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Color.fromRGBO(41, 30, 47, 1),
                                        textColor: Colors.white,
                                        disabledColor: Colors.green[400],
                                        disabledTextColor: Colors.white,
                                        padding: EdgeInsets.all(5.0),
                                        splashColor: Colors.blueAccent,
                                        onPressed: () async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard(),
                                              ));
                                        },
                                        child: Text(
                                          "Kembali Ke Beranda",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : sudahCheckin == true
                                ? Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 30.0),
                                          height: 50.0,
                                          alignment: Alignment.center,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    100.0) //                 <--- border radius here
                                                ),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1.0)),
                                            color: Colors.white,
                                          ),
                                          child: Icon(Icons.close,
                                              size: 26,
                                              color: Color.fromRGBO(
                                                  255, 0, 0, 1.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Anda Sudah Melakukan Checkin Pada Sesi Tersebut',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(height: 2.0),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: RaisedButton(
                                            color:
                                                Color.fromRGBO(41, 30, 47, 1),
                                            textColor: Colors.white,
                                            disabledColor: Colors.green[400],
                                            disabledTextColor: Colors.white,
                                            padding: EdgeInsets.all(5.0),
                                            splashColor: Colors.blueAccent,
                                            onPressed: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Dashboard(),
                                                  ));
                                            },
                                            child: Text(
                                              "Kembali Ke Beranda",
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : gagalCheckin == true
                                    ? Column(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 30.0),
                                              height: 50.0,
                                              alignment: Alignment.center,
                                              width: 50.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        100.0) //                 <--- border radius here
                                                    ),
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        255, 0, 0, 1.0)),
                                                color: Colors.white,
                                              ),
                                              child: Icon(Icons.close,
                                                  size: 26,
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1.0)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              'Gagal Melakukan Checkin, Silahkan Coba Kembali',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(height: 2.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: RaisedButton(
                                                color: Color.fromRGBO(
                                                    41, 30, 47, 1),
                                                textColor: Colors.white,
                                                disabledColor:
                                                    Colors.green[400],
                                                disabledTextColor: Colors.white,
                                                padding: EdgeInsets.all(5.0),
                                                splashColor: Colors.blueAccent,
                                                onPressed: () async {
                                                  checkinsekarang();
                                                },
                                                child: Text(
                                                  "Checkin Kembali",
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
