import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';


GlobalKey globalKey = new GlobalKey();
String _dataString;

class DetailQrCheckin extends StatefulWidget {
  DetailQrCheckin({Key key, this.title, this.event, this.checkin}) : super(key: key);
  final String title, event, checkin;
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

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

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
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

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
                child: QrImage(
                  data: _dataString,
                  size:  bodyHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}