import 'package:checkin_app/api/checkin_service.dart';
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:unicorndial/unicorndial.dart';
import 'create_checkin.dart';
import 'list_peserta_checkin.dart';
// import 'listprovinsi.dart';
// import 'listkabupaten.dart';
// import 'listkecamatan.dart';
// import 'create_checkin.dart';

GlobalKey<ScaffoldState> _scaffoldKeycreateevent;
String sifat = 'VIP';
String tipe = 'Public';
var datepicker;
List<UserCheckin> listPeserta;
List<Checkin> listCheckin;

void showInSnackBar(String value) {
  _scaffoldKeycreateevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class DashboardCheckin extends StatefulWidget {
  DashboardCheckin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardCheckinState();
  }
}

class _DashboardCheckinState extends State<DashboardCheckin>
    with SingleTickerProviderStateMixin {
  BuildContext context;
  // UserCheckinService checkinService;
  TabController _tabController;

  getDataMember() async {
    listPeserta = [];
    dynamic response =
        await RequestGet(name: "api/get_user_checkin.json", customrequest: "")
            .getdata();
    print(response);
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

  getDataCheckin() async {
    listCheckin = [];
    dynamic response =
        await RequestGet(name: "api/get_checkin.json", customrequest: "")
            .getdata();
    print(response);
    for (var i = 0; i < response.length; i++) {
      Checkin checkin = Checkin(
        checkinKey: response[i]["checkin_key"],
        startTime: response[i]["start_time"],
        endTime: response[i]["end_time"],
        checkinDate: response[i]["checkin_date"],
      );

      listCheckin.add(checkin);
    }
    setState(() {});
  }

  @override
  void initState() {
    getDataMember();
    getDataCheckin();
    _scaffoldKeycreateevent = GlobalKey<ScaffoldState>();
    _tabController = TabController(
        length: 2, vsync: _DashboardCheckinState(), initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    datepicker = FocusNode();
    // checkinService = UserCheckinService();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  bool monVal = false;
  bool monVal2 = false;
  bool monVal3 = false;
  bool monVal4 = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    // checkinService.getCheckin().then((value) => print("value: $value"));

    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Choo choo",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {},
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "airplane",
      backgroundColor: Colors.greenAccent,
      mini: true,
      child: Icon(Icons.airplanemode_active),
      onPressed: () {},
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "directions",
      backgroundColor: Colors.blueAccent,
      mini: true,
      child: Icon(Icons.directions_car),
      onPressed: () {},
    )));

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          title: Text('Manajemen Event', style: TextStyle(fontSize: 14)),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Peserta (3000)'),
              Tab(icon: Icon(Icons.schedule), text: 'Checkin'),
            ],
          ),
        ), //
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(5.0),
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
                  SingleChildScrollView(
                    child: _buildListViewMember(),
                  )
                  // FutureBuilder(
                  //     future: checkinService.getMemberEvent(),
                  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //       if (snapshot.hasError) {
                  //         return Center(
                  //           child: Text(
                  //               "Something wrong with message: ${snapshot.error.toString()}"),
                  //         );
                  //       } else if (snapshot.connectionState ==
                  //           ConnectionState.done) {
                  //         List<UserCheckin> memberEvent = snapshot.data;
                  //         return _buildListViewMember(memberEvent);
                  //       } else {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //     }),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 15.0,
                right: 5.0,
                left: 5.0,
              ),
              child: SafeArea(
                child: _builderlistViewCheckin(),
                // future: checkinService.getCheckin(),
                // builder: (BuildContext context, AsyncSnapshot snapshot) {
                //   // print(snapshot.connectionState);
                //   if (snapshot.hasError) {
                //     return Center(
                //       child: Text(
                //           "Something wrong with message: ${snapshot.error.toString()}"),
                //     );
                //   } else if (snapshot.connectionState == ConnectionState.done) {
                //     List<Checkin> checkin = snapshot.data;
                //     return _builderlistViewCheckin();
                //   } else {
                //     return Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }
                // },
              ),

              // Container(
              //   margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
              //         child: Text(
              //           '13 September 2019',
              //           style: TextStyle(
              //               fontSize: 14,
              //               color: Colors.blue,
              //               fontWeight: FontWeight.w500),
              //         ),
              //       ),
              //       Card(
              //         child: ListTile(
              //           leading: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(100.0),
              //               child: Container(
              //                 height: 15.0,
              //                 alignment: Alignment.center,
              //                 width: 15.0,
              //                 color: Color.fromRGBO(41, 30, 47, 1),
              //               ),
              //             ),
              //           ),
              //           title: Text(
              //             'KODECHECKIN',
              //             style: TextStyle(
              //               fontWeight: FontWeight.w500,
              //               fontSize: 13,
              //             ),
              //           ),
              //           onTap: () async {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => ListPesertaCheckin()));
              //           },
              //           trailing: ButtonTheme(
              //               minWidth: 0.0,
              //               child: FlatButton(
              //                 color: Colors.white,
              //                 textColor: Colors.red,
              //                 disabledColor: Colors.green[400],
              //                 disabledTextColor: Colors.white,
              //                 padding: EdgeInsets.all(15.0),
              //                 splashColor: Colors.blueAccent,
              //                 child: Icon(
              //                   Icons.close,
              //                 ),
              //                 onPressed: () async {},
              //               )),
              //           subtitle: Text('04:00 - 04:30'),
              //         ),
              //       ),
              //       Card(
              //         child: ListTile(
              //           leading: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(100.0),
              //               child: Container(
              //                 height: 15.0,
              //                 alignment: Alignment.center,
              //                 width: 15.0,
              //                 color: Color.fromRGBO(41, 30, 47, 1),
              //               ),
              //             ),
              //           ),
              //           title: Text(
              //             'KODECHECKIN',
              //             style: TextStyle(
              //               fontWeight: FontWeight.w500,
              //               fontSize: 13,
              //             ),
              //           ),
              //           onTap: () async {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => ListPesertaCheckin()));
              //           },
              //           trailing: ButtonTheme(
              //               minWidth: 0.0,
              //               child: FlatButton(
              //                 color: Colors.white,
              //                 textColor: Colors.red,
              //                 disabledColor: Colors.green[400],
              //                 disabledTextColor: Colors.white,
              //                 padding: EdgeInsets.all(15.0),
              //                 splashColor: Colors.blueAccent,
              //                 child: Icon(
              //                   Icons.close,
              //                 ),
              //                 onPressed: () async {},
              //               )),
              //           subtitle: Text('04:00 - 04:30'),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            )
          ],
        ),

        floatingActionButton: _bottomButtons(),
      ),
    );
  }

  Widget _buildListViewMember() {
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
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              new NetworkImage(f.picProfile))),
                                ),
                                // trailing: Text(
                                //   DateFormat('HH:mm:ss').format(DateTime.parse(f.name)).toString() ,
                                //   style: TextStyle(color: Colors.grey),
                                // ),
                                title: Text(f.name),
                                onTap: () {},
                                subtitle: Text(f.name.toString()),
                              ),
                            ),
                          ))
                      .toList()),
            )
                // },
                // itemCount: usercheckin.length,
                // ),
                ),
          ),
        ),
      ],
    );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: listPeserta.map((UserCheckin f) => Padding(
    //     padding: const EdgeInsets.only(top: 8.0),
    //   )
    //   )
    //   )
    // )
    //     child: Card(
    //         child: ListTile(
    //       leading: Container(
    //           width: 40.0,
    //           height: 40.0,
    //           decoration: new BoxDecoration(
    //             shape: BoxShape.circle,
    //             image: new DecorationImage(
    //               fit: BoxFit.fill,
    //               image: new NetworkImage("memberEvent.pic_profile"),
    //             ),
    //           )),
    //       title: Text("memberEvent.name"),
    //       subtitle: Text("memberEvent.number_of_regist.toString()"),
    //     )));
  }

  Widget _builderlistViewCheckin() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                  child: Row(
                      children: listPeserta
                          .map((UserCheckin f) => Padding(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        f.checkinTime,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Container(
                                              height: 15.0,
                                              alignment: Alignment.center,
                                              width: 15.0,
                                              color:
                                                  Color.fromRGBO(41, 30, 47, 1),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          "checkin.checkin_key,",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListPesertaCheckin()));
                                        },
                                        // onTap: Navigator.push(context,MaterialPageRoute(builder: (context) => context)),
                                        trailing: ButtonTheme(
                                            minWidth: 0.0,
                                            child: FlatButton(
                                              color: Colors.white,
                                              textColor: Colors.red,
                                              disabledColor: Colors.green[400],
                                              disabledTextColor: Colors.white,
                                              padding: EdgeInsets.all(15.0),
                                              splashColor: Colors.blueAccent,
                                              child: Icon(
                                                Icons.close,
                                              ),
                                              onPressed: () async {},
                                            )),
                                        subtitle: Text(""),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList())),
            ),
          ),
        )

        // )
      ],
    );
  }

  Widget _bottomButtons() {
    return _tabController.index == 1
        ? DraggableFab(
            child: FloatingActionButton(
                shape: StadiumBorder(),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManajemeCreateCheckin(),
                      ));
                },
                backgroundColor: Color.fromRGBO(41, 30, 47, 1),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                )))
        : null;
  }
}
