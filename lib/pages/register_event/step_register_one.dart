import 'package:flutter/material.dart';
import 'step_register_self.dart';
import 'step_register_someone.dart';

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
                  margin: EdgeInsets.only(top:50.0,bottom:20.0),
                  child:Center(
                    child: Image.asset("images/clipboard.png",height:150.0,width:150.0)
                  )
                ),
                Container(
                  margin: EdgeInsets.only(bottom:30.0),
                  padding: EdgeInsets.all(5.0),
                  child:Text("Anda Bisa mendaftar event untuk anda sendiri atau apabila anda ingin mendaftarkan orang lain juga bisa mendaftarkan",
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
                              child:Text("Daftar Untuk Sendiri",style:TextStyle(
                                color:Colors.white
                              )),
                              onPressed: (){
                                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmEvent(),
                        ));
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
                                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmEventGuest(),
                        ));
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