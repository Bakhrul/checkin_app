import 'package:flutter/material.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'manage_admin.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';

bool isLoading, isError, isFilter, isErrorfilter, isCreate;
TextEditingController _filtercontroller = new TextEditingController();
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
var datepicker;
List<ListUser> listUserItem = [];
final _debouncer = Debouncer(milliseconds: 500);

class ManajemenTambahAdmin extends StatefulWidget {
  ManajemenTambahAdmin({Key key, this.title, this.event}) : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreatePesertaState();
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ManajemeCreatePesertaState extends State<ManajemenTambahAdmin> {
  @override
  void initState() {
    datepicker = FocusNode();
    super.initState();
    isLoading = true;
    isCreate = false;
    isFilter = false;
    isErrorfilter = false;
    getHeaderHTTP();
  }

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);
    return listUser();
  }

  Future<List<List>> listUser() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
    });
    try {
      final getUser = await http.post(
        url('api/getdataparticipant'),
        headers: requestHeaders,
      );

      if (getUser.statusCode == 200) {
        var listuserJson = json.decode(getUser.body);
        var listUsers = listuserJson['participant'];
        listUserItem = [];
        for (var i in listUsers) {
          ListUser willcomex = ListUser(
            id: '${i['us_code']}',
            nama: i['us_name'],
            email: i['us_email'],
            image: i['us_image'],
          );
          listUserItem.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getUser.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(getUser.body);
        setState(() {
          isLoading = false;
          isError = true;
        });
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

  Future<List<List>> listUserfilter() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isFilter = true;
    });
    try {
      final getUserFilter = await http.post(
        url('api/getdataparticipant'),
        body: {
          'filter': _filtercontroller.text,
        },
        headers: requestHeaders,
      );

      if (getUserFilter.statusCode == 200) {
        var listuserJson = json.decode(getUserFilter.body);
        var listUsers = listuserJson['participant'];
        listUserItem = [];
        for (var i in listUsers) {
          ListUser willcomex = ListUser(
            id: '${i['us_code']}',
            nama: i['us_name'],
            email: i['us_email'],
            image: i['us_image'],
          );
          listUserItem.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (getUserFilter.statusCode == 401) {
        setState(() {
          isFilter = false;
          isErrorfilter = true;
        });
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(getUserFilter.body);
        setState(() {
          isFilter = false;
          isErrorfilter = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isFilter = false;
        isErrorfilter = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isFilter = false;
        isErrorfilter = true;
      });
      debugPrint('$e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Tambahkan Admin Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isError == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => listUser(),
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
                            "Gagal memuat halaman, tekan tombol muat ulang halaman untuk refresh halaman",
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
              : Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Column(
                    children: <Widget>[
                      isCreate == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    width: 15.0,
                                    margin:
                                        EdgeInsets.only(top: 10.0, right: 15.0),
                                    height: 15.0,
                                    child: CircularProgressIndicator()),
                              ],
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: TextField(
                            controller: _filtercontroller,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            onChanged: (string) {
                              _debouncer.run(() {
                                listUserfilter();
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color.fromRGBO(41, 30, 47, 1),
                              ),
                              hintText: "Cari Berdasarkan Nama atau Email",
                              border: InputBorder.none,
                            )),
                      ),
                      isFilter == true
                          ? Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: CircularProgressIndicator(),
                            )
                          : listUserItem.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Column(children: <Widget>[
                                    new Container(
                                      width: 100.0,
                                      height: 100.0,
                                      child: Image.asset(
                                          "images/empty-white-box.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                        left: 15.0,
                                        right: 15.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "User Tidak ada / tidak ditemukan",
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
                              : isErrorfilter == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: RefreshIndicator(
                                        onRefresh: () => listUser(),
                                        child: Column(children: <Widget>[
                                          new Container(
                                            width: 80.0,
                                            height: 80.0,
                                            child: Image.asset(
                                                "images/system-eror.png"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                              left: 15.0,
                                              right: 15.0,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Gagal Memuat Data, Silahkan Coba Kembali",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                  height: 1.5,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    )
                                  : Expanded(
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          // scrollDirection: Axis.horizontal,
                                          itemCount: listUserItem.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              child: Container(
                                                child: Card(
                                                    child: ListTile(
                                                  leading: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: ClipOval(
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            'images/loading.gif',
                                                        image: listUserItem[index]
                                                                        .image ==
                                                                    null ||
                                                                listUserItem[
                                                                            index]
                                                                        .image ==
                                                                    '' ||
                                                                listUserItem[
                                                                            index]
                                                                        .image ==
                                                                    'null'
                                                            ? url('assets/images/imgavatar.png')
                                                            : url(
                                                                'storage/image/profile/${listUserItem[index].image}'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                      listUserItem[index]
                                                                  .nama ==
                                                              null
                                                          ? 'Unknown Nama'
                                                          : listUserItem[index]
                                                              .nama),
                                                  subtitle: Text(
                                                      listUserItem[index]
                                                                  .email ==
                                                              null
                                                          ? 'Unknown Email'
                                                          : listUserItem[index]
                                                              .email),
                                                )),
                                              ),
                                              onTap: isCreate == true
                                                  ? null
                                                  : () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Peringatan!'),
                                                          content: Text(
                                                              'Apakah Anda Ingin Menambahkan Member ini ke Admin Event Anda? '),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child:
                                                                  Text('Tidak'),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              textColor:
                                                                  Colors.green,
                                                              child: Text('Ya'),
                                                              onPressed:
                                                                  isCreate ==
                                                                          true
                                                                      ? null
                                                                      : () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {
                                                                            isCreate =
                                                                                true;
                                                                          });
                                                                          _tambahadmin(
                                                                              widget.event,
                                                                              listUserItem[index].id);
                                                                        },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                    ],
                  ),
                ),
    );
  }

  void _tambahadmin(idevent, idpeserta) async {
    try {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      final addadminevent = await http
          .post(url('api/addadmin_event'), headers: requestHeaders, body: {
        'event': idevent,
        'peserta': idpeserta,
      });

      if (addadminevent.statusCode == 200) {
        var addadmineventJson = json.decode(addadminevent.body);
        if (addadmineventJson['status'] == 'success') {
          Fluttertoast.showToast(msg: "Berhasil !");
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageAdmin(event: widget.event)));
        } else if (addadmineventJson['status'] == 'sudah ada') {
          Fluttertoast.showToast(
              msg: "Member ini sudah terdaftar menjadi admin event anda");
          setState(() {
            isCreate = false;
          });
        } else if (addadmineventJson['status'] == 'creator') {
          Fluttertoast.showToast(msg: "Member ini merupakan pembuat event");
          setState(() {
            isCreate = false;
          });
        } else if (addadmineventJson['status'] == 'pending') {
          Fluttertoast.showToast(
              msg: "Permintaan menjadi admin menunggu persetujuan");
          setState(() {
            isCreate = false;
          });
          Navigator.pop(context);
        } else if (addadmineventJson['status'] == 'sudahpeserta') {
          Fluttertoast.showToast(
              msg: "Member ini sudah menjadi peserta event anda");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else if (addadmineventJson['status'] == 'pendingpeserta') {
          Fluttertoast.showToast(
              msg:
                  "Member ini sudah mendaftar event anda sebagai peserta dan menunggu persetujuan anda");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else {
          Fluttertoast.showToast(msg: "Status tidak diketahui");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        }
      } else {
        print(addadminevent.body);
    Fluttertoast.showToast(msg: "Gagal, Silahkan Coba Kembali");
        setState(() {
          isCreate = false;
        });
      }
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
}
