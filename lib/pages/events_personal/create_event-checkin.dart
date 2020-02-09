import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'dart:async';
import 'dart:convert';
import 'create_checkin.dart';
import 'index.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'model.dart';
import 'package:checkin_app/utils/utils.dart';
import 'create_event-information.dart';

List<ListCheckinAdd> listcheckinAdd = [];
List<ListKategoriEventAdd> listKategoriAdd = [];
List<ListUserAdd> listUseradd = [];
String tokenType, accessToken;
bool isCreate, isDelete;
Map<String, String> requestHeaders = Map();

class ManajemenCreateEventCheckin extends StatefulWidget {
  ManajemenCreateEventCheckin({Key key, this.title, this.event})
      : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenCreateEventCheckinState();
  }
}

class _ManajemenCreateEventCheckinState
    extends State<ManajemenCreateEventCheckin> {
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
    print(requestHeaders);
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
          "Event Baru - Tambah CheckIn",
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
            tooltip: 'Tambah Checkin',
            onPressed: isDelete == true ? null : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManajemeCreateCheckin(
                        listCheckinadd: ListCheckinAdd, event: widget.event),
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
         isDelete == true
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
              listcheckinAdd.length == 0
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
                              "Checkin Event Belum Ditambahkan / Masih Kosong",
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
                        children: listcheckinAdd.reversed
                            .map((ListCheckinAdd item) => Card(
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
                                                    'keyword': item.keyword,
                                                    'typehapuscheckin':
                                                        'checkin',
                                                  });

                                              if (addadminevent.statusCode ==
                                                  200) {
                                                var addadmineventJson = json
                                                    .decode(addadminevent.body);
                                                if (addadmineventJson[
                                                        'status'] ==
                                                    'success') {
                                                  setState(() {
                                                    listcheckinAdd.remove(item);
                                                    isDelete = false;
                                                  });

                                                  Fluttertoast.showToast(
                                                      msg: "Berhasil !");
                                                }
                                              } else {
                                                print(addadminevent.body);
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
                                    title: Text(
                                      '${item.nama} ( ${item.keyword} )',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        '${item.timestart} - ${item.timeend}',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isDelete == true ? null : () async {
          setState(() {
            idEventFinalX = null;
            listcheckinAdd = [];
            listKategoriAdd = [];
            listUseradd = [];
          });
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ManajemenEventPersonal()));
        },
        child: Icon(Icons.check),
        backgroundColor: primaryButtonColor,
      ),
    );
  }
}
