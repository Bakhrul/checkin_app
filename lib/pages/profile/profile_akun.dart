import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';

class ProfileUser extends StatefulWidget{

  ProfileUser({Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState(){
    return _ProfileUser();
  }
}

class _ProfileUser extends State<ProfileUser> {

  
  String nama;
  String email;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  _getUser() async {
  DataStore user =  new DataStore();
  String namaUser = await user.getDataString('name');
  String emailUser = await user.getDataString('email');

  setState(() {
    nama = namaUser;
    email = emailUser;
  });
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
                      color: Colors.red,
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: [0.3, 0.5, 0.7, 0.9],
                        colors: [
                          Color.fromRGBO(153, 187, 255,1),
                          Color.fromRGBO(77, 136, 255,1),
                          Color.fromRGBO(51, 119, 255,1),
                          Color.fromRGBO(26, 102, 255,1)
                        ],
                      )
                    ),
      child: Scaffold(
           backgroundColor: Colors.transparent,
           appBar: AppBar(
             title:Text(
              "Profile",
                style: TextStyle(fontSize: 16),
              ),
             iconTheme: IconThemeData(
                color: Colors.white,
              ),
             backgroundColor: Color.fromRGBO(41, 30, 47, 0),
             elevation: 0.0
           ),
           body:SingleChildScrollView(
             child:Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                              image: AssetImage(
                                'images/imgavatar.png'
                              )
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
                    Expanded(
                      child: Container(
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
                              child: Text('0812345678',
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
                              margin: EdgeInsets.only(bottom: 20.0),
                              child: Text('Jawa timur',
                              style: TextStyle(
                                  fontSize: 20.0,
                                )
                              )
                            )
                          ],
                        )
                      )
                    )
                ],
              )
             )
           )
          )
    );
  }

}