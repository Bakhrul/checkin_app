import 'package:flutter/material.dart';
import 'step_register_three.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class ConfirmEvent extends StatefulWidget{
  final int id;
  final String creatorId;
  final Map dataUser;
  
  ConfirmEvent({Key key,this.id,this.creatorId, this.dataUser}) : super(key:key);

  State<StatefulWidget> createState(){
    return _ConfirmEvent();
  }
}

class _ConfirmEvent extends State<ConfirmEvent> {

  bool _isLoading = false;

  @override
  void initState(){
    print(widget.dataUser);
    super.initState();
  }

  Future _registerSelf() async {

    setState((){
      _isLoading = true;
    });

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    Map<String, dynamic> body = {'event_id':widget.id.toString(),'creator_id':widget.creatorId.toString(),'position':'3','status':'P'};

  try{
    final ongoingevent = await http.post(
        url('api/event/register'),
        headers: requestHeaders,
        body:body
      );
      

     if (ongoingevent.statusCode == 200) {
     setState((){
        _isLoading = false;
     });
     return Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingEvent(
                            id:widget.id,
                            creatorId:widget.creatorId,
                            selfEvent: false
                          ),
                        ));
    }else if(ongoingevent.statusCode == 401){
      Fluttertoast.showToast(msg: 'Gagal mendaftar');
      setState((){
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'Gagal mendaftar');
      setState((){
        _isLoading = false;
      });
    }
  } on TimeoutException catch(_){
     Fluttertoast.showToast(msg: 'Time out, silahkan coba lagi nanti');
      setState((){
        _isLoading = false;
      });
  } catch(e){
    Fluttertoast.showToast(msg: '$e');
      setState((){
        _isLoading = false;
      });
  }
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
          "Form Pendaftaran Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
      body:SingleChildScrollView(
        child: Container(
          margin:EdgeInsets.only(top:20.0,bottom:20.0),
          child:Column(
            children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child:Container(
                    padding:EdgeInsets.only(top:5,bottom:5),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                          child:Text("Nama",style:TextStyle(
                            fontSize: 17,
                          ))
                        ),
                        Container(
                          color: Color.fromRGBO(241,241,241,1),
                          margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                          child:TextFormField(
                            enabled: false,
                            initialValue: widget.dataUser['us_name'],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                              border: OutlineInputBorder(),
                              hintText: 'nama',
                            ),
                          )
                        )
                      ],
                    )
                  )
                ),
                // Expanded(
                //   child:Container(
                //     padding:EdgeInsets.only(top:5,bottom:5),
                //     child:Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Container(
                //           margin: EdgeInsets.only(top:5,bottom:5,left:15,right:7),
                //           child:Text("Nama Belakang",style:TextStyle(
                //             fontSize: 17,
                //           ))
                //         ),
                //         Container(
                //           color: Color.fromRGBO(241,241,241,1),
                //           margin: EdgeInsets.only(top:5,bottom:5,left:7,right:15),
                //           child:TextFormField(
                //             initialValue: "zakaria",
                //             enabled: false,
                //             decoration: InputDecoration(
                //               contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                //               border: OutlineInputBorder(),
                //               hintText: 'Password',
                //             ),
                //           )
                //         )
                //       ],
                //     )
                //   )
                // )
              ],
            ),
            Container(
              padding:EdgeInsets.only(top:5,bottom:5),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:Text("Email",style:TextStyle(
                      fontSize: 17,
                    ))
                  ),
                  Container(
                    color: Color.fromRGBO(241,241,241,1),
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:TextFormField(
                      initialValue: widget.dataUser['us_email'],
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                      ),
                    )
                  )
                ],
              )
            ),
            Container(
              padding:EdgeInsets.only(top:5,bottom:5),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:Text("Alamat",style:TextStyle(
                      fontSize: 17,
                    ))
                  ),
                  Container(
                    color: Color.fromRGBO(241,241,241,1),
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:TextFormField(
                      initialValue: 'Kec.driyorejo Kab. Gresik',
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                        border: OutlineInputBorder(),
                        hintText: 'Alamat',
                      ),
                    )
                  )
                ],
              )
            ),
            Container(
              padding:EdgeInsets.only(top:5,bottom:5),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:Text("No Telp",style:TextStyle(
                      fontSize: 17,
                    ))
                  ),
                  Container(
                    color: Color.fromRGBO(241,241,241,1),
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:TextFormField(
                      initialValue: '0823456789',
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                    )
                  )
                ],
              )
            ),
            Container(
              padding:EdgeInsets.only(top:5,bottom:5),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                  //   child:Text("Kategory",style:TextStyle(
                  //     fontSize: 17,
                  //   ))
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                  //   padding: EdgeInsets.only(left:10,right:10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border.all(color:Color.fromRGBO(195,195,195,1),width:1),
                  //     borderRadius:BorderRadius.circular(5.0)
                  //   ),
                  //   child:DropdownButtonHideUnderline(
                  //     child:DropdownButton(
                  //       value:_valueCombo,
                  //       isExpanded: true,
                  //       items:_comboBox.map((val){
                  //         return new DropdownMenuItem(
                  //           value: val['value'],
                  //           child: new Text(val['name'])
                  //         );
                  //       }).toList(),
                  //       onChanged:(value){
                  //           setState((){
                  //             _valueCombo = value;
                  //           });
                  //       }
                  //     )
                  //   )
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                  //   child:InkWell(
                  //     onTap: () {
                  //       setState((){
                  //         _check = !_check;
                  //       });
                  //     },
                  //     child: Row(
                  //         children: <Widget>[
                  //           Checkbox(
                  //             value: _check,
                  //             onChanged: (bool value) {
                  //               setState((){
                  //                 _check = !_check;
                  //               });
                  //             },
                  //           ),
                  //           Expanded(child: Text("Saya Menyetujui ketentuan & Syarat yang berlaku"))
                  //         ],
                  //       ),
                  //   )
                  // ),
                  Container(
                    margin: EdgeInsets.only(top:20,bottom:20,left:15,right:15),
                    width: double.infinity,
                    child:RaisedButton(
                      color: Colors.black,
                      padding: EdgeInsets.all(15.0),
                      child:Text(_isLoading ? 'Mengirim Data....':'Selanjutnya',style:TextStyle(
                        color:Colors.white
                      )),
                      onPressed:(){
                        _registerSelf();
                      }
                    )
                  )
                ],
              )
            )
          ],
          )
        )
      )
    );
  }
}