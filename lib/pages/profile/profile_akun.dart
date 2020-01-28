import 'package:flutter/material.dart';
import 'package:checkin_app/pages/profile/profile_akun_edit.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/dashboard.dart';
import 'dart:io';


File imageProfile;

class ProfileUser extends StatefulWidget{

  ProfileUser({Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState(){
    return _ProfileUser();
  }
}

class _ProfileUser extends State<ProfileUser> {

  
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(
                color: Colors.white,
              ),
             backgroundColor: Color.fromRGBO(41, 30, 47, 1),
             elevation: 0.0,
             actions:<Widget>[
               IconButton(
                 icon:Icon(Icons.edit),
                 onPressed:(){
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context)=> ProfileUserEdit())
                   );
                 }
               )
             ]
           ),
           body:SingleChildScrollView(
             child:Stack(
               children: <Widget>[
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Color.fromRGBO(41, 30, 47, 1)
                  ),
                  Container(
                      child: Column(
                      children: <Widget>[
                          imageStore == '-' ?
                          Container(
                                margin: EdgeInsets.only(top:20),
                                height: 90,
                                width: 90,
                                child : ClipOval(
                                  child: Image.asset('images/imgavatar.png',fit:BoxFit.fill)
                                )
                              ):
                          Container(
                                margin: EdgeInsets.only(top:20),
                                height: 90,
                                width: 90,
                                child : ClipOval(
                                  child: imageProfile == null ? 
                                  FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder : 'images/imgavatar.png',
                                    image:url('storage/image/profile/$imageStore')
                                  ):
                                  Image.file(imageProfile)
                                )
                              ),
                              Container(
                                    margin: EdgeInsets.only(bottom: 5.0,top: 10.0),
                                    child: Text(namaStore == null ? 'memuat..':namaStore,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      )
                                    ),
                              ),
                              Container(
                                    margin: EdgeInsets.only(bottom: 50.0),
                                    child: Text(locationStore == null ? 'memuat..':locationStore,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      )
                                    ),
                              ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left:50.0,right:50.0,top:20.0,),
                              color: Colors.white,
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text('Nama',
                                      style: TextStyle(
                                        color: Colors.grey
                                      )
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    child: Text(namaStore == null ? 'memuat..':namaStore,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text('Email',
                                    style: TextStyle(
                                        color: Colors.grey
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    child: Text(emailStore == null ? 'memuat..':emailStore,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                      )
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text('No Telp',
                                    style: TextStyle(
                                        color: Colors.grey
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    child: Text(phoneStore == null ? '-':phoneStore,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                      )
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text('Alamat',
                                    style: TextStyle(
                                        color: Colors.grey
                                      )
                                    ),
                                  ),
                                  Container(
                                    child: Text(locationStore == null ? '-':locationStore,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                      )
                                    )
                                  )
                                ],
                              )
                            )
                      ],
                    )
                  )
               ],
             )
           )
          );
  }

}