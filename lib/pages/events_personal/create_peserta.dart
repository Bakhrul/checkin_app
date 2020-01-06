import 'package:checkin_app/pages/events_personal/create.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'manage_peserta.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';

bool isLoading, isError;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
var datepicker;
List<ListUser> listUserItem = [];

class ManajemeCreatePeserta extends StatefulWidget {
  ManajemeCreatePeserta({Key key, this.title, this.event}) : super(key: key);
  final String title, event;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreatePesertaState();
  }
}

class _ManajemeCreatePesertaState extends State<ManajemeCreatePeserta> {
  @override
  void initState() {
    datepicker = FocusNode();
    super.initState();
    isLoading = true;
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
    });
    try {
      final willcomeevent = await http.post(
        url('api/getdataparticipant'),
        headers: requestHeaders,
      );

      if (willcomeevent.statusCode == 200) {
        var listuserJson = json.decode(willcomeevent.body);
        var listUsers = listuserJson['participant'];
        listUserItem = [];
        for (var i in listUsers) {
          ListUser willcomex = ListUser(
            id: '${i['us_code']}',
            nama: i['us_name'],
            email: i['us_email'],
          );
          listUserItem.add(willcomex);
        }
        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (willcomeevent.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(willcomeevent.body);
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
          "Tambahkan Peserta Event",
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
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: TextField(
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
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
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            itemCount: listUserItem.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: Container(
                                  child: Card(
                                      child: ListTile(
                                    leading: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              'images/imgavatar.png',
                                            ),
                                          ),
                                        )),
                                    title: Text(listUserItem[index].nama == null
                                        ? 'Unknown Nama'
                                        : listUserItem[index].nama),
                                    subtitle: Text(
                                        listUserItem[index].email == null
                                            ? 'Unknown Email'
                                            : listUserItem[index].email),
                                  )),
                                ),
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text('Peringatan!'),
                                      content: Text(
                                          'Apakah Anda Ingin Menambahkan Peserta ini ke Event Anda? '),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Tidak'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          textColor: Colors.green,
                                          child: Text('Ya'),
                                          onPressed: () async {
                                            try {
                                              Fluttertoast.showToast(
                                                      msg:
                                                          "Mohon Tunggu Sebentar");
                                              final hapuswishlist = await http
                                                  .post(
                                                      url('api/addpeserta_event'),
                                                      headers: requestHeaders,
                                                      body: {
                                                    'event': widget.event,
                                                    'peserta':
                                                        listUserItem[index].id,
                                                  });

                                              if (hapuswishlist.statusCode ==
                                                  200) {
                                                var hapuswishlistJson = json
                                                    .decode(hapuswishlist.body);
                                                if (hapuswishlistJson[
                                                        'status'] ==
                                                    'success') {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ManagePeserta(event: widget.event)));
                                                } else if (hapuswishlistJson[
                                                        'status'] ==
                                                    'sudah ada') {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Member ini sudah terdaftar pada event anda");
                                                } else if (hapuswishlistJson[
                                                        'status'] ==
                                                    'belumacc') {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Pendaftaran member ini menunggu persetujuan dari anda");
                                                }
                                              } else {
                                                print(hapuswishlist.body);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Request failed with status: ${hapuswishlist.statusCode}");
                                              }
                                            } on TimeoutException catch (_) {
                                              Fluttertoast.showToast(
                                                  msg: "Timed out, Try again");
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  );
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
