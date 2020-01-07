import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../dashboard.dart';

List<Checkin> listCheckin;

class CheckinManual extends StatefulWidget {
  @override
  _CheckinManualState createState() => _CheckinManualState();
}

class _CheckinManualState extends State<CheckinManual>
    with SingleTickerProviderStateMixin {
  TextEditingController _controllerCheckin = TextEditingController();
  TextEditingController _inputErrorText = TextEditingController();
  AnimationController _controller;
  var _isLoading = false;
  var _listBuild = false;

  _searchCodeCheckin() async {
    _isLoading = true;
    _listBuild = true;
    String checkinCode = _controllerCheckin.text.trim().toString();
    listCheckin = [];
    dynamic response = await RequestGet(
            name: "checkin/getdata/searchcode/",
            customrequest: "${checkinCode}")
        .getdata();
    print(response.length);
    if (response == "gagal") {
      _isLoading = false;
      Fluttertoast.showToast(
          msg: "Data Tidak Ditemukan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (var i = 0; i < response.length; i++) {
        Checkin codeCheckin = Checkin(
            id: response[i]["id"],
            eventId: response[i]["event_id"],
            checkinKey: response[i]["keyword"],
            startTime: response[i]["start_time"],
            endTime: response[i]["end_time"],
            sessionName: response[i]["session_name"],
            titleEvent: response[i]["title"],
            locationEvent: response[i]["location"]);

        listCheckin.add(codeCheckin);
        _isLoading = false;
      }
    }
    setState(() {});
  }

  _postCheckin(_eventId, _checkin) async {
    var _timeCheckin = DateTime.now().toString();
    dynamic body = {
      "event_id": _eventId.toString(),
      "checkin_id": _checkin.toString(),
      "checkin_type": "IC",
      "time_checkin": _timeCheckin
    };
    dynamic response =
        await RequestPost(name: "checkin/postdata/usercheckin", body: body)
            .sendrequest();

    if (response == "success") {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
      // Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // key: _scaffoldKeycreatecheckin,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Checkin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.brightness_1,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  controller: _controllerCheckin,
                  decoration: InputDecoration(
                      hintText: 'Kode Checkin',
                      // errorText: _inputErrorText,
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Card(
                  margin: EdgeInsets.only(top: 10.0),
                  child: FlatButton(
                      child: Text("Cari"),
                      onPressed: () async {
                        _searchCodeCheckin();
                      })),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Card(
                    child: _listBuild != false
                        ? _builderListView()
                        : Align(
                            alignment: Alignment.center,
                            child: Text("Tidak Ada Data"),
                          )),
              )
            ],
          ),
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
                child: _isLoading == true
                    ? CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                            children: listCheckin
                                .map((Checkin f) => Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(f.sessionName),
                                          onTap: () async {
                                            _postCheckin(f.eventId, f.id);
                                          },
                                          subtitle: Text("${f.locationEvent}"),
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
