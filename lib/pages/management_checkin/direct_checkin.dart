import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/pages/management_checkin/create_checkin.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dashboard_checkin.dart';
// Tambahan Untuk Membuat StopWatch
class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}
class Dependencies {

  final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(fontSize: 10.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}
// =======
class DirectCheckin extends StatefulWidget {
  final idevent;
  DirectCheckin({Key key,this.idevent});

  @override
  _DirectCheckinState createState() => _DirectCheckinState();
}

class _DirectCheckinState extends State<DirectCheckin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  // Tambahan StopWatch
  final Dependencies dependencies = new Dependencies();
   void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsedMilliseconds}");
      } else {
        dependencies.stopwatch.reset();
      }
    });
  }
void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }
    Widget buildStopButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle = const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
      child: new Text(text, style: roundTextStyle),
      onPressed: callback);
  }

  // ========
  GlobalKey globalKey = new GlobalKey();
  bool _isLoading,_isChange = false;
  String _dataString;
  String _inputErrorText;
  String eventName,eventId,checkinId ;
final TextEditingController _controllerGenerate = TextEditingController();

   randomNumberGenerator() {
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 10000;
    while (next < 1000) {
      next *= 10;
    }
      setState(() {
  _isLoading = true;  
  });
    return _dataString = next.toInt().toString();
  }

updateDateCheckin() async {  
  // await new Future.delayed(const Duration(seconds: 2));
    dynamic body = {
      "event_id": widget.idevent.toString(),
      // "checkin_keyword": checkinId.toString(),
      "types": "D",
      "chekin_id": checkinId.toString(),
    };

    dynamic response =
        await RequestPost(name: "checkin/updatedata/checkinreguler", body: body)
            .sendrequest();
            print(response);
    if (response != "gagal") {
      Fluttertoast.showToast(
          msg: "Checkin Berhenti",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          // backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
          //  dependencies.stopwatch.isRunning = false;
        setState(() {
          
          _isChange = true;
          dependencies.stopwatch.stop();
          //  _b = false;
            
          });
      // Navigator.pushReplacement(context,
      // MaterialPageRoute(builder: (context) => DashboardCheckin(idevent: widget.idevent,)));
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
      _isLoading = false;
    });
  }

postDataCheckin() async {  
  await new Future.delayed(const Duration(seconds: 2));
    dynamic body = {
      "event_id": widget.idevent.toString(),
      "checkin_keyword": _controllerGenerate.text.toString(),
      "types": "D",
      "chekin_id": _dataString,
    };

    dynamic response =
        await RequestPost(name: "checkin/postdata/checkinreguler", body: body)
            .sendrequest();
    if (response != "gagal") {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
        setState(() {
          checkinId = response['checkin'].toString();
          eventName = response['event'];
          eventId   = widget.idevent.toString();
          _isChange = true;
          dependencies.stopwatch.start();
          // rightButtonPressed();
            
          });
      // Navigator.pushReplacement(context,
      // MaterialPageRoute(builder: (context) => DashboardCheckin(idevent: widget.idevent,)));
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
      _isLoading = false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
    MediaQuery.of(context).viewInsets.bottom;
   return Scaffold(
      backgroundColor: Colors.white,
      // key: _scaffoldKeycreatecheckin,
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
                  Icons.create,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: TextField(
                  controller: _controllerGenerate,
                  decoration: InputDecoration(
                      hintText: 'Keyword',
                      errorText: _inputErrorText,
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              )),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: _builderGenerateDirect(bodyHeight),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    
    );
  }

   Widget _builderGenerateDirect(bodyHeight) {
     if(_isLoading == true){
       return Center(
         child: CircularProgressIndicator(),
       );
     }
    if ( checkinId != null && _isChange == true) {
      return Column(
        children: <Widget>[
          Container(
            child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: checkinId,
                  size: 0.5 * bodyHeight,
                  // onError: (ex) {
                  //   print("[QR] ERROR - $ex");
                  //   setState((){
                  //     _inputErrorText = "Error! Maybe your input value is too long?";
                  //   });
                  // },
                ),
              ),
          ),
          Container(
            
            width: double.infinity,
            child: new TimerText(dependencies: dependencies),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            height: 0.5 * bodyHeight,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                        child: FlatButton(
                          color: Colors.red,
                          child: Text("Berhenti",style: TextStyle(color: Colors.white),), onPressed: () {
                            updateDateCheckin();
                          },
                        ),
                      ),
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                    child: FlatButton(
                      child: Text("Unduh",style: TextStyle(color: Colors.white)), onPressed: () {_saveScreen();},),),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text("Kembali"), onPressed: () { 
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardCheckin(idevent: widget.idevent,)));
                      },),)
              ],
            ),
          ),
                
          // Expanded(
          //   child: Column(
          //     children: <Widget>[
                
          //     ],
          //   ),)
        ],
      );
    } else {
      return RepaintBoundary(
          child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
              child: FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                // Navigator.push(context,MaterialPageRoute(builder: (context) => ManajemeCreateCheckin() ));
                randomNumberGenerator();
                postDataCheckin();
                
              },
                child: Text("Mulai"),
          ))
        ],
      ));
    }
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
          var sudahada = await File('${tes.path}/$eventName-$eventId.png').exists();          
          if(sudahada == true){
          File('${tes.path}/$eventId.png').delete();
          final file = await new File('${tes.path}/$eventName-$eventId.png').create();
          await file.writeAsBytes(pngBytes);
          Fluttertoast.showToast(msg: "Berhasil, Cari gambar QrCode pada folder EventZhee - nama file $eventName-$eventId.png",
           toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,);
          setState(() {
            sudahada = false;
          });
          }else{
          final file = await new File('${tes.path}/$eventName-$eventId.png').create();
          await file.writeAsBytes(pngBytes);
          Fluttertoast.showToast(
            msg: "Berhasil, Cari gambar QrCode pada folder EventZhee - nama file $eventName-$eventId.png",
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

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() => new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate), callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: <Widget>[
            new RepaintBoundary(
              child: new SizedBox(
                // height: 50.0,
                child: new MinutesAndSeconds(dependencies: dependencies),
              ),
            ),
            new RepaintBoundary(
              child: new SizedBox(
                // height: 50.0,
                child: new Hundreds(dependencies: dependencies),
              ),
            ),
        ],
      ),
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() => new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new AutoSizeText('$minutesStr:$secondsStr.', style: TextStyle(fontSize: 30),);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}