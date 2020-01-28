import 'package:flutter/material.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/pages/profile/image_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
File imageProfileEdit;

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
  bool load = false;
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

    if(load){
      return false;
    }

    setState((){
      load = true;
    });

    Map body = {
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

          storageApp.setDataString("name",body['name']);
          storageApp.setDataString("email",body['email']);
          storageApp.setDataString("phone",body['phone'] == '' ? '-':body['phone']);
          storageApp.setDataString("location",body['location'] == '' ? '-':body['location']);

          setState((){
            usernameprofile = body['name'];
            emailprofile = body['email'];
            namaStore = namaData;
            emailStore = emailData;
            phoneStore = body['phone'] == '' ? '-':body['phone'];
            locationStore = body['location'] == '' ? '-':body['location'];
            load = false;
          });
          
        Fluttertoast.showToast(msg: "success");

        Navigator.pop(context);

      }else{
        setState((){
        load = false;
        });
        Fluttertoast.showToast(msg: "error: gagal update");
      }

    } on TimeoutException catch (_) {
      setState((){
        load = false;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } on SocketException catch(_){
      setState((){
        load = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    } catch (e) {
      setState((){
        load = false;
      });
      Fluttertoast.showToast(msg: "$e");
    }

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
                                onTap: (){
                                  Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => ImageEdit())
                                  );
                                },
                                child: 
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
                                      child:ClipOval(
                                        child: imageProfileEdit == null ? FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholder : 'images/imgavatar.png',
                                          image:url('storage/image/profile/$imageStore')
                                        ):Image.file(imageProfileEdit)
                                      )
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
                                       enabled: false,
                                       controller:_controllerEmail,
                                       decoration: InputDecoration(
                                         suffixIcon: Icon(Icons.lock,
                                           size: 20.0
                                         )
                                       ),
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
                                       keyboardType: TextInputType.number,
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
                                        color: load ? Colors.brown:Color.fromRGBO(41, 30, 47, 1),
                                        child: Text( load ? "menyimpan...":"Save",
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