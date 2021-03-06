import 'package:flutter/material.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'detail_user_checkin.dart';
import 'package:shimmer/shimmer.dart';
import 'package:checkin_app/utils/utils.dart';

bool isLoading, isError, isFilter, isErrorfilter;
String tokenType, accessToken, ideventget;
bool actionBackAppBar, iconButtonAppbarColor;
String namaEventX;
Map<String, String> requestHeaders = Map();
final TextEditingController _searchQuery = new TextEditingController();
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
  PointEvents({Key key, this.title, this.idevent, this.namaEvent})
      : super(key: key);
  final String title, idevent, namaEvent;
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
        namaEventX == null
            ? "Hasil Akhir Peserta Event"
            : "Hasil Akhir Peserta Event $namaEventX",
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
      isError = false;
      isFilter = false;
      isErrorfilter = false;
      this.appBarTitle = Text(
        "Hasil Akhir Peserta Event $namaEventX",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      );
    });
    try {
      final resultCheckinParticipant = await http.post(
        url('api/checkin/getdata/countcheckin/users'),
        body: {
          'idevent': widget.idevent,
        },
        headers: requestHeaders,
      );

      if (resultCheckinParticipant.statusCode == 200) {
        var listuserJson = json.decode(resultCheckinParticipant.body);
        print(listuserJson);
        listpointcheckin = [];
        for (var i in listuserJson) {
          ListPointCheckin willcomex = ListPointCheckin(
            idpeserta: i['idparticipant'].toString(),
            namapeserta: i['name'],
            image: i['image'],
            jumlahcheckinevent: i['of_checkin'].toString(),
            jumlahcheckinpeserta: i['total_checkin'].toString(),
            persencheckin: i['percentage'].toString(),
          );
          listpointcheckin.add(willcomex);
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
      isErrorfilter = false;
      isLoading = false;
      isError = false;
    });
    try {
      final resultCheckinParticipantFilter = await http.post(
        url('api/checkin/getdata/countcheckin/users'),
        body: {
          'idevent': widget.idevent,
          'filter': _searchQuery.text,
        },
        headers: requestHeaders,
      );

      if (resultCheckinParticipantFilter.statusCode == 200) {
        var listuserJson = json.decode(resultCheckinParticipantFilter.body);
        print(listuserJson);
        listpointcheckin = [];
        for (var i in listuserJson) {
          ListPointCheckin willcomex = ListPointCheckin(
            namapeserta: i['name'],
            image: i['image'],
            jumlahcheckinevent: i['of_checkin'].toString(),
            jumlahcheckinpeserta: i['total_checkin'].toString(),
            persencheckin: i['percentage'].toString(),
          );
          listpointcheckin.add(willcomex);
        }
        setState(() {
          isFilter = false;
          isErrorfilter = false;
          isLoading = false;
          isError = false;
        });
      } else if (resultCheckinParticipantFilter.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isFilter = false;
          isErrorfilter = true;
          isLoading = false;
          isError = false;
        });
      } else {
        print(resultCheckinParticipantFilter.body);
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

  Widget appBarTitle = Text(
    namaEventX == null || namaEventX == ''
        ? "Hasil Akhir Peserta Event"
        : "Hasil Akhir Peserta Event $namaEventX",
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
            ? loadingView()
            : isError == true
                ? RefreshIndicator(
                    onRefresh: () => listUserfilter(),
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
                              top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
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
                                listUserfilter();
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
                    ? loadingView()
                    : isErrorfilter == true
                        ? RefreshIndicator(
                            onRefresh: () => listUserfilter(),
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(children: <Widget>[
                                new Container(
                                  width: 80.0,
                                  height: 80.0,
                                  child: Image.asset("images/system-eror.png"),
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
                        : listpointcheckin.length == 0
                            ? RefreshIndicator(
                                onRefresh: () => listUserfilter(),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
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
                                ))
                            : Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Column(children: <Widget>[
                                  Expanded(
                                    child: Scrollbar(
                                      child: RefreshIndicator(
                                        onRefresh: () => listUserfilter(),
                                        child: ListView.builder(                                         
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
                                            return InkWell(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DetailUserCheckin(
                                                            idUser:
                                                                listpointcheckin[
                                                                        index]
                                                                    .idpeserta,
                                                            idevent:
                                                                widget.idevent,
                                                            namaParticipant:
                                                                listpointcheckin[
                                                                        index]
                                                                    .namapeserta),
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
                                                          image: listpointcheckin[
                                                                              index]
                                                                          .image ==
                                                                      null ||
                                                                  listpointcheckin[
                                                                              index]
                                                                          .image ==
                                                                      '' ||
                                                                  listpointcheckin[
                                                                              index]
                                                                          .image ==
                                                                      'null'
                                                              ? url(
                                                                  'assets/images/imgavatar.png')
                                                              : url(
                                                                  'storage/image/profile/${listpointcheckin[index].image}'),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(listpointcheckin[
                                                                        index]
                                                                    .namapeserta ==
                                                                null ||
                                                            listpointcheckin[
                                                                        index]
                                                                    .namapeserta ==
                                                                ''
                                                        ? 'Peserta tidak diketahui'
                                                        : listpointcheckin[
                                                                index]
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
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ])));
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
}
