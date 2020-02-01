import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';
import 'register.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:async';
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
    _firebaseMessaging.getToken().then((token){
      setState(() {
        fcmToken = token;
      });
    });
  }


  login() async {
    // print('login');
    // await Auth(username: username,password: password ,name: 'login',nameStringsession: headsession , dataStringsession: getsession).getuser();
    await Auth(username: username.text, password: password.text).process();
    Navigator.pushReplacementNamed(context, "/dashboard");
    loading = false;
  }
    String msg = '';
  

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // void showInSnackBar(String value, {SnackBarAction action}) {
  //   _scaffoldKey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(value),
  //     action: action,
  //   ));
  // }
  _login() async {
    setState(() {
      _isLoading = true;
      validatePassword = false;
      validateEmail = false;
    });

    if(password.text == '' && username.text == ''){
      setState((){
        validatePassword = true;
        validateEmail = true;
        _isLoading = false;
      });
      return false;
    } else if(username.text == ''){
      setState((){
        validateEmail = true;
        _isLoading = false;
      });
      return false;
    }else if(password.text == ''){
      setState((){
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
          Fluttertoast.showToast(msg: getTokenDecode['message']);
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
          
          List head = ['token_type','access_token'];
          List value = [getTokenDecode['token_type'],getTokenDecode['access_token']];
          await Auth(nameStringsession: head , dataStringsession: value).savesession();
         
        }
        dynamic tokenType = getTokenDecode['token_type'];
        dynamic accessToken = getTokenDecode['access_token'];
        requestHeaders['Accept'] = 'application/json';
        requestHeaders['Authorization'] = '$tokenType $accessToken';
        try {
          final getUser =
              await http.get(url("api/user"), headers: requestHeaders);
          // print('getUser ' + getUser.body);

          if (getUser.statusCode == 200) {
            dynamic datauser = json.decode(getUser.body);

            DataStore store = new DataStore();
            store.setDataString("id", datauser['us_code'].toString());
            store.setDataString("email", datauser['us_email']);
            store.setDataString("name", datauser['us_name']);
            store.setDataString("image",datauser['us_image'] == null ? '-':datauser['us_image']);
            store.setDataString("phone",datauser['us_phone'] == null ? '-':datauser['us_phone']);
            store.setDataString("location",datauser['us_location'] == null ? '-':datauser['us_location']);
            
            // var dir = await getApplicationDocumentsDirectory().path;
            // var type_image = datauser['us_image'].split('.').last;
            //     print(type_image);
            // File profileImageDownload = File('$dir/profile.$type_image');

              try{

                Map body = {'id':datauser['us_code'].toString(),'token':fcmToken.toString()};
                final getToken =
                await http.post(url("api/updateTokenFcm"), headers: requestHeaders,body:body);

                if(getToken.statusCode == 200){

                  Navigator.pushReplacementNamed(context, "/dashboard");
                  setState(() {
                    _isLoading = false;
                  });

                } else if(getToken.statusCode != 200){
                  Fluttertoast.showToast(msg: "error: cannot update token");
                  setState(() {
                    _isLoading = false;
                  });
                }

              } catch(e) {
                Fluttertoast.showToast(msg: "error: $e");
                  setState(() {
                    _isLoading = false;
                  });
              }

          } else {
            Fluttertoast.showToast(msg: "Request failed with status: ${getUser.statusCode}");
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
        Fluttertoast.showToast(msg: "Username atau Password salah");
        setState(() {
          _isLoading = false;
        });
        }else if(getToken.statusCode == 404){
        Fluttertoast.showToast(msg: "Terjadi Kesalahan Server");
        setState(() {
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Request failed with status: ${getToken.statusCode}");
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

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    if (user.displayName != '' || user.displayName != null) {
      Navigator.pushNamed(context, '/dashboard');
    }
    return user;
  }

  // void signfacebook() async {
  //   var facebooklogin = await FacebookLogin();
  //   var result = await facebooklogin.logIn(['email']);
  //   final token = result.accessToken.token;
  //   final graphResponse = await http.get(
  //       'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  //   final profile = json.decode(graphResponse.body);
  //   print(profile);
  //   if (profile != null) {
  //     Navigator.pushNamed(context, '/dashboard');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      controller: username,
      autofocus: true,
      obscureText: false,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Alamat Email",
          errorText: validateEmail ? "email tidak boleh kosong":null,
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
          errorText: validatePassword ? "password tidak boleh kosong":null,
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
        onPressed: _isLoading == true ? null : () async {
          //login();
          _login();
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CobaApps()));
        },
        child: Text(
          _isLoading == true ? "Tunggu Sebentar" :"Masuk" ,
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
            padding: const EdgeInsets.only(top:27.0,left: 27.0,right: 27.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 160.0,
                    child: Center(
                      child: Image.asset(
                        "images/logo.png",
                        height: 500.0,
                        width: 500.0,
                      ),
                    ),
                  ),
                
                  usernameField,
                  SizedBox(height: 15.0),
                  passwordField,
                  SizedBox(
                    height: 15.0,
                  ),
                  loginButton,
                  // Container(
                  //   margin: EdgeInsets.only(top: 20.0),
                  //   width: double.infinity,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Expanded(
                  //         flex: 3,
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //               border: BorderDirectional(
                  //             bottom:
                  //                 BorderSide(width: 1 / 2, color: Colors.grey),
                  //           )),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 6,
                  //         child: Center(
                  //           child: Text(
                  //             'Login Dengan',
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 fontFamily: 'Roboto',
                  //                 color: Colors.grey,
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 12),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 3,
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //               border: BorderDirectional(
                  //             bottom:
                  //                 BorderSide(width: 1 / 2, color: Colors.grey),
                  //           )),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.0,
                  // ),
                  Container(
                  padding: EdgeInsets.only(top:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Belum Memiliki Akun ?',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500),),
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
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    ],
                  ),
                )
                  // adsSection,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
