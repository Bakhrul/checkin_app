import 'dart:convert';

import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'step_register_three.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:email_validator/email_validator.dart';

class ConfirmEventGuest extends StatefulWidget {
  ConfirmEventGuest({Key key, this.id, this.creatorId, this.dataUser})
      : super(key: key);
  final int id;
  final String creatorId;
  final Map dataUser;

  State<StatefulWidget> createState() {
    return _ConfirmEventGuest();
  }
}

class _ConfirmEventGuest extends State<ConfirmEventGuest> {

  bool _isLoading = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  Future postRegister() async {
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
    String fullName =
        firstNameController.text.toString() + ' ' + lastNameController.text.toString();
    Map<String, dynamic> body = {
      'event_id': widget.id.toString(),
      'creator_id': widget.creatorId.toString(),
      'email': emailController.text.toString(),
      'namalengkap': fullName.toString(),
      'alamat': addressController.text.toString(),
      'nohp': phoneController.text.toString(),
      'position': '3',
      'status': 'P',
      'type' : 'someone',
    };

    try {
      final ongoingevent = await http.post(url('api/event/register'),
          headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        
        setState(() {
          _isLoading = false;
        });
        
        var datasToJson = json.decode(ongoingevent.body);
        if(datasToJson['status'] == 'success'){
            String idUser = datasToJson['user_id'].toString();
            return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WaitingEvent(
                  id: widget.id, creatorId: widget.creatorId, selfEvent: false, userId: idUser, type: 'someone',dataUser: widget.dataUser,),
            ));
        }else if(datasToJson['status'] == 'emailsudahada'){
          Fluttertoast.showToast(msg: 'Email Sudah Digunakan, Mohon Gunakan Email Lainnya');

        }else if(datasToJson['status'] == 'emailsendiri'){
          Fluttertoast.showToast(msg: 'Mohon Gunakan Menu Daftar Untuk Diri Sendiri');
        }
        
      } else if (ongoingevent.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Gagal Mendaftar');
        print(ongoingevent.body);
        setState(() {
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: 'Gagal Mendaftar');
        setState(() {
          _isLoading = false;
        });
        print(ongoingevent.body);
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
                                        child: Text("Nama Depan",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ))),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 15,
                                            right: 15),
                                        child: TextFormField(
                                          enabled: true,
                                          controller: firstNameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            border: OutlineInputBorder(),
                                            hintText: 'Nama Depan',
                                          ),
                                        ))
                                  ],
                                ))),
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
                                            right: 7),
                                        child: Text("Nama Belakang",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ))),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 7,
                                            right: 15),
                                        child: TextFormField(
                                          enabled: true,
                                          controller: lastNameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            border: OutlineInputBorder(),
                                            hintText: 'Nama Belakang',
                                          ),
                                        ))
                                  ],
                                )))
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
                                child: Text("Alamat Lengkap",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ))),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: TextFormField(
                                  enabled: true,
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    border: OutlineInputBorder(),
                                    hintText: 'Alamat',
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
                                child: Text("Email",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ))),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: TextFormField(
                                  enabled: true,
                                  controller: emailController,
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
                                child: Text("No Telepon",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ))),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  enabled: true,
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    border: OutlineInputBorder(),
                                    hintText: 'No Telepon',
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
                                    onPressed: _isLoading == true ? null :  () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                       String emailValid = emailController.text;
                                       final bool isValid = EmailValidator.validate(emailValid);
                                      if(firstNameController.text == '' || firstNameController.text == null){
                                        Fluttertoast.showToast(msg: 'Nama Depan Tidak Boleh Kosong');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }else if(lastNameController.text == '' || lastNameController.text == null){
                                        Fluttertoast.showToast(msg: 'Nama Belakang Tidak Boleh Kosong');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }else if(addressController.text == '' || addressController.text == null){
                                        Fluttertoast.showToast(msg: 'Alamat Lengkap Tidak Boleh Kosong');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }else if(emailController.text == '' || emailController.text == null){
                                        Fluttertoast.showToast(msg: 'Email Tidak Boleh Kosong');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }else if(!isValid){
                                        Fluttertoast.showToast(msg: 'Masukkan Email Yang Valid');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                      else if(phoneController.text == '' || phoneController.text == null){
                                        Fluttertoast.showToast(msg: 'No. Telp Tidak Boleh Kosong');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }else{
                                        postRegister();
                                      }
                                    }))
                          ],
                        ))
                  ],
                ))));
  }
}
