import 'package:checkin_app/pages/events_personal/edit_event.dart';
import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';

List<ListKategoriEvent> listkategoriEvent = [];
Map<String, String> requestHeaders = Map();
bool isLoading, isError, isSame;
var datepicker;
String tokenType, accessToken;
List<ListUser> listUserItem = [];

class ManajemenEditCategoryEvent extends StatefulWidget {
  ManajemenEditCategoryEvent({Key key, this.title, this.listkategoryedit})
      : super(key: key);
  final String title;
  final listkategoryedit;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEditCategoryEventState();
  }
}

class _ManajemenEditCategoryEventState
    extends State<ManajemenEditCategoryEvent> {
  @override
  void initState() {
    datepicker = FocusNode();
    super.initState();
    isLoading = true;
    isError = false;
    isSame = false;
    listKategoriEvent();
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
  }

  Future<List<ListKategoriEvent>> listKategoriEvent() async {
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
      final getCategory = await http.get(
        url('api/listkategorievent'),
        headers: requestHeaders,
      );

      if (getCategory.statusCode == 200) {
        var kategorieventJson = json.decode(getCategory.body);
        var kategorievents = kategorieventJson['kategori'];

        listkategoriEvent = [];
        for (var i in kategorievents) {
          ListKategoriEvent donex = ListKategoriEvent(
            id: '${i['c_id']}',
            nama: i['c_name'],
          );
          listkategoriEvent.add(donex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getCategory.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(getCategory.body);
        print(getCategory.statusCode);
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
          "Tambahkan Kategori Sekarang",
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
                    onRefresh: () => listKategoriEvent(),
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
                              listKategoriEvent();
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
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            itemCount: listkategoriEvent.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: Container(
                                  child: Card(
                                      child: ListTile(
                                    title: Text(
                                        listkategoriEvent[index].nama == null
                                            ? 'Unknown Nama'
                                            : listkategoriEvent[index].nama),
                                  )),
                                ),
                                onTap: () async {
                                  for (int i = 0;
                                      i < listkategoriEventEdit.length;
                                      i++) {
                                    if (listkategoriEvent[index].id ==
                                        listkategoriEventEdit[i].id) {
                                      setState(() {
                                        isSame = true;
                                      });
                                    }
                                  }
                                  if (isSame == true) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Kategori Event Tersebut Sudah Ada');
                                    setState(() {
                                      isSame = false;
                                    });
                                  } else {
                                    setState(() {
                                      ListEditKategoriEvent notax =
                                          ListEditKategoriEvent(
                                        id: listkategoriEvent[index].id,
                                        nama: listkategoriEvent[index].nama,
                                      );
                                      listkategoriEventEdit.add(notax);
                                    });
                                    Navigator.pop(context);
                                  }
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
}
