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
import 'package:draggable_fab/draggable_fab.dart';
import 'model.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';

import 'package:checkin_app/utils/utils.dart';

String tokenType, accessToken;
TextEditingController _controllerAddadmin = new TextEditingController();
List<ListAdminEvent> listadminevent = [];
bool actionBackAppBar, iconButtonAppbarColor;
bool isLoading, isError, isFilter, isErrorfilter, isDelete;
final _debouncer = Debouncer(milliseconds: 500);
Map<String, String> requestHeaders = Map();
String namaEventX;

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
  ManageAdmin({Key key, this.title, this.event, this.namaEvent, this.eventEnd})
      : super(key: key);
  final String title, event, namaEvent;
  final bool eventEnd;
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
    isCreate = false;
    isFilter = false;
    isErrorfilter = false;
    isDelete = false;
    namaEventX = widget.namaEvent;
    actionBackAppBar = true;
    iconButtonAppbarColor = true;
    getHeaderHTTP();
    print(requestHeaders);
    listcheckin();
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

                                    print('Email is valid? ' +
                                        (isValid ? 'yes' : 'no'));
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
    try {
      Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
      final addadminevent = await http
          .post(url('api/addadmin_event'), headers: requestHeaders, body: {
        'event': widget.event,
        'admin': admin,
      });

      if (addadminevent.statusCode == 200) {
        var addadmineventJson = json.decode(addadminevent.body);
        if (addadmineventJson['status'] == 'success') {
          setState(() {
            isCreate = false;
          });
          Fluttertoast.showToast(msg: "Berhasil !");
          listcheckin();
        } else if (addadmineventJson['status'] == 'user tidak ditemukan') {
          Fluttertoast.showToast(
              msg: "Email ini belum terdaftar pada akun eventzhee");
          setState(() {
            isCreate = false;
          });
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
        } else if (addadmineventJson['status'] == 'sudahpeserta') {
          Fluttertoast.showToast(
              msg: "Member ini sudah menjadi peserta event anda");
          setState(() {
            isCreate = false;
          });
        } else if (addadmineventJson['status'] == 'pendingpeserta') {
          Fluttertoast.showToast(
              msg:
                  "Member ini sudah mendaftar event anda sebagai peserta dan menunggu persetujuan anda");
          setState(() {
            isCreate = false;
          });
        } else {
          Fluttertoast.showToast(msg: "Status tidak diketahui");
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

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
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
      this.appBarTitle = Text(
        "Kelola Co-Host / Admin Event $namaEventX",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
    });
    try {
      final getAdminEvent = await http.post(
        url('api/listadminevent'),
        body: {'event': widget.event},
        headers: requestHeaders,
      );

      if (getAdminEvent.statusCode == 200) {
        var listuserJson = json.decode(getAdminEvent.body);
        var listUsers = listuserJson['admin'];
        listadminevent = [];
        for (var i in listUsers) {
          ListAdminEvent willcomex = ListAdminEvent(
            idevent: '${i['ep_events']}',
            idpeserta: '${i['ep_participants']}',
            nama: i['us_name'],
            posisi: i['ep_position'].toString(),
            status: i['ep_status'],
            email: i['us_email'],
            image: i['us_image'],
          );
          listadminevent.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (getAdminEvent.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
          isFilter = false;
          isErrorfilter = false;
        });
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
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
        listadminevent = [];
        for (var i in listUsers) {
          ListAdminEvent willcomex = ListAdminEvent(
            idevent: '${i['ep_events']}',
            idpeserta: '${i['ep_participants']}',
            nama: i['us_name'],
            posisi: i['ep_position'].toString(),
            status: i['ep_status'],
            email: i['us_email'],
            image: i['us_image'],
          );
          listadminevent.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
          isLoading = false;
          isError = false;
        });
      } else if (checkinevent.statusCode == 401) {
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
      actionBackAppBar = true;
      iconButtonAppbarColor = true;
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Kelola Co-Host / Admin Event $namaEventX",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
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
    "Kelola Co-Host / Admin Event $namaEventX",
    style: TextStyle(fontSize: 14),
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
                                isDelete == true || isCreate == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                              width: 15.0,
                                              margin: EdgeInsets.only(
                                                  top: 10.0, right: 15.0),
                                              height: 15.0,
                                              child:
                                                  CircularProgressIndicator()),
                                        ],
                                      )
                                    : Container(),
                                listadminevent.length == 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
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
                                                  child: ClipOval(
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'images/loading.gif',
                                                      image: listadminevent[
                                                                          index]
                                                                      .image ==
                                                                  null ||
                                                              listadminevent[
                                                                          index]
                                                                      .image ==
                                                                  '' ||
                                                              listadminevent[
                                                                          index]
                                                                      .image ==
                                                                  'null'
                                                          ? url(
                                                              'assets/images/imgavatar.png')
                                                          : url(
                                                              'storage/image/profile/${listadminevent[index].image}'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                title: Text(
                                                    listadminevent[index]
                                                                    .nama ==
                                                                null ||
                                                            listadminevent[
                                                                        index]
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                            fontWeight: FontWeight
                                                                .w500)
                                                        : listadminevent[index]
                                                                    .status ==
                                                                'C'
                                                            ? TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.red)
                                                            : listadminevent[index]
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    listadminevent[index]
                                                                    .status ==
                                                                'P' ||
                                                            listadminevent[
                                                                        index]
                                                                    .status ==
                                                                'C'
                                                        ? Container()
                                                        : widget.eventEnd ==
                                                                true
                                                            ? Container()
                                                            : ButtonTheme(
                                                                minWidth: 0.0,
                                                                child:
                                                                    FlatButton(
                                                                  color: Colors
                                                                      .white,
                                                                  textColor:
                                                                      Colors
                                                                          .red,
                                                                  disabledColor:
                                                                      Colors
                                                                          .white,
                                                                  disabledTextColor:
                                                                      Colors.red[
                                                                          400],
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  splashColor:
                                                                      Colors
                                                                          .blueAccent,
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                  ),
                                                                  onPressed:
                                                                      isDelete ==
                                                                              true
                                                                          ? null
                                                                          : () async {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                  title: Text('Peringatan!'),
                                                                                  content: Text('Apakah Anda Ingin Menghapus Admin Event?'),
                                                                                  actions: <Widget>[
                                                                                    FlatButton(
                                                                                      child: Text('Tidak'),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    FlatButton(
                                                                                      textColor: Colors.green,
                                                                                      child: Text('Ya'),
                                                                                      onPressed: () async {
                                                                                        Navigator.pop(context);
                                                                                        setState(() {
                                                                                          isDelete = true;
                                                                                        });
                                                                                        try {
                                                                                          Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
                                                                                          final removeAdmin = await http.post(url('api/deleteadmin_event'), headers: requestHeaders, body: {
                                                                                            'peserta': listadminevent[index].idpeserta,
                                                                                            'event': listadminevent[index].idevent
                                                                                          });
                                                                                          if (removeAdmin.statusCode == 200) {
                                                                                            var removeAdminJson = json.decode(removeAdmin.body);
                                                                                            if (removeAdminJson['status'] == 'success') {
                                                                                              Fluttertoast.showToast(msg: "Berhasil");
                                                                                              setState(() {
                                                                                                isDelete = false;
                                                                                              });
                                                                                              setState(() {
                                                                                                listadminevent.remove(listadminevent[index]);
                                                                                              });
                                                                                            } else if (removeAdminJson['status'] == 'Error') {
                                                                                              Fluttertoast.showToast(msg: "Request failed with status: ${removeAdmin.statusCode}");
                                                                                              setState(() {
                                                                                                isDelete = false;
                                                                                              });
                                                                                            }
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: "Request failed with status: ${removeAdmin.statusCode}");
                                                                                            setState(() {
                                                                                              isDelete = false;
                                                                                            });
                                                                                          }
                                                                                        } on TimeoutException catch (_) {
                                                                                          Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                          setState(() {
                                                                                            isDelete = false;
                                                                                          });
                                                                                        } catch (e) {
                                                                                          setState(() {
                                                                                            isDelete = false;
                                                                                          });
                                                                                          print(e);
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
        floatingActionButton: widget.eventEnd == true
            ? null
            : DraggableFab(
                child: FloatingActionButton(
                    shape: StadiumBorder(),
                    onPressed: isCreate == true
                        ? null
                        : () async {
                            showAddModalAdmin();
                            //    Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) =>
                            //         ManajemenTambahAdmin(event: widget.event)));
                          },
                    backgroundColor: primaryButtonColor,
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                    ))));
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
                                filterlistadmin();
                              });
                            }
                          },
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.grey),
                            hintText: "Cari Berdasarkan Nama Admin",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
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
