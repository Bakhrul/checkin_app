import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user_checkin.dart';

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
        // position: response[i]["position"].toString(),
        // picProfile: response[i]["pic_profile"],
        // eventId: response[i]["event_id"],
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
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "List User ",
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
                              "Belum Ada Peserta yang Checkin",
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
                                leading: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  // decoration: new BoxDecoration(
                                  //     shape: BoxShape.circle,
                                  //     image: new DecorationImage(
                                  //         fit: BoxFit.fill,
                                  //         image:
                                  //             new NetworkImage(f.picProfile))),
                                ),
                                title: Text(f.name),
                                onTap: () async {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => HomeScreen()));
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
