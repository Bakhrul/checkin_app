import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/model/participant.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:draggable_fab/draggable_fab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import 'create_checkin.dart';
import 'create_participant.dart';
import 'list_approval.dart';
import 'list_peserta_checkin.dart';
// import 'listprovinsi.dart';
// import 'listkabupaten.dart';
// import 'listkecamatan.dart';
// import 'create_checkin.dart';

String sifat = 'VIP';
String tipe = 'Public';
var datepicker;
List<UserParticipant> listPeserta;
List<Checkin> listCheckin;

class DashboardCheckin extends StatefulWidget {
  DashboardCheckin({Key key, this.title, this.idevent}) : super(key: key);
  final String title;
  final idevent;
  @override
  State<StatefulWidget> createState() {
    return _DashboardCheckinState();
  }
}

class _DashboardCheckinState extends State<DashboardCheckin>
    with SingleTickerProviderStateMixin {
  BuildContext context;
  TabController _tabController;
  static const List<IconData> icons = const [
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];

  getDataMember() async {
    listPeserta = [];
    dynamic response =
        await RequestGet(name: "event/getdata/participant", customrequest: "")
            .getdata();
    for (var i = 0; i < response.length; i++) {
      UserParticipant peserta = UserParticipant(
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

  getDataCheckin() async {
    listCheckin = [];
    dynamic response =
        await RequestGet(name: "checkin/getdata/checkin", customrequest: "")
            .getdata();
    for (var i = 0; i < response.length; i++) {
      Checkin checkin = Checkin(
        id: response[i]["id"],
        eventId: response[i]["event_id"],
        checkinKey: response[i]["checkin_keyword"],
        startTime: response[i]["start_time"],
        endTime: response[i]["end_time"],
        checkinDate: response[i]["checkin_date"],
      );

      listCheckin.add(checkin);
      print(response);
    }
    setState(() {});
  }

  deleteCheckin() async {
    dynamic body = {
      "event_id": "1",
      "checkin_id": "7",
    };
    dynamic response =
        await RequestPost(name: "checkin/deletedata/checkinreguler", body: body)
            .sendrequest();
    if (response == "success") {
      setState(() {});
      Fluttertoast.showToast(
          msg: "Data Berhasil Terhapus",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Terjadi Kesalahan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    getDataMember();
    getDataCheckin();
    _tabController = TabController(
        length: 2, vsync: _DashboardCheckinState(), initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    datepicker = FocusNode();
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
  
 Widget appBarTitle = Text(
    "Dashboard",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    String jumlahPeserta = listPeserta.length.toString();
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
          actions: <Widget>[
            new IconButton( icon: new Icon(Icons.notifications_none),  tooltip: 'Air it', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => ListApproval() ));

            }, ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Peserta ( $jumlahPeserta )'),
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
              ),
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
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                      children: listPeserta
                          .map((UserParticipant f) => Padding(
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
                                                  f.picProfile))),
                                    ),
                                    title: Text(f.name),
                                    onTap: () {},
                                    subtitle: Text(f.email.toString()),
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

  Widget _builderlistViewCheckin() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(2),
                  child: Column(
                      children: listCheckin
                          .map((Checkin data) => Padding(
                                padding: EdgeInsets.all(2),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        data.checkinDate,
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
                                                color: Color.fromRGBO(
                                                    41, 30, 47, 1),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            data.checkinKey,
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
                                                        ListPesertaCheckin( id: data.id.toString(),eventid: data.eventId.toString()  )));
                                          },
                                          trailing: ButtonTheme(
                                              minWidth: 0.0,
                                              child: FlatButton(
                                                color: Colors.white,
                                                textColor: Colors.red,
                                                disabledColor:
                                                    Colors.green[400],
                                                disabledTextColor: Colors.white,
                                                padding: EdgeInsets.all(15.0),
                                                splashColor: Colors.blueAccent,
                                                child: Icon(
                                                  Icons.close,
                                                ),
                                                onPressed: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title:
                                                              Text("Warning"),
                                                          content: Text(
                                                              "Are you sure want to delete data?"),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child:
                                                                  Text("Yes"),
                                                              onPressed: () {
                                                                deleteCheckin();

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text("No"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                              )),
                                          subtitle: Text(DateFormat('HH:mm:dd')
                                                  .format(DateTime.parse(
                                                      data.startTime))
                                                  .toString() +
                                              " - " +
                                              DateFormat('HH:mm:dd')
                                                  .format(DateTime.parse(
                                                      data.endTime))
                                                  .toString())),
                                    ),
                                  ],
                                ),
                              ))
                          .toList())),
            ),
          ),
        )
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
                        builder: (context) => ManajemeCreateCheckin(idevent: widget.idevent),
                      ));
                },
                backgroundColor: Color.fromRGBO(41, 30, 47, 1),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                )))
        : DraggableFab(
            child: FloatingActionButton(
                shape: StadiumBorder(),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateParticipant(idevent: widget.idevent),
                      ));
                },
                backgroundColor: Color.fromRGBO(41, 30, 47, 1),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                )));
  }
}
