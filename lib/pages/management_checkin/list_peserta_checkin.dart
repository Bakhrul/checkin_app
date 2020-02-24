import 'dart:io';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/utils/utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<UserCheckin> listPeserta = [];
bool isLoading, isError;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class ListPesertaCheckin extends StatefulWidget {
  final String id;
  final String eventid, namaCheckin;

  ListPesertaCheckin({Key key, @required this.id, @required this.eventid, this.namaCheckin})
      : super(key: key);
  @override
  _ListPesertaCheckinState createState() => _ListPesertaCheckinState();
}

class _ListPesertaCheckinState extends State<ListPesertaCheckin>
    with SingleTickerProviderStateMixin {
  BuildContext context;
  File imageProfile;

  Future<List<List>> getData() async {
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
      final getParticipantEventFilter = await http.get(
        url('api/checkin/getdata/usercheckin/${widget.id.toString()}/${widget.eventid.toString()}'),
        headers: requestHeaders,
      );
      if (getParticipantEventFilter.statusCode == 200) {
        var listuserJson = json.decode(getParticipantEventFilter.body);
        for (var i = 0; i < listuserJson.length; i++) {
          UserCheckin peserta = UserCheckin(
            name: listuserJson[i]["name"].toString(),
            email: listuserJson[i]["email"].toString(),
            picProfile: listuserJson[i]["pic_profile"],
          );
          listPeserta.add(peserta);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (getParticipantEventFilter.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = false;
        });
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
      } else {
        setState(() {
          isLoading = false;
          isError = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = false;
      });
      debugPrint('$e');
    }
    return null;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
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
          "Daftar Peserta CheckIn ${widget.namaCheckin}",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            isLoading == true
                ? Container(
                  height: 100.0,
                  margin: EdgeInsets.only(top:20.0),
                  child: Center(
                      child: CircularProgressIndicator(),
                    ),
                )
                : isError == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RefreshIndicator(
                          onRefresh: () => getData(),
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
                                    getData();
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
                    : SafeArea(
                        child: listPeserta.length > 0
                            ? _builderListView()
                            : Padding(
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
                                        "Belum Ada Peserta Yang Checkin",
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
                              ),
                      )
          ],
        )),
      ),
    );
  }

  Widget _builderListView() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: Expanded(
            child: SizedBox(
                child: SingleChildScrollView(
              child: Column(
                  children: listPeserta
                      .map((UserCheckin f) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Card(
                              child: ListTile(
                                leading: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            placeholder: 'images/loading.gif',
                                            image: f.picProfile == null ||
                                                    f.picProfile == ''
                                                ? url(
                                                    'assets/images/imgavatar.png')
                                                : url(
                                                    'storage/image/profile/${f.picProfile}')))),
                                title: Text(f.name == null || f.name == '' ? 'Peserta tidak diketahui' : f.name),
                                onTap: () async {},
                                subtitle: Text(f.name.toString()),
                              ),
                            ),
                          ))
                      .toList()),
            )),
          ),
        ),
      ],
    );
  }
}
