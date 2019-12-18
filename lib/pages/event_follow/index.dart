import 'package:flutter/material.dart';



GlobalKey<ScaffoldState> _scaffoldKeyfollowevent;

void showInSnackBar(String value) {
  _scaffoldKeyfollowevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemeEventFollow extends StatefulWidget {
  ManajemeEventFollow({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemeEventFollowState();
  }
}

class _ManajemeEventFollowState extends State<ManajemeEventFollow> {
  

  @override
  void initState() {
    _scaffoldKeyfollowevent = GlobalKey<ScaffoldState>();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyfollowevent,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Event yang diikuti",
            style: TextStyle(
              color: Color(0xff25282b),
            ),
          ),
          backgroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Event Yang diikuti',
            ),
          ],
        ),
      ),
    );
  }
}

