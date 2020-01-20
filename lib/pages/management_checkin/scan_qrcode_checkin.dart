import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import 'checkin_qrcode.dart';

class ScanQrcode extends StatefulWidget {
  final id;
  ScanQrcode({Key key, @required this.id});
  @override
  _ScanQrcodeState createState() => _ScanQrcodeState();
}

class _ScanQrcodeState extends State<ScanQrcode> with TickerProviderStateMixin {
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;
  bool _isTorchOn = false;
  String _isTorchOnText = 'off';
  String _captureText = 'Arahkan ke Kode Qr';

  postDataCheckin(data) async {
     _captureController.pause();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CheckinQRCode(idevent: widget.id, idcheckin: data.toString())));
    print('testing' + data.toString());

    // var _timeCheckin = DateTime.now().toString();
    // dynamic body = {
    //   "event_id": widget.id,
    //   "checkin_id": data.toString(),
    //   "checkin_type": "BS",
    //   "time_checkin": _timeCheckin
    // };

    // dynamic response =
    //     await RequestPost(name: "checkin/postdata/usercheckin", body: body)
    //         .sendrequest();
    // if (response == "success") {
    //   Fluttertoast.showToast(
    //       msg: "Success",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIos: 1,
    //       backgroundColor: Colors.green,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //   Navigator.pop(context);
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Terjadi Kesalahan Server Mohon Coba Lagi",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIos: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

    // setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      print('onCapture----$data');
      postDataCheckin(data);
      _captureText = '';
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
            width: double.infinity,
            height: double.infinity,
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
            alignment: Alignment.bottomCenter,
            child: _buildToolBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCapture() {
    if (_captureText != null ||
        _captureText != "" ||
        _captureText != "Arahkan ke Kode Qr") {
      _captureController.pause();
      postDataCheckin(_captureText);
    } else {
      return Text(_captureText != '' ? _captureText : "Coba Lagi");
    }
  }

  Widget _buildToolBar() {
    return Container(
      color: Color.fromRGBO(41, 30, 47, 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
            child: Text(
              'Flash : $_isTorchOnText',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
