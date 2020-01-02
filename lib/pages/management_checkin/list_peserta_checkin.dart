import 'package:checkin_app/api/checkin_service.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/pages/management_checkin/testing.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

GlobalKey<ScaffoldState> _scaffoldKeyListCheckin;
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

  @override
  void initState() {
    super.initState();
    _scaffoldKeyListCheckin = GlobalKey<ScaffoldState>();
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
                    hintText: " Berdasarkan Nama Lengkap",
                    border: InputBorder.none,
                  )),
            ),
            SafeArea(
              child: FutureBuilder(
                  future: userCheckinService.getUserCheckin(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            "Something wrong with message: ${snapshot.error.toString()}"),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      List<UserCheckin> usercheckin = snapshot.data;
                      return _builderListView(usercheckin);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        )),
      ),
    );
  }

  Widget _builderListView(List<UserCheckin> usercheckin) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: Expanded(
            // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SizedBox(
              height: 400,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  shrinkWrap:
                  true;
                  UserCheckin userCheckin = usercheckin[index];
                  return Padding(
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
                                    userCheckin.pic_profile
                                  ))),
                        ),
                        trailing: Text(
                          DateFormat('HH:mm:ss').format(DateTime.parse(userCheckin.checkin_time)).toString() ,
                          style: TextStyle(color: Colors.grey),
                        ),
                        title: Text(userCheckin.name),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contexxt) => HomeScreen()));
                        },
                        subtitle: Text(userCheckin.number_of_regist.toString()),
                      ),
                    ),
                  );
                },
                itemCount: usercheckin.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
