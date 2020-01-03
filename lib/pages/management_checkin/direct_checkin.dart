import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/pages/management_checkin/create_checkin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DirectCheckin extends StatefulWidget {
  @override
  _DirectCheckinState createState() => _DirectCheckinState();
}

class _DirectCheckinState extends State<DirectCheckin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  // GlobalKey globalKey = new GlobalKey();
String _dataString;
  String _inputErrorText;
final TextEditingController _controllerGenerate = TextEditingController();
postDataCheckin() async {
    dynamic body = {
      "event_id": "1",
      "checkin_keyword": _controllerGenerate.text.toString()
    };
    print(body);

    dynamic response =
        await RequestPost(name: "checkin/postdata/checkindirect", body: body)
            .sendrequest();
    if (response == "success") {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
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
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
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
                trailing: FlatButton(
                  child: Text("SUBMIT"),
                  textColor: Colors.green,
                  color: Color.fromRGBO(220, 237, 193, 99),
                  onPressed: () {
                    setState(() {
                      _dataString = _controllerGenerate.text;
                      _inputErrorText = null;
                    });
                  },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() => _isLoading = true);
          postDataCheckin();
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }
  Widget _buildTextFieldDirect(){

  }

   Widget _builderGenerateDirect(bodyHeight) {
    if (_dataString != null) {
      return RepaintBoundary(
        // key: globalKey,
        child: QrImage(
          data: _dataString,
          size: 0.5 * bodyHeight,
          // onError: (ex) {
          //   print("[QR] ERROR - $ex");
          //   setState((){
          //     _inputErrorText = "Error! Maybe your input value is too long?";
          //   });
          // },
        ),
      );
    } else {
      return RepaintBoundary(
          child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
              child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => ManajemeCreateCheckin() ));
              },
                child: Text("Reguer Checkin"),
          ))
        ],
      ));
    }
  }
}