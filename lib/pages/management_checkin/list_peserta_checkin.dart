import 'package:checkin_app/api/checkin_service.dart';
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/pages/management_checkin/testing.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

GlobalKey<ScaffoldState> _scaffoldKeyListCheckin;
List<UserCheckin> listPeserta;

void showInSnackBar(String value) {
  _scaffoldKeyListCheckin.currentState.showSnackBar(new SnackBar(
    content: new Text(value),
  ));
}

class ListPesertaCheckin extends StatefulWidget {
  @override
  _ListPesertaCheckinState createState() => _ListPesertaCheckinState();
}

class _ListPesertaCheckinState extends State<ListPesertaCheckin> 
  with SingleTickerProviderStateMixin {
  
  AnimationController _controller;
  BuildContext context;
 

   getData() async {
    listPeserta = [];
    dynamic response =
        await RequestGet(name: "api/get_user_checkin.json", customrequest: "")
            .getdata();
    for (var i = 0; i < response.length; i++) {
      UserCheckin peserta = UserCheckin(
        name: response[i]["name"],
        checkinTime: response[i]["checkin_time"],
        numberOfRegist: response[i]["number_of_regist"],
        picProfile: response[i]["pic_profile"],
        eventId: response[i]["event_id"],
      );

      listPeserta.add(peserta);
    }
    setState(() {});
  }
  @override
  void initState() {
    getData();
    super.initState();
    _scaffoldKeyListCheckin = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKeyListCheckin,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "List User Checkin",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                    hintText: " Berdasarkan Nama Lengkap",
                    border: InputBorder.none,
                  )),
            ),

            SafeArea(
              child: _builderListView(),
           
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
                      children: listPeserta.map((UserCheckin f) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                        f.picProfile
                                      ))),
                            ),
                            title: Text(f.name),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (contexxt) => HomeScreen()));
                            },
                            subtitle: Text(f.name.toString()),
                          ),
                        ),
                      )).toList()
                    ),
                  )
            ),
          ),
        ),
      ],
    );
  }
}
