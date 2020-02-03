import 'dart:io';
import 'dart:typed_data';

import 'package:checkin_app/pages/management_checkin/dashboard_checkin.dart';
import 'package:checkin_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
 
 String message;
class GenerateScreen extends StatefulWidget {
  GenerateScreen({Key key, this.idEvent, this.codeQr, this.eventName, this.checkinKeyword});
  final idEvent;
  final codeQr;
  final eventName;
  String checkinKeyword;
  
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  String _codeQr;
  bool isLoading,isError = false;
  String _eventName,_checkinId;
   
  GlobalKey globalKey = new GlobalKey();
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    _codeQr = widget.codeQr;
  }


   @override
  void initState() {
    message = '';
    super.initState();
  }

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Kode Qr",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _captureAndSharePng,
          )
        ],
        backgroundColor: primaryAppBarColor,
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              message == null || message == ''
              ? Container()
              : Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15.0,right:15.0,top:20.0,bottom: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(0, 204, 65, 1.0),
                    width: 1.0,
                    
                  ),
                  color: Color.fromRGBO(153, 255, 185, 1.0),
                ),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.black,height:1.5),
                  )),

            Center(
              child: Container(
                child: RepaintBoundary(                
                  key: globalKey,
                  child: QrImage(
                    backgroundColor: Colors.white,
                    data: widget.codeQr,
                    size: 0.5 * bodyHeight,
                   
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:20.0),
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => DashboardCheckin(idevent: widget.idEvent) ));
                        
                      },
                      child: Text("Kembali",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
        
          ],
        ),
      ),
    );
  }
   Future<void> _captureAndSharePng() async {
    try {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.contacts);

      if (permission != PermissionStatus.denied) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);

        RenderRepaintBoundary boundary =
            globalKey.currentContext.findRenderObject();

        var image = await boundary.toImage();
        ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final tempDir = await getExternalStorageDirectory();
        var tes = await new Directory('${tempDir.path}/EventZhee').create();
        var sudahada = await File(
                '${tes.path}/${widget.eventName}_${widget.checkinKeyword}.png')
            .exists();
        if (sudahada == true) {
          File('${tes.path}/${widget.eventName}_${widget.checkinKeyword}.png')
              .delete();
          final file = await new File(
                  '${tes.path}/${widget.eventName}_${widget.checkinKeyword}.png')
              .create();
          await file.writeAsBytes(pngBytes);
          setState(() {
            sudahada = false;
            message =
                'Berhasil, Cari gambar QrCode pada folder EventZhee - ${widget.eventName}_${widget.checkinKeyword}.png';
          });
        } else {
          final file = await new File(
                  '${tes.path}/${widget.eventName}_${widget.checkinKeyword}.png')
              .create();
          await file.writeAsBytes(pngBytes);
          setState(() {
            message =
                'Berhasil, Cari gambar QrCode pada folder EventZhee - ${widget.eventName}_${widget.checkinKeyword}.png';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  
      
      
      
  }
}
