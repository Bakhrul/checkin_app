import 'dart:convert';

import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'step_register_three.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class ConfirmEvent extends StatefulWidget {
  final int id;
  final String creatorId;
  final Map dataUser;

  ConfirmEvent({Key key, this.id, this.creatorId, this.dataUser})
      : super(key: key);

  State<StatefulWidget> createState() {
    return _ConfirmEvent();
  }
}

class _ConfirmEvent extends State<ConfirmEvent> {
  bool _isLoading = false;
  // final emailController = TextEditingController();
  // final addressController = TextEditingController();
  // final numberPhoneController = TextEditingController();
  // final nameController = TextEditingController();

  @override
  void initState() {
    print(widget.dataUser);
    super.initState();
  }

  Future _registerSelf() async {
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

    Map<String, dynamic> body = {
      'event_id': widget.id.toString(),
      'creator_id': widget.creatorId.toString(),
      'email': widget.dataUser['us_email'],
      'position': '3',
      'status': 'P',
      'type' : 'self',
    };

    try {
      final ongoingevent = await http.post(url('api/event/register'),
          headers: requestHeaders, body: body);

      var datasToJson = json.decode(ongoingevent.body);

      if (ongoingevent.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        if(datasToJson['status'] == 'emailsendiri'){
          Fluttertoast.showToast(msg: 'Mohon Gunakan Menu Daftar Untuk Diri Sendiri');
        }else if(datasToJson['status'] == 'emailsudahada'){
           Fluttertoast.showToast(msg: 'Email Sudah Digunakan, Mohon Gunakan Email Lainnya');
        }else if(datasToJson['status'] == 'success'){
          String idUser = datasToJson['user_id'].toString();
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WaitingEvent(
                id: widget.id,
                creatorId: widget.creatorId,
                selfEvent: false,
                dataUser : widget.dataUser,
                userId: idUser,
                type: 'self',
              ),
            ));
        }
        
      } else if (ongoingevent.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Gagal mendaftar');
        setState(() {
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: 'Gagal mendaftar');
        setState(() {
          _isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Time out, silahkan coba lagi nanti');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   emailController.dispose();
  //   addressController.dispose();
  //   numberPhoneController.dispose();
  //   nameController.dispose();
  //   super.dispose();
  // }

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
            "Form Pendaftaran Event",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: primaryAppBarColor,
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 15,
                                            right: 15),
                                        child: Text("Nama",
                                            style: TextStyle(
                                              fontSize: 17,
                                            ))),
                                    Container(
                                        color: Color.fromRGBO(241, 241, 241, 1),
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 15,
                                            right: 15),
                                        child: TextFormField(
                                          enabled: false,
                                          // controller: nameController,
                                          initialValue:
                                              widget.dataUser['us_name'],
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            border: OutlineInputBorder(),
                                            hintText: 'nama',
                                          ),
                                        ))
                                  ],
                                ))),
                        // Expanded(
                        //   child:Container(
                        //     padding:EdgeInsets.only(top:5,bottom:5),
                        //     child:Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Container(
                        //           margin: EdgeInsets.only(top:5,bottom:5,left:15,right:7),
                        //           child:Text("Nama Belakang",style:TextStyle(
                        //             fontSize: 17,
                        //           ))
                        //         ),
                        //         Container(
                        //           color: Color.fromRGBO(241,241,241,1),
                        //           margin: EdgeInsets.only(top:5,bottom:5,left:7,right:15),
                        //           child:TextFormField(
                        //             initialValue: "zakaria",
                        //             enabled: false,
                        //             decoration: InputDecoration(
                        //               contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                        //               border: OutlineInputBorder(),
                        //               hintText: 'Password',
                        //             ),
                        //           )
                        //         )
                        //       ],
                        //     )
                        //   )
                        // )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: Text("Email",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ))),
                            Container(
                                color: Color.fromRGBO(241, 241, 241, 1),
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: TextFormField(
                                  initialValue: widget.dataUser['us_email'],
                                  // controller: emailController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    border: OutlineInputBorder(),
                                    hintText: 'Email',
                                  ),
                                ))
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: Text("Alamat",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ))),
                            Container(
                                color: Color.fromRGBO(241, 241, 241, 1),
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: TextFormField(
                                  initialValue: widget.dataUser['us_location'],
                                  enabled: false,
                                  // controller: addressController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    border: OutlineInputBorder(),
                                    hintText: null,
                                  ),
                                ))
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: Text("No Telp",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ))),
                            Container(
                                color: Color.fromRGBO(241, 241, 241, 1),
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: TextFormField(
                                  initialValue: widget.dataUser['us_phone'],
                                  enabled: false,
                                  // controller: numberPhoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    border: OutlineInputBorder(),
                                  ),
                                ))
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[                           
                            Container(
                                margin: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 15, right: 15),
                                width: double.infinity,
                                child: RaisedButton(
                                    color: Colors.green,
                                    disabledColor: Colors.green[400],
                                    padding: EdgeInsets.all(15.0),
                                    child: _isLoading == true
                                        ? Container(
                                            height: 25.0,
                                            width: 25.0,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.white)))
                                        : Text('Selanjutnya',
                                            style:
                                                TextStyle(color: Colors.white)),
                                    onPressed: _isLoading == true
                                        ? null
                                        : () {
                                            _registerSelf();
                                          }))
                          ],
                        ))
                  ],
                ))));
  }
}
