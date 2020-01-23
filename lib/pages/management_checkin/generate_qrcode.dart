import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';
import 'package:checkin_app/pages/management_checkin/dashboard_checkin.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
 
class GenerateScreen extends StatefulWidget {
  GenerateScreen({Key key, this.idEvent, this.codeQr, this.eventName});
  final idEvent;
  final codeQr;
  final eventName;
  
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
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
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
            Expanded(
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
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.orange,
                      onPressed: () {
                        _saveScreen();
                      },
                      child: Text("Unduh",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Container(
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
    _saveScreen() async {
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
          var sudahada = await File('${tes.path}/${widget.eventName}-${widget.idEvent}.png').exists();          
          if(sudahada == true){
          File('${tes.path}/${widget.idEvent}.png').delete();
          final file = await new File('${tes.path}/${widget.eventName}-${widget.idEvent}.png').create();
          await file.writeAsBytes(pngBytes);

          Fluttertoast.showToast(msg: "Berhasil, Cari gambar QrCode pada folder EventZhee - nama file ${widget.eventName}-${widget.idEvent}.png",
           toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,);
          setState(() {
            sudahada = false;
          });
          }else{
          final file = await new File('${tes.path}/${widget.eventName}-${widget.idEvent}.png').create();
          await file.writeAsBytes(pngBytes);
          Fluttertoast.showToast(
            msg: "Berhasil, Cari gambar QrCode pada folder EventZhee - nama file ${widget.eventName}-${widget.idEvent}.png",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
          );
          }
      }
      
      
      

    } catch(e) {
      print(e.toString());
    }
  }
}
