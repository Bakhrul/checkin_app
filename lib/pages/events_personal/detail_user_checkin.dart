import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'tambah_checkin.dart';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'package:shimmer/shimmer.dart';
import 'model.dart';
import 'package:intl/intl.dart';

import 'package:checkin_app/utils/utils.dart';

bool isLoading, isError;
String jumlahhadirX,
    jumlahtidakhadirX,
    jumlahpesertaX,
    percentX,
    jumlahcheckinX,
    namaParticipantX;
List<ListUserCheckins> listuserscheckin = [];

class DetailUserCheckin extends StatefulWidget {
  DetailUserCheckin(
      {Key key, this.title, this.idevent, this.idUser, this.namaParticipant})
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
    namaParticipantX =
        widget.namaParticipant == null || widget.namaParticipant == ''
            ? "Participant"
            : widget.namaParticipant;
    jumlahhadirX = '0';
    jumlahpesertaX = '0';
    jumlahtidakhadirX = '0';
    jumlahcheckinX = '0';
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
      isError = false;
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
        String jumlahhadir = listuserJson['jumlahhadir'].toString();
        String jumlahtidakhadir = listuserJson['jumlahtidakhadir'].toString();
        String percent = listuserJson['percent'].toString();
        String jumlahcheckin = listuserJson['jumlahcheckin'].toString();
        print(int.parse(jumlahhadir) / int.parse(jumlahtidakhadir));
        print(percent);
        setState(() {
          jumlahhadirX = jumlahhadir;
          jumlahcheckinX = jumlahcheckin;
          jumlahtidakhadirX = jumlahtidakhadir;
          percentX = percent;
        });
        listuserscheckin = [];
        for (var i in listUsers) {
          ListUserCheckins willcomex = ListUserCheckins(
            idCheckin: i['ec_checkid'].toString(),
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
        body: isLoading == true
            ? loadingView()
            : isError == true
                ? RefreshIndicator(
                    onRefresh: () => listcheckin(),
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
                              top: 20.0, left: 15.0,bottom: 15.0, right: 15.0),
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
                                listcheckin();
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
                : RefreshIndicator(
                    onRefresh: () => listcheckin(),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Column(
                              children: <Widget>[
                                listuserscheckin.length == 0
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
                                    : Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 10.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: listuserscheckin
                                                    .map(
                                                        (ListUserCheckins
                                                                item) =>
                                                            Card(
                                                                child: ListTile(
                                                              leading: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        40.0,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 40.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color: item.userId == null || item.userId == '' || item.userId == 'null'
                                                                              ? Color.fromRGBO(204, 204, 204,
                                                                                  1.0)
                                                                              : Color.fromRGBO(0, 204, 65,
                                                                                  1.0),
                                                                          width:
                                                                              2.0),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(100.0) //                 <--- border radius here
                                                                              ),
                                                                      color: item.userId == null ||
                                                                              item.userId ==
                                                                                  '' ||
                                                                              item.userId ==
                                                                                  'null'
                                                                          ? Colors
                                                                              .white
                                                                          : Color.fromRGBO(
                                                                              153,
                                                                              255,
                                                                              185,
                                                                              1.0),
                                                                    ),
                                                                    child: Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: item.userId == null || item.userId == '' || item.userId == 'null'
                                                                            ? Color.fromRGBO(
                                                                                204,
                                                                                204,
                                                                                204,
                                                                                1.0)
                                                                            : Color.fromRGBO(
                                                                                0,
                                                                                204,
                                                                                65,
                                                                                1.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                  item.keyword == null ||
                                                                          item.keyword ==
                                                                              ''
                                                                      ? 'Kata Kunci Tidak Diketahui'
                                                                      : item
                                                                          .keyword,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              subtitle: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0),
                                                                child: Text(item
                                                                                .ucTime ==
                                                                            null ||
                                                                        item.ucTime ==
                                                                            '' ||
                                                                        item.ucTime ==
                                                                            'null'
                                                                    ? 'Belum Melakukan CheckIn'
                                                                    : DateFormat(
                                                                            'dd MMM yyyy H:m:s')
                                                                        .format(
                                                                            DateTime.parse(item.ucTime))),
                                                              ),
                                                            )))
                                                    .toList(),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(15.0),
                                              margin: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        217, 217, 217, 1.0),
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        10.0) //                 <--- border radius here
                                                    ),
                                                color: Color.fromRGBO(
                                                    242, 242, 242, 1.0),
                                              ),
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5.0),
                                                    child: Text(
                                                      'Indikator Absensi CheckIn',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 10.0),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 120.0,
                                                      lineWidth: 8.0,
                                                      animation: true,
                                                      percent: int.parse(
                                                              jumlahhadirX
                                                                  .toString()) /
                                                          int.parse(
                                                              jumlahcheckinX
                                                                  .toString()),
                                                      center: Text(
                                                        percentX,
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20.0),
                                                      ),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      progressColor:
                                                          Colors.purple,
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          3.0),
                                                              height: 15.0,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 15.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            204,
                                                                            65,
                                                                            1.0),
                                                                    width: 1.0),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            100.0) //                 <--- border radius here
                                                                        ),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        204,
                                                                        65,
                                                                        1.0),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0),
                                                            child: Text(
                                                                jumlahhadirX +
                                                                    ' Sudah Checkin'),
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          3.0),
                                                              height: 15.0,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 15.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            100.0) //                 <--- border radius here
                                                                        ),
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0),
                                                            child: Text(
                                                                jumlahtidakhadirX +
                                                                    ' Belum Checkin'),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
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
    return AppBar(
      centerTitle: true,
      title: Text(
        "Detail CheckIn Peserta ${widget.namaParticipant}",
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: primaryAppBarColor,
      actions: <Widget>[],
    );
  }
}
