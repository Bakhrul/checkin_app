import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


GlobalKey globalKey = new GlobalKey();
String _dataString;



class DetailQrCheckin extends StatefulWidget {
  DetailQrCheckin({Key key, this.title, this.event, this.namaEvent, this.checkin, this.kodecheckin}) : super(key: key);
  final String title, event, checkin, kodecheckin, namaEvent;
  @override
  State<StatefulWidget> createState() {
    return _DetailQrCheckinState();
  }
}

class _DetailQrCheckinState extends State<DetailQrCheckin> {
  @override
  void initState() {
    super.initState();
    _dataString = widget.checkin.toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cetak QR Code',style: TextStyle(fontSize: 14),),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _captureAndSharePng,
          )
        ],
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {

      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);

      if(permission != PermissionStatus.denied){
         
          Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      
          RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
          
          var image = await boundary.toImage();
          ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
          Uint8List pngBytes = byteData.buffer.asUint8List();

          final tempDir = await getExternalStorageDirectory();
          var tes = await new Directory('${tempDir.path}/EventZhee').create();
          var sudahada = await File('${tes.path}/${widget.namaEvent}-${widget.kodecheckin}.png').exists();          
          if(sudahada == true){
          File('${tes.path}/${widget.kodecheckin}.png').delete();
          final file = await new File('${tes.path}/${widget.namaEvent}-${widget.kodecheckin}.png').create();
          await file.writeAsBytes(pngBytes);
          Fluttertoast.showToast(msg: "Berhasil, Cari gambar QrCode pada folder EventZhee - nama file ${widget.namaEvent}-${widget.kodecheckin}.png");
          setState(() {
            sudahada = false;
          });
          }else{
          final file = await new File('${tes.path}/${widget.namaEvent}-${widget.kodecheckin}.png').create();
          await file.writeAsBytes(pngBytes);
          Fluttertoast.showToast(msg: "Berhasil, Cari gambar QrCode pada folder EventZhee - nama file ${widget.namaEvent}-${widget.kodecheckin}.png");
          }
      }
      
      
      

    } catch(e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 10.0,
            
            ),
            child:  Container(
              
              child:  Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                ],
              ),
            ),
          ),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  width:  MediaQuery.of(context).size.width,
                  height :  MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child:QrImage(
                  data: _dataString,
                  size:  bodyHeight,
                 ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}