import 'package:flutter/material.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:checkin_app/storage/storage.dart';
import 'step_register_three.dart';

String tokenType,accessToken;


class GuestNotRegistered extends StatefulWidget{

  final String creatorId;
  final int eventId;
  final Map dataUser;

  GuestNotRegistered({Key key,this.eventId,this.creatorId,this.dataUser}) : super(key : key);

  State<StatefulWidget> createState(){
    return _GuestNotRegistered();
  }
}

class _GuestNotRegistered extends State<GuestNotRegistered>{

  bool delay = false;
  int page = 1;
  int manyPage = 0;
  List _users = [];
  bool _isLoading = false;
  bool _isDisconnect = false;
  Map<String, String> requestHeaders = {};

  @override
  initState(){
    headers();
    print("j");
    super.initState();
  }

   headers() async {
      var storage = new DataStore();
      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;

      setState((){
        requestHeaders['Accept'] = 'application/json';
        requestHeaders['Authorization'] = '$tokenType $accessToken';
      });
   }

   invite(String userId) async {

    Fluttertoast.showToast(msg: "Mohon Tunggu Sebentar");

    Map<String, dynamic> body = {
      'to': userId.toString(),
      'event_id':widget.eventId.toString(),
      'creator_id':widget.creatorId
    };
          print(body);

    try {
    
      final invite = await http.post(
          url('api/inviteparticipant'),
          headers: requestHeaders,
          body: body
      );


        if (invite.statusCode == 200) {
          var data = json.decode(invite.body);     
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WaitingEvent(
                  id: widget.eventId, creatorId: widget.creatorId, selfEvent: false, userId: userId.toString(), type: 'someone',dataUser: widget.dataUser,),
            ));
          Fluttertoast.showToast(msg: "Sukses");
        } else {
          print(invite.body);
          Fluttertoast.showToast(msg: "Gagal Mendaftarkan Event");
        }
    
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: "Terjadi Galat, Mohon Coba Lagi");
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "Koneksi Telah Terputus,Periksa Koneksi Anda");
    } catch (e) {
      print('$e');
    }
  }

  _getUser(String query) async {

    setState(() {
      _users.clear();
      _isLoading = true;
      delay = false;
      page = 1;
      _isDisconnect = false;
    });

    Map<String, dynamic> body = {
      'filter': query.toString()
    };


    try {
      final userData = await http.post(url('api/getdataparticipant'),
          headers: requestHeaders, body: body);

      if (userData.statusCode == 200) {
        Map rawData = json.decode(userData.body);
        print(rawData);

        if (mounted) {
          setState(() {

            _users.clear();

            for (var x in rawData['participant']) {
              _users.add(x);
            }

            if(_users.isEmpty){
              Fluttertoast.showToast(msg: "Email Tidak Ditemukan");
          }
            _isLoading = false;
          });
        }
      }  else {
        print('error');
        print(userData.body);
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        _isLoading = false;
        _isDisconnect = true;
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
        _isDisconnect = true;
      });
      Fluttertoast.showToast(msg: "No Internet Connection");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      appBar: new AppBar(
        backgroundColor: primaryAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Tambahkan Peserta Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left:10,right:10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: TextField(
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            onSubmitted:(string) {
                              _getUser(string);
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color.fromRGBO(41, 30, 47, 1),
                              ),
                              hintText: "Cari Berdasarkan Email Pengguna",
                              border: InputBorder.none,
                            )),
                      ),
                _isLoading ? Container(
                  height: 55,
                  padding: EdgeInsets.only(top:10),
                  child:Center(
                    child: CircularProgressIndicator()
                  )
                ):Container(),
              for(var x = 0;x < _users.length;x++)
                  InkWell(
                    child: Container(
                      margin:EdgeInsets.only(left:10,right:10),
                      child: Card(
                        child: ListTile(
                        leading: Container(
                          width: 40.0,
                          height: 40.0,
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder:'images/loading.gif',
                              image:_users[x]['us_image'] == null || _users[x]['us_image'] == '' || _users[x]['us_image'] == 'null' ? url('assets/images/imgavatar.png') : url('storage/image/profile/${_users[x]['us_image']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(_users[x]['us_name'] == null || _users[x]['us_name'] == '' ? 'Unknown Nama':_users[x]['us_name']),
                        subtitle: Text(_users[x]['us_email'] == null || _users[x]['us_email'] == '' ? 'Unknown email':_users[x]['us_email']),
                      )),
                    ),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Info',
                              style:TextStyle(
                                fontSize: 18
                              )
                            ),
                            content:Text('Apakah Anda Yakin Untuk Mengundang Akun Ini Untuk Ikut Serta Ke Dalam Event ?',
                              style:TextStyle(
                                fontSize: 14
                              )
                            ),
                            actions: <Widget>[
                               
                                FlatButton(
                                  onPressed: (){
                                     Navigator.pop(context);
                                  }, 
                                  child: Text('Tidak')
                                  ),
                                   FlatButton(
                                  onPressed: (){
                                    invite(_users[x]['us_code'].toString());
                                    Navigator.pop(context);
                                  }, 
                                  child: Text('Ya')
                                  ),
                            ],
                          );
                        }
                      );
                    }
                  )
                  
          ]
        )
      )
          );

  }
}