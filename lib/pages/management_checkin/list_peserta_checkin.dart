import 'package:checkin_app/api/checkin_service.dart';
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/pages/management_checkin/testing.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

GlobalKey<ScaffoldState> _scaffoldKeyListCheckin;
List<ListPeserta> listPeserta;

void showInSnackBar(String value) {
  _scaffoldKeyListCheckin.currentState.showSnackBar(new SnackBar(
    content: new Text(value),
  ));
}

class ListPesertaCheckin extends StatefulWidget {
  @override
  _ListPesertaCheckinState createState() => _ListPesertaCheckinState();
}

class _ListPesertaCheckinState extends State<ListPesertaCheckin> {
  // with SingleTickerProviderStateMixin {
  
  AnimationController _controller;
  BuildContext context;
  UserCheckinService userCheckinService;
  postData() async{
    dynamic body = {
      "name" : "h",
      "age" : "89"
    };

   dynamic response  = await RequestPost(name: "alamraya/lumen_mobile/public/checkin",body: body).sendrequest(); 
   print(response);

  }

  getData() async {
    listPeserta = [];
   dynamic response  = await RequestGet(name: "api/get_checkin.json",customrequest: "").getdata(); 
   print(response);
   for (var i = 0; i < response.length; i++) {
     ListPeserta peserta = ListPeserta(
       name: response[i]["checkin_key"],
       checkinTime: response[i]["checkin_key"],
       numberOfRegist: response[i]["checkin_key"],
       picProfile: response[i]["checkin_key"],
     );

    listPeserta.add(peserta);
   }
  setState(() {
    
  });
  }
  @override
  void initState() {
    getData();
    super.initState();
    _scaffoldKeyListCheckin = GlobalKey<ScaffoldState>();
    postData();
    // _controller = AnimationController(vsync: this);
    userCheckinService = UserCheckinService();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    // userCheckinService.getUserCheckin();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    // userCheckinService.getUserCheckin().then((value) => print("value: $value"));

    return Scaffold(
      backgroundColor: Colors.white,
      // key: _scaffoldKeyListCheckin,
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
                    hintText: " Berdasarkan Nama hfghf Lengkap",
                    border: InputBorder.none,
                  )),
            ),

            SafeArea(
              child: _builderListView(),
            //   child: FutureBuilder(
            //       future: userCheckinService.getUserCheckin(),
            //       builder: (BuildContext context, AsyncSnapshot snapshot) {
            //         if (snapshot.hasError) {
            //           return Center(
            //             child: Text(
            //                 "Something wrong with message: ${snapshot.error.toString()}"),
            //           );
            //         } else if (snapshot.connectionState ==
            //             ConnectionState.done) {
            //           List<UserCheckin> usercheckin = snapshot.data;
            //           return _builderListView(usercheckin);
            //         } else {
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         }
            //       }),
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
            // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SizedBox(
              height: 400,
              // child: ListView.builder(
                // itemBuilder: (context, index) {
                  // shrinkWrap:
                  // true;
                  // UserCheckin userCheckin = usercheckin[index];
                  child: SingleChildScrollView(
                    child: Column(
                      children: listPeserta.map((ListPeserta f) => Padding(
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
                            // trailing: Text(
                            //   DateFormat('HH:mm:ss').format(DateTime.parse(f.name)).toString() ,
                            //   style: TextStyle(color: Colors.grey),
                            // ),
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
                // },
                // itemCount: usercheckin.length,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListPeserta{
  var name;
  var numberOfRegist;
  var checkinTime;
  var picProfile;
  ListPeserta({Key key, this.name , this.checkinTime, this.numberOfRegist, this.picProfile});
}