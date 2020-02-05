import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/checkin.dart';

import 'package:checkin_app/pages/management_checkin/generate_qrcode.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:checkin_app/utils/utils.dart';

var datepicker;

class ManajemeCreateCheckin extends StatefulWidget {
  Checkin checkin;
  final String title;
  final idevent;
  
  ManajemeCreateCheckin({Key key, this.title, this.checkin, this.idevent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManajemeCreateCheckinState();
  }
}

class _ManajemeCreateCheckinState extends State<ManajemeCreateCheckin> {
  bool _isLoading = false;
  GlobalKey globalKey = new GlobalKey();
  String _dataString;
  String _inputErrorText;
  final TextEditingController _controllerGenerate = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController _controllerTimeStart = TextEditingController();
  TextEditingController _controllerTimeEnd = TextEditingController();
  TextEditingController _controllerSessionname = TextEditingController();
  bool inside = false;
  Uint8List imageInMemory;

  randomNumberGenerator() {
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 10000;
    while (next < 1000) {
      next *= 10;
    }
    return _dataString = next.toInt().toString();
  }

  //  getDataChekinId() async {
  //   listPeserta = [];
  //   dynamic response =
  //       await RequestGet(name: "checkin/getdata/getcodeqr/", customrequest: "${widget.idevent.toString()}")
  //           .getdata();
  //           _dataString = response.toString();

  //           print(_dataString);
  // }

  postDataCheckin() async {
    _isLoading = true;
    dynamic body = {
      "event_id": widget.idevent.toString(),
      "checkin_keyword": _controllerGenerate.text.toString(),
      "chekin_id": _dataString,
      "start_time": _controllerTimeStart.text.toString(),
      "end_time": _controllerTimeEnd.text.toString(),
      "session_name": _controllerSessionname.text.toString(),
      "types": "S"
    };

    dynamic response =
    await RequestPost(name: "checkin/postdata/checkinreguler", body: body)
        .sendrequest();

    
    if (response != 'gagal') {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green[100],
          textColor: Colors.white,
          fontSize: 16.0);
      
      _isLoading =false;
      var codeQr = response['checkin'];
      var eventName = response['event'];
      var checkinCode = response['keyword'];
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
              GenerateScreen(idEvent: widget.idevent,codeQr: codeQr,eventName: eventName, checkinKeyword: checkinCode)));
    }else if(response == "tanggal kurang"){
      _isLoading =false;
       Fluttertoast.showToast(
          msg: "Tanggal/Waktu Yang Anda Inputkan Harus Melebihi Dengan Waktu Check-In Sebelumnya",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red[200],
          textColor: Colors.white,
          fontSize: 16.0);
    }else{
       _isLoading =false;
       Fluttertoast.showToast(
          msg: "Terjadi Kesalahan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red[200],
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      _isLoading =false;
    });
  }

  @override
  void initState() {
    datepicker = FocusNode();
    super.initState();
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
          "Buat Checkin Sekarang",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.brightness_1,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                    title: TextField(
                      controller: _controllerSessionname,
                      decoration: InputDecoration(
                          hintText: 'Nama Sesi',
                          errorText: _inputErrorText,
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.black)),
                    ),
                  )),
              Card(
                  child: ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                      title: _buildTextFieldTimeStart())),
              Card(
                  child: ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                      title: _buildTextFieldTimeEnd())),
              Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.create,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                    title: TextField(
                      controller: _controllerGenerate,
                      decoration: InputDecoration(
                          hintText: 'Keyword',
                          errorText: _inputErrorText,
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.black)),
                    ),
                  )),
             
            ],
          ),
        ),
      ),
      floatingActionButton: _isLoading == false ? FloatingActionButton(
        onPressed: _isLoading == true ? null : () {

          setState(() => _isLoading = true);
          if(_controllerSessionname.text == '' || _controllerSessionname.text == null){
            Fluttertoast.showToast(
            msg: "Nama sesi tidak boleh kosong");
          setState(() {
            _isLoading = false;
          });
          }else if(_controllerTimeStart.text == '' || _controllerTimeStart.text == null){
            Fluttertoast.showToast(
            msg: "Tanggal berlangsungnya checkin tidak boleh kosong");
            setState(() {
            _isLoading = false;
          });
          }else if(_controllerTimeEnd.text == '' || _controllerTimeEnd.text == null){
            Fluttertoast.showToast(
            msg: "Tanggal berakhirnya checkin tidak boleh kosong");
            setState(() {
            _isLoading = false;
          });
          }else if(_controllerGenerate.text == '' || _controllerGenerate.text == null){
            Fluttertoast.showToast(
            msg: "Keyword checkin tidak boleh kosong");
            setState(() {
            _isLoading = false;
          });
          }else{
            randomNumberGenerator();
            postDataCheckin();
          }
          
        },
        child: Icon(Icons.check),
        backgroundColor: primaryAppBarColor,
      ) 
      :  Align(
          alignment: FractionalOffset.bottomCenter,
          child: CircularProgressIndicator(),
        ),
      );
    
  }

  Widget _buildTextFieldTimeEnd() {
    return DateTimeField(
      controller: _controllerTimeEnd,
      format: format,
      decoration: InputDecoration(
        hintText: 'Tanggal Berakhirnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget _buildTextFieldTimeStart() {
    return DateTimeField(
      controller: _controllerTimeStart,
      format: format,
      decoration: InputDecoration(
        hintText: 'Tanggal Berlangsungnya CheckIn',
        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

 



//  Future<Uint8List> _getWidgetImage() async {
//    try {
//      RenderRepaintBoundary boundary =
//      globalKey.currentContext.findRenderObject();
//      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//      ByteData byteData =
//      await image.toByteData(format: ui.ImageByteFormat.png);
//      var pngBytes = byteData.buffer.asUint8List();
//      var bs64 = base64Encode(pngBytes);
//      debugPrint(bs64.length.toString());
//      return pngBytes;
//    } catch (exception) {}
//  }
//
//  Future<Uint8List> _capturePng() async {
//    try {
//      print('inside');
//      inside = true;
//      RenderRepaintBoundary boundary =
//      globalKey.currentContext.findRenderObject();
//      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//      ByteData byteData =
//      await image.toByteData(format: ui.ImageByteFormat.png);
//      Uint8List pngBytes = byteData.buffer.asUint8List();
////      String bs64 = base64Encode(pngBytes);
////      print(pngBytes);
////      print(bs64);
//      print('png done');
//      setState(() {
//        imageInMemory = pngBytes;
//        inside = false;
//      });
//      return pngBytes;
//    } catch (e) {
//      print(e);
//    }
//  }
//  Future<String> _createFileFromString() async {
//    final encodedStr = "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";
//    Uint8List bytes = base64.decode(encodedStr);
//    String dir = (await getApplicationDocumentsDirectory()).path;
//    File file = File(
//        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
//    await file.writeAsBytes(bytes);
//    return file.path;
//  }
//
//  _save() async {
//    var response = await Dio().get("https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg", options: Options(responseType: ResponseType.bytes));
//    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
//    print(result);
//  }

}


// =========================================================================
