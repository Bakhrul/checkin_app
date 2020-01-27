import 'package:flutter/material.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:image_crop/image_crop.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkin_app/dashboard.dart';
import 'package:checkin_app/pages/profile/profile_akun.dart';
import 'package:checkin_app/pages/profile/profile_akun_edit.dart';
import 'package:checkin_app/pages/profile/image_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class StudioCrop extends StatefulWidget{

  final File rawImage;

  StudioCrop({Key key,this.rawImage}) : super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _StudioCrop();
  }
}

class _StudioCrop extends State<StudioCrop> {

  final cropKey = GlobalKey<CropState>();
  var storageApp = new DataStore();
  bool send = false;

  @override
  initState(){
    getHeaderHTTP();
    super.initState();
  }
  

  Widget _buildCropImage() {
  return Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: Crop(
          key: cropKey,
          image: FileImage(widget.rawImage),
          aspectRatio: 4.0 / 4.0,
        ),
    );
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

  cropNow() async {

    setState((){
      send = true;
    });

    final crop = cropKey.currentState;
    String base64Image = '';
    String imageName = '';

    final croppedFile = await ImageCrop.cropImage(
        file: widget.rawImage,
        area: crop.area,
    );

    if(croppedFile != null){
      base64Image = base64Encode(croppedFile.readAsBytesSync());
      imageName = croppedFile.path.split('/').last;
    }
   print(base64Image);
    Map body = {
      "image":base64Image,
      "name_image":imageName,
      };

    try{

    var data = await http.post(
      url('api/userImageUpdate'),headers:requestHeaders,body:body
    );

    print(data.body);

      if(data.statusCode == 200){

        var rawData = json.decode(data.body);
          storageApp.setDataString("image",rawData['data']);

          setState((){
            imageStore = rawData['data'];
            imageProfileEdit = croppedFile;
            imageDashboardProfile = croppedFile;
            imageProfile = croppedFile;
            profileImageData = croppedFile;
            send = false;
          });

          print(rawData['data']);
          
        Fluttertoast.showToast(msg: "success");

        Navigator.pop(context);

      }else{
        setState((){
          send = false;
        });
        Fluttertoast.showToast(msg: "error: gagal update");
      }

    } on TimeoutException catch (_) {
      setState((){
          send = false;
        });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } on SocketException catch(_){
      setState((){
          send = false;
        });
      Fluttertoast.showToast(msg: "No Internet Connection");
    } catch (e) {
      setState((){
          send = false;
        });
      Fluttertoast.showToast(msg: "$e");
    }

  }

  @override
  Widget build(BuildContext context) {
 
    return WillPopScope(
              onWillPop: () async {
                    return send ? false:true;
                },
              child:Scaffold(
                    appBar:AppBar(
                        iconTheme: IconThemeData(
                            color: Colors.white,
                          ),
                        actions:<Widget>[
                          send ?
                          Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 20),
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)
                              )
                            )
                          ):
                          IconButton(
                            icon:Icon(Icons.check),
                            onPressed: (){
                                cropNow();
                            }
                          )
                        ],
                        backgroundColor: Colors.black,
                        elevation: 0.0,
                      ),
                    body: Center(
                      child: _buildCropImage()
                    )
                )
           );
      
  
  }


}