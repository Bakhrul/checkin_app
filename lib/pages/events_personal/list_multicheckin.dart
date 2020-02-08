import 'package:flutter/material.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'detail_user_checkin.dart';
import 'package:checkin_app/utils/utils.dart';

var list = ['one', 'two', 'three', 'four'];
bool isLoading, isError, isFilter, isErrorfilter;
String tokenType, accessToken, ideventget;
final TextEditingController _searchQuery = new TextEditingController();
final _debouncer = Debouncer(milliseconds: 500);
bool actionBackAppBar, iconButtonAppbarColor;
Map<String, String> requestHeaders = Map();
var datepicker;
String namaEventX;
List<LisMultiCheckinUser> listCheckinUser = [];

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

class ListMultiCheckin extends StatefulWidget {
  ListMultiCheckin({Key key, this.title, this.event, this.namaEvent}) : super(key: key);
  final String title, event, namaEvent;
  @override
  State<StatefulWidget> createState() {
    return _ListMultiCheckinState();
  }
}

class _ListMultiCheckinState extends State<ListMultiCheckin> {
  @override
  void initState() {
    datepicker = FocusNode();
    super.initState();
    namaEventX = widget.namaEvent;  
    actionBackAppBar = true;
    iconButtonAppbarColor = true;
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
      this.appBarTitle = Text(
        "Kelola Checkin Peserta $namaEventX",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
    });
    try {
      final resultCheckinParticipant = await http.post(
        url('api/getdatacheckinuser'),
        body: {
          'event_id': widget.event,
        },
        headers: requestHeaders,
      );

      if (resultCheckinParticipant.statusCode == 200) {
        var listuserJson = json.decode(resultCheckinParticipant.body);
        print(listuserJson);
        listCheckinUser = [];
        for (var i in listuserJson) {
          LisMultiCheckinUser willcomex = LisMultiCheckinUser(
            idpeserta: i['idpeserta'].toString(),
            nama: i['name'],
            image: i['image'],
            email: i['email'].toString(),
            listcheckin: i['checkin'],
          );
          listCheckinUser.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
          isFilter = false;
          isErrorfilter = false;
        });
      } else if (resultCheckinParticipant.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
          isFilter = false;
          isErrorfilter = false;
        });
      } else {
        print(resultCheckinParticipant.body);
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

  Future<List<List>> listUserFilter() async {
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
      final resultCheckinParticipant = await http.post(
        url('api/getdatacheckinuser'),
        body: {
          'event_id': widget.event,
          'filter': _searchQuery.text,
        },
        headers: requestHeaders,
      );

      if (resultCheckinParticipant.statusCode == 200) {
        var listuserJson = json.decode(resultCheckinParticipant.body);
        print(listuserJson);
        listCheckinUser = [];
        for (var i in listuserJson) {
          LisMultiCheckinUser willcomex = LisMultiCheckinUser(
            idpeserta: i['idpeserta'].toString(),
            nama: i['name'],
            image: i['image'],
            email: i['email'].toString(),
            listcheckin: i['checkin'],
          );
          listCheckinUser.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
          isLoading = false;
          isError = false;
        });
      } else if (resultCheckinParticipant.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isFilter = false;
          isErrorfilter = true;
          isLoading = false;
          isError = false;
        });
      } else {
        print(resultCheckinParticipant.body);
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
        namaEventX == null ? "Kelola Checkin Peserta" : "Kelola Checkin Peserta $namaEventX",
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
    "Kelola Checkin Peserta $namaEventX",
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
              : isFilter == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          isErrorfilter == true
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
                              : listCheckinUser.length == 0
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
                                  : Expanded(
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          // scrollDirection: Axis.horizontal,
                                          itemCount: listCheckinUser.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailUserCheckin(
                                                          idUser:
                                                              listCheckinUser[
                                                                      index]
                                                                  .idpeserta,
                                                          idevent: widget.event,
                                                          namaParticipant:
                                                              listCheckinUser[
                                                                      index]
                                                                  .nama,
                                                        ),
                                                      ));
                                                },
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
                                                        image: listCheckinUser[
                                                                            index]
                                                                        .image ==
                                                                    null ||
                                                                listCheckinUser[
                                                                            index]
                                                                        .image ==
                                                                    '' ||
                                                                listCheckinUser[
                                                                            index]
                                                                        .image ==
                                                                    'null'
                                                            ? url(
                                                                'assets/images/imgavatar.png')
                                                            : url(
                                                                'storage/image/profile/${listCheckinUser[index].image}'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                      listCheckinUser[index]
                                                                      .nama ==
                                                                  null ||
                                                              listCheckinUser[
                                                                          index]
                                                                      .nama ==
                                                                  ''
                                                          ? 'Peserta tidak diketahui'
                                                          : listCheckinUser[
                                                                  index]
                                                              .nama,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Text(listCheckinUser[
                                                                        index]
                                                                    .email ==
                                                                null ||
                                                            listCheckinUser[
                                                                        index]
                                                                    .email ==
                                                                ''
                                                        ? 'Email tidak diketahui'
                                                        : listCheckinUser[index]
                                                            .email),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      listCheckinUser[index]
                                                                  .listcheckin
                                                                  .length ==
                                                              1
                                                          ? appendFour()
                                                          : listCheckinUser[
                                                                          index]
                                                                      .listcheckin
                                                                      .length ==
                                                                  2
                                                              ? appendThree()
                                                              : listCheckinUser[
                                                                              index]
                                                                          .listcheckin
                                                                          .length ==
                                                                      3
                                                                  ? appendTwo()
                                                                  : listCheckinUser[index]
                                                                              .listcheckin
                                                                              .length ==
                                                                          4
                                                                      ? appendOne()
                                                                      : listCheckinUser[index].listcheckin.length ==
                                                                              0
                                                                          ? appendFive()
                                                                          : Container(),
                                                      for (var x
                                                          in listCheckinUser[
                                                                  index]
                                                              .listcheckin)
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 3.0),
                                                            height: 15.0,
                                                            alignment: Alignment
                                                                .center,
                                                            width: 15.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: x['uc_userid'] ==
                                                                      null
                                                                  ? Border.all(
                                                                      color: Color.fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          1.0),
                                                                      width:
                                                                          1.0)
                                                                  : Border.all(
                                                                      color: Color.fromRGBO(
                                                                          0,
                                                                          204,
                                                                          65,
                                                                          1.0),
                                                                      width:
                                                                          1.0),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          100.0) //                 <--- border radius here
                                                                      ),
                                                              color: x['uc_userid'] ==
                                                                      null
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          1.0)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          204,
                                                                          65,
                                                                          1.0),
                                                            ),
                                                            child: x['uc_userid'] ==
                                                                    null
                                                                ? Icon(
                                                                    Icons.close,
                                                                    size: 10,
                                                                    color: Colors
                                                                        .white)
                                                                : Icon(
                                                                    Icons.check,
                                                                    size: 10,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                )));
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
                                listUserFilter();
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
                            hintText: "Cari Berdasarkan Nama Peserta",
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
  // Widget buildBar(BuildContext context) {
  //   return AppBar(
  //     centerTitle: true,
  //     title: appBarTitle,
  //     backgroundColor: primaryAppBarColor,
  //     actions: <Widget>[],
  //   );
  // }

  Widget appendFive() {
    return Row(
      children: <Widget>[
        for (var x = 0; x < 5; x++)
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              margin: EdgeInsets.only(right: 3.0),
              height: 15.0,
              alignment: Alignment.center,
              width: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        100.0) //                 <--- border radius here
                    ),
                color: Colors.grey,
              ),
              child: Icon(Icons.remove, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget appendFour() {
    return Row(
      children: <Widget>[
        for (var x = 0; x < 4; x++)
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              margin: EdgeInsets.only(right: 3.0),
              height: 15.0,
              alignment: Alignment.center,
              width: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        100.0) //                 <--- border radius here
                    ),
                color: Colors.grey,
              ),
              child: Icon(Icons.remove, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget appendThree() {
    return Row(
      children: <Widget>[
        for (var x = 0; x < 3; x++)
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              margin: EdgeInsets.only(right: 3.0),
              height: 15.0,
              alignment: Alignment.center,
              width: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        100.0) //                 <--- border radius here
                    ),
                color: Colors.grey,
              ),
              child: Icon(Icons.remove, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget appendTwo() {
    return Row(
      children: <Widget>[
        for (var x = 0; x < 2; x++)
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              margin: EdgeInsets.only(right: 3.0),
              height: 15.0,
              alignment: Alignment.center,
              width: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        100.0) //                 <--- border radius here
                    ),
                color: Colors.grey,
              ),
              child: Icon(Icons.remove, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget appendOne() {
    return Row(
      children: <Widget>[
        for (var x = 0; x < 1; x++)
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              margin: EdgeInsets.only(right: 3.0),
              height: 15.0,
              alignment: Alignment.center,
              width: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        100.0) //                 <--- border radius here
                    ),
                color: Colors.grey,
              ),
              child: Icon(Icons.remove, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
