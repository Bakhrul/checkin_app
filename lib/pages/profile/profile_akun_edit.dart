import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/profile/image_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

String tokenType, accessToken;
String validatePasswordLama, validatePasswordBaru, validateConfirmPassword;
Map<String, String> requestHeaders = Map();
File imageProfileEdit;

class ProfileUserEdit extends StatefulWidget {
  ProfileUserEdit({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileUserEdit();
  }
}

class _ProfileUserEdit extends State<ProfileUserEdit> {
  String namaData;
  String emailData;
  String phoneData;
  String locationData;
  File profileImageData;
  bool load = false;
  var storageApp = new DataStore();
  TextEditingController _controllerNama = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerLocation = new TextEditingController();
  TextEditingController _controllerPasswordLama = new TextEditingController();
  TextEditingController _controllerPasswordBaru = new TextEditingController();
  TextEditingController _controllerConfirmPassword =
      new TextEditingController();

  @override
  void initState() {
    _getUser();
    validatePasswordLama = null;
    validatePasswordBaru = null;
    validateConfirmPassword = null;
    _controllerNama.addListener(nameEdit);
    _controllerEmail.addListener(emailEdit);
    _controllerPhone.addListener(phoneEdit);
    _controllerLocation.addListener(locationEdit);

    getHeaderHTTP();

    super.initState();
  }

  nameEdit() {
    setState(() {
      namaData = _controllerNama.text;
    });
  }

  emailEdit() {
    setState(() {
      emailData = _controllerEmail.text;
    });
  }

  phoneEdit() {
    setState(() {
      phoneData = _controllerPhone.text;
    });
  }

  locationEdit() {
    setState(() {
      locationData = _controllerLocation.text;
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
  }

  _getUser() async {
    DataStore user = new DataStore();
    String namaUser = await user.getDataString('name');
    String emailUser = await user.getDataString('email');
    String phoneUser = await user.getDataString('phone');
    String locationUser = await user.getDataString('location');

    setState(() {
      namaData = namaUser;
      emailData = emailUser;
      phoneData = phoneUser;
      locationData = locationUser;
      _controllerNama.text = namaUser;
      _controllerEmail.text = emailUser;
      _controllerPhone.text = phoneUser;
      _controllerLocation.text = locationUser;
    });
  }

  void _showPasswordModal() {
    setState(() {
      _controllerPasswordLama.text = '';
      _controllerPasswordBaru.text = '';
      _controllerConfirmPassword.text = '';
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            margin: EdgeInsets.only(top: 40.0),
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text('Password Lama',
                        style: TextStyle(color: Colors.black45))),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      obscureText: true,
                      controller: _controllerPasswordLama,
                      decoration: InputDecoration(
                        errorText: validatePasswordLama == null
                            ? null
                            : validatePasswordLama,
                      ),
                    )),
                Container(
                    child: Text('Password Baru',
                        style: TextStyle(color: Colors.black45))),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      obscureText: true,
                      controller: _controllerPasswordBaru,
                      decoration: InputDecoration(
                        errorText: validatePasswordBaru == null
                            ? null
                            : validatePasswordBaru,
                      ),
                    )),
                Container(
                    child: Text('Konfirmasi Password Baru',
                        style: TextStyle(color: Colors.black45))),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText: validateConfirmPassword == null
                            ? null
                            : validateConfirmPassword,
                      ),
                      controller: _controllerConfirmPassword,
                    )),
                Center(
                    child: Container(
                        width: double.infinity,
                        height: 45.0,
                        child: RaisedButton(
                            onPressed: load == true ? null : () async {
                              editData('Y');
                            },
                            color: primaryAppBarColor,
                            textColor: Colors.white,
                            disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                            disabledTextColor: Colors.white,
                            splashColor: Colors.blueAccent,
                            child: load == true
                              ? Container(
                                  height: 25.0,
                                  width: 25.0,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white)))
                              :  Text("Ubah password",
                                style: TextStyle(color: Colors.white)))))
              ],
            ),
          );
        });
  }

  editData(password) async {
    if (load) {
      return false;
    }
    Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
    if (password == 'Y') {
      if (_controllerPasswordLama.text == '') {
        Fluttertoast.showToast(msg: "Password Lama Tidak Boleh Kosong");
        return false;
      } else if (_controllerPasswordBaru.text == '') {
        Fluttertoast.showToast(msg: "Password Baru Tidak Boleh Kosong");
        return false;
      } else if (_controllerConfirmPassword.text == '') {
        Fluttertoast.showToast(
            msg: "Konfirmasi Password Baru Tidak Boleh Kosong");
        return false;
      } else if (_controllerPasswordBaru.text !=
          _controllerConfirmPassword.text) {
        Fluttertoast.showToast(
            msg: "Password Baru Dan Konfirmasi Password Baru Harus Sama");
        return false;
      }
    }

    setState(() {
      load = true;
    });

    Map body = {
      "name": namaData,
      "ispassword": password,
      'oldpassword': _controllerPasswordLama.text,
      'newpassword': _controllerPasswordBaru.text,
      'confirmpassword': _controllerConfirmPassword.text,
      "email": emailData,
      "phone": phoneData != '-' ? phoneData : '',
      "location": locationData != '-' ? locationData : ''
    };

    try {
      var data = await http.post(url('api/userUpdate'),
          headers: requestHeaders,
          body: body,
          encoding: Encoding.getByName("utf-8"));

      print(data.body);

      var dataUserToJson = json.decode(data.body);
      if (data.statusCode == 200) {
        if (dataUserToJson['status'] == 'password baru tidak sama') {
          Fluttertoast.showToast(
              msg: "Password Baru Dan Konfirmasi Password Baru Tidak Sama");
          setState(() {
            load = false;
          });
        } else if (dataUserToJson['status'] == 'password lama tidak sama') {
          Fluttertoast.showToast(msg: "Password Lama Tidak Sama");
          setState(() {
            load = false;
          });
        } else if (dataUserToJson['status'] == 'emailnotavailable') {
          Fluttertoast.showToast(msg: "Email Sudah Digunakan");
          setState(() {
            load = false;
          });
        } else if (dataUserToJson['status'] == 'success') {
          storageApp.setDataString("name", body['name']);
          storageApp.setDataString("email", body['email']);
          storageApp.setDataString(
              "phone", body['phone'] == '' ? '-' : body['phone']);
          storageApp.setDataString(
              "location", body['location'] == '' ? '-' : body['location']);

          setState(() {
            usernameprofile = body['name'];
            emailprofile = body['email'];
            namaStore = namaData;
            emailStore = emailData;
            phoneStore = body['phone'] == '' ? '-' : body['phone'];
            locationStore = body['location'] == '' ? '-' : body['location'];
            load = false;
          });

          Fluttertoast.showToast(msg: "Berhasil");

          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
          setState(() {
            load = false;
          });
        }
      } else {
        setState(() {
          load = false;
        });
        Fluttertoast.showToast(msg: "Error: Gagal Memperbarui");
      }
    } on TimeoutException catch (_) {
      setState(() {
        load = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } on SocketException catch (_) {
      setState(() {
        load = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    } catch (e) {
      setState(() {
        load = false;
      });
      Fluttertoast.showToast(msg: "$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: primaryAppBarColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            color: primaryAppBarColor,
          ),
          Container(
              child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImageEdit()));
                },
                child: imageStore == '-'
                    ? Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 90,
                        width: 90,
                        child: ClipOval(
                            child: Image.asset('images/imgavatar.png',
                                fit: BoxFit.fill)))
                    : Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 90,
                        width: 90,
                        child: ClipOval(
                            child: imageProfileEdit == null
                                ? FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: 'images/imgavatar.png',
                                    image: url(
                                        'storage/image/profile/$imageStore'))
                                : Image.file(imageProfileEdit))),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: Text(namaData == null ? 'memuat..' : namaData,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50.0),
                child: Text(locationData == null ? 'memuat..' : locationData,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    )),
              ),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 50.0,
                    right: 50.0,
                    top: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Text('Nama',
                              style: TextStyle(color: Colors.grey))),
                      Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: TextField(
                            controller: _controllerNama,
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child:
                            Text('Email', style: TextStyle(color: Colors.grey)),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: TextField(
                            enabled: false,
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.lock, size: 20.0)),
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text('No Telp',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _controllerPhone,
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text('Alamat',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: TextField(
                            controller: _controllerLocation,
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text('Password',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('********'),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                'Ganti Password',
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            onPressed: _showPasswordModal,
                          ),
                        ],
                      ),
                    ],
                  )),
              Center(
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 50.0),
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: load == true ? null : () {
                            editData('N');
                          },
                          color: primaryAppBarColor,
                          textColor: Colors.white,
                          disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                          disabledTextColor: Colors.white,
                          splashColor: Colors.blueAccent,
                          child: load == true
                              ? Container(
                                  height: 25.0,
                                  width: 25.0,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white)))
                              : Text("Simpan Data",
                                  style: TextStyle(color: Colors.white)))))
            ],
          ))
        ],
      )),
    );
  }
}
