import 'dart:convert';

import 'package:checkin_app/core/api.dart';
import 'package:checkin_app/model/user.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:checkin_app/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dashboard_checkin.dart';


var datepicker;
class CreateParticipant extends StatefulWidget {
  final idevent;
  CreateParticipant({Key key, this.idevent});
  @override
  _CreateParticipantState createState() => _CreateParticipantState();
}

class _CreateParticipantState extends State<CreateParticipant>
    with SingleTickerProviderStateMixin {
  User user = new User();
  TextEditingController _searchNameController = new TextEditingController();
  AnimationController _controller;
  List _types = ["Peserta", "Co-Host","Admin"];


  List<DropdownMenuItem<String>> _dropDownTypes;
  String _currentType;
  String tokenType, accessToken;
  Map<String, String> requestHeaders = Map();
  String _currentSearch;

Future<void> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);
  }

  Future<String> getDataMember() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    // setState(() {
    //   isLoading = true;
    // });
    var resp = await http.get(
        url(
            "api/event/getdata/listusers"),headers: requestHeaders,
        );
        print(resp.body);
    return resp.body;
  }

 postDataParticipant() async {
    dynamic body = {
      "event_id": widget.idevent.toString(),
      "position": _currentType,
      "user_id": _currentSearch,
      "status": "a"
    };
    dynamic response =
        await RequestPost(name: "event/postdata/addparticipant", body: body)
            .sendrequest();
    print(response);

    if (response == "success") {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardCheckin(idevent: widget.idevent)));
    }else if(response == 1000){
      Fluttertoast.showToast(
          msg: "Peserta Telah Terdaftar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  
  @override
  void initState() {
    getHeaderHTTP();
    _dropDownTypes = getDropDownMenuItems();
    _currentType = _dropDownTypes[0].value;
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String _type in _types) {
      items.add(new DropdownMenuItem(value: _type, child: new Text(_type)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Tambah Partisipan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                      leading: Icon(
                        Icons.filter_tilt_shift,
                        color: Color.fromRGBO(41, 30, 47, 1),
                      ),
                      title: _buildSelectType())),
              Card(
                  child: ListTile(
                leading: Icon(
                  Icons.access_time,
                  color: Color.fromRGBO(41, 30, 47, 1),
                ),
                title: FutureBuilder<String>(
                  future: getDataMember(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final dataUsers =
                          DataUsers.fromJson(json.decode(snapshot.data));
                      return _buildSelectName(dataUsers.users);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() => _isLoading = true);
          postDataParticipant();
        },
        child: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }

  Widget _buildSelectType() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: DropdownButton(
        isExpanded: true,
        value: _currentType,
        items: _dropDownTypes,
        onChanged: changedDropDownType,
      ),
    );
  }

  Widget _buildSelectName(List<User> users) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        controller: _searchNameController,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Cari Peserta",
          labelStyle: TextStyle(color: Colors.black38),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
      suggestionsCallback: (String query) {
        return getUserSuggestions(query, users);
      },
      onSuggestionSelected: (User user) {
        setState(() {
          this.user = user;
        });
        _searchNameController.text = user.name;
        _currentSearch = user.id;
      },
      noItemsFoundBuilder: (BuildContext context) {
        return ListTile(
          title: Text('Upss...Maaf Data Tidak Ditemukan.'),
        );
      },
      itemBuilder: (BuildContext context, User user) {
        return ListTile(
          title: Text(user.name),
          subtitle: Text(
            '${user.email}',
            style: TextStyle(
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
    );
  }

  void changedDropDownType(String selectedType) {
    setState(() {
      _currentType = selectedType;
      print(_currentSearch);

    });
  }
}
