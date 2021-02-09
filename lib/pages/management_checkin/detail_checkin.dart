import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user_checkin.dart';
import 'package:checkin_app/pages/management_checkin/list_peserta_checkin.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

List<UserCheckin> listPeserta;
String message;

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
  });

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }
}

class DetailCheckin extends StatefulWidget {
  DetailCheckin(
      {Key key, @required this.idEvent, this.idCheckin, this.keywordCheckin});
  final idEvent;
  final idCheckin;
  final String keywordCheckin;
  @override
  _DetailCheckinState createState() => _DetailCheckinState();
}

class _DetailCheckinState extends State<DetailCheckin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  File imageProfile;

  String id,
      eventId,
      keyword,
      startTime,
      endTime,
      typeCheckin,
      eventName,
      dateCheckin;
  bool _isLoading = true;
  //shader gradient Color for text
  GlobalKey globalKey = new GlobalKey();
  @override
  void initState() {
    getData();
    message = '';
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getData() async {
    listPeserta = [];

    dynamic response = await RequestGet(
            name: "checkin/getdata/detailcheckin/",
            customrequest:
                "${widget.idCheckin.toString()}/${widget.idEvent.toString()}")
        .getdata();
// set data participant from webservice into List
    for (var i = 0; i < response['participant'].length; i++) {
      // print response['participant']["name"].toString());
      UserCheckin peserta = UserCheckin(
        name: response['participant'][i]["name"].toString(),
        email: response['participant'][i]["email"].toString(),
        picProfile: response['participant'][i]["photo_profile"],
      );

      listPeserta.add(peserta);
    }
//set data detail checkin from web service into String
    id = response["id_checkin"].toString();
    eventId = response["id_event"].toString();
    startTime = response["time_start"].toString();
    endTime = response["time_end"].toString();
    keyword = response["keyword"].toString();
    eventName = response["eventName"].toString();

    if (startTime.substring(0, 10) == endTime.substring(0, 10)) {
      dateCheckin = startTime + ' - ' + endTime.substring(11);
    } else {
      dateCheckin = startTime + ' - ' + endTime;
    }

    if (response["type"].toString() == "S") {
      typeCheckin = "Checkin Reguler";
    } else {
      typeCheckin = "Checkin Langsung";
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: primaryAppBarColor,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Detail CheckIn",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed:_isLoading == true ? null : () {
                _saveScreen();
              },
            ),
          ],
        ),
        body: _isLoading == false
            ? _buildBody()
            : Center(child: CircularProgressIndicator()));
  }

  Widget _buildBody() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              message == null || message == ''
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0,top:15.0,bottom:15.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                          width: 1.0,
                        ),
                        color: Color.fromRGBO(153, 255, 185, 1.0),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.black, height: 1.5),
                      )),
              Container(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    backgroundColor: Colors.white,
                    data: widget.idCheckin,
                    size: 0.4 * bodyHeight,
                  ),
                ),
              ),
              Divider(),
              Center(
                child: Text(
                  '$keyword',                 
                ),
              ),
              Divider(),

              Container(
                margin: EdgeInsets.all(8.0),
                height: 60.0,
                width: double.infinity,
                child: Card(
                  color: Colors.blue[200],
                  elevation: 2,
                  child: Center(
                      child: Text(
                    "Detail",
                    style: TextStyle(fontSize: 18),
                  )),
                ),
              ),
              Text("$eventName"), // title event
              Text("$dateCheckin"),
              Text("$typeCheckin"),
              Container(
                margin: EdgeInsets.all(8.0),
                height: 60.0,
                width: double.infinity,
                child: Card(
                  color: Colors.blue[200],
                  elevation: 2,
                  child: Center(
                      child: Text(
                    "Peserta",
                    style: TextStyle(fontSize: 18),
                  )),
                ),
              ),
              Column(
                children: <Widget>[
                  Column(
                      children: listPeserta
                          .map((UserCheckin item) => Padding(
                                padding: EdgeInsets.only(bottom: 2.0),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      right: 8.0, bottom: 2.0, left: 8.0),
                                  color: Colors.grey[50],
                                  child: ListTile(
                                    leading: item.picProfile == '-'
                                        ? Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: 50,
                                            width: 50,
                                            child: ClipOval(
                                                child: Image.asset(
                                                    'images/imgavatar.png',
                                                    fit: BoxFit.fill)))
                                        : Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: 50,
                                            width: 50,
                                            child: ClipOval(
                                                child: imageProfile == null
                                                    ? FadeInImage.assetNetwork(
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            'images/imgavatar.png',
                                                        image: url(
                                                            'storage/image/profile/${item.picProfile}'))
                                                    : Image.file(
                                                        imageProfile))),
                                    title: Text("${item.name}"),
                                    onTap: () {},
                                    subtitle: Text("${item.email}"),
                                  ),
                                ),
                              ))
                          .toList()),
                ],
              ),

              //  ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 4.5, right: 8.0, left: 8.0),
                child: FlatButton(
                  child: Text("Lainnya..."),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListPesertaCheckin(
                                id: widget.idCheckin.toString(),
                                eventid: widget.idEvent.toString())));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _saveScreen() async {
    try {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.contacts);

      if (permission != PermissionStatus.denied) {
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

        RenderRepaintBoundary boundary =
            globalKey.currentContext.findRenderObject();

        var image = await boundary.toImage();
        ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final tempDir = await getExternalStorageDirectory();
        var tes = await new Directory('${tempDir.path}/EventZhee').create();
        var sudahada =
            await File('${tes.path}/$eventName - ${widget.keywordCheckin}.png')
                .exists();
        if (sudahada == true) {
          File('${tes.path}/$eventName - ${widget.keywordCheckin}.png')
              .delete();
          final file = await new File(
                  '${tes.path}/$eventName - ${widget.keywordCheckin}.png')
              .create();
          await file.writeAsBytes(pngBytes);
          setState(() {
            sudahada = false;
            message =
                'Berhasil, Cari gambar QrCode pada folder EventZhee - $eventName - ${widget.keywordCheckin}.png';
          });
        } else {
          final file = await new File(
                  '${tes.path}/$eventName - ${widget.keywordCheckin}.png')
              .create();
          await file.writeAsBytes(pngBytes);
          setState(() {
            message =
                'Berhasil, Cari gambar QrCode pada folder EventZhee - $eventName - ${widget.keywordCheckin}.png';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
