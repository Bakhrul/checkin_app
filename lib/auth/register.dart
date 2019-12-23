import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

TextEditingController namadepan = TextEditingController();
TextEditingController namabelakang = TextEditingController();
TextEditingController email = TextEditingController();

class Register extends StatefulWidget{
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register>{

  register(){

  }

  @override
  Widget build(BuildContext context) {
    final namaField = TextField(
      controller: namadepan,
      autofocus: true,
      obscureText: false,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nama Depan",
          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black38, fontSize: 14),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black38)),
          border:
          OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
            ),
          )
      ),
    );

    final emailField = TextField(
      controller: namabelakang,
      autofocus: true,
      obscureText: false,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nama Belakang",
          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black38, fontSize: 14),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black38)),
          border:
          OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
            ),
          )
      ),
    );

    final usernameField = TextField(
      controller: email,
      autofocus: true,
      obscureText: false,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email / HP",
          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black38, fontSize: 14),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black38)),
          border:
          OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
            ),
          )
      ),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(3.0),
      color: Color.fromRGBO(54, 55, 84, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          register();
        },
        child: Text("Daftar",
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
    final adsSection = Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Text(
            "Belum Menggunakan Alamraya Software+ ?",
            style: TextStyle(
              color: Colors.grey[500],
              fontFamily: 'Roboto',
              fontSize: 11.0,
            ),
          ),
          SizedBox(height: 10),
          OutlineButton(
            padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/login');
            },
            child: Text("Kembali",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Roboto',
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
    final footer = Text(
      "Powered by Alamraya Software v.1.0 © 2019",
      style: TextStyle(
        color: Colors.grey,
        fontFamily: 'Roboto',
        fontSize: 10.0
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(27.0),
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
                        "images/logo_alamraya.jpg",
                        height: 500.0,
                        width: 500.0,
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(width: 1 , color: Colors.black45),
                              )
                            ),
                          ),
                        ),

                        Expanded(
                          child:  Center(
                            child: Text('Register',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(width: 1 , color: Colors.black45),
                              )
                            ),
                          ),
                        ),

                        
                      ],  
                    ),
                  ),

                  SizedBox(height: 20.0),
                  namaField,
                  SizedBox(height: 15.0),
                  emailField,
                  SizedBox(height: 15.0),
                  usernameField,
                  SizedBox(
                    height: 15.0,
                  ),
                  loginButton,
                  SizedBox(
                    height: 15.0,
                  ),
                adsSection,
                SizedBox(
                  height: 15.0,
                ),
                footer,
                SizedBox(
                  height: 1.0,
                )
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }
}