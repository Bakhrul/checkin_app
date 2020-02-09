import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:checkin_app/utils/utils.dart';

GlobalKey globalKey = new GlobalKey();
String _dataString, message;

class DetailQrCheckin extends StatefulWidget {
  DetailQrCheckin(
      {Key key,
      this.title,
      this.event,
      this.namaEvent,
      this.checkin,
      this.kodecheckin})
      : super(key: key);
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
    message = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cetak QR Code',
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: primaryAppBarColor,
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
                '${tes.path}/${widget.namaEvent}_${widget.kodecheckin}.png')
            .exists();
        if (sudahada == true) {
          File('${tes.path}/${widget.namaEvent}_${widget.kodecheckin}.png')
              .delete();
          final file = await new File(
                  '${tes.path}/${widget.namaEvent}_${widget.kodecheckin}.png')
              .create();
          await file.writeAsBytes(pngBytes);
          setState(() {
            sudahada = false;
            message =
                'Berhasil, Cari Gambar QrCode Pada Folder EventZhee - ${widget.namaEvent}_${widget.kodecheckin}.png';
          });
        } else {
          final file = await new File(
                  '${tes.path}/${widget.namaEvent}_${widget.kodecheckin}.png')
              .create();
          await file.writeAsBytes(pngBytes);
          setState(() {
            message =
                'Berhasil, Cari Gambar QrCode Pada Folder EventZhee - ${widget.namaEvent}_${widget.kodecheckin}.png';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 10.0,
            ),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[],
              ),
            ),
          ),
          message == null || message == ''
              ? Container()
              : Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15.0,right:15.0),
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
          Expanded(
            child: Center(
              child: RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: QrImage(
                      data: _dataString,
                      size: bodyHeight,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
