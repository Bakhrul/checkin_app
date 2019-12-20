import 'package:flutter/material.dart';

class EventAll extends StatefulWidget{
  final Widget child;
  final bool expand;
  EventAll({this.expand = false, this.child});

  State<StatefulWidget> createState(){
    return _EventAll();
  }
}

class _EventAll extends State<EventAll>{
  var height;
  var futureheight;
  var pastheight;

  @override
  void initState() {
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
  Widget build(BuildContext context){
    return Scaffold(
        appBar: new AppBar(
          title: new Text("List Event")
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
                    Column(
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
                  ]
                )
              ),
              Container(
                child:Column(
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
                    Column(
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
                  ]
                )
              ),
              Container(
                child:Column(
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
                    Column(
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
                  ]
                )
              ),
            ]
          )
        )
    );
  }
}