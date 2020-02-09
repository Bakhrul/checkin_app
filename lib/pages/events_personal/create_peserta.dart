import 'package:flutter/material.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'manage_peserta.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';

import 'package:checkin_app/utils/utils.dart';

bool isLoading, isError, isFilter, isErrorfilter, isCreate;
bool actionBackAppBar, iconButtonAppbarColor;
final TextEditingController _searchQuery = new TextEditingController();
String tokenType, accessToken;
final _debouncer = Debouncer(milliseconds: 500);
Map<String, String> requestHeaders = Map();
var datepicker;
List<ListUser> listUserItem = [];

class ManajemeCreatePeserta extends StatefulWidget {
  ManajemeCreatePeserta({Key key, this.title, this.event}) : super(key: key);
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

class _ManajemeCreatePesertaState extends State<ManajemeCreatePeserta> {
  @override
  void initState() {
    actionBackAppBar = true;
    listUserItem = [];
    iconButtonAppbarColor = true;
    _searchQuery.text = '';
    datepicker = FocusNode();
    super.initState();
    isLoading = true;
    getHeaderHTTP();
    isFilter = false;
    isErrorfilter = false;
    isCreate = false;
  }

  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
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
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (getUser.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
        setState(() {
          isLoading = false;
          isError = true;
          isFilter = false;
          isErrorfilter = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          isFilter = false;
          isErrorfilter = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
        isFilter = false;
        isErrorfilter = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        isFilter = false;
        isErrorfilter = false;
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
          'filter': _searchQuery.text,
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
          isLoading = false;
          isError = false;
        });
      } else if (getUserFilter.statusCode == 401) {
        setState(() {
          isFilter = false;
          isErrorfilter = true;
          isLoading = false;
          isError = false;
        });
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
      } else {
        setState(() {
          isFilter = false;
          isErrorfilter = true;
          isLoading = false;
          isError = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isFilter = false;
        isErrorfilter = true;
        isLoading = false;
        isError = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isFilter = false;
        isErrorfilter = true;
        isLoading = false;
        isError = false;
      });
      debugPrint('$e');
    }
    return null;
  }

  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      actionBackAppBar = true;
      iconButtonAppbarColor = true;
      this.appBarTitle = new Text(
        "Tambah Peserta Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
      listUser();
      _debouncer.run(() {
        _searchQuery.clear();
      });
    });
  }

  Widget appBarTitle = Text(
    "Tambah Peserta Event",
    style: TextStyle(fontSize: 14),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      appBar: buildBar(context),
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
              : Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: <Widget>[
                      isCreate == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    width: 15.0,
                                    margin:
                                        EdgeInsets.only(top: 10.0, right: 15.0,bottom: 10.0),
                                    height: 15.0,
                                    child: CircularProgressIndicator()),
                              ],
                            )
                          : Container(),
                      isFilter == true
                          ? Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: CircularProgressIndicator(),
                            )
                          : isErrorfilter == true
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: RefreshIndicator(
                            onRefresh: () => listUserfilter(),
                            child: Column(children: <Widget>[
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                child: Image.asset("images/system-eror.png"),
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
                        ):listUserItem.length == 0
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
                                          "Pengguna Tidak ada / tidak ditemukan",
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
                                                            ? url(
                                                                'assets/images/imgavatar.png')
                                                            : url(
                                                                'storage/image/profile/${listUserItem[index].image}'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
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
                                                              'Apakah Anda Ingin Menambahkan Peserta ini ke Event Anda? '),
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
                                                                  () async {
                                                                setState(() {
                                                                  isCreate =
                                                                      true;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                                _tambahpeserta(
                                                                    widget
                                                                        .event,
                                                                    listUserItem[
                                                                            index]
                                                                        .id);
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

  void _tambahpeserta(idevent, idpeserta) async {
    try {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      final addpeserta = await http
          .post(url('api/addpeserta_event'), headers: requestHeaders, body: {
        'event': widget.event,
        'peserta': idpeserta,
      });

      if (addpeserta.statusCode == 200) {
        var addpesertaJson = json.decode(addpeserta.body);
        if (addpesertaJson['status'] == 'success') {
          setState(() {
            isCreate = false;
          });
          Fluttertoast.showToast(msg: "Berhasil");
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ManagePeserta(event: widget.event)));
        } else if (addpesertaJson['status'] == 'creator') {
          Fluttertoast.showToast(msg: "Pengguna Ini Merupakan Pembuat Event");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else if (addpesertaJson['status'] == 'sudah ada') {
          Fluttertoast.showToast(
              msg: "Pengguna Ini Sudah Terdaftar Pada Event Anda");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else if (addpesertaJson['status'] == 'pending') {
          Fluttertoast.showToast(
              msg: "Pendaftaran Pengguna Ini Menunggu Persetujuan Dari Anda");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else if (addpesertaJson['status'] == 'sudahadmin') {
          Fluttertoast.showToast(
              msg: "Pengguna Ini Sudah Terdaftar Menjadi Admin Event Anda");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else if (addpesertaJson['status'] == 'adminpending') {
          Fluttertoast.showToast(
              msg:
                  "Anda Sudah Memninta Pengguna Ini Untuk Menjadi Admin Event Dan Saat Ini Menunggu Persetujuan");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        } else {
          Fluttertoast.showToast(msg: "Status Tidak Diketahui");
          Navigator.pop(context);
          setState(() {
            isCreate = false;
          });
        }
      } else {
        print(addpeserta.body);
        Navigator.pop(context);
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
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
      setState(() {
        isCreate = false;
      });
      print(e);
    }
  }

  Widget buildBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: appBarTitle,
          titleSpacing: 0.0,
          centerTitle: true,
          backgroundColor: primaryAppBarColor,
          automaticallyImplyLeading: actionBackAppBar,
          actions: <Widget>[
            Container(
              color: iconButtonAppbarColor == true
                  ? primaryAppBarColor
                  : Colors.white,
              child: IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      actionBackAppBar = false;
                      iconButtonAppbarColor = false;
                      this.actionIcon = new Icon(
                        Icons.close,
                        color: Colors.grey,
                      );
                      this.appBarTitle = Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: _searchQuery,
                          onChanged: (string) {
                            if (string != null || string != '') {
                              _debouncer.run(() {
                                listUserfilter();
                              });
                            }
                          },
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.grey),
                            hintText: "Cari Berdasarkan Email Pengguna",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    } else {
                      _handleSearchEnd();
                    }
                  });
                },
              ),
            ),
          ],
        ));
  }
}
