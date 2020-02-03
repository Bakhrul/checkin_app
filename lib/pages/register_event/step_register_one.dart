import 'package:checkin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'step_register_self.dart';
import 'step_register_someone.dart';
import 'step_not_register.dart';

class RegisterEventMethod extends StatefulWidget{
  final int id;
  final String creatorId;
  final Map dataUser;
  RegisterEventMethod({Key key,this.id,this.creatorId, this.dataUser}) : super(key : key);

  State<StatefulWidget> createState(){
    return _RegisterEventMethod();
  }
}

class _RegisterEventMethod extends State<RegisterEventMethod>{

  @override
  void initState() {
    super.initState();
  }

  showSheet(){
   return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        builder: (context){
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                color: Colors.white
              ),
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.only(top:20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap:(){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuestNotRegistered(),
                        ));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left:10,right:10,top:15,bottom:15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:10,right:10),
                            child:Icon(
                              Icons.people,
                            )
                          ),
                          Container(
                            child:Text('Belum Memiliki Akun',
                                style:TextStyle(
                                  fontWeight: FontWeight.w500
                                )
                            )
                          )
                        ],
                      )
                        
                    ) 
                  ),
                  InkWell(
                    onTap:(){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmEventGuest(
                            id:widget.id,
                            creatorId:widget.creatorId,
                            dataUser:widget.dataUser
                            ),
                        ));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left:10,right:10,top:15,bottom:15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:10,right:10),
                            child:Icon(
                              Icons.people
                            )
                          ),
                          Container(
                            child:Text('Sudah Memiliki Akun',
                                style:TextStyle(
                                  fontWeight: FontWeight.w500
                                )
                            )
                          )
                        ],
                      )
                        
                    ) 
                  ),
                ]
              )
            );
        }, 
      );
  }
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Metode Pendaftaran",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: primaryAppBarColor,
      ),
      body:SingleChildScrollView(
        child:Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:50.0,bottom:20.0),
                  child:Center(
                    child: Image.asset("images/clipboard.png",height:150.0,width:150.0)
                  )
                ),
                Container(
                  margin: EdgeInsets.only(bottom:30.0),
                  padding: EdgeInsets.all(5.0),
                  child:Text("Anda Bisa mendaftar event untuk anda sendiri atau apabila anda ingin mendaftarkan orang lain juga bisa mendaftarkan",
                    textAlign: TextAlign.center,
                    style:TextStyle(
                      height: 1.7,
                      fontSize: 20
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  width:double.infinity,
                  child:Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child:RaisedButton(
                              color:Colors.green,
                              child:Text("Daftar Untuk Sendiri",style:TextStyle(
                                color:Colors.white
                              )),
                              onPressed: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmEvent(
                                      id:widget.id,
                                      creatorId:widget.creatorId,
                                      dataUser:widget.dataUser
                                      ),
                                  ));
                              }
                            )
                      ),
                      Container(
                        width: double.infinity,
                        child:RaisedButton(
                              color:Colors.white,
                              child:Text("Daftarkan Orang Lain",style:TextStyle(
                                color:Colors.black
                              )),
                              onPressed: (){
                             showSheet();
                              }
                            )
                      )
                    ],
                  )
                )
              ],
            )
          ],
        )
      )
    );
  }
}