import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventDetail;

void showInSnackBar(String value) {
  _scaffoldKeyEventDetail.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEventDetail extends StatefulWidget {
  ManajemenEventDetail({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventDetailState();
  }
}

class _ManajemenEventDetailState extends State<ManajemenEventDetail> {
  @override
  void initState() {
    _scaffoldKeyEventDetail = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      key: _scaffoldKeyEventDetail,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Detail Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
        child: SingleChildScrollView(
          child: Card(            
            
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 50.0),
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  'images/imgavatar.png',
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right:15.0,left:15.0,top:20.0),
                          child: Text('Meetup Programmer Abal Abal',style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0,bottom: 20.0),
                          child: Text('Category Event',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Text('Tanggal Event'),
                                Text('12 Desember 2019'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Text('Timing Event'),
                                Text('12:00'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top:10.0,right: 15.0,left: 15.0,),
                      child: Text('Tentang Event',style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged',textAlign: TextAlign.center,style: TextStyle(height: 2,)),
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Text('Alamat Diselenggaranya Event'),
                  ),
                  Container(
                    child: Text('Jl Lemahbang Kecamatan Sukorejo Pasuruan'),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
