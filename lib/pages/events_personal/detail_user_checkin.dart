import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'tambah_checkin.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'model.dart';
import 'package:intl/intl.dart';

import 'package:checkin_app/utils/utils.dart';

bool isLoading, isError;
String jumlahhadirX, jumlahtidakhadirX, jumlahpesertaX, percentX, namaParticipantX;
List<ListUserCheckins> listuserscheckin = [];

class DetailUserCheckin extends StatefulWidget {
  DetailUserCheckin({Key key, this.title, this.idevent, this.idUser, this.namaParticipant})
      : super(key: key);
  final String title, idevent, idUser, namaParticipant;
  @override
  State<StatefulWidget> createState() {
    return _DetailUserCheckinState();
  }
}

class _DetailUserCheckinState extends State<DetailUserCheckin> {
  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    isLoading = true;
    isError = false;
    namaParticipantX = widget.namaParticipant == null || widget.namaParticipant == '' ? "Participant" : widget.namaParticipant;
    jumlahhadirX = '0';
    jumlahpesertaX = '0';
    jumlahtidakhadirX = '0';
    percentX = '0';
  }

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    return listcheckin();
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
      final getAttendParticipant = await http.post(
        url('api/event/detail_userCheckin'),
        body: {'event': widget.idevent, 'participant': widget.idUser},
        headers: requestHeaders,
      );

      if (getAttendParticipant.statusCode == 200) {
        var listuserJson = json.decode(getAttendParticipant.body);
        var listUsers = listuserJson['checkin'];
        listuserscheckin = [];
        for (var i in listUsers) {
          ListUserCheckins willcomex = ListUserCheckins(
            idCheckin : i['ec_checkid'].toString(),
            keyword: i['ec_keyword'],
            userId: i['uc_userid'].toString(),
            ucTime: i['uc_time'],
          );
          listuserscheckin.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getAttendParticipant.statusCode == 401) {
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

  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildBar(context),
      body:
      isLoading == true
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
              :  Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Column(
                            children: <Widget>[
                              listuserscheckin.length == 0
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
                                              "Event Belum Memiliki CheckIn Sama Sekali",
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
                                  :
                              Expanded(
                                child: Scrollbar(
                                  child: ListView.builder(
                                    // scrollDirection: Axis.horizontal,
                                    itemCount: listuserscheckin.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                          child: ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Container(
                                              height: 40.0,
                                              alignment: Alignment.center,
                                              width: 40.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: listuserscheckin[index].userId == null || listuserscheckin[index].userId == '' || listuserscheckin[index].userId == 'null'
                                                        ? Color.fromRGBO(
                                                            204, 204, 204, 1.0)
                                                        : Color.fromRGBO(
                                                            0, 204, 65, 1.0),
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        100.0) //                 <--- border radius here
                                                    ),
                                                color:
                                                    listuserscheckin[index].userId == null || listuserscheckin[index].userId == '' || listuserscheckin[index].userId == 'null'
                                                        ? Colors.white
                                                        : Color.fromRGBO(
                                                            153, 255, 185, 1.0),
                                              ),
                                              child: Icon(Icons.check,
                                                  color: listuserscheckin[index].userId == null || listuserscheckin[index].userId == '' || listuserscheckin[index].userId == 'null'
                                                      ? Color.fromRGBO(
                                                          204, 204, 204, 1.0)
                                                      : Color.fromRGBO(
                                                          0, 204, 65, 1.0)),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                            listuserscheckin[index].keyword == null ||
                                                    listuserscheckin[index].keyword == ''
                                                ? 'Kata Kunci Tidak Diketahui'
                                                : listuserscheckin[index].keyword,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                              listuserscheckin[index].ucTime == null || listuserscheckin[index].ucTime == '' || listuserscheckin[index].ucTime == 'null'
                                                  ? 'Belum Melakukan CheckIn'
                                                  : DateFormat('dd MMM yyyy H:m:s').format(DateTime.parse(listuserscheckin[index].ucTime))),
                                        ),
                                      ));
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
      title: Text(
    "Detail CheckIn Peserta ${widget.namaParticipant}",
    style: TextStyle(fontSize: 16),
  ),
      backgroundColor: primaryAppBarColor,
      actions: <Widget>[
      ],
    );
  }
}
