import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/participant.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:checkin_app/pages/events_all/detail_event.dart';
import 'dart:core';

String tokenType, accessToken;
List<UserParticipant> listParticipant = [];
bool isLoading, isError, isAction, isSuccess;
Map<String, String> requestHeaders = Map();
Map dataUser;
enum PageEnum {
  detailEvent,
  batalkanEvent,
  tolakConfirmation,
  outEvent,
}

class EventOrder extends StatefulWidget {
  EventOrder({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _EventOrder();
  }
}

class _EventOrder extends State<EventOrder> {
  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
    isAction = false;
    isSuccess = false;
    getHeaderHTTP();
    _getUserData();
  }

  _outFromEvent(pesertaId, eventId, creatorId, userName) async {
    setState(() {
      isLoading == true;
    });
    try {
      dynamic body = {
        "peserta": pesertaId.toString(),
        "event": eventId.toString(),
        "creator": creatorId.toString(),
        "notif": 'keluarkan orang lain dari event',
        "user_name": userName.toString()
      };
      dynamic response =
          await RequestPost(name: "deletepeserta_event", body: body)
              .sendrequest();
      print(response['status']);
      if (response['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Berhasil Keluar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        isSuccess = true;
        isLoading = false;

        // getDataCheckin();
      } else {
        Fluttertoast.showToast(
            msg: "Terjadi Kesalahan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        isLoading = false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        // isError = true;
      });
      debugPrint('$e');
    }
  }

  Future _cancelRegisterEvent(idEvent, idUser) async {
    setState(() {
      isLoading = true;
    });

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print("ID" + idEvent.toString() + idUser.toString());
    Map body = {
      'event_id': idEvent.toString(),
      'user_id': idUser.toString(),
      'type': 'someone'
    };

    try {
      final ongoingevent = await http.post(url('api/event/cancelregisterevent'),
          headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        setState(() {
          isLoading = false;
          isSuccess = true;
        });
        Fluttertoast.showToast(msg: "Anda Membatalkan Pendaftaran Anda");
        await new Future.delayed(new Duration(seconds: 1));

        // return Navigator.pop(context);
      } else if (ongoingevent.statusCode == 401) {
        Fluttertoast.showToast(msg: "Gagal Membatalkan Event");
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Time out, silahkan coba lagi nanti");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      setState(() {
        isLoading = false;
      });
    }
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
    return listParticipants();
  }

  _getUserData() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final ongoingevent =
          await http.get(url('api/user'), headers: requestHeaders);

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);

        if (mounted) {
          setState(() {
            dataUser = rawData;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print(e);
    }
  }

  Future<List<List>> listParticipants() async {
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
      final participant = await http.get(
        url('api/event/getevent/order'),
        headers: requestHeaders,
      );

      if (participant.statusCode == 200) {
        var listParticipantToJson = json.decode(participant.body);
        var participants = listParticipantToJson;
        // String jumlahnotifGet = listNotificationJson['jumlahnotif'].toString();
        // setState(() {
        //   jumlahnotifX = jumlahnotifGet;
        // });
        listParticipant = [];

        for (var i in participants) {
          UserParticipant participant = UserParticipant(
              userId: i['id_user'].toString(),
              eventId: i['id_event'].toString(),
              status: i['status'],
              participant: i['participant'],
              position: i['position'].toString(),
              userName: i['name_of_user'],
              eventName: i['name_of_event'],
              creatorId: i['creator_id'],
              dateRegist: i['date_regist']);
          listParticipant.add(participant);
        }

        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (participant.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token telah kadaluwarsa, silahkan login kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        print(participant.body);
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
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "List Order Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        backgroundColor: primaryAppBarColor,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isError == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => listParticipants(),
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
                              listParticipants();
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
              : listParticipant.length == 0
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
                              "Anda belum  mendaftarkan orang lain ke event",
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
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          isAction == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                        width: 20.0,
                                        margin: EdgeInsets.all(15.0),
                                        height: 20.0,
                                        child: CircularProgressIndicator()),
                                  ],
                                )
                              : Container(),
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                // scrollDirection: Axis.horizontal,
                                itemCount: listParticipant.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                        trailing: PopupMenuButton<PageEnum>(
                                          onSelected: (PageEnum value) {
                                            switch (value) {
                                              case PageEnum.detailEvent:
                                                Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            RegisterEvents(
                                                              id: int.parse(
                                                                  listParticipant[
                                                                          index]
                                                                      .eventId),
                                                              creatorId:
                                                                  listParticipant[
                                                                          index]
                                                                      .creatorId,
                                                              dataUser:
                                                                  dataUser,
                                                              selfEvent: true,
                                                            )));
                                                break;
                                              case PageEnum.batalkanEvent:
                                                _cancelRegisterEvent(
                                                  listParticipant[index]
                                                      .eventId
                                                      .toString(),
                                                  listParticipant[index]
                                                      .userId
                                                      .toString(),
                                                );
                                                //  isSuccess != false ?
                                                listParticipant.remove(
                                                    listParticipant[index]);
                                                break;
                                              case PageEnum.outEvent:
                                                _outFromEvent(
                                                  listParticipant[index]
                                                      .participant
                                                      .toString(),
                                                  listParticipant[index]
                                                      .eventId
                                                      .toString(),
                                                  listParticipant[index]
                                                      .creatorId
                                                      .toString(),
                                                  listParticipant[index]
                                                      .userName
                                                      .toString(),
                                                );
                                                // isSuccess != false ?
                                                listParticipant.remove(
                                                    listParticipant[index]);
                                                break;

                                              default:
                                                break;
                                            }
                                          },
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: PageEnum.detailEvent,
                                              child: Text("Lihat Detail Event"),
                                            ),
                                            listParticipant[index].status == "P"
                                                ? PopupMenuItem(
                                                    value:
                                                        PageEnum.batalkanEvent,
                                                    child:
                                                        Text("Batalkan Event"),
                                                  )
                                                : PopupMenuItem(
                                                    value: PageEnum.outEvent,
                                                    child: Text("Keluar Event"),
                                                  ),
                                          ],
                                        ),
                                        leading: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: listParticipant[index]
                                                          .status ==
                                                      "A"
                                                  ? Container(
                                                      height: 30.0,
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100.0) //                 <--- border radius here
                                                                ),
                                                        color: Color.fromRGBO(
                                                            0, 204, 65, 1.0),
                                                      ),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 30.0,
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100.0) //                 <--- border radius here
                                                                ),
                                                        color:
                                                            Colors.orangeAccent,
                                                      ),
                                                      child: Text("P"))),
                                        ),
                                        title: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Text(
                                              "${listParticipant[index].userName}",
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 2,
                                            )),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${listParticipant[index].eventName}",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2.0)),
                                              listParticipant[index].status ==
                                                      "P"
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10.0),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.0),
                                                      width: 200.0,
                                                      child: Text(
                                                        'Menunggu Konfirmasi',
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ))
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.0),
                                                      width: 200,
                                                      child: Text(
                                                        'Sudah Terdaftar',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ))
                                            ],
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
    );
  }
}
