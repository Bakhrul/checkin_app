import 'dart:io';

import 'package:checkin_app/model/search_event.dart';
import 'package:checkin_app/pages/events_all/model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:checkin_app/pages/register_event/step_register_one.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/profile/profile_organizer.dart';
import 'package:checkin_app/storage/storage.dart';
import 'dart:async';
import 'package:checkin_app/pages/register_event/step_register_six.dart';
import 'package:checkin_app/pages/register_event/step_register_three.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
List<ListRekomEvent> listRekomendasiEvent = [];

class RegisterEvents extends StatefulWidget {
  final int id;
  final bool selfEvent;
  final String creatorId;
  final Map dataUser;

  RegisterEvents(
      {Key key, this.id, this.creatorId, this.selfEvent, this.dataUser})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterEvent();
  }
}

class _RegisterEvent extends State<RegisterEvents> {
  SearchEvent searchEvent = new SearchEvent();
  SearchEvent dataEvent;
  bool _isLoading = true;
  String creatorEmail;
  String creatorName;
  bool _isDisconnect = false;
  ScrollController scrollPage = new ScrollController();
  double offset = 0; //12.5
  bool expired;

  @override
  void initState() {
    _getAll();
    scrollPage.addListener(_parallax);
    super.initState();
    print('testing' + widget.dataUser['us_code'].toString());
  }

  _parallax() {
    if (scrollPage.position.userScrollDirection == ScrollDirection.reverse) {
      setState(() {
        offset = scrollPage.position.pixels;
      });
    } else {
      setState(() {
        offset = scrollPage.position.pixels;
      });
    }
  }

  _reload() {
    setState(() {
      _isDisconnect = false;
      _isLoading = true;
    });

    _getAll();
  }

  _getAll() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    String id = widget.id.toString();

    try {
      final ongoingevent = await http.get(
        url('api/event/$id'),
        headers: requestHeaders,
      );

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);
        setState(() {
          dataEvent = SearchEvent.fromJson(rawData['data']);
          _isLoading = false;
          expired = dataEvent.expired;
          creatorEmail = rawData['creator_email'];
          creatorName = rawData['creator_name'];
        });

        var listRekomendasis = rawData['rekomendasi'];
        print(listRekomendasis);
        listRekomendasiEvent = [];
        for (var i in listRekomendasis) {
          ListRekomEvent willcomex = ListRekomEvent(
            id: i['ev_id'].toString(),
            image: i['ev_image'],
            title: i['ev_title'],
            waktuawal: DateFormat('dd MMM yyyy')
                .format(DateTime.parse(i['ev_time_start'])),
            waktuakhir: DateFormat('dd MMM yyyy')
                .format(DateTime.parse(i['ev_time_end'])),
            wishlist: i['ew_event'].toString(),
            idcreator: i['ev_create_user'].toString(),
            posisi: i['ep_position'].toString(),
            status: DateTime.parse(i['ev_time_end']).difference(DateTime.now()).inSeconds <= 0 ? 'selesai' : i['ep_status'],
          );
          listRekomendasiEvent.add(willcomex);
        }
      } else {
        setState(() {
          _isLoading = false;
          _isDisconnect = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
        _isDisconnect = true;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
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
          "Detail Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isDisconnect
              ? Center(
                  child: GestureDetector(
                      onTap: _reload,
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.refresh,
                              color: Colors.blueAccent, size: 25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]))))
              : SingleChildScrollView(
                  controller: scrollPage,
                  child: Column(children: <Widget>[
                    Stack(children: <Widget>[
                      Column(
                        children: <Widget>[
                          ClipRect(
                            child: Container(
                              height: 300.0,
                              padding: EdgeInsets.only(top: offset),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'images/noimage.jpg',
                                image: dataEvent.image == null ||
                                        dataEvent.image == '' ||
                                        dataEvent.image == 'null'
                                    ? 'images/noimage.jpg'
                                    : url(
                                        'storage/image/event/event_original/${dataEvent.image}'),
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        width: double.infinity,
                                        child: Text(
                                            dataEvent.title == null
                                                ? 'Memuat..'
                                                : dataEvent.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 15.0),
                                        width: double.infinity,
                                        child: Row(children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.location_on,
                                                size: 16,
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                              dataEvent.location == null
                                                  ? 'Memuat ...'
                                                  : dataEvent.location,
                                              style: TextStyle(
                                                  color: Colors.grey[600]))
                                        ])),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 15.0),
                                        width: double.infinity,
                                        child: Row(children: <Widget>[
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(Icons.date_range,
                                                  size: 16,
                                                  color: Colors.grey[600])),
                                          Text(
                                              dataEvent.start == null
                                                  ? "Memuat ..."
                                                  : dataEvent.start +
                                                      ' - ' +
                                                      dataEvent.end,
                                              style: TextStyle(
                                                  color: Colors.grey[600]))
                                        ])),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 25.0),
                                        width: double.infinity,
                                        child: Row(children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.access_time,
                                                size: 16,
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                              dataEvent.hour == null
                                                  ? 'Memuat ...'
                                                  : dataEvent.hour,
                                              style: TextStyle(
                                                  color: Colors.grey[600]))
                                        ])),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text('Tentang Event',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Text(dataEvent.detail,
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                height: 1.5))),
                                    Divider(),
                                    Container(
                                        margin: EdgeInsets.only(
                                            bottom: 20.0, top: 10.0),
                                        child: Text("Organizer",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18))),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileOrganizer(
                                                      iduser: widget.creatorId),
                                            ));
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 20.0, right: 5.0),
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
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 20.0, left: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(creatorName,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Text(creatorEmail,
                                                          textAlign:
                                                              TextAlign.left),
                                                    )
                                                  ],
                                                )),
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                     listRekomendasiEvent.length == 0 ?
                                    Container():
                                    Divider(),
                                     listRekomendasiEvent.length == 0 ?
                                    Container():
                                    Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Text("Event Lainnya",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18))),
                                    listRekomendasiEvent.length == 0 ?
                                    Container():
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: <Widget>[
                                            Row(
                                              children: listRekomendasiEvent
                                                  .map(
                                                      (ListRekomEvent item) =>
                                                          Container(
                                                            child: InkWell(
                                                                child: Container(
                                                                    width: 300.0,
                                                                    child: Card(
                                                                      elevation:
                                                                          1,
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  flex: 5,
                                                                                  child: Container(
                                                                                    height: 80.0,
                                                                                    width: 80.0,
                                                                                    child: FadeInImage.assetNetwork(
                                                                                      placeholder: 'images/loading-event.png',
                                                                                      image: item.image == null || item.image == '' || item.image == 'null' ? url('assets/images/noimage.jpg') : url('storage/image/event/event_thumbnail/${item.image}'),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 7,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          '${item.waktuawal}',
                                                                                          style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 5.0),
                                                                                          child: Text(
                                                                                            item.title == null || item.title == '' ? 'Event Tidak Diketahui' : item.title,
                                                                                            style: TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 2,
                                                                                            softWrap: true,
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 10.0),
                                                                                          child: Text(
                                                                                            creatorName == null || creatorName == '' ? 'Organizer Tidak Diketahui' : creatorName,
                                                                                            style: TextStyle(color: Colors.grey),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            softWrap: true,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                           Column(children: <Widget>[
                                                                                  Container(padding: EdgeInsets.only(left: 10.0, right: 10.0), child: Divider()),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: <Widget>[
                                                                                        Container(
                                                                                            decoration: new BoxDecoration(
                                                                                              color: item.status == 'selesai' ? Color.fromRGBO(255, 191, 128, 1) : widget.dataUser['us_code'].toString() == item.idcreator ? Colors.blue : item.status == null ? Colors.grey : item.status == 'P' ? Colors.orange : item.status == 'C' ? Colors.red : item.status == 'A' ? Colors.green : Colors.blue,
                                                                                              borderRadius: new BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0), bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0)),
                                                                                            ),
                                                                                            padding: EdgeInsets.all(5.0),
                                                                                            width: 120.0,
                                                                                            child: Text(
                                                                                              item.status == 'selesai' ? 'Event Selesai' : widget.dataUser['us_code'].toString() == item.idcreator ? 'Event Saya' : item.status == null ? 'Belum Terdaftar' : item.status == 'P' && item.posisi == '3' ? 'Proses Daftar' : item.status == 'C' && item.posisi == '3' ? 'Pendaftaran Ditolak' : item.status == 'A' && item.posisi == '3' ? 'Sudah Terdaftar' : item.status == 'P' && item.posisi == '2' ? 'Proses Daftar Admin' : item.status == 'C' && item.posisi == '2' ? 'Tolak Pendaftaran Admin' : item.status == 'A' && item.posisi == '2' ? 'Sudah Terdaftar Admin' : 'Status Tidak Diketahui',
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 12,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                              textAlign: TextAlign.center,
                                                                                            )),
                                                                                        widget.dataUser['us_code'].toString() == item.idcreator ?
                                                                                        Container():
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(right: 0),
                                                                                          child: ButtonTheme(
                                                                                            minWidth: 0, //wraps child's width
                                                                                            height: 0,
                                                                                            child: FlatButton(
                                                                                              child: Row(
                                                                                                children: <Widget>[
                                                                                                  Icon(
                                                                                                    Icons.favorite,
                                                                                                    color: item.wishlist == null || item.wishlist == 'null' || item.wishlist == '0' ? Colors.grey : Colors.pink,
                                                                                                    size: 18,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                              padding: EdgeInsets.only(left: 15, right: 15.0),
                                                                                              onPressed: () async {
                                                                                                try {
                                                                                                  final hapuswishlist = await http.post(url('api/actionwishlist'), headers: requestHeaders, body: {
                                                                                                    'event': item.id,
                                                                                                  });

                                                                                                  if (hapuswishlist.statusCode == 200) {
                                                                                                    var hapuswishlistJson = json.decode(hapuswishlist.body);
                                                                                                    if (hapuswishlistJson['status'] == 'tambah') {
                                                                                                      setState(() {
                                                                                                        item.wishlist = item.id;
                                                                                                      });
                                                                                                    } else if (hapuswishlistJson['status'] == 'hapus') {
                                                                                                      setState(() {
                                                                                                        item.wishlist = null;
                                                                                                      });
                                                                                                    }
                                                                                                  } else {
                                                                                                    print(hapuswishlist.body);
                                                                                                    Fluttertoast.showToast(msg: "Request failed with status: ${hapuswishlist.statusCode}");
                                                                                                  }
                                                                                                } on TimeoutException catch (_) {
                                                                                                  Fluttertoast.showToast(msg: "Timed out, Try again");
                                                                                                } catch (e) {
                                                                                                  print(e);
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ])
                                                                        ],
                                                                      ),
                                                                    )),
                                                                onTap: () async {
                                                                  switch (item
                                                                      .status) {
                                                                    case 'P':
                                                                      if (item.posisi ==
                                                                          '2') {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                      RegisterEvents(
                                                                                id: int.parse(
                                                                                    item.id),
                                                                                selfEvent:
                                                                                    true,
                                                                                dataUser:
                                                                                    widget.dataUser,
                                                                                creatorId:
                                                                                    item.idcreator,
                                                                              ),
                                                                            ));
                                                                      } else if (item
                                                                              .posisi ==
                                                                          '3') {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                      WaitingEvent(
                                                                                id: int.parse(
                                                                                    item.id),
                                                                                selfEvent:
                                                                                    true,
                                                                                creatorId:
                                                                                    item.idcreator,
                                                                              ),
                                                                            ));
                                                                      } else {}
                                                                      break;
                                                                    case 'C':
                                                                      if (item.posisi ==
                                                                          '2') {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                      RegisterEvents(
                                                                                id: int.parse(
                                                                                    item.id),
                                                                                selfEvent:
                                                                                    false,
                                                                                dataUser:
                                                                                    widget.dataUser,
                                                                                creatorId:
                                                                                    item.idcreator,
                                                                              ),
                                                                            ));
                                                                      } else if (item
                                                                              .posisi ==
                                                                          '3') {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                      RegisterEvents(
                                                                                id: int.parse(
                                                                                    item.id),
                                                                                selfEvent:
                                                                                    false,
                                                                                dataUser:
                                                                                    widget.dataUser,
                                                                                creatorId:
                                                                                    item.idcreator,
                                                                              ),
                                                                            ));
                                                                      } else {}
                                                                      break;
                                                                    case 'A':
                                                                      if (item.posisi ==
                                                                          '2') {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                      RegisterEvents(
                                                                                id: int.parse(
                                                                                    item.id),
                                                                                selfEvent:
                                                                                    true,
                                                                                dataUser:
                                                                                    widget.dataUser,
                                                                                creatorId:
                                                                                    item.idcreator,
                                                                              ),
                                                                            ));
                                                                      } else if (item
                                                                              .posisi ==
                                                                          '3') {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                      SuccesRegisteredEvent(
                                                                                id: int.parse(
                                                                                    item.id),
                                                                                selfEvent:
                                                                                    true,
                                                                                dataUser:widget.dataUser,
                                                                                creatorId:
                                                                                    item.idcreator,
                                                                              ),
                                                                            ));
                                                                      } else {}
                                                                      break;
                                                                    default:
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (context) =>
                                                                                    RegisterEvents(
                                                                              id: int.parse(
                                                                                  item.id),
                                                                              selfEvent:  widget.dataUser['us_code'].toString() == item.idcreator
                                                                                  ? true
                                                                                  : false,
                                                                              dataUser:
                                                                                  widget.dataUser,
                                                                              creatorId:
                                                                                  item.idcreator,
                                                                            ),
                                                                          ));
                                                                      break;
                                                                  }
                                                                }),
                                                          ))
                                                  .toList(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (!widget.selfEvent)
                                      if (expired == false)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: RaisedButton(
                                              color:
                                                  Color.fromRGBO(41, 30, 47, 1),
                                              textColor: Colors.white,
                                              disabledColor: Colors.green[400],
                                              disabledTextColor: Colors.white,
                                              padding: EdgeInsets.all(15.0),
                                              splashColor: Colors.blueAccent,
                                              onPressed: () async {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegisterEventMethod(
                                                              id: dataEvent.id,
                                                              creatorId: widget
                                                                  .creatorId,
                                                              dataUser: widget
                                                                  .dataUser),
                                                    ));
                                              },
                                              child: Text(
                                                "Daftar Sekarang",
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                  ]))
                        ],
                      ),
                    ]),
                  ])),
    );
  }
}
