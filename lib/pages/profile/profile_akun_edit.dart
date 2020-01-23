import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class ProfileUserEdit extends StatefulWidget{

  ProfileUserEdit({Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState(){
    return _ProfileUserEdit();
  }
}

class _ProfileUserEdit extends State<ProfileUserEdit> {

  
  String nama;
  String email;
  String phone;
  String location;
  File profileImage;
  var storageApp = new DataStore();
  TextEditingController _controllerNama = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerLocation = new TextEditingController();

  @override
  void initState() {
    _getUser();

    _controllerNama.addListener(nameEdit);
    _controllerEmail.addListener(emailEdit);
    _controllerPhone.addListener(phoneEdit);
    _controllerLocation.addListener(locationEdit);

    getHeaderHTTP();


    super.initState();
  }

  nameEdit(){
    setState((){
        nama = _controllerNama.text;
    });
  }

  emailEdit(){
    setState((){
        email = _controllerEmail.text;
    });
  }

  phoneEdit(){
    setState((){
        phone = _controllerPhone.text;
    });
  }

  locationEdit(){
    setState((){
        location = _controllerLocation.text;
    });
  }

  Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
  }

  _getUser() async {
  DataStore user =  new DataStore();
  String namaUser = await user.getDataString('name');
  String emailUser = await user.getDataString('email');

  setState(() {
    nama = namaUser;
    email = emailUser;
    phone = '08123456789';
    location = 'Indonesia , Jawa Timur';
     _controllerNama.text = namaUser;
     _controllerEmail.text = emailUser;
     _controllerPhone.text = '08123456789';
     _controllerLocation.text = 'Indonesia , Jawa Timur';
  });

  }

  editData() async {

     String base64image = '';
     String imageName = '';

    if (profileImage != null) {

    base64image = base64Encode(profileImage.readAsBytesSync());
    imageName = profileImage.path.split('/').last;

    }

    Map body = {"image":base64image,"name_image":imageName,"name":nama,"email":email};

    try{

    var data = await http.post(
      url('api/userUpdate'),headers:requestHeaders,body:body,encoding: Encoding.getByName("utf-8")
    );

      if(data.statusCode == 200){

          storageApp.setDataString("name",body['name']);
          storageApp.setDataString("email",body['email']);

          setState((){
            usernameprofile = body['name'];
            emailprofile = body['email'];
          });

        Fluttertoast.showToast(msg: "success");
      }else{
        print(data.body);
        Fluttertoast.showToast(msg: "error: gagal update");
      }

    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } on SocketException catch(_){
      Fluttertoast.showToast(msg: "No Internet Connection");
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }

  }

  Future openGallery() async {
     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     
     setState((){
        profileImage = image;
     });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
           backgroundColor: Colors.white,
           appBar: AppBar(
             iconTheme: IconThemeData(
                color: Colors.white,
              ),
             backgroundColor: Color.fromRGBO(41, 30, 47, 1),
             elevation: 0.0,
           ),
           body:SingleChildScrollView(
             child:Stack(
               children: <Widget>[
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Color.fromRGBO(41, 30, 47, 1),
                  ),
                  Container(
                      child: Column(
                      children: <Widget>[
                              GestureDetector(
                                onTap: openGallery,
                                child: Container(
                                      margin: EdgeInsets.only(top:20),
                                      height: 90,
                                      width: 90,
                                      decoration : BoxDecoration(
                                        border: Border.all(color:Colors.white,width:2),
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: profileImage == null ? AssetImage(
                                            'images/imgavatar.png'
                                          ): FileImage(profileImage)
                                        )
                                      ),
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
                                    child: Text(location == null ? 'memuat..':location,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      )
                                    ),
                              ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left:50.0,right:50.0,top:20.0,),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text('Nama',
                                      style: TextStyle(
                                        color: Colors.grey
                                      )
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    child:TextField(
                                       controller:_controllerNama,
                                    )
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
                                    child:TextField(
                                       controller:_controllerEmail,
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
                                    child:TextField(
                                       controller:_controllerPhone,
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
                                    margin: EdgeInsets.only(bottom: 30.0),
                                    child:TextField(
                                       controller:_controllerLocation,
                                    )
                                  ),
                                  Center(
                                   child:Container(
                                     width: 200,
                                     margin: EdgeInsets.only(bottom: 50.0),
                                     child: RaisedButton(
                                        onPressed: (){
                                          editData();
                                        },
                                        color: Color.fromRGBO(41, 30, 47, 1),
                                        child: Text("Save",
                                           style:TextStyle(
                                             color: Colors.white
                                           )
                                        )
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