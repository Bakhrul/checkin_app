import 'package:checkin_app/auth/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'dart:convert';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

Map<String, dynamic> formSerialize;
Map<String, String> requestHeaders = Map();
TextEditingController namalengkap = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
bool isLoading, isRegister;

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  void initState() {
    super.initState();
    isLoading = true;
    isRegister = false;
    namalengkap.text = '';
    email.text = '';
    password.text = '';
  }

  void dispose() {
    super.dispose();
  }

  void register() async {
    setState(() {
      isRegister = true;
    });
    formSerialize = Map<String, dynamic>();
    formSerialize['namakelengkap'] = null;
    formSerialize['email'] = null;
    formSerialize['password'] = null;
    formSerialize['namalengkap'] = namalengkap.text;
    formSerialize['email'] = email.text;
    formSerialize['password'] = password.text;

    print(formSerialize);

    Map<String, dynamic> requestHeadersX = requestHeaders;

    requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
    try {
      final response = await http.post(
        url('api/registeruser'),
        // headers: requestHeadersX,
        body: {
          'type_platform': 'android',
          'data': jsonEncode(formSerialize),
        },
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        if (responseJson['status'] == 'success') {
          Fluttertoast.showToast(msg: "Berhasil Mendaftarkan Akun");
          setState(() {
            isRegister = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (responseJson['status'] == 'emailnotavailable') {
          Fluttertoast.showToast(
              msg: "Email telah digunakan, mohon gunakan email lainnya");
          setState(() {
            isRegister = false;
          });
        }
        print('response decoded $responseJson');
      } else {
        print('${response.body}');
        Fluttertoast.showToast(
            msg: "Gagal Mendaftarkan Akun Silahkan Coba Kembali");
        setState(() {
          isRegister = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(
          msg: "Gagal Mendaftarkan Akun, Silahkan Coba Kembali");
      setState(() {
        isRegister = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mendaftarkan Akun, Silahkan Coba Kembali");
      setState(() {
        isRegister = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final namaField = TextField(
      controller: namalengkap,
      autofocus: true,
      obscureText: false,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nama Lengkap",
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

    final emailField = TextField(
      controller: email,
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
          hintText: "Password",
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
      color: Color.fromRGBO(54, 55, 84, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: isRegister == true ? null : () async {
          setState(() {
            isLoading = true;
          });
          if (namalengkap.text == null || namalengkap.text == '') {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Nama Lengkap Tidak Boleh Kosong");
          } else if (email.text == null || email.text == '') {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Email Tidak Boleh Kosong");
          } else if (password.text == null || password.text == '') {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Password Tidak Boleh Kosong");
          } else {
            register();
          }
        },
        child: Text(
          isRegister == true ? "Mohon Tunggu Sebentar" :"Daftar Sekarang",
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
                namaField,
                SizedBox(height: 15.0),
                emailField,
                SizedBox(height: 15.0),
                passwordField,
                SizedBox(
                  height: 15.0,
                ),
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
                      textColor: Color.fromRGBO(41, 30, 47, 1),
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
      // ),
    );
  }
}
