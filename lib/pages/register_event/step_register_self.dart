import 'package:flutter/material.dart';
import 'step_register_three.dart';
import 'package:http/http.dart' as http;

class ConfirmEvent extends StatefulWidget{
  final int id;
  
  ConfirmEvent({Key key,this.id}) : super(key:key);

  State<StatefulWidget> createState(){
    return _ConfirmEvent();
  }
}

class _ConfirmEvent extends State<ConfirmEvent> {

  List<Map> _comboBox = [{"name":"Vip","value":1},{"name":"Regular","value":2},{"name":"Gold","value":3}];
  int _valueCombo = 1;
  bool _check = false;

  @override
  void initState(){
    super.initState();
  }

  Future _registerSelf() async {
    Map<String, String> head = {'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MWEwNGQzM2NmNzBlNWZjMDk0MGYwMTA5NTQ4ZDFlZjc1NTdjYTNkZjc2ZGE2NTk0ZDg0OTM0ZWIxZWZmOTVmODMwNDUzYWNjMDBiOWQ2In0.eyJhdWQiOiIxIiwianRpIjoiYTQxYTA0ZDMzY2Y3MGU1ZmMwOTQwZjAxMDk1NDhkMWVmNzU1N2NhM2RmNzZkYTY1OTRkODQ5MzRlYjFlZmY5NWY4MzA0NTNhY2MwMGI5ZDYiLCJpYXQiOjE1Nzc5ODE4NzEsIm5iZiI6MTU3Nzk4MTg3MSwiZXhwIjoxNjA5NjA0MjcxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.T34QK_ocXFDmQCUQhnwMshAvHKqN0a0Jr_13Q8Bv02ez4u19KVH_h6a3Bk90HnpKOJPU3AcOTsanL0H57tGKxV9rFm8nnI1oKm-ZIoASR4MT9XrWd0T2Zj09qBJQY_-pfFRqk1r8G78ic9-_NaMmUhJxua8IdzNs_0DvySm2oIofKEDN4D14IPiSEUwlEBtMHIJXo8eKtiEGMrJbXYD0-P9tJL3vdflZGFTL72OvJdRNjpVgnCQMAuSFVTAtytQDEMnIjH41rNCbw-whyaalQBVIjWIGtwIaAtOX_3b_NcaNF0j8xtRkFMR2bV3p7cLJ77oQmvTVVcguTW15b3TPLje9K0aaYgUVwRpgiGxP3ySwJXfuoarrZ_sFNTMNA0awMlTh5J3iDgfnX33SuLnDOERu3WYd0dpx6fefGbYtbz73J9l7vY2ub5KozWJ3VxpLjIq0UbPor6m_qL7knys-NMDCDfK7uM6ZiI5ioV8W8gN3BPZ2bYYN6rqWtVqKxs5mFQJpRdS11Q-J50Qyf_wTqP3aigUzOGfeqSzmKSmmUfv1CHCQ6rs_RL8UdeHhWmvxDxnMIzdwLqZoBUG5zr1IQn6IXLkp7gwKV4gHRkxOnQuYIJwNPEi1bFm8N9y-e0Kl3ymTBODo-6B9VDGR6WmI0PYlf-yq4eXnghIkEsFnG6w'};
    Map<String, dynamic> body = {'event_id':widget.id.toString(),'position':'3','status':'P'};

    var data = await http.post('http://localhost:8000/api/event/register',headers:head,body:body);
    print(data);
    if(data.statusCode == 200){
     return Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingEvent(),
                        ));
    }else{
      return print(data.body);
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
                          child:Text("Nama Depan",style:TextStyle(
                            fontSize: 17,
                          ))
                        ),
                        Container(
                          color: Color.fromRGBO(241,241,241,1),
                          margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                          child:TextFormField(
                            enabled: false,
                            initialValue: 'mohammad',
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
                          color: Color.fromRGBO(241,241,241,1),
                          margin: EdgeInsets.only(top:5,bottom:5,left:7,right:15),
                          child:TextFormField(
                            initialValue: "zakaria",
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
                    color: Color.fromRGBO(241,241,241,1),
                    margin: EdgeInsets.only(top:5,bottom:5,left:15,right:15),
                    child:TextFormField(
                      initialValue: 'Kec.driyorejo Kab. Gresik',
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