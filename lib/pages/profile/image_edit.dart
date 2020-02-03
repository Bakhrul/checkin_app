import 'package:flutter/material.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/pages/profile/studio_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:checkin_app/dashboard.dart';
import 'dart:io';

File profileImageData;

class ImageEdit extends StatefulWidget{

  ImageEdit({Key key}) : super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _ImageEdit();
  }
}

class _ImageEdit extends State<ImageEdit>{

  bool tapOpen = false;
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState(){
    super.initState();
  }



  Future openCamera() async {

    var imageGallery;
    imageGallery = await ImagePicker.pickImage(source: ImageSource.camera);
      
      if(imageGallery != null){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => StudioCrop(rawImage:imageGallery))
          );
      }

  }


  Future openGallery() async {

    var imageGallery;
    imageGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
      
      if(imageGallery != null){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => StudioCrop(rawImage:imageGallery))
          );
      }

  }

  void openEditBox(){

    setState((){
      tapOpen = !tapOpen;
    });

    scaffoldKey.currentState.showBottomSheet((context) => 
      Container(
        color:Colors.white,
        height: 150,
        width: double.infinity,
        child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    InkWell(
                      onTap:openCamera,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(right:10),
                              child: Icon(Icons.camera_alt)
                            ),
                            Container(
                              child: Text('Camera')
                            )
                          ],
                        )
                      )
                    ),
                     InkWell(
                      onTap:openGallery,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(right:10),
                              child: Icon(Icons.image)
                            ),
                            Container(
                              child: Text('Gallery')
                            )
                          ],
                        )
                      )
                    )
                ])
      )
    ).closed.then((value){
        setState((){
          tapOpen = !tapOpen;
        });
      }
    );

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldKey,
      appBar:AppBar(
             iconTheme: IconThemeData(
                color: Colors.white,
              ),
             actions:<Widget>[
               !tapOpen ?
               IconButton(
                 icon:Icon(Icons.edit),
                 onPressed: openEditBox
               ):Container()
             ],
             backgroundColor: Colors.black,
             elevation: 0.0,
           ),
      body:
      Center(
        child:imageStore == '-' ?
        Image.asset('images/imgavatar.png',fit:BoxFit.fill)
        :
         profileImageData == null ? 
         FadeInImage.assetNetwork(
          placeholder:'images/imgavatar.png',
          image: url('storage/image/profile/'+imageStore)
        )
        : 
        Image.file(profileImageData)
      )
    );
  }

}