import 'package:checkin_app/pages/events_personal/manage_checkin.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';

bool isLoading, isError, isFilter, isErrorfilter;
String tokenType, accessToken, ideventget;
TextEditingController _filtercontroller = new TextEditingController();
Map<String, String> requestHeaders = Map();
var datepicker;
List<ListPointCheckin> listpointcheckin = [];
final _debouncer = Debouncer(milliseconds: 500);

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

class PointEvents extends StatefulWidget {
  PointEvents({Key key, this.title, this.idevent}) : super(key: key);
  final String title, idevent;
  @override
  State<StatefulWidget> createState() {
    return _PointEventsState();
  }
}

class _PointEventsState extends State<PointEvents> {
  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
    ideventget = widget.idevent;
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
    print(widget.idevent);
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
      final hasilakhirevent = await http.post(
        url('api/checkin/getdata/countcheckin/users'),
        body: {
          'idevent': widget.idevent,
        },
        headers: requestHeaders,
      );

      if (hasilakhirevent.statusCode == 200) {
        var listuserJson = json.decode(hasilakhirevent.body);
        print(listuserJson);
        listpointcheckin = [];
        for (var i in listuserJson) {
          ListPointCheckin willcomex = ListPointCheckin(
            namapeserta: i['name'],
            jumlahcheckinevent: i['of_checkin'].toString(),
            jumlahcheckinpeserta: i['total_checkin'].toString(),
            persencheckin: i['percentage'].toString(),
          );
          listpointcheckin.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (hasilakhirevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(hasilakhirevent.body);
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
      final willcomeevent = await http.post(
        url('api/checkin/getdata/countcheckin/users'),
        body: {
          'idevent': widget.idevent,
          'filter' : _filtercontroller.text,
        },
        headers: requestHeaders,
      );

      if (willcomeevent.statusCode == 200) {
        var listuserJson = json.decode(willcomeevent.body);
        print(listuserJson);
        listpointcheckin = [];
        for (var i in listuserJson) {
          ListPointCheckin willcomex = ListPointCheckin(
            namapeserta: i['name'],
            jumlahcheckinevent: i['of_checkin'].toString(),
            jumlahcheckinpeserta: i['total_checkin'].toString(),
            persencheckin: i['percentage'].toString(),
          );
          listpointcheckin.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (willcomeevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isFilter = false;
          isErrorfilter = true;
        });
      } else {
        print(willcomeevent.body);
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

  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Kelola Hasil Absen Peserta",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }

  final TextEditingController _searchQuery = new TextEditingController();

  Widget appBarTitle = Text(
    "Kelola Hasil Absen Peserta",
    style: TextStyle(fontSize: 16),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
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
                              hintText: "Cari Berdasarkan Nama Lengkap",
                              border: InputBorder.none,
                            )),
                      ),
                      isFilter == true
                          ? Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: CircularProgressIndicator(),
                            )
                          : listpointcheckin.length == 0
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
                                          "Peserta event tidak ada / tidak ditemukan",
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
                                              top: 20.0,
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
                                          itemCount: listpointcheckin.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String jumlahcheckinpeserta =
                                                listpointcheckin[index]
                                                    .jumlahcheckinpeserta;
                                            String jumlahcheckinevent =
                                                listpointcheckin[index]
                                                    .jumlahcheckinevent;
                                            String persencheckinpeserta =
                                                listpointcheckin[index]
                                                    .persencheckin;
                                            return Card(
                                              child: ListTile(
                                                leading: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration:
                                                        new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                          'images/imgavatar.png',
                                                        ),
                                                      ),
                                                    )),
                                                title: Text(listpointcheckin[
                                                                    index]
                                                                .namapeserta ==
                                                            null ||
                                                        listpointcheckin[index]
                                                                .namapeserta ==
                                                            ''
                                                    ? 'Peserta tidak diketahui'
                                                    : listpointcheckin[index]
                                                        .namapeserta),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                      '$jumlahcheckinpeserta / $jumlahcheckinevent Total Absen'),
                                                ),
                                                trailing: Text(
                                                    '$persencheckinpeserta %',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          41, 30, 47, 1),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
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

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
      ],
    );
  }
}
