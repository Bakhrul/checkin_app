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
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:email_validator/email_validator.dart';

List<ListUserAdd> listUseradd = [];
String tokenType, accessToken;
bool isLoading, isError;
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
  ProgressDialog progressApiAction;
  void initState() {
    getHeaderHTTP();
    isLoading = true;
    isError = false;
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
    return listAdminEvent();
  }

  Future<List<ListUserAdd>> listAdminEvent() async {
    setState(() {
      isLoading = true;
      listUseradd.clear();
      listUseradd = [];
    });
    try {
      final getAdmin = await http.post(
        url('api/admin_createevent'),
        body: {
          'event': widget.event,
        },
        headers: requestHeaders,
      );

      if (getAdmin.statusCode == 200) {
        var adminEventJson = json.decode(getAdmin.body);
        var admins = adminEventJson['admin'];
        setState(() {
          listUseradd.clear();
          listUseradd = [];
        });

        for (var i in admins) {
          ListUserAdd donex = ListUserAdd(
            id: '${i['us_id']}',
            nama: i['us_name'],
            email: i['us_email'],
          );
          listUseradd.add(donex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getAdmin.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        print(getAdmin.body);
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
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
    try {
      Navigator.pop(context);
      await progressApiAction.show();
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
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
          getHeaderHTTP();
          Fluttertoast.showToast(msg: "Berhasil !");
        } else if (addadmineventJson['status'] == 'user tidak terdaftar') {
          Fluttertoast.showToast(
              msg: "Email Yang Belum Memiliki Akun Pengguna!");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        } else if (addadmineventJson['status'] == 'sudah terdaftar') {
          Fluttertoast.showToast(
              msg: "Email Tersebut Sudah Terdaftar Pada Admin Anda !");
          progressApiAction.hide().then((isHidden) {
            print(isHidden);
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        progressApiAction.hide().then((isHidden) {
          print(isHidden);
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Timed out, Try again");
      progressApiAction.hide().then((isHidden) {
        print(isHidden);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
      progressApiAction.hide().then((isHidden) {
        print(isHidden);
      });
      print(e);
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    progressApiAction = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressApiAction.style(
        message: 'Tunggu Sebentar...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600));
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
            onPressed: () {
                    showAddModalAdmin();
                  },
          ),
        ],
      ),
      body: isLoading == true
          ? loadingView()
          : isError == true
              ? RefreshIndicator(
                  onRefresh: () => getHeaderHTTP(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(children: <Widget>[
                      new Container(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset("images/system-eror.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Center(
                          child: Text(
                            "Gagal Memuat Halaman, Tekan Tombol Muat Ulang Halaman Untuk Refresh Halaman",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 15.0, right: 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.white,
                            textColor: Color.fromRGBO(41, 30, 47, 1),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(15.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () async {
                              getHeaderHTTP();
                            },
                            child: Text(
                              "Muat Ulang Halaman",
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                )
              : listUseradd.length == 0
                  ? RefreshIndicator(
                      onRefresh: () => getHeaderHTTP(),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
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
                      ))
                  : Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Scrollbar(
                                child: RefreshIndicator(
                                    onRefresh: () => getHeaderHTTP(),
                                    child: ListView.builder(
                                        itemCount: listUseradd.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                              elevation: 0.5,
                                              child: ListTile(
                                                leading: ButtonTheme(
                                                    minWidth: 0.0,
                                                    child: FlatButton(
                                                      color: Colors.white,
                                                      textColor: Colors.red,
                                                      disabledColor:
                                                          Colors.white,
                                                      disabledTextColor:
                                                          Colors.red[400],
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      splashColor:
                                                          Colors.blueAccent,
                                                      child: Icon(
                                                        Icons.close,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          await progressApiAction
                                                              .show();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Mohon Tunggu Sebentar");
                                                          final addadminevent =
                                                              await http.post(
                                                                  url(
                                                                      'api/delete_opsicreateevent'),
                                                                  headers:
                                                                      requestHeaders,
                                                                  body: {
                                                                'event': widget
                                                                    .event,
                                                                'admin':
                                                                    listUseradd[
                                                                            index]
                                                                        .email,
                                                                'typehapusadmin':
                                                                    'admin',
                                                              });

                                                          if (addadminevent
                                                                  .statusCode ==
                                                              200) {
                                                            var addadmineventJson =
                                                                json.decode(
                                                                    addadminevent
                                                                        .body);
                                                            if (addadmineventJson[
                                                                    'status'] ==
                                                                'success') {
                                                              setState(() {
                                                                listUseradd.remove(
                                                                    listUseradd[
                                                                        index]);
                                                              });
                                                              progressApiAction
                                                                  .hide()
                                                                  .then(
                                                                      (isHidden) {
                                                                print(isHidden);
                                                              });
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Berhasil !");
                                                            }
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Gagal, Silahkan Coba Kembali");
                                                            progressApiAction
                                                                .hide()
                                                                .then(
                                                                    (isHidden) {
                                                              print(isHidden);
                                                            });
                                                          }
                                                        } on TimeoutException catch (_) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Timed out, Try again");
                                                          progressApiAction
                                                              .hide()
                                                              .then((isHidden) {
                                                            print(isHidden);
                                                          });
                                                        } catch (e) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Gagal, Silahkan Coba Kembali");
                                                          progressApiAction
                                                              .hide()
                                                              .then((isHidden) {
                                                            print(isHidden);
                                                          });
                                                          print(e);
                                                        }
                                                      },
                                                    )),
                                                title: Text(listUseradd[index]
                                                                .nama ==
                                                            null ||
                                                        listUseradd[index]
                                                                .nama ==
                                                            ''
                                                    ? 'Unknown Nama'
                                                    : listUseradd[index].nama),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 15.0),
                                                  child: Text(listUseradd[index]
                                                              .email ==
                                                          null
                                                      ? 'Unknown Email'
                                                      : listUseradd[index]
                                                          .email),
                                                ),
                                              ));
                                        }))))
                      ])),
      floatingActionButton: _bottomButtons(),
    );
  }

  Widget loadingView() {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 25.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8]
                    .map((_) => Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRect(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.white,
                                  ),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                    ),
                                    Container(
                                      width: 100.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          )),
    );
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () async {
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
