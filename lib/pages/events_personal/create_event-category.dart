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
import 'package:shimmer/shimmer.dart';
import 'package:progress_dialog/progress_dialog.dart';

List<ListKategoriEventAdd> listKategoriAdd = [];
String tokenType, accessToken;
bool isLoading, isError;
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
  ProgressDialog progressApiAction;
  void initState() {
    isLoading = true;
    isError = false;
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
    return listKategoriEvent();
  }

  Future<List<ListKategoriEventAdd>> listKategoriEvent() async {
    setState(() {
      isLoading = true;
      listKategoriAdd.clear();
      listKategoriAdd = [];
    });
    try {
      final getCategory = await http.post(
        url('api/kategori_createevent'),
        body: {
          'event': widget.event,
        },
        headers: requestHeaders,
      );

      if (getCategory.statusCode == 200) {
        var kategorieventJson = json.decode(getCategory.body);
        var kategorievents = kategorieventJson['kategori'];
        setState(() {
          listKategoriAdd.clear();
          listKategoriAdd = [];
        });

        listkategoriEvent = [];
        for (var i in kategorievents) {
          ListKategoriEventAdd donex = ListKategoriEventAdd(
            id: '${i['c_id']}',
            nama: i['c_name'],
          );
          listKategoriAdd.add(donex);
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
        print(getCategory.body);
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
            onPressed: () {
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
      body: isLoading == true
          ? loadingView()
          : isError == true
              ? RefreshIndicator(
                  onRefresh: () => listKategoriEvent(),
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
              : listKategoriAdd.length == 0
                  ? RefreshIndicator(
                    onRefresh: () => listKategoriEvent(),
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
                    ))
                  : Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Scrollbar(
                                child: RefreshIndicator(
                                    onRefresh: () => listKategoriEvent(),
                                    child: ListView.builder(
                                        itemCount: listKategoriAdd.length,
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
                                                  disabledColor: Colors.white,
                                                  disabledTextColor:
                                                      Colors.red[400],
                                                  padding: EdgeInsets.all(15.0),
                                                  splashColor:
                                                      Colors.blueAccent,
                                                  child: Icon(
                                                    Icons.close,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await progressApiAction
                                                          .show();
                                                      final addadminevent =
                                                          await http.post(
                                                              url(
                                                                  'api/delete_opsicreateevent'),
                                                              headers:
                                                                  requestHeaders,
                                                              body: {
                                                            'event':
                                                                widget.event,
                                                            'kategori':
                                                                listKategoriAdd[
                                                                        index]
                                                                    .id,
                                                            'typehapuskategori':
                                                                'kategori',
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
                                                          progressApiAction
                                                              .hide()
                                                              .then((isHidden) {
                                                            print(isHidden);
                                                          });
                                                          setState(() {
                                                            listKategoriAdd.remove(
                                                                listKategoriAdd[
                                                                    index]);
                                                          });
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Berhasil !");
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Gagal, Silahkan Coba Kembali");
                                                        progressApiAction
                                                            .hide()
                                                            .then((isHidden) {
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
                                            title: Text(listKategoriAdd[index]
                                                        .nama ==
                                                    null
                                                ? 'Unknown Nama'
                                                : listKategoriAdd[index].nama),
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
