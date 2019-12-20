import 'package:flutter/material.dart';
import 'dart:ui';


GlobalKey<ScaffoldState> _scaffoldKeyDashboard;

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  var height;
  var futureheight;
  var pastheight;

  @override
  void initState() {
    _scaffoldKeyDashboard = GlobalKey<ScaffoldState>();
    super.initState();
  }

   void currentEvent(){
        setState((){
            if(height == 0.0){
                height = null;
            }else{
                height = 0.0;
            } 
        });
    }

  void futureEvent(){
        setState((){
            if(futureheight == 0.0){
                futureheight = null;
            }else{
                futureheight = 0.0;
            } 
        });
    }

  void pastEvent(){
        setState((){
            if(pastheight == 0.0){
                pastheight = null;
            }else{
                pastheight = 0.0;
            } 
        });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyDashboard,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            tooltip: 'Notifikasi',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Profil Drawer Here
            UserAccountsDrawerHeader(
              accountName: Text("Muhammad Bakhrul Bila Sakhil"),
              accountEmail: Text("bakhrulrpl@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            //  Menu Section Here
            Expanded(
              child: Container(
                // color: Colors.red,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Semua Event',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Color(0xff25282b),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/semua_event");
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Event Anda',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Color(0xff25282b),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/personal_event");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Colors.black54,
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                trailing: Icon(Icons.exit_to_app),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Peringatan!'),
                      content: Text('Apa anda yakin ingin logout?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Tidak',
                            style: TextStyle(color: Colors.black54),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            'Ya',
                            style: TextStyle(color: Colors.cyan),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            children : <Widget>[
              Container(
                child:Column(
                  children:<Widget>[
                    GestureDetector(
                      onTap: currentEvent,
                      child: Container(
                          decoration:new BoxDecoration(
                          color:Color.fromRGBO(54,55,84,1),
                          border:Border(
                            bottom: BorderSide(width: 0.2, color: Colors.white),
                          )
                        ),
                          padding:EdgeInsets.all(20.0),
                          width: double.infinity,
                          child:Text(('Event Berlangsung').toUpperCase(),style:TextStyle(color:Colors.white,fontSize:18),textAlign:TextAlign.center)
                        )
                    ),
                    Container(
                      height:height,
                      child:Column(
                      children: <Widget>[
                        Card(
                            child: ListTile(
                              leading: Image.asset("images/noimage.jpg"),
                              title: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text('Nama Event',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                                    ),
                                  Container(
                                       padding : EdgeInsets.all(1.5),
                                       margin: EdgeInsets.only(left:5.0),
                                       decoration:BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(100.0),
                                              topRight: const Radius.circular(100.0),
                                              bottomLeft: const Radius.circular(100.0),
                                              bottomRight: const Radius.circular(100.0),
                                        )
                                      ),
                                      child: Icon(Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                  )
                                ],
                              ),  
                              subtitle: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                      Text('A sufficiently long subtitle warrants three lines.'),
                                   ],
                                ),
                              trailing: Icon(Icons.more_vert),
                              isThreeLine:true,
                            ),
                          ),
                      ],
                    )
                      )
                  ]
                )
              ),
              Column(
                  children:<Widget>[
                    GestureDetector(
                      onTap: futureEvent,
                      child: Container(
                         decoration:new BoxDecoration(
                          color:Color.fromRGBO(54,55,84,1),
                          border:Border(
                            bottom: BorderSide(width: 0.2, color: Colors.white),
                          )
                        ),
                          padding:EdgeInsets.all(20.0),
                          width: double.infinity,
                          child:Text(('Event Baru').toUpperCase(),style:TextStyle(color:Colors.white,fontSize:18),textAlign:TextAlign.center)
                        )
                    ),
                    Container(
                      height:futureheight,
                      child:Column(
                      children: <Widget>[
                        Card(
                            child: ListTile(
                              leading: Image.asset("images/noimage.jpg"),
                              title: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text('Nama Event',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                                    ),
                                  Container(
                                       padding : EdgeInsets.all(1.5),
                                       margin: EdgeInsets.only(left:5.0),
                                       decoration:BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(100.0),
                                              topRight: const Radius.circular(100.0),
                                              bottomLeft: const Radius.circular(100.0),
                                              bottomRight: const Radius.circular(100.0),
                                        )
                                      ),
                                      child: Icon(Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                  )
                                ],
                              ),  
                              subtitle: Text(
                                'A sufficiently long subtitle warrants three lines.'
                              ),
                              trailing: Icon(Icons.more_vert),
                              isThreeLine:true,
                            ),
                          ),
                        Card(
                            child: ListTile(
                              leading: Image.asset("images/noimage.jpg"),
                              title: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text('Nama Event',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                                    ),
                                  Container(
                                       padding : EdgeInsets.all(1.5),
                                       margin: EdgeInsets.only(left:5.0),
                                       decoration:BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(100.0),
                                              topRight: const Radius.circular(100.0),
                                              bottomLeft: const Radius.circular(100.0),
                                              bottomRight: const Radius.circular(100.0),
                                        )
                                      ),
                                      child: Icon(Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                  )
                                ],
                              ),  
                              subtitle: Text(
                                'A sufficiently long subtitle warrants three lines.'
                              ),
                              trailing: Icon(Icons.more_vert),
                              isThreeLine:true,
                            ),
                          ),
                      ],
                    )
                    )
                    
                  ]
                ),
              Column(
                  children:<Widget>[
                    GestureDetector(
                      onTap: pastEvent,
                      child: Container(
                         decoration:new BoxDecoration(
                          color:Color.fromRGBO(54,55,84,1),
                          border:Border(
                            bottom: BorderSide(width: 0.2, color: Colors.white),
                          )
                        ),
                          padding:EdgeInsets.all(20.0),
                          width: double.infinity,
                          child:Text(('Event Selesai').toUpperCase(),style:TextStyle(color:Colors.white,fontSize:18),textAlign:TextAlign.center)
                        )
                    ),
                    Container(
                      height:pastheight,
                      child:Column(
                      children: <Widget>[
                        Card(
                            child: ListTile(
                              leading: Image.asset("images/noimage.jpg"),
                              title: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text('Nama Event',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                                    ),
                                  Container(
                                       padding : EdgeInsets.all(1.5),
                                       margin: EdgeInsets.only(left:5.0),
                                       decoration:BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(100.0),
                                              topRight: const Radius.circular(100.0),
                                              bottomLeft: const Radius.circular(100.0),
                                              bottomRight: const Radius.circular(100.0),
                                        )
                                      ),
                                      child: Icon(Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                  )
                                ],
                              ),  
                              subtitle: Text(
                                'A sufficiently long subtitle warrants three lines.'
                              ),
                              trailing: Icon(Icons.more_vert),
                              isThreeLine:true,
                            ),
                          ),
                      ],
                    )
                    )
                  ]
                ),
            ]
          )
        )
    );
  }
}
