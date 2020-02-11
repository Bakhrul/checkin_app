import 'dart:io';

import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/utils/utils.dart';

import 'package:flutter/material.dart';

List<UserCheckin> listPeserta;

class ListPesertaCheckin extends StatefulWidget {
  final String id;
  final String eventid;

  ListPesertaCheckin({Key key, @required this.id, @required this.eventid})
      : super(key: key);
  @override
  _ListPesertaCheckinState createState() => _ListPesertaCheckinState();
}

class _ListPesertaCheckinState extends State<ListPesertaCheckin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  BuildContext context;
  File imageProfile;

  getData() async {
    listPeserta = [];

    dynamic response = await RequestGet(
            name: "checkin/getdata/usercheckin/",
            customrequest:
                "${widget.id.toString()}/${widget.eventid.toString()}")
        .getdata();
    for (var i = 0; i < response.length; i++) {
      UserCheckin peserta = UserCheckin(
        name: response[i]["name"].toString(),
        email: response[i]["email"].toString(),  
        picProfile: response[i]["pic_profile"],
      );

      listPeserta.add(peserta);
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: primaryAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Daftar Peserta ",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SafeArea(
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
        )
        ),
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
                                leading: 
                                f.picProfile == '-' ?
                          Container(
                                margin: EdgeInsets.only(top:20),
                                height: 50,
                                width: 50,
                                child : ClipOval(
                                  child: Image.asset('images/imgavatar.png',fit:BoxFit.fill)
                                )
                              ):
                          Container(
                                margin: EdgeInsets.only(top:20),
                                height: 50,
                                width: 50,
                                child : ClipOval(
                                  child: imageProfile == null ? 
                                  FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder : 'images/imgavatar.png',
                                    image:url('storage/image/profile/${f.picProfile}')
                                  ):
                                  Image.file(imageProfile)
                                )
                              ),
                                title: Text(f.name),
                                onTap: () async {
                                },
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
