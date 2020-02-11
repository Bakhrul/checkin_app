import 'package:checkin_app/auth/login.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'dart:convert';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

Map<String, dynamic> formSerialize;
Map<String, String> requestHeaders = Map();
TextEditingController email = TextEditingController();
bool isLoading, isReset;

class ResetPassword extends StatefulWidget {
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  void initState() {
    super.initState();
    isLoading = true;
    isReset = false;
    email.text = '';
  }

  void dispose() {
    super.dispose();
  }

  void resetpassword() async {
    setState(() {
      isReset = true;
    });
    formSerialize = Map<String, dynamic>();
    formSerialize['email'] = null;
    formSerialize['email'] = email.text;
    
    Map<String, dynamic> requestHeadersX = requestHeaders;

    requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
    try {
      final response = await http.post(
        url('api/kirimemail'),
        // headers: requestHeadersX,
        body: {
          'type_platform': 'android',
          'data': jsonEncode(formSerialize),
        },
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        if (responseJson == 'success') {
          Fluttertoast.showToast(msg: "Silahkan Cek Email Anda, Jika Tidak Ditemukan Cek Pada Spam Email",
          toastLength: Toast.LENGTH_LONG);
          setState(() {
            isReset = false;
          });
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (responseJson == 'emailnotavailable') {
          Fluttertoast.showToast(
              msg: "Email Tidak Ditemukan");
          setState(() {
            isReset = false;
          });
        }
        // print('response decoded $responseJson');
      } else {
        print('${response.body}');
        Fluttertoast.showToast(
            msg: "Gagal Reset Akun Silahkan Coba Kembali");
        setState(() {
          isReset = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(
          msg: "Gagal Reset Akun, Silahkan Coba Kembali");
      setState(() {
        isReset = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Reset Akun, Silahkan Coba Kembali");
      setState(() {
        isReset = false;
      });
      print(e);
    }
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
            Fluttertoast.showToast(msg: "Waktu Checkin telah Habis");
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
    DateTime _getDateExp = DateTime.now().subtract(Duration(minutes: 1));

    _seconds = _getDateExp.difference(_date).inSeconds;
    var _time = Duration(seconds: _seconds);
    _count = _seconds < 1
        ? "00:00:00"
        : '${(_time.inHours).toString().padLeft(2, '0')}:${(_time.inMinutes % 60).toString().padLeft(2, '0')}:${(_time.inSeconds % 60).toString().padLeft(2, '0')}';
    // print(_count);
  }

  @override
  Widget build(BuildContext context) {
    
    final emailField = TextFormField(
      validator: (value) {
              if (value.isEmpty) {
                print(value);
                return 'Email Tidak Boleh Kosong';
              }
              return null;
            },
      controller: email,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          hintStyle: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.black, fontSize: 14),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black38)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
            ),
          )),
    );

   
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(3.0),
      color: primaryAppBarColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: isReset == true ? null : () async {
          setState(() {
            isLoading = true;
          });
          String emailValid = email.text;
          final bool isValid = EmailValidator.validate(emailValid);

          // print('Email is valid? ' + (isValid ? 'yes' : 'no'));
          if (email.text == null || email.text == '') {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Email Tidak Boleh Kosong");
          } else if(!isValid){
            Fluttertoast.showToast(msg: "Masukkan Email Yang Valid");
          } else {
            resetpassword();
          }
        },
        child: Text(
          isReset == true ? "Mohon Tunggu Sebentar"  : disable == false ? "Kirim Permintaan" : _count,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            fontSize: 14.0,
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 27.0, right: 27.0, left: 27.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 40.0,top:40.0),
                    child: Text('EventZhee', style: TextStyle(
                      color: Color.fromRGBO(254, 86, 14, 1),
                      fontSize: 42.0,
                    ),),
                  ),
                
               
                emailField,
                SizedBox(height: 15.0),
               
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              border: BorderDirectional(
                            bottom:
                                BorderSide(width: 1 / 2, color: Colors.grey),
                          )),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Center(
                          child: Text(
                            'Sudah Memiliki Akun ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              border: BorderDirectional(
                            bottom:
                                BorderSide(width: 1 / 2, color: Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.white,
                      textColor: primaryAppBarColor,
                      disabledColor: Colors.green[400],
                      disabledTextColor: Colors.white,
                      padding: EdgeInsets.all(15.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login Sekarang',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
       bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    'Powered By :',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Image.asset(
                  "images/logo.png",
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            )),
      ),
      // ),
    );
  }
}
