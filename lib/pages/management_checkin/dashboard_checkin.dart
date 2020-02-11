import 'dart:io';

import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/model/participant.dart';
import 'package:checkin_app/pages/management_checkin/create_checkin.dart';
import 'package:checkin_app/pages/management_checkin/detail_checkin.dart';
import 'package:checkin_app/pages/management_checkin/direct_checkin.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import 'create_participant.dart';
import 'list_peserta_checkin.dart';
import 'dart:math' as math;
import 'package:checkin_app/routes/env.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

String sifat = 'VIP';
String tipe = 'Public';
var datepicker;
List<UserParticipant> listPeserta = [];
List<UserParticipant> listAdmin = [];
List<Checkin> listCheckin = [];
Map<String, String> requestHeaders = Map();
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
  String titleEvent;
  var isEnable;
  final TextEditingController _keywordController = TextEditingController();
  static const List<IconData> icons = const [
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];

  var childButtons = List<UnicornButton>();


  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    return getDataEvent();
  }
   Future<List<List>> getDataEvent() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
    });
    try {
      final getDataEvents = await http.post(
        url('api/event/getdata/event/${widget.idevent}'),
        headers: requestHeaders,
      );

      if (getDataEvents.statusCode == 200) {
        var dataeventToJson = json.decode(getDataEvents.body);
        var dataEvent = dataeventToJson;
        // listPeserta = [];

      setState(() {
        isLoading = false;
        titleEvent = dataEvent[0]['title'];
      });
      } else if (getDataEvents.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }
 Future<List<List>> getDataMember() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
    });
    try {
      final getDataMembers = await http.get(
        url('api/event/getdata/participant/${widget.idevent}'),
        headers: requestHeaders,
      );

      if (getDataMembers.statusCode == 200) {
        var dataMembeToJson = json.decode(getDataMembers.body);
        var dataEvent = dataMembeToJson;
        // listPeserta = [];

         for (var i = 0; i < dataEvent.length; i++) {
        UserParticipant peserta = UserParticipant(
          id: dataEvent[i]["id"].toString(),
          name: dataEvent[i]["name"],
          email: dataEvent[i]["email"],
          position: dataEvent[i]["position"].toString(),
          status: dataEvent[i]["status"],
          picProfile: dataEvent[i]["pic_profile"],
          eventId: dataEvent[i]["event_id"].toString(),
        );

        listPeserta.add(peserta);
      }
      setState(() {
        isLoading = false;
        // titleEvent = dataEvent[0]['title'];
      });
      } else if (getDataMembers.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }
Future<List<List>> getDataAdmin() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
    });
    try {
      final getDataAdmins = await http.get(
        url('api/event/getdata/admin/${widget.idevent}'),
        headers: requestHeaders,
      );

      if (getDataAdmins.statusCode == 200) {
        var dataAdminToJson = json.decode(getDataAdmins.body);
        var dataAdmin = dataAdminToJson;
        // listAdmin = [];

       for (var i = 0; i < dataAdmin.length; i++) {
        UserParticipant admin = UserParticipant(
          id: dataAdmin[i]["id"].toString(),
          name: dataAdmin[i]["name"],
          email: dataAdmin[i]["email"],
          position: dataAdmin[i]["position"].toString(),
          status: dataAdmin[i]["status"],
          picProfile: dataAdmin[i]["pic_profile"],
          eventId: dataAdmin[i]["event_id"].toString(),
        );

        listAdmin.add(admin);
      }
      setState(() {
        isLoading = false;
        // titleEvent = dataEvent[0]['title'];
      });

      } else if (getDataAdmins.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }

  Future<List<List>> getDataCheckin() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
    });
    try {
      final getDataCheckins = await http.get(
        url('api/checkin/getdata/checkin/${widget.idevent}'),
        headers: requestHeaders,
      );
  print(getDataCheckins.statusCode);
      if (getDataCheckins.statusCode == 200) {
        var dataCheckinToJson = json.decode(getDataCheckins.body);
        var dataCheckin = dataCheckinToJson;
        listCheckin = [];

      for (var i = 0; i < dataCheckin.length; i++) {
        Checkin checkin = Checkin(
          id: dataCheckin[i]["id"].toString(),
          eventId: dataCheckin[i]["event_id"].toString(),
          checkinKey: dataCheckin[i]["checkin_keyword"],
          startTime: dataCheckin[i]["start_time"],
          endTime: dataCheckin[i]["end_time"],
          checkinDate: dataCheckin[i]["checkin_date"],
          totalUsers: dataCheckin[i]["total_users"],
          checkinType: dataCheckin[i]["checkin_type"],
        );

        listCheckin.add(checkin);
      }
      setState(() {
        isLoading = false;
        // titleEvent = dataEvent[0]['title'];
      });
      } else if (getDataCheckins.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token Telah Kadaluwarsa, Silahkan Login Kembali");
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }
  // getDataEvent() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   listPeserta = [];
  //   try {
  //     dynamic response = await RequestGet(
  //             name: "event/getdata/event/", customrequest: "${widget.idevent}")
  //         .getdata();
  //     // print(response[0]['title']);
  //     setState(() {
  //       titleEvent = response[0]['title'];
  //     });

  //     setState(() {
  //       isLoading = false;
  //       isError = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       isError = true;
  //     });
  //     debugPrint('$e');
  //   }
  // }

  // getDataMember() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   listPeserta = [];
  //   try {
  //     dynamic response = await RequestGet(
  //             name: "event/getdata/participant/",
  //             customrequest: "${widget.idevent}")
  //         .getdata();
  //     print(response);
  //     for (var i = 0; i < response.length; i++) {
  //       UserParticipant peserta = UserParticipant(
  //         id: response[i]["id"].toString(),
  //         name: response[i]["name"],
  //         email: response[i]["email"],
  //         position: response[i]["position"].toString(),
  //         status: response[i]["status"],
  //         picProfile: response[i]["pic_profile"],
  //         eventId: response[i]["event_id"].toString(),
  //       );

  //       listPeserta.add(peserta);
  //     }
  //     setState(() {
  //       isLoading = false;
  //       isError = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       isError = true;
  //     });
  //     debugPrint('$e');
  //   }
  // }

  // getDataAdmin() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   listAdmin = [];
  //   try {
  //     dynamic response = await RequestGet(
  //             name: "event/getdata/admin/", customrequest: "${widget.idevent}")
  //         .getdata();
  //     print("as");
  //     print(response);
  //     for (var i = 0; i < response.length; i++) {
  //       UserParticipant admin = UserParticipant(
  //         id: response[i]["id"].toString(),
  //         name: response[i]["name"],
  //         email: response[i]["email"],
  //         position: response[i]["position"].toString(),
  //         status: response[i]["status"],
  //         picProfile: response[i]["pic_profile"],
  //         eventId: response[i]["event_id"].toString(),
  //       );

  //       listAdmin.add(admin);
  //     }
  //     setState(() {
  //       isLoading = false;
  //       isError = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       isError = true;
  //     });
  //     debugPrint('$e');
  //   }
  // }

  // getDataCheckin() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     listCheckin = [];
  //     dynamic response = await RequestGet(
  //             name: "checkin/getdata/checkin/",
  //             customrequest: "${widget.idevent}")
  //         .getdata();
  //     for (var i = 0; i < response.length; i++) {
  //       Checkin checkin = Checkin(
  //         id: response[i]["id"].toString(),
  //         eventId: response[i]["event_id"].toString(),
  //         checkinKey: response[i]["checkin_keyword"],
  //         startTime: response[i]["start_time"],
  //         endTime: response[i]["end_time"],
  //         checkinDate: response[i]["checkin_date"],
  //         totalUsers: response[i]["total_users"],
  //         checkinType: response[i]["checkin_type"],
  //       );

  //       listCheckin.add(checkin);
  //     }
  //     setState(() {
  //       isLoading = false;
  //       isError = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       isError = true;
  //     });
  //     debugPrint('$e');
  //   }
  // }

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

// Direct checkin function 
 randomNumberGenerator() {
    setState(() {
         isEnable = false;
          });
          Fluttertoast.showToast(
          msg: "Mohon Tunggu Sebentar",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
         setState(() {
         isEnable = false;
          });
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 10000;
    while (next < 1000) {
      next *= 10;
    }
      setState(() {
  isLoading = true;  
  });
    return postDataCheckin(next.toInt().toString());
  }

  postDataCheckin(_qrcode) async {  
  await new Future.delayed(const Duration(seconds: 2));
    dynamic body = {
      "event_id": widget.idevent.toString(),
      "checkin_keyword": _keywordController.text.toString(),
      "types": "D",
      "chekin_id": _qrcode,
    };

    dynamic response =
        await RequestPost(name: "checkin/postdata/checkinreguler", body: body)
            .sendrequest();
    if (response != "gagal") {
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => DirectCheckin(idevent: widget.idevent,idcheckin: _qrcode,keyword:_keywordController.text.toString())));
    }else{
       Fluttertoast.showToast(
          msg: "Terjadi Kesalahan, Coba Lagi...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoading = false;
      isEnable = false;
    });
  }

  @override
  void initState() {
    getHeaderHTTP();
    getDataMember();
    getDataCheckin();
    getDataAdmin();
    getDataEvent();
    isEnable = true;
    _tabController = TabController(
        length: 3, vsync: _DashboardCheckinState(), initialIndex: 0);
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
    "Beranda",
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
    String jumlahAdmin = listAdmin.length.toString();
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryAppBarColor,
          title: Text('Manajemen Event $titleEvent',
              style: TextStyle(fontSize: 14)),
          actions: <Widget>[],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Admin ( $jumlahAdmin )'),
              Tab(icon: Icon(Icons.person), text: 'Peserta ( $jumlahPeserta )'),
              Tab(icon: Icon(Icons.schedule), text: 'CheckIn'),
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
                        : _buildListViewAdmin(),
                  )
                ],
              ),
            ),
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
            ),
          ],
        ),

        floatingActionButton: isEnable != true ? Container() : _bottomButtons(),
      ),
    );
  }

  Widget _buildListViewAdmin() {
    return listAdmin.length == 0
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
                          "Event Belum Memiliki Admin Sama Sekali",
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
                        children: listAdmin
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
                                      // trailing: FlatButton(
                                      //   child: Icon(Icons.exit_to_app),
                                      //   onPressed: () async {
                                      //     showDialog(
                                      //         context: context,
                                      //         builder: (context) {
                                      //           return AlertDialog(
                                      //             title: Text("Warning"),
                                      //             content: Text(
                                      //                 "Apa anda yakin untuk mengeluarkan ${f.name}?"),
                                      //             actions: <Widget>[
                                      //               FlatButton(
                                      //                 child: Text("Yes"),
                                      //                 onPressed: () {
                                      //                   deleteParticipant(
                                      //                       f.id,
                                      //                       f.eventId
                                      //                           .toString());
                                      //                   listPeserta.remove(f);
                                      //                   Navigator.pop(context);
                                      //                 },
                                      //               ),
                                      //               FlatButton(
                                      //                 child: Text("No"),
                                      //                 onPressed: () {
                                      //                   Navigator.pop(context);
                                      //                 },
                                      //               )
                                      //             ],
                                      //           );
                                      //         });
                                      //   },
                                      // ),
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
                                                              ? 'Permintaan Diterima ( Admin / Co-Host)'
                                                              : f.status ==
                                                                          'A' &&
                                                                      f.position ==
                                                                          '3'
                                                                  ? 'Pendaftaran Diterima ( Peserta )'
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
                                                              ? 'Permintaan Diterima ( Admin / Co-Host)'
                                                              : f.status ==
                                                                          'A' &&
                                                                      f.position ==
                                                                          '3'
                                                                  ? 'Pendaftaran Diterima ( Peserta )'
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
                                                leading: data.checkinType ==
                                                        "Direct"
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                          child: Container(
                                                            height: 15.0,
                                                            alignment: Alignment
                                                                .center,
                                                            width: 15.0,
                                                            color:
                                                                Color.fromRGBO(
                                                                    41,
                                                                    30,
                                                                    47,
                                                                    1),
                                                          ),
                                                        ),
                                                      )
                                                    : null,
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
                                                trailing: isEnable != true ? Container() :
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

  void showModalInputKeyword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tambah Checkin Langsung'),
            content: Container(
              height: 130,
              child: Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _keywordController,
                        maxLines: 1,
                        autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Kata Kunci'
                      ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color:primaryAppBarColor,
                        child:  Text('Simpan',style: TextStyle(color:Colors.white),),
                        onPressed:  (){
                          Navigator.pop(context);
                          randomNumberGenerator();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showDialogChoiceCheckin(idEvent) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            height: 150.0 + MediaQuery.of(context).viewInsets.bottom,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: 15.0,
                left: 15.0,
                top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 7),
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          color: primaryAppBarColor,
                          child: Text('CheckIn Reguler',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManajemeCreateCheckin(
                                        idevent: idEvent)));
                          },
                        ))),
                Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 7),
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.white,
                          child: Text('CheckIn Langsung',
                              style: TextStyle(color: primaryAppBarColor)),
                          onPressed: () {
                            Navigator.pop(context);
                            showModalInputKeyword();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             DirectCheckin(idevent: idEvent)));
                          },
                        )))
              ],
            ),
          );
        });
  }

  Widget _bottomButtons() {
    return _tabController.index == 2
        ? DraggableFab(
            child: FloatingActionButton(
                shape: StadiumBorder(),
                onPressed:  () async {
                  showDialogChoiceCheckin(widget.idevent);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           ChoiceCheckin(idevent: widget.idevent),
                  //     ));
                },
                backgroundColor: Color.fromRGBO(254, 86, 14, 1),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                )))
        : null;
    // : DraggableFab(
    //     child: FloatingActionButton(
    //         shape: StadiumBorder(),
    //         onPressed: () async {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) =>
    //                     CreateParticipant(idevent: widget.idevent),
    //               ));
    //         },
    //         backgroundColor: Color.fromRGBO(254, 86, 14, 1),
    //         child: Icon(
    //           Icons.add,
    //           size: 20.0,
    //         )));
  }
}
