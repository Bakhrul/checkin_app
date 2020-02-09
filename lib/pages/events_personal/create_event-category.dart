import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'dart:convert';
import 'create_event-admin.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'model.dart';
import 'package:checkin_app/utils/utils.dart';
import 'create_category.dart';

List<ListKategoriEventAdd> listKategoriAdd = [];
String tokenType, accessToken;
bool isCreate, isDelete;
Map<String, String> requestHeaders = Map();

class ManajemenCreateEventCategory extends StatefulWidget {
  ManajemenCreateEventCategory({Key key, this.title, this.event})
      : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenCreateEventCategoryState();
  }
}

class _ManajemenCreateEventCategoryState
    extends State<ManajemenCreateEventCategory> {
  void initState() {
    isCreate = false;
    isDelete = false;
    getHeaderHTTP();
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
          "Event Baru - Tambah Kategori",
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
            tooltip: 'Tambah Kategori',
            onPressed: isDelete == true ? null : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManajemenCreateCategory(
                      listKategoriadd: ListKategoriEventAdd,
                      event: widget.event,
                    ),
                  ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isCreate || isDelete == true
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
              listKategoriAdd.length == 0
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
                              "Kategori Event Belum Ditambahkan / Masih Kosong",
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
                        children: listKategoriAdd.reversed
                            .map((ListKategoriEventAdd item) => Card(
                                    child: ListTile(
                                  leading: ButtonTheme(
                                      minWidth: 0.0,
                                      child: FlatButton(
                                        color: Colors.white,
                                        textColor: Colors.red,
                                        disabledColor: Colors.white,
                                        disabledTextColor:Colors.red[400],
                                        padding: EdgeInsets.all(15.0),
                                        splashColor: Colors.blueAccent,
                                        child: Icon(
                                          Icons.close,
                                        ),
                                        onPressed: isDelete == true ? null : () async {
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
                                                  'kategori': item.id,
                                                  'typehapuskategori':
                                                      'kategori',
                                                });

                                            if (addadminevent.statusCode ==
                                                200) {
                                              var addadmineventJson = json
                                                  .decode(addadminevent.body);
                                              if (addadmineventJson['status'] ==
                                                  'success') {
                                                setState(() {
                                                  isDelete = false;
                                                });
                                                setState(() {
                                                  listKategoriAdd.remove(item);
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
                                  title: Text(item.nama == null
                                      ? 'Unknown Nama'
                                      : item.nama),
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
        onPressed: isDelete ? null : () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManajemenCreateEventAdmin(
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
