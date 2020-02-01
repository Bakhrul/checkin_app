import 'dart:io';

import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/model/participant.dart';
import 'package:checkin_app/pages/management_checkin/choice_checkin.dart';
import 'package:checkin_app/pages/management_checkin/detail_checkin.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import 'create_participant.dart';
import 'list_peserta_checkin.dart';

String sifat = 'VIP';
String tipe = 'Public';
var datepicker;
List<UserParticipant> listPeserta;
List<Checkin> listCheckin;
enum PageEnum { detailCheckin, deleteCheckin }

class DashboardCheckin extends StatefulWidget {
  DashboardCheckin({Key key, this.idevent}) : super(key: key);
  // final String title;
  final idevent;
  @override
  State<StatefulWidget> createState() {
    return _DashboardCheckinState();
  }
}

class _DashboardCheckinState extends State<DashboardCheckin>
    with SingleTickerProviderStateMixin {
  BuildContext context;
  bool isLoading, isError;
  String tokenType, accessToken;
  TabController _tabController;
  File imageProfile;
  static const List<IconData> icons = const [
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];

  var childButtons = List<UnicornButton>();

  getDataMember() async {
    setState(() {
      isLoading = true;
    });
    listPeserta = [];
    try {
      dynamic response = await RequestGet(
              name: "event/getdata/participant/",
              customrequest: "${widget.idevent}")
          .getdata();
      for (var i = 0; i < response.length; i++) {
        UserParticipant peserta = UserParticipant(
          id: response[i]["id"].toString(),
          name: response[i]["name"],
          email: response[i]["email"],
          position: response[i]["position"].toString(),
          status: response[i]["status"],
          picProfile: response[i]["pic_profile"],
          eventId: response[i]["event_id"].toString(),
        );

        listPeserta.add(peserta);
      }
      setState(() {
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
  }

  getDataCheckin() async {
    setState(() {
      isLoading = true;
    });
    try {
      listCheckin = [];
      dynamic response = await RequestGet(
              name: "checkin/getdata/checkin/",
              customrequest: "${widget.idevent}")
          .getdata();
      for (var i = 0; i < response.length; i++) {
        Checkin checkin = Checkin(
          id: response[i]["id"].toString(),
          eventId: response[i]["event_id"].toString(),
          checkinKey: response[i]["checkin_keyword"],
          startTime: response[i]["start_time"],
          endTime: response[i]["end_time"],
          checkinDate: response[i]["checkin_date"],
          totalUsers: response[i]["total_users"],
        );

        listCheckin.add(checkin);
      }
      setState(() {
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
  }

  deleteParticipant(id, eventId) async {
    setState(() {
      isLoading = true;
    });
    try {
      dynamic body = {
        "peserta": id.toString(),
        "event": eventId.toString(),
      };
      dynamic response =
          await RequestPost(name: "deletepeserta_event", body: body)
              .sendrequest();
      // print(response['status']);
      if (response['status'] == "success") {
        setState(() {});

        Fluttertoast.showToast(
            msg: "Peserta Telah Dikeluarkan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        isLoading = false;

        // getDataCheckin();
      } else {
        Fluttertoast.showToast(
            msg: "Terjadi Kesalahan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        isLoading = false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
  }

  deleteCheckin(id, eventId) async {
    dynamic body = {
      "event_id": eventId.toString(),
      "checkin_id": id.toString(),
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
      // getDataCheckin();
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
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryAppBarColor,
          title: Text('Manajemen Event', style: TextStyle(fontSize: 14)),
          actions: <Widget>[],
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
                      // border: Color.fromRGBO(r, g, b, opacity),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _buildListViewMember(),
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
                child: isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _builderlistViewCheckin(),
              ),
            )
          ],
        ),

        floatingActionButton: _bottomButtons(),
      ),
    );
  }

  Widget _buildListViewMember() {
    return listPeserta.length == 0
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 100.0,
                      height: 100.0,
                      child: Image.asset("images/empty-white-box.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: Center(
                        child: Text(
                          "Event Belum Memiliki Peserta Sama Sekali",
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
        : Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Expanded(
                  child: SizedBox(
                      child: SingleChildScrollView(
                    child: Column(
                        children: listPeserta
                            .map((UserParticipant f) => Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Card(
                                    child: ListTile(
                                      leading: Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: ClipOval(
                                              child: imageProfile == null
                                                  ? FadeInImage.assetNetwork(
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          'images/loading.gif',
                                                      image: f.picProfile ==
                                                                  null ||
                                                              f.picProfile == ''
                                                          ? url(
                                                              'assets/images/imgavatar.png')
                                                          : url(
                                                              'storage/image/profile/${f.picProfile}'))
                                                  : Image.file(imageProfile))),
                                      trailing: FlatButton(
                                        child: Icon(Icons.exit_to_app),
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Warning"),
                                                  content: Text(
                                                      "Apa anda yakin untuk mengeluarkan ${f.name}?"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Yes"),
                                                      onPressed: () {
                                                        deleteParticipant(
                                                            f.id,
                                                            f.eventId
                                                                .toString());
                                                        listPeserta.remove(f);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      title: Text(f.name == null || f.name == ''
                                          ? 'Memuat..'
                                          : f.name),
                                      onTap: () {},
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          f.status == 'P' && f.position == '2'
                                              ? 'Menunggu Konfirmasi ( Admin / Co-Host)'
                                              : f.status == 'P' &&
                                                      f.position == '3'
                                                  ? 'Menunggu Konfirmasi ( Peserta )'
                                                  : f.status == 'C' &&
                                                          f.position == '2'
                                                      ? 'Permintaan Ditolak ( Admin-Co-Host )'
                                                      : f.status == 'C' &&
                                                              f.position == '3'
                                                          ? 'Pendaftaran Ditolak ( Peserta )'
                                                          : f.status == 'A' &&
                                                                  f.position ==
                                                                      '2'
                                                              ? 'Perimintaan Diterima ( Admin / Co-Host)'
                                                              : f.status ==
                                                                          'A' &&
                                                                      f.position ==
                                                                          '3'
                                                                  ? 'pendaftaran Diterima ( Peserta )'
                                                                  : 'Status Tidak Diketahui',
                                          style: f.status == 'P'
                                              ? TextStyle(
                                                  fontWeight: FontWeight.w500)
                                              : f.status == 'C'
                                                  ? TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red)
                                                  : f.status == 'A'
                                                      ? TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.green)
                                                      : TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                        ),
                                      ),
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
    return listCheckin.length == 0
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 100.0,
                      height: 100.0,
                      child: Image.asset("images/empty-white-box.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: Center(
                        child: Text(
                          "Event Belum Memiliki Checkin Sama Sekali",
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
        : Row(
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
                                          Card(
                                            child: ListTile(
                                                leading: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: Container(
                                                      height: 15.0,
                                                      alignment:
                                                          Alignment.center,
                                                      width: 15.0,
                                                      color: Color.fromRGBO(
                                                          41, 30, 47, 1),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  data.checkinKey == null ||
                                                          data.checkinKey == ''
                                                      ? 'Memuat...'
                                                      : data.checkinKey,
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
                                                              ListPesertaCheckin(
                                                                  id: data.id
                                                                      .toString(),
                                                                  eventid: data
                                                                      .eventId
                                                                      .toString())));
                                                },
                                                trailing:
                                                    PopupMenuButton<PageEnum>(
                                                  onSelected: (PageEnum value) {
                                                    switch (value) {
                                                      case PageEnum
                                                          .detailCheckin:
                                                        Navigator.of(context).push(CupertinoPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                DetailCheckin(
                                                                    idEvent: data
                                                                        .eventId,
                                                                    idCheckin:
                                                                        data.id)));
                                                        break;
                                                      case PageEnum
                                                          .deleteCheckin:
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Warning"),
                                                                content: Text(
                                                                    "Apakah Anda Yakin Akan Menghapus Checkin ini?"),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        "Yes"),
                                                                    onPressed:
                                                                        () {
                                                                      deleteCheckin(
                                                                          data.id,
                                                                          data.eventId);

                                                                      listCheckin
                                                                          .remove(
                                                                              data);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                        "No"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                        break;

                                                      default:
                                                    }
                                                  },
                                                  icon: Icon(Icons.more_vert),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      value: PageEnum
                                                          .detailCheckin,
                                                      child: Text(
                                                          "Detail Checkin"),
                                                    ),
                                                    data.totalUsers < 1
                                                        ? PopupMenuItem(
                                                            value: PageEnum
                                                                .deleteCheckin,
                                                            child:
                                                                Text("Delete"),
                                                          )
                                                        : null
                                                  ],
                                                ),
                                                subtitle: Text(DateFormat(
                                                            'HH:mm:dd')
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
                        builder: (context) =>
                            ChoiceCheckin(idevent: widget.idevent),
                      ));
                },
                backgroundColor: Color.fromRGBO(254, 86, 14, 1),
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
                        builder: (context) =>
                            CreateParticipant(idevent: widget.idevent),
                      ));
                },
                backgroundColor: Color.fromRGBO(254, 86, 14, 1),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                )));
  }
}
