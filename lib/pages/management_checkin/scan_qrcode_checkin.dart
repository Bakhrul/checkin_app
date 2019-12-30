import 'package:checkin_app/pages/register_event/step_register_six.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrcode/qrcode.dart';

class ScanQrcode extends StatefulWidget {
  @override
  _ScanQrcodeState createState() => _ScanQrcodeState();
}

class _ScanQrcodeState extends State<ScanQrcode> with TickerProviderStateMixin {
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;

  bool _isTorchOn = false;
  String _isTorchOnText = 'off';
  String _captureText = 'Arahkan Pada Kode Qr';

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      print('onCapture----$data');
      setState(() {
        _captureText = data;
      });
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Checkin",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 250,
              height: 250,
              child: QRCaptureView(
                controller: _captureController,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 56),
              child: AspectRatio(
                aspectRatio: 264 / 258.0,
                child: Stack(
                  alignment: _animation.value,
                  children: <Widget>[
                    Image.asset('images/header-scanning.png'),
                    Image.asset('images/scanning.png')
                  ],
                ),
              ),
            ),
             Align(
              heightFactor: 20.0,
              alignment: Alignment.topCenter,
              child:  Text(_captureText != '' ? _captureText : "Coba Lagi") ,   
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildToolBar(),
            ),
            // Container(
              
            //   child: _captureText != '' ?  Navigator.push(context, MaterialPageRoute(builder: => SuccesRegisteredEvent() )): Fluttertoast.showToast(msg:"Berhasil Mengirimkan Notifikasi kepada Pembuat Event"),
            // )
          ],
        ),
      
    );
  }


  Widget _buildToolBar() {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                _captureController.pause();
              },
              child: Text('pause'),
            ),
            FlatButton(
              onPressed: () {
                if (_isTorchOn) {
                  _isTorchOnText = 'Off';
                  _captureController.torchMode = CaptureTorchMode.off;
                } else {
                  _isTorchOnText = 'On';
                  _captureController.torchMode = CaptureTorchMode.on;
                }
                _isTorchOn = !_isTorchOn;
              },
              child: Text('Flash : $_isTorchOnText'),
        ),
        FlatButton(
          onPressed: () {
            _captureController.resume();
          },
          child: Text('resume'),
        ),
      ],
    );
  }
}
