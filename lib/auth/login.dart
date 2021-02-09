import 'package:checkin_app/auth/reset_password.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';
import 'register.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();
bool loading = false;
bool _isLoading = false;
Map<String, String> requestHeaders = Map();

class LoginPage extends StatefulWidget {
  //   LoginPage({Key key, this.indexIkis, indexIki}) : super(key: key);
  // final String indexIkis;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String indexIki;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcmToken;
  bool validateEmail = false;
  bool validatePassword = false;

  void initState() {
    _isLoading = false;
    username.text = '';
    password.text = '';
    register();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  register() {
    _firebaseMessaging.getToken().then((token) {
      setState(() {
        fcmToken = token;
      });
    });
  }

  login() async {    
    await Auth(username: username.text, password: password.text).process();
    Navigator.pushReplacementNamed(context, "/dashboard");
    loading = false;
  }

  String msg = ''; 
  _login() async {
    setState(() {
      _isLoading = true;
      validatePassword = false;
      validateEmail = false;
    });

    if (password.text == '' && username.text == '') {
      setState(() {
        validatePassword = true;
        validateEmail = true;
        _isLoading = false;
      });
      return false;
    } else if (username.text == '') {
      setState(() {
        validateEmail = true;
        _isLoading = false;
      });
      return false;
    } else if (password.text == '') {
      setState(() {
        validatePassword = true;
        _isLoading = false;
      });
      return false;
    }

    try {
      final getToken = await http.post(url('oauth/token'), body: {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientSecret,
        "username": username.text,
        "password": password.text,
      });

      // print('getToken ' + getToken.body);

      var getTokenDecode = json.decode(getToken.body);
      // print(getToken.statusCode);
      if (getToken.statusCode == 200) {
        if (getTokenDecode['error'] == 'invalid_credentials') {
          // Fluttertoast.showToast("");
          msg = getTokenDecode['message'];
          setState(() {
            _isLoading = false;
          });
        } else if (getTokenDecode['error'] == 'invalid_request') {
          Fluttertoast.showToast(msg: getTokenDecode['hint']);
          msg = getTokenDecode['hint'];
          setState(() {
            _isLoading = false;
          });
        } else if (getTokenDecode['token_type'] == 'Bearer') {
          DataStore()
              .setDataString('access_token', getTokenDecode['access_token']);
          DataStore().setDataString('token_type', getTokenDecode['token_type']);

          List head = ['token_type', 'access_token'];
          List value = [
            getTokenDecode['token_type'],
            getTokenDecode['access_token']
          ];
          await Auth(nameStringsession: head, dataStringsession: value)
              .savesession();
        }
        dynamic tokenType = getTokenDecode['token_type'];
        dynamic accessToken = getTokenDecode['access_token'];
        requestHeaders['Accept'] = 'application/json';
        requestHeaders['Authorization'] = '$tokenType $accessToken';
        try {
          final getUser =
              await http.get(url("api/user"), headers: requestHeaders);       

          if (getUser.statusCode == 200) {
            dynamic datauser = json.decode(getUser.body);

            DataStore store = new DataStore();
            store.setDataString("id", datauser['us_code'].toString());
            store.setDataString("email", datauser['us_email']);
            store.setDataString("name", datauser['us_name']);
            store.setDataString("image",
                datauser['us_image'] == null ? '-' : datauser['us_image']);
            store.setDataString("phone",
                datauser['us_phone'] == null ? '-' : datauser['us_phone']);
            store.setDataString(
                "location",
                datauser['us_location'] == null
                    ? '-'
                    : datauser['us_location']);     

            try {
              Map body = {
                'id': datauser['us_code'].toString(),
                'token': fcmToken.toString()
              };
              final getToken = await http.post(url("api/updateTokenFcm"),
                  headers: requestHeaders, body: body);

              if (getToken.statusCode == 200) {
                Navigator.pushReplacementNamed(context, "/dashboard");
                setState(() {
                  _isLoading = false;
                });
              } else if (getToken.statusCode != 200) {
                Fluttertoast.showToast(msg: "error: cannot update token");
                setState(() {
                  _isLoading = false;
                });
              }
            } catch (e) {
              Fluttertoast.showToast(msg: "error: $e");
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            Fluttertoast.showToast(
                msg: "Request failed with status: ${getUser.statusCode}");
            setState(() {
              _isLoading = false;
            });
          }
        } on SocketException catch (_) {
          Fluttertoast.showToast(msg: "Connection Timed Out");
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          print(e);
          setState(() {
            _isLoading = false;
          });
        }
      } else if (getToken.statusCode == 401) {
        Fluttertoast.showToast(msg: "Username Atau Password Salah");
        setState(() {
          _isLoading = false;
        });
      } else if (getToken.statusCode == 404) {
        Fluttertoast.showToast(msg: "Terjadi Kesalahan Server");
        setState(() {
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Request failed with status: ${getToken.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "Connection Timed Out");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Terjadi Kesalahan Server");
    }
  } 

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      controller: username,
      autofocus: true,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Alamat Email",
          errorText: validateEmail ? "Email Tidak Boleh Kosong" : null,
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
    final passwordField = TextField(
      controller: password,
      obscureText: true,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Kata Sandi",
          errorText: validatePassword ? "Password Tidak Boleh Kosong" : null,
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
        onPressed: _isLoading == true
            ? null
            : () async {
                //login();
                _login();
                // Navigator.push(context, MaterialPageRoute(builder: (context) => CobaApps()));
              },
        child: Text(
          _isLoading == true ? "Tunggu Sebentar" : "Masuk",
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
    // final adsSection = Material(
    //   color: Colors.white,
    //   child: Column(
    //     children: <Widget>[
    //       SizedBox(height: 10),
    //       Container(
    //         width: double.infinity,
    //         child: Column(
    //           children: <Widget>[
    //             SizedBox(
    //               width: 20,
    //             ),
    //             Padding(
    //               padding: EdgeInsets.all(0),
    //               child: SizedBox(
    //                 width: double.infinity,
    //                 child: OutlineButton(
    //                   color: Colors.white,
    //                   textColor: Color.fromRGBO(41, 30, 47, 1),
    //                   disabledTextColor: Colors.green[400],
    //                   padding: EdgeInsets.all(0),
    //                   splashColor: Colors.blueAccent,
    //                   borderSide: BorderSide(
    //                     color: Colors.grey, //Color of the border
    //                     style: BorderStyle.solid, //Style of the border
    //                     width: 0.2, //width of the border
    //                   ),
    //                   onPressed: () async {
    //                     signin();
    //                     },
    //                   child: new Row(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Container(
    //                           margin: EdgeInsets.only(
    //                             left: 15.0,
    //                             right: 15.0,
    //                           ),
    //                           height: 40.0,
    //                           width: 20.0,
    //                           padding: EdgeInsets.all(15),
    //                           decoration: new BoxDecoration(
    //                             color: Colors.white,
    //                             image: new DecorationImage(
    //                               image: AssetImage(
    //                                 'images/google.png',
    //                               ),
    //                             ),
    //                           )),
    //                       new Container(
    //                           height: 40.0,
    //                           decoration: new BoxDecoration(
    //                               border: Border(
    //                             left:
    //                                 BorderSide(width: 0.2, color: Colors.grey),
    //                           )),
    //                           padding: EdgeInsets.only(
    //                             left: 10.0,
    //                             right: 10.0,
    //                             top: 12.0,
    //                           ),
    //                           child: new Text(
    //                             "Google",
    //                             style: TextStyle(
    //                                 color: Colors.black54,
    //                                 fontWeight: FontWeight.bold),
    //                           )),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(top:10.0),
    //               child: SizedBox(
    //                 width: double.infinity,
    //                 child: OutlineButton(
    //                   color: Colors.white,
    //                   textColor: Color.fromRGBO(41, 30, 47, 1),
    //                   disabledTextColor: Colors.green[400],
    //                   padding: EdgeInsets.all(0),
    //                   splashColor: Colors.blueAccent,
    //                   borderSide: BorderSide(
    //                     color: Colors.grey, //Color of the border
    //                     style: BorderStyle.solid, //Style of the border
    //                     width: 0.2, //width of the border
    //                   ),
    //                   onPressed: () async {
    //                     // signfacebook();
    //                     },
    //                   child: new Row(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Container(
    //                           margin: EdgeInsets.only(
    //                             left: 15.0,
    //                             right: 15.0,
    //                           ),
    //                           height: 40.0,
    //                           width: 20.0,
    //                           padding: EdgeInsets.all(15),
    //                           decoration: new BoxDecoration(
    //                             color: Colors.white,
    //                             image: new DecorationImage(
    //                               image: AssetImage(
    //                                 'images/facebook.png',
    //                               ),
    //                             ),
    //                           )),
    //                       Column(
    //                         children: <Widget>[
    //                           new Container(
    //                               height: 40.0,
    //                               decoration: new BoxDecoration(
    //                                   border: Border(
    //                                 left:
    //                                     BorderSide(width: 0.2, color: Colors.grey),
    //                               )),
    //                               padding: EdgeInsets.only(
    //                                 left: 10.0,
    //                                 right: 10.0,
    //                                 top: 12.0,
    //                               ),
    //                               child: new Text(
    //                                 "Facebook",
    //                                 style: TextStyle(
    //                                     color: Colors.black54,
    //                                     fontSize: 14,
    //                                     fontWeight: FontWeight.bold),
    //                               )),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top:40.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: <Widget>[
    //                   Text('Belum Memiliki Akun ?',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500),),
    //                   ButtonTheme(
    //                   minWidth: 0.0,
    //                   height: 0.0,
    //                   child: FlatButton(
    //                     padding: EdgeInsets.all(5.0),
    //                     onPressed: () async {
    //                       Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => Register()));
    //                     },
    //                     child: Text(
    //                       'Daftar Sekarang',
    //                       style: TextStyle(
    //                         color: Color.fromRGBO(0, 0, 102, 1),
    //                       ),
    //                     ),
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 27.0, left: 27.0, right: 27.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 40.0),
                    child: Text(
                      'EventZhee',
                      style: TextStyle(
                        color: Color.fromRGBO(254, 86, 14, 1),
                        fontSize: 42.0,
                      ),
                    ),
                  ),

                  usernameField,
                  SizedBox(height: 15.0),

                  passwordField,
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      
                      ButtonTheme(
                        minWidth: 0.0,
                        height: 0.0,
                        child: FlatButton(
                          padding: EdgeInsets.all(5.0),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                          },
                          child: Text(
                            'Lupa Password ?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ),
                       ButtonTheme(
                          minWidth: 0.0,
                          height: 0.0,
                          child: FlatButton(
                            padding: EdgeInsets.all(5.0),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                color: primaryAppBarColor,
                                fontSize: 12
                              ),
                            ),
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  loginButton,
                 

                  // Container(
                  //   padding: EdgeInsets.only(top: 2.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text(
                  //         'Belum Memiliki Akun ?',
                  //         style: TextStyle(
                  //             color: Colors.black54,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //       ButtonTheme(
                  //         minWidth: 0.0,
                  //         height: 0.0,
                  //         child: FlatButton(
                  //           padding: EdgeInsets.all(5.0),
                  //           onPressed: () async {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => Register()));
                  //           },
                  //           child: Text(
                  //             'Daftar Sekarang',
                  //             style: TextStyle(
                  //               color: primaryAppBarColor,
                  //             ),
                  //           ),
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  // adsSection,
                ],
              ),
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
    );
  }
}
