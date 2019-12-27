import 'package:flutter/material.dart';

class RegisterEventMethod extends StatefulWidget{
  RegisterEventMethod({Key key}) : super(key : key);

  State<StatefulWidget> createState(){
    return _RegisterEventMethod();
  }
}

class _RegisterEventMethod extends State<RegisterEventMethod>{
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
          "Metode Pendaftaran",
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
                    child: Image.asset("images/clipboard.png",height:150.0,width:150.0)
                  )
                ),
                Container(
                  margin: EdgeInsets.only(bottom:30.0),
                  child:Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                    textAlign: TextAlign.center,
                    style:TextStyle(
                      height: 1.7,
                      fontSize: 20
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  width:double.infinity,
                  child:Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child:RaisedButton(
                              color:Color.fromRGBO(54, 55, 84, 1),
                              child:Text("Mendaftar",style:TextStyle(
                                color:Colors.white
                              )),
                              onPressed: (){
                                  Navigator.pushNamed(context, '/confirm-event');
                              }
                            )
                      ),
                      Container(
                        width: double.infinity,
                        child:RaisedButton(
                              color:Colors.white,
                              child:Text("Daftarkan Orang Lain",style:TextStyle(
                                color:Colors.black
                              )),
                              onPressed: (){
                                 Navigator.pushNamed(context, '/confirm-event-guest');
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