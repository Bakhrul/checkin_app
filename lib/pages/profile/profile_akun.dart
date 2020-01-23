import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/pages/profile/profile_akun_edit.dart';
import 'package:checkin_app/routes/env.dart';

String nama,email,phone,location,image;

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
    _getUser();
    super.initState();
  }

  _getUser() async {
  DataStore user =  new DataStore();
  String namaUser = await user.getDataString('name');
  String emailUser = await user.getDataString('email');
  String phoneUser = await user.getDataString('phone');
  String imageUser = await user.getDataString('image');
  String locationUser = await user.getDataString('location');

  setState((){
    nama = namaUser;
    email = emailUser;
    phone = phoneUser;
    image = imageUser;
    location = locationUser;
  });

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
                          Container(
                                margin: EdgeInsets.only(top:20),
                                height: 90,
                                width: 90,
                                decoration : BoxDecoration(
                                  border: Border.all(color:Colors.white,width:2),
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: image == '-' ? AssetImage(
                                      'images/imgavatar.png'
                                    ): NetworkImage(url('storage/image/profile/'+image))
                                  )
                                ),
                              ),
                              Container(
                                    margin: EdgeInsets.only(bottom: 5.0,top: 10.0),
                                    child: Text(nama == null ? 'memuat..':nama,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      )
                                    ),
                              ),
                              Container(
                                    margin: EdgeInsets.only(bottom: 50.0),
                                    child: Text('Indonesia, Jawa Timur',
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
                                    child: Text(nama == null ? 'memuat..':nama,
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
                                    child: Text(email == null ? 'memuat..':email,
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
                                    child: Text(phone == null ? '-':phone,
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
                                    child: Text(location == null ? '-':location,
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