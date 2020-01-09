import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:flutter/material.dart';
  List<UserCheckin> listPeserta;

class ListApproval extends StatefulWidget {
  @override
  _ListApprovalState createState() => _ListApprovalState();
}

class _ListApprovalState extends State<ListApproval>{
    // with SingleTickerProviderStateMixin {
  AnimationController _controller;
  BuildContext context;


  getData() async {
    listPeserta = [];
    dynamic response =
        await RequestGet(name: "event/getdata/participant/", customrequest: "")
            .getdata();
    for (var i = 0; i < response.length; i++) {
      UserCheckin peserta = UserCheckin(
       name: response[i]["name"],
        email: response[i]["email"],
        position: response[i]["position"],
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
    // _controller = AnimationController(vsync: this);
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeScreen()));
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