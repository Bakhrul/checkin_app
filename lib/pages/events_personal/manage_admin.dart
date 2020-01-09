import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'tambah_admin.dart';
import 'model.dart';
import 'dart:core';

String tokenType, accessToken;
List<ListAdminEvent> listadminevent = [];
bool isLoading, isError, isFilter, isErrorfilter;
final _debouncer = Debouncer(milliseconds: 500);
Map<String, String> requestHeaders = Map();

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

class ManageAdmin extends StatefulWidget {
  ManageAdmin({Key key, this.title, this.event}) : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManageAdminState();
  }
}

class _ManageAdminState extends State<ManageAdmin> {
  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
    isFilter = false;
    isErrorfilter = false;
    getHeaderHTTP();
    print(requestHeaders);
    listcheckin();
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
  }

  Future<List<List>> listcheckin() async {
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
      final checkinevent = await http.post(
        url('api/listadminevent'),
        body: {'event': widget.event},
        headers: requestHeaders,
      );

      if (checkinevent.statusCode == 200) {
        var listuserJson = json.decode(checkinevent.body);
        var listUsers = listuserJson['admin'];
        print(listUsers);
        listadminevent = [];
        for (var i in listUsers) {
          ListAdminEvent willcomex = ListAdminEvent(
            idevent: '${i['ep_events']}',
            idpeserta: '${i['ep_participants']}',
            nama: i['us_name'],
            posisi: i['ep_position'].toString(),
            status: i['ep_status'],
            email: i['us_email'],
          );
          listadminevent.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (checkinevent.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(checkinevent.body);
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
      print('eror');
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }

  Future<List<List>> filterlistadmin() async {
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
      final checkinevent = await http.post(
        url('api/listadminevent'),
        body: {'event': widget.event, 'filter': _searchQuery.text},
        headers: requestHeaders,
      );

      if (checkinevent.statusCode == 200) {
        var listuserJson = json.decode(checkinevent.body);
        var listUsers = listuserJson['admin'];
        print(listUsers);
        listadminevent = [];
        for (var i in listUsers) {
          ListAdminEvent willcomex = ListAdminEvent(
            idevent: '${i['ep_events']}',
            idpeserta: '${i['ep_participants']}',
            nama: i['us_name'],
            posisi: i['ep_position'].toString(),
            status: i['ep_status'],
            email: i['us_email'],
          );
          listadminevent.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (checkinevent.statusCode == 401) {
        setState(() {
          isFilter = false;
          isErrorfilter = true;
        });
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(checkinevent.body);
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
      print('eror');
      setState(() {
        isFilter = false;
        isErrorfilter = true;
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
      this.appBarTitle = new Text(
        "Kelola Co Host / Admin Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      listcheckin();
      _debouncer.run(() {
        _searchQuery.clear();
      });
    });
  }

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Kelola Co Host / Admin Event",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildBar(context),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isError == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => getHeaderHTTP(),
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
              : isFilter == true
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : isErrorfilter == true
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: RefreshIndicator(
                            onRefresh: () => filterlistadmin(),
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
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Column(
                            children: <Widget>[
                              listadminevent.length == 0
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
                                            top: 30.0,
                                            left: 15.0,
                                            right: 15.0,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Event Belum Memiliki Admin Sama Sekali",
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
                                  : Expanded(
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          // scrollDirection: Axis.horizontal,
                                          itemCount: listadminevent.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Card(
                                                child: ListTile(
                                              leading: Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                        'images/imgavatar.png',
                                                      ),
                                                    ),
                                                  )),
                                              title: Text(
                                                  listadminevent[index].nama ==
                                                              null ||
                                                          listadminevent[index]
                                                                  .nama ==
                                                              ''
                                                      ? 'Nama Tidak Diketahui'
                                                      : listadminevent[index]
                                                          .nama,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Text(
                                                  listadminevent[index]
                                                              .status ==
                                                          'P'
                                                      ? 'Menunggu Konfirmasi'
                                                      : listadminevent[index]
                                                                  .status ==
                                                              'C'
                                                          ? 'Pendaftaran Ditolak'
                                                          : listadminevent[
                                                                          index]
                                                                      .status ==
                                                                  'A'
                                                              ? 'Pendaftaran Diterima'
                                                              : 'Status Tidak Diketahui',
                                                  style: listadminevent[index]
                                                              .status ==
                                                          'P'
                                                      ? TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)
                                                      : listadminevent[index]
                                                                  .status ==
                                                              'C'
                                                          ? TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors.red)
                                                          : listadminevent[
                                                                          index]
                                                                      .status ==
                                                                  'A'
                                                              ? TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .green)
                                                              : TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  listadminevent[index]
                                                                  .status ==
                                                              'P' ||
                                                          listadminevent[index]
                                                                  .status ==
                                                              'C'
                                                      ? Container()
                                                      : ButtonTheme(
                                                          minWidth: 0.0,
                                                          child: FlatButton(
                                                            color: Colors.white,
                                                            textColor:
                                                                Colors.red,
                                                            disabledColor:
                                                                Colors
                                                                    .green[400],
                                                            disabledTextColor:
                                                                Colors.white,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            splashColor: Colors
                                                                .blueAccent,
                                                            child: Icon(
                                                              Icons.delete,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  title: Text(
                                                                      'Peringatan!'),
                                                                  content: Text(
                                                                      'Apakah Anda Ingin Menghapus Admin Event?'),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child: Text(
                                                                          'Tidak'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      textColor:
                                                                          Colors
                                                                              .green,
                                                                      child: Text(
                                                                          'Ya'),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        try {
                                                                          Fluttertoast.showToast(
                                                                              msg: "Mohon Tunggu Sebentar");
                                                                          final hapuswishlist = await http.post(
                                                                              url('api/deleteadmin_event'),
                                                                              headers: requestHeaders,
                                                                              body: {
                                                                                'peserta': listadminevent[index].idpeserta,
                                                                                'event': listadminevent[index].idevent
                                                                              });
                                                                          print(
                                                                              hapuswishlist);
                                                                          if (hapuswishlist.statusCode ==
                                                                              200) {
                                                                            var hapuswishlistJson =
                                                                                json.decode(hapuswishlist.body);
                                                                            if (hapuswishlistJson['status'] ==
                                                                                'success') {
                                                                              Fluttertoast.showToast(msg: "Berhasil");
                                                                              setState(() {
                                                                                listadminevent.remove(listadminevent[index]);
                                                                              });
                                                                            } else if (hapuswishlistJson['status'] ==
                                                                                'Error') {
                                                                              Fluttertoast.showToast(msg: "Request failed with status: ${hapuswishlist.statusCode}");
                                                                            }
                                                                          } else {
                                                                            Fluttertoast.showToast(msg: "Request failed with status: ${hapuswishlist.statusCode}");
                                                                          }
                                                                        } on TimeoutException catch (_) {
                                                                          Fluttertoast.showToast(
                                                                              msg: "Timed out, Try again");
                                                                        } catch (e) {
                                                                          print(
                                                                              e);
                                                                        }
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          )),
                                                ],
                                              ),
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ManajemenTambahAdmin(event: widget.event)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                // ignore: new_with_non_type
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = TextField(
                  controller: _searchQuery,
                  onChanged: (string) {
                    if (string != null || string != '') {
                      _debouncer.run(() {
                        filterlistadmin();
                      });
                    }
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: InputBorder.none,
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Cari Nama Admin",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                );
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ],
    );
  }
}
