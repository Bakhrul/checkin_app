import 'package:checkin_app/model/checkin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'checkin_success.dart';
import 'dart:async';
import 'scan_qrcode_checkin.dart';
import 'dart:convert';
import 'package:checkin_app/storage/storage.dart';

List<Checkin> listCheckin;
bool isCheckin;
String tokenType, accessToken;
Map<String, dynamic> formSerialize;

Map<String, String> requestHeaders = Map();

class CheckinManual extends StatefulWidget {
  CheckinManual(
      {Key key, this.title, this.idevent, this.startTime, this.endTime})
      : super(key: key);
  final String title, idevent;
  final String startTime, endTime;
  @override
  State<StatefulWidget> createState() {
    return _CheckinManualState();
  }
}

class _CheckinManualState extends State<CheckinManual>
    with SingleTickerProviderStateMixin {
  TextEditingController _controllerCheckin = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    getDifTime();
    startTimer();
    _controllerCheckin.text = '';
    isCheckin = false;
  }

  DateTime _date = new DateTime.now();
  int _seconds = 0;
  var _count = '00:00';
  bool disable = false;

  void startTimer() {
    Duration minusDuration = Duration(seconds: 1);

    Timer.periodic(minusDuration, (Timer timer) {
      if (mounted) {
        setState(() {
          if (_seconds < 1) {
            timer.cancel();
            disable = true;
            Fluttertoast.showToast(msg: "Waktu CheckIn Telah Habis");
          } else {
            _seconds = _seconds - 1;
            var _time = Duration(seconds: _seconds);
            _count = _seconds < 1
                ? "00:00:00"
                : '${(_time.inHours).toString().padLeft(2, '0')}:${(_time.inMinutes % 60).toString().padLeft(2, '0')}:${(_time.inSeconds % 60).toString().padLeft(2, '0')}';
          }
        });
      }
    });
  }

  void getDifTime() {
    DateTime _getDateExp = DateTime.parse(widget.endTime.toString());

    _seconds = _getDateExp.difference(_date).inSeconds;
    var _time = Duration(seconds: _seconds);
    _count = _seconds < 1
        ? "00:00:00"
        : '${(_time.inHours).toString().padLeft(2, '0')}:${(_time.inMinutes % 60).toString().padLeft(2, '0')}:${(_time.inSeconds % 60).toString().padLeft(2, '0')}';
    // print(_count);
  }

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    // print(requestHeaders);
  }

  void checkinsekarang() async {
    setState(() {
      isCheckin = true;
    });
    if (_controllerCheckin.text == null || _controllerCheckin.text == '') {
      Fluttertoast.showToast(msg: "Masukkan Kode CheckIn Anda");
      setState(() {
        isCheckin = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      formSerialize = Map<String, dynamic>();
      formSerialize['event'] = null;
      formSerialize['keyword'] = null;
      formSerialize['event'] = widget.idevent;
      formSerialize['keyword'] = _controllerCheckin.text;

      // print(formSerialize);

      Map<String, dynamic> requestHeadersX = requestHeaders;

      requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
      try {
        final response = await http.post(
          url('api/usercheckinevent'),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccesRegisteredCheckin(),
                ));
            Fluttertoast.showToast(msg: "Berhasil Checkin");
          } else if (responseJson['status'] == 'checkinnotavailable') {
            setState(() {
              isCheckin = false;
            });
            Fluttertoast.showToast(
                msg: "Checkin Tidak Ditemukan Atau Telah Kadaluwarsa");
          } else if (responseJson['status'] == 'sudahcheckin') {
            setState(() {
              isCheckin = false;
            });
            Fluttertoast.showToast(
                msg: "Anda Sudah Melakukan Checkin Pada Sesi Checkin Tersebut");
          }
        } else {
          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
          setState(() {
            isCheckin = false;
          });
        }
      } on TimeoutException catch (_) {
        Fluttertoast.showToast(msg: "Timeout!!, Silahkan Coba Kembali");
        setState(() {
          isCheckin = false;
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Gagal Melakukan Checkin, Silahkan Coba Kembali");
        setState(() {
          isCheckin = false;
        });
        print(e);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // key: _scaffoldKeycreatecheckin,
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset("images/checkin_flat.png"),
                        ),
                        Container(
                            padding: const EdgeInsets.only(
                                right: 10.0),
                            child:
                                Text(_count, style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w500))),
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 10.0, right: 10.0),
                        child: Text('Punya Kode CheckIn ????',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: Text('Masukkan Kode CheckIn Anda disini',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w400)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 15.0, right: 15.0),
                        child: TextField(
                          maxLines: 1,
                          controller: _controllerCheckin,
                          decoration: InputDecoration(
                            hintText: 'Example : CheckIn01',
                            hintStyle:
                                TextStyle(color: Colors.black45, fontSize: 14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: FlatButton(
                          child: Text(
                            "Atau Ingin Menggunakan QRCode ?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScanQrcode(id: widget.idevent)));
                          },
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: disable ? Colors.grey : Colors.green[400],
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(15.0),
            splashColor: Colors.blueAccent,
            onPressed: disable
                ? null
                : () async {
                    checkinsekarang();
                  },
            child: isCheckin == true
                ? Container(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white)))
                : Text(
                    'CheckIn Sekarang',
                    style: TextStyle(fontSize: 18.0),
                  ),
          ),
        ),
      ),
    );
  }
}
