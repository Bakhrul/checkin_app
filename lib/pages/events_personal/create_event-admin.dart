import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'create_admin.dart';
import 'create_event-checkin.dart';
import 'dart:convert';
import 'package:checkin_app/storage/storage.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'model.dart';
import 'package:checkin_app/utils/utils.dart';

import 'package:email_validator/email_validator.dart';

List<ListUserAdd> listUseradd = [];
String tokenType, accessToken;
bool isCreate, isDelete;
TextEditingController _controllerAddadmin = TextEditingController();
Map<String, String> requestHeaders = Map();

class ManajemenCreateEventAdmin extends StatefulWidget {
  ManajemenCreateEventAdmin({Key key, this.title, this.event})
      : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenCreateEventAdminState();
  }
}

class _ManajemenCreateEventAdminState extends State<ManajemenCreateEventAdmin> {
  void initState() {
    getHeaderHTTP();
    isCreate = false;
    isDelete = false;
    super.initState();
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

  void showAddModalAdmin() {
    setState(() {
      _controllerAddadmin.text = '';
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            height: 200.0 + MediaQuery.of(context).viewInsets.bottom,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: 15.0,
                left: 15.0,
                top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: TextField(
                      controller: _controllerAddadmin,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan Email Admin/Pengelola',
                          hintStyle: TextStyle(
                            fontSize: 12,
                          )),
                    )),
                Center(
                    child: Container(
                        width: double.infinity,
                        height: 45.0,
                        child: RaisedButton(
                            onPressed: isCreate == true
                                ? null
                                : () async {
                                    String emailValid =
                                        _controllerAddadmin.text;
                                    final bool isValid =
                                        EmailValidator.validate(emailValid);

                                    // print('Email is valid? ' +
                                    //     (isValid ? 'yes' : 'no'));
                                    if (_controllerAddadmin.text == null ||
                                        _controllerAddadmin.text == '') {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Email Tidak Boleh Kosong");
                                    } else if (!isValid) {
                                      Fluttertoast.showToast(
                                          msg: "Masukkan Email Yang Valid");
                                    } else {
                                      _tambahadmin(_controllerAddadmin.text);
                                    }
                                  },
                            color: primaryAppBarColor,
                            textColor: Colors.white,
                            disabledColor: Color.fromRGBO(254, 86, 14, 0.7),
                            disabledTextColor: Colors.white,
                            splashColor: Colors.blueAccent,
                            child: isCreate == true
                                ? Container(
                                    height: 25.0,
                                    width: 25.0,
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white)))
                                : Text("Tambahkan Admin",
                                    style: TextStyle(color: Colors.white)))))
              ],
            ),
          );
        });
  }

  void _tambahadmin(admin) async {
    setState(() {
      isCreate = true;
    });
    Navigator.pop(context);
    
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      print(widget.event);
      final addadminevent = await http
          .post(url('api/createcheckin'), headers: requestHeaders, body: {
        'event': widget.event,
        'email': admin,
        'typeadmin': 'admin',
      });

      if (addadminevent.statusCode == 200) {
        var addadmineventJson = json.decode(addadminevent.body);
        if (addadmineventJson['status'] == 'success') {
          setState(() {
            isCreate = false;
          });
          setState(() {
            ListUserAdd notax = ListUserAdd(
              email: admin,
            );
            listUseradd.add(notax);
          });
          Fluttertoast.showToast(msg: "Berhasil !");
        } else if (addadmineventJson['status'] == 'user tidak terdaftar') {
          Fluttertoast.showToast(
              msg: "Email Yang Belum Memiliki Akun EventZhee!");
          setState(() {
            isCreate = false;
          });
        } else if (addadmineventJson['status'] == 'sudah terdaftar') {
          Fluttertoast.showToast(
              msg: "Email Tersebut Sudah Terdaftar Pada Admin Anda !");
          setState(() {
            isCreate = false;
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        setState(() {
          isCreate = false;
        });
      }
    try {
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Timed out, Try again");
      setState(() {
        isCreate = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
      setState(() {
        isCreate = false;
      });
      print(e);
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: primaryAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Event Baru - Tambah Admin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            tooltip: 'Tambah Admin',
            onPressed: isCreate == true || isDelete == true ? null : () {
              showAddModalAdmin();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isCreate == true || isDelete == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: 15.0,
                            margin: EdgeInsets.only(top: 10.0, right: 15.0),
                            height: 15.0,
                            child: CircularProgressIndicator()),
                      ],
                    )
                  : Container(),
              listUseradd.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(children: <Widget>[
                        new Container(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset("images/empty-white-box.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Center(
                            child: Text(
                              "Admin Event Belum Ditambahkan / Masih Kosong",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black45,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: listUseradd.reversed
                            .map((ListUserAdd item) => Card(
                                    child: ListTile(
                                  leading: ButtonTheme(
                                      minWidth: 0.0,
                                      child: FlatButton(
                                        color: Colors.white,
                                        textColor: Colors.red,
                                        disabledColor: Colors.white,
                                        disabledTextColor: Colors.red[400],
                                        padding: EdgeInsets.all(15.0),
                                        splashColor: Colors.blueAccent,
                                        child: Icon(
                                          Icons.close,
                                        ),
                                        onPressed: isDelete == true || isCreate == true ? null : () async {
                                          setState(() {
                                            isDelete = true;
                                          });
                                          
                                          try {
                                            Fluttertoast.showToast(
                                                msg: "Mohon Tunggu Sebentar");
                                            final addadminevent = await http.post(
                                                url('api/delete_opsicreateevent'),
                                                headers: requestHeaders,
                                                body: {
                                                  'event': widget.event,
                                                  'admin': item.email,
                                                  'typehapusadmin': 'admin',
                                                });

                                            if (addadminevent.statusCode ==
                                                200) {
                                              var addadmineventJson = json
                                                  .decode(addadminevent.body);
                                              if (addadmineventJson['status'] ==
                                                  'success') {                                                
                                                setState(() {
                                                  listUseradd.remove(item);
                                                  isDelete = false;
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "Berhasil !");
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Gagal, Silahkan Coba Kembali");
                                              setState(() {
                                                isDelete = false;
                                              });
                                            }
                                          } on TimeoutException catch (_) {
                                            Fluttertoast.showToast(
                                                msg: "Timed out, Try again");
                                            setState(() {
                                              isDelete = false;
                                            });
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Gagal, Silahkan Coba Kembali");
                                            setState(() {
                                              isDelete = false;
                                            });
                                            print(e);
                                          }
                                        },
                                      )),
                                  title: Text(item.email == null
                                      ? 'Unknown Email'
                                      : item.email),
                                )))
                            .toList(),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: _bottomButtons(),
    );
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: isCreate == true || isDelete == true
            ? null
            : () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManajemenCreateEventCheckin(
                              event: widget.event,
                            )));
              },
        backgroundColor: primaryButtonColor,
        child: Icon(
          Icons.chevron_right,
          size: 25.0,
        ));
  }
}
