import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'tambah_checkin.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'model.dart';

bool isLoading, isError;
String jumlahhadirX, jumlahtidakhadirX, jumlahpesertaX, percentX;
List<ListCheckinUsers> listuserscheckin = [];

class ManageAbsenPeserta extends StatefulWidget {
  ManageAbsenPeserta({Key key, this.title, this.idevent, this.idcheckin})
      : super(key: key);
  final String title, idevent, idcheckin;
  @override
  State<StatefulWidget> createState() {
    return _ManageAbsenPesertaState();
  }
}

class _ManageAbsenPesertaState extends State<ManageAbsenPeserta> {
  @override
  void initState() {
    super.initState();
    getHeaderHTTP();
    isLoading = true;
    isError = false;
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
    print(requestHeaders);
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
        url('api/listUserscheckin'),
        body: {'event': widget.idevent, 'checkin': widget.idcheckin},
        headers: requestHeaders,
      );

      if (getAttendParticipant.statusCode == 200) {
        var listuserJson = json.decode(getAttendParticipant.body);
        var listUsers = listuserJson['checkinUsers'];
        String jumlahhadir = listuserJson['jumlahhadir'].toString();
        String jumlahtidakhadir = listuserJson['jumlahtidakhadir'].toString();
        String jumlahpeserta = listuserJson['jumlahpeserta'].toString();
        String percent = listuserJson['percent'].toString();
        setState(() {
          jumlahhadirX = jumlahhadir;
          jumlahtidakhadirX = jumlahtidakhadir;
          jumlahpesertaX = jumlahpeserta;
          percentX = percent;
        });
        print(listUsers);
        listuserscheckin = [];
        for (var i in listUsers) {
          ListCheckinUsers willcomex = ListCheckinUsers(
            idevent: '${i['ec_eventsid']}',
            idpeserta: '${i['ep_participants']}',
            idcheckin: '${i['ec_checkid']}',
            namapeserta: i['us_name'],
            emailpeserta: i['us_email'],
            statuscheckin: i['uc_userid'],
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
            msg: "Token telah kadaluwarsa, silahkan login kembali");
      } else {
        print(getAttendParticipant.body);
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

  Widget appBarTitle = Text(
    "Kelola Absen Peserta",
    style: TextStyle(fontSize: 16),
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
              : listuserscheckin.length == 0
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
                            top: 30.0,
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Center(
                            child: Text(
                              "Tidak Ada Peserta Yang Terdaftar",
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
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: listuserscheckin
                                  .map((ListCheckinUsers item) => Card(
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
                                                    color: item.statuscheckin ==
                                                            null
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
                                                    item.statuscheckin == null
                                                        ? Colors.white
                                                        : Color.fromRGBO(
                                                            153, 255, 185, 1.0),
                                              ),
                                              child: Icon(Icons.check,
                                                  color: item.statuscheckin ==
                                                          null
                                                      ? Color.fromRGBO(
                                                          204, 204, 204, 1.0)
                                                      : Color.fromRGBO(
                                                          0, 204, 65, 1.0)),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                            item.namapeserta == null ||
                                                    item.namapeserta == ''
                                                ? 'Peserta Tidak Diketahui'
                                                : item.namapeserta,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                              item.emailpeserta == null ||
                                                      item.emailpeserta == ''
                                                  ? 'Email Tidak Diketahui'
                                                  : item.emailpeserta),
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
                                  color: Color.fromRGBO(217, 217, 217, 1.0),
                                  width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      10.0) //                 <--- border radius here
                                  ),
                              color: Color.fromRGBO(242, 242, 242, 1.0),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    'Indikator Absensi Peserta Checkin',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 10.0),
                                  child: CircularPercentIndicator(
                                    radius: 120.0,
                                    lineWidth: 8.0,
                                    animation: true,
                                    percent: int.parse(
                                            jumlahhadirX.toString()) /
                                        int.parse(jumlahpesertaX.toString()),
                                    center: Text(
                                      percentX,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.purple,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Container(
                                            margin: EdgeInsets.only(right: 3.0),
                                            height: 15.0,
                                            alignment: Alignment.center,
                                            width: 15.0,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      0, 204, 65, 1.0),
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      100.0) //                 <--- border radius here
                                                  ),
                                              color: Color.fromRGBO(
                                                  0, 204, 65, 1.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child:
                                              Text(jumlahhadirX + ' Peserta'),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Container(
                                            margin: EdgeInsets.only(right: 3.0),
                                            height: 15.0,
                                            alignment: Alignment.center,
                                            width: 15.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      100.0) //                 <--- border radius here
                                                  ),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                              jumlahtidakhadirX + ' Peserta'),
                                        ),
                                      ],
                                    ))
                              ],
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
