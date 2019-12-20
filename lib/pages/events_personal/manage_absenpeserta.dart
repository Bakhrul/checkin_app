import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';

GlobalKey<ScaffoldState> _scaffoldKeyManageAbsenPeserta;

class ManageAbsenPeserta extends StatefulWidget {
  ManageAbsenPeserta({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManageAbsenPesertaState();
  }
}

class _ManageAbsenPesertaState extends State<ManageAbsenPeserta> {
  @override
  void initState() {
    _scaffoldKeyManageAbsenPeserta = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyManageAbsenPeserta,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Kelola Absen Peserta",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            tooltip: 'Cari Peserta',
            onPressed: () {},
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Container(
            color: Colors.blue,
            
            child: Column(
              
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:50.0,bottom: 50.0),
                  child: Text('Indikator Absen Peserta Event',style: TextStyle(fontSize: 20,color: Colors.white,)),
                ),
                CircularPercentIndicator(
                  radius: 160.0,
                  lineWidth: 5.0,
                  percent: 0.8,
                  center: new Text(
                    "30 / 70%",
                    style:
                        new TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 14.0),
                  ),
                  backgroundColor: Colors.greenAccent,
                  progressColor: Color.fromRGBO(179, 0, 179, 1.0),
                  footer: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:30.0,),
                            child: Text("12 ",
                                style: new TextStyle(
                                     fontSize: 17.0,color: Colors.greenAccent)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:30.0,),
                            child: Text("/  478",
                                style: new TextStyle(
                                     fontSize: 17.0,color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:15.0,),
                            child: Text("466 ",
                                style: new TextStyle(
                                     fontSize: 17.0,color: Colors.purple)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:15.0,),
                            child: Text("/  478",
                                style: new TextStyle(
                                     fontSize: 17.0,color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Profil Drawer Here
                //  Menu Section Here
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(0, 204, 65, 1.0), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Color.fromRGBO(153, 255, 185, 1.0),
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(0, 204, 65, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(204, 204, 204, 1.0),
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(204, 204, 204, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(0, 204, 65, 1.0), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Color.fromRGBO(153, 255, 185, 1.0),
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(0, 204, 65, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(0, 204, 65, 1.0), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Color.fromRGBO(153, 255, 185, 1.0),
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(0, 204, 65, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
            Card(
                child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    width: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(204, 204, 204, 1.0),
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.check,
                        color: Color.fromRGBO(204, 204, 204, 1.0)),
                  ),
                ),
              ),
              title: Text('Muhammad Bakhrul Bila Sakhil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('081285270793'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
