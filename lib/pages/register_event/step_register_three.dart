import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';
import '../events_all/index.dart';

class WaitingEvent extends StatefulWidget {
   WaitingEvent({Key key}) : super(key:key);

   State<StatefulWidget> createState(){
     return _WaitingEvent();
   }
}

class _WaitingEvent extends State<WaitingEvent> {

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
                                  child:Text("Batalkan",style:TextStyle(
                                    color:Colors.black
                                  )),
                                  onPressed: (){
                                    Fluttertoast.showToast(msg:"Anda Membatalkan Pendaftaran Anda");
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