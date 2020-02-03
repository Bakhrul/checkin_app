import 'package:flutter/material.dart';
import 'package:checkin_app/utils/utils.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:checkin_app/storage/storage.dart';

String tokenType,accessToken;


class GuestNotRegistered extends StatefulWidget{

  GuestNotRegistered({Key key}) : super(key : key);

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

  _getUser(String query) async {
    print('_getAll()');

    setState(() {
      _users.clear();
      _isLoading = true;
      delay = false;
      page = 1;
      _isDisconnect = false;
    });

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');
    Map<String, String> requestHeaders =  {};

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    Map<String, dynamic> body = {
      'filter': query.toString()
    };

    try {
      final ongoingevent = await http.post(url('api/getdataparticipant'),
          headers: requestHeaders, body: body);

      if (ongoingevent.statusCode == 200) {
        Map rawData = json.decode(ongoingevent.body);
        print(rawData);

        if (mounted) {
          setState(() {

            _users.clear();

            for (var x in rawData['participant']) {
              _users.add(x);
            }
            _isLoading = false;
          });
        }
      } else if (ongoingevent.statusCode == 401) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
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
          "Tambahkan Admin Event",
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
                        subtitle: Text(_users[x]['us_email'] == null || _users[x]['us_emil'] == '' ? 'Unknown email':_users[x]['us_email']),
                      )),
                    ),
                    onTap: (){
                      print('test');
                    }
                  )
                  
          ]
        )
      )
          );

  }
}