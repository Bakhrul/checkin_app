import 'package:checkin_app/pages/events_personal/create_event-information.dart';
import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'create_event-category.dart';
import 'package:checkin_app/utils/utils.dart';

List<ListKategoriEvent> listkategoriEvent = [];
bool isLoading, isError, isSame, isCreate;
var datepicker;
String tokenType, accessToken;
List<ListUser> listUserItem = [];

Map<String, String> requestHeaders = Map();

class ManajemenCreateCategory extends StatefulWidget {
  ManajemenCreateCategory(
      {Key key, this.title, this.listKategoriadd, this.event})
      : super(key: key);
  final String title, event;
  final listKategoriadd;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateCategoryState();
  }
}

class _ManajemeCreateCategoryState extends State<ManajemenCreateCategory> {
  @override
  void initState() {
    datepicker = FocusNode();
    super.initState();
    isLoading = true;
    isError = false;
    isSame = false;
    isCreate = false;
    isDelete = false;
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
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
      } else {
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
        backgroundColor: primaryAppBarColor,
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
                  padding: const EdgeInsets.all(5.0),
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
                                onTap: isCreate == true ? null : () async {
                                  for (int i = 0;
                                      i < listKategoriAdd.length;
                                      i++) {
                                    if (listkategoriEvent[index].id ==
                                        listKategoriAdd[i].id) {
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
                                    _tambahCategory(listkategoriEvent[index].id,
                                        listkategoriEvent[index].nama);
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

  void _tambahCategory(idCategory, namaCategory) async {
    setState(() {
      isCreate = true;
    });
    Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");
    formSerialize = Map<String, dynamic>();
    formSerialize['event'] = null;
    formSerialize['kategori'] = null;
    formSerialize['typeinformasi'] = null;
    formSerialize['typekategori'] = null;
    formSerialize['typeadmin'] = null;
    formSerialize['typecheckin'] = null;

    formSerialize['typekategori'] = 'kategori';
    formSerialize['event'] = widget.event == null || widget.event == ''
        ? null
        : widget.event.toString();
    formSerialize['kategori'] = idCategory;


    Map<String, dynamic> requestHeadersX = requestHeaders;

    requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
    try {
      final response = await http.post(
        url('api/createcheckin'),
        headers: requestHeadersX,
        body: {
          'type_platform': 'android',
          'data': jsonEncode(formSerialize),
        },
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        String idEventFromDB = responseJson['finalidevent'].toString();
        if (responseJson['status'] == 'success') {
          setState(() {
            idEventFinalX = idEventFromDB;
            isCreate = false;
          });
          setState(() {
            ListKategoriEventAdd notax = ListKategoriEventAdd(
              id: idCategory,
              nama: namaCategory,
            );
            listKategoriAdd.add(notax);
          });
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Gagal Menambahkan Kategori, Silahkan Coba Kembali");
        setState(() {
          isCreate = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time Out, Try Again");
      setState(() {
        isCreate = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Menambahkan Kategori, Silahkan Coba Kembali");
      setState(() {
        isCreate = false;
      });
      print(e);
    }
  }
}
