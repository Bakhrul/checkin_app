import 'package:flutter/material.dart';
import 'step_register_three.dart';

class ConfirmEventGuest extends StatefulWidget{
  ConfirmEventGuest({Key key}) : super(key:key);

  State<StatefulWidget> createState(){
    return _ConfirmEventGuest();
  }
}

class _ConfirmEventGuest extends State<ConfirmEventGuest> {

  List<Map> _comboBox = [{"name":"Vip","value":1},{"name":"Regular","value":2},{"name":"Gold","value":3}];
  int _valueCombo = 1;
  bool _check = false;

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
                          child:Text("Nama Depan",style:TextStyle(
                            fontSize: 17,
                          ))
                        ),
                        Container(
                          margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                          child:TextFormField(
                            enabled:true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                              border: OutlineInputBorder(),
                              hintText: 'nama depan',
                            ),
                          )
                        )
                      ],
                    )
                  )
                ),
                Expanded(
                  child:Container(
                    padding:EdgeInsets.only(top:5,bottom:5),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:5,bottom:5,left:15,right:7),
                          child:Text("Nama Belakang",style:TextStyle(
                            fontSize: 17,
                          ))
                        ),
                        Container(
                          margin: EdgeInsets.only(top:5,bottom:5,left:7,right:15),
                          child:TextFormField(
                            enabled: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                              border: OutlineInputBorder(),
                              hintText: 'nama belakang',
                            ),
                          )
                        )
                      ],
                    )
                  )
                )
              ],
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
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:TextFormField(
                      enabled: true,
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
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:TextFormField(
                      enabled: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                        border: OutlineInputBorder(),
                        hintText: 'No Telepon',
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
                    child:Text("Kategory",style:TextStyle(
                      fontSize: 17,
                    ))
                  ),
                  Container(
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    padding: EdgeInsets.only(left:10,right:10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color:Color.fromRGBO(195,195,195,1),width:1),
                      borderRadius:BorderRadius.circular(5.0)
                    ),
                    child:DropdownButtonHideUnderline(
                      child:DropdownButton(
                        value:_valueCombo,
                        isExpanded: true,
                        items:_comboBox.map((val){
                          return new DropdownMenuItem(
                            value: val['value'],
                            child: new Text(val['name'])
                          );
                        }).toList(),
                        onChanged:(value){
                            setState((){
                              _valueCombo = value;
                            });
                        }
                      )
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:InkWell(
                      onTap: () {
                        setState((){
                          _check = !_check;
                        });
                      },
                      child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _check,
                              onChanged: (bool value) {
                                setState((){
                                  _check = !_check;
                                });
                              },
                            ),
                            Expanded(child: Text("Saya Menyetujui ketentuan & Syarat yang berlaku"))
                          ],
                        ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top:20,bottom:20,left:15,right:15),
                    width: double.infinity,
                    child:RaisedButton(
                      color: Colors.black,
                      padding: EdgeInsets.all(15.0),
                      child:Text('Selanjutnya',style:TextStyle(
                        color:Colors.white
                      )),
                      onPressed:(){
                         Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingEvent(),
                        ));
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