import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/pages/events_all/index.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class WaitingEvent extends StatefulWidget {
  
   WaitingEvent({Key key, this.id, this.creatorId, this.selfEvent}) : super(key:key);
  final int id;
  final String creatorId;
  final bool selfEvent;
   State<StatefulWidget> createState(){
     return _WaitingEvent();
   }
}

class _WaitingEvent extends State<WaitingEvent> {

  bool _isLoading = false;

  Future _cancelRegisterEvent() async {
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

    Map body = {'event_id':widget.id.toString()};

    try{
      final ongoingevent = await http.post(
        url('api/event/cancelregisterevent'),
        headers: requestHeaders,
        body:body
      );

      if(ongoingevent.statusCode == 200){
        Fluttertoast.showToast(msg:"Anda Membatalkan Pendaftaran Anda");
        await new Future.delayed(new Duration(seconds:1));
        
        return Navigator.pop(context);
      } else if (ongoingevent.statusCode == 401){
        Fluttertoast.showToast(msg:"Gagal Membatalkan Event");
        setState((){
          _isLoading = false;
        });
      }

    } on TimeoutException catch(_) {
        Fluttertoast.showToast(msg:"Time out, silahkan coba lagi nanti");
        setState((){
          _isLoading = false;
        });
    } catch(e) {
        Fluttertoast.showToast(msg:"$e");
        setState((){
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            centerTitle:true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: new Text(
              "Menunggu Verifikasi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Color.fromRGBO(41, 30, 47, 1),
          ),
          body:SingleChildScrollView(
            child:Stack(
              children: <Widget>[
                // Positioned.fill(  //
                //     child: Image(
                //       image: AssetImage('images/party.jpg'),
                //       fit : BoxFit.,
                //   )
                // ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:50.0,bottom:50.0),
                      child:Center(
                        child: Image.asset("images/like.png",height:150.0,width:150.0)
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(left:20.0,right:20.0),
                      margin: EdgeInsets.only(bottom:5.0),
                      child:Text("Terima Kasih telah mendaftar event",
                        textAlign: TextAlign.center,
                        style:TextStyle(
                          height: 1.5,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(left:20.0,right:20.0),
                      margin: EdgeInsets.only(bottom:30.0),
                      child:Text("Pendaftaran sebagai peserta event yang anda kirimkan telah kami terima, tunggu konfirmasi dari pembuatan event apakah pendaftaran anda diterima atau ditolak.",
                        textAlign: TextAlign.center,
                        style:TextStyle(
                          height: 1.5,
                          fontSize: 17
                        )
                      )
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.only(bottom: 20.0),
                      width:double.infinity,
                      child:Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child:RaisedButton(
                                  color:Color.fromRGBO(54, 55, 84, 1),
                                  child:Text("Kirim Notifikasi Konfirmasi",style:TextStyle(
                                    color:Colors.white
                                  )),
                                  onPressed: (){
                                    Fluttertoast.showToast(msg:"Berhasil Mengirimkan Notifikasi kepada Pembuat Event");
                                  }
                                )
                          ),
                          Container(
                            width: double.infinity,
                            child:RaisedButton(
                                  color:Colors.white,
                                  child:Text(_isLoading ? "mengirim Data....":"Batalkan",style:TextStyle(
                                    color:Colors.black
                                  )),
                                  onPressed: (){
                                    _cancelRegisterEvent();
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