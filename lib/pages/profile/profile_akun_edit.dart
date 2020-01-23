import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/profile/profile_akun.dart';
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

  
  String namaData;
  String emailData;
  String phoneData;
  String locationData;
  File profileImageData;
  String imageData = image;
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
        namaData = _controllerNama.text;
    });
  }

  emailEdit(){
    setState((){
        emailData = _controllerEmail.text;
    });
  }

  phoneEdit(){
    setState((){
        phoneData = _controllerPhone.text;
    });
  }

  locationEdit(){
    setState((){
        locationData = _controllerLocation.text;
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
  String phoneUser = await user.getDataString('phone');
  String locationUser = await user.getDataString('location');

  setState(() {
    namaData = namaUser;
    emailData = emailUser;
    phoneData = phoneUser;
    locationData = locationUser;
     _controllerNama.text = namaUser;
     _controllerEmail.text = emailUser;
     _controllerPhone.text = phoneUser;
     _controllerLocation.text = locationUser;
  });

  }

  editData() async {

     String base64image = '';
     String imageName = '';

    if (profileImageData != null) {

    base64image = base64Encode(profileImageData.readAsBytesSync());
    imageName = profileImageData.path.split('/').last;

    }

    Map body = {
      "image":base64image,
      "name_image":imageName,
      "name":namaData,
      "email":emailData,
      "phone":phoneData != '-' ? phoneData:'',
      "location": locationData != '-' ? locationData:''
      };

    try{

    var data = await http.post(
      url('api/userUpdate'),headers:requestHeaders,body:body,encoding: Encoding.getByName("utf-8")
    );

      print(data.body);

      if(data.statusCode == 200){

        var rawData = json.decode(data.body);

          storageApp.setDataString("name",body['name']);
          storageApp.setDataString("email",body['email']);
          storageApp.setDataString("image",rawData['data']);
          storageApp.setDataString("phone",body['phone'] == '' ? '-':body['phone']);
          storageApp.setDataString("location",body['location'] == '' ? '-':body['location']);

          setState((){
            usernameprofile = body['name'];
            emailprofile = body['email'];
            nama = namaData;
            email = emailData;
            image = rawData['data'];
            phone = body['phone'] == '' ? '-':body['phone'];
            location = body['location'] == '' ? '-':body['location'];
            imageprofile = rawData['data'];
          });
          
        Fluttertoast.showToast(msg: "success");

        Navigator.pop(context);

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
     var imageGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
     
     setState((){
        imageData = '-';
        profileImageData = imageGallery;
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
                                          image: imageData != '-' ? NetworkImage(url('storage/image/profile/'+image)):profileImageData == null ? AssetImage(
                                            'images/imgavatar.png'
                                          ): FileImage(profileImageData)
                                        )
                                      ),
                                    ),
                              ),
                              Container(
                                    margin: EdgeInsets.only(bottom: 5.0,top: 10.0),
                                    child: Text(namaData == null ? 'memuat..':namaData,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      )
                                    ),
                              ),
                              Container(
                                    margin: EdgeInsets.only(bottom: 50.0),
                                    child: Text(locationData == null ? 'memuat..':locationData,
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