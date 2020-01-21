import 'package:checkin_app/pages/management_checkin/create_checkin.dart';
import 'package:checkin_app/pages/management_checkin/direct_checkin.dart';
import 'package:flutter/material.dart';



var datepicker;
class ChoiceCheckin extends StatefulWidget {
  final idevent;
  ChoiceCheckin({Key key, this.idevent});
  @override
  _ChoiceCheckinState createState() => _ChoiceCheckinState();
}

class _ChoiceCheckinState extends State<ChoiceCheckin>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchNameController = new TextEditingController();
  AnimationController _controller;
  List _types = ["Schedule Checkin", "Direct Checkin"];


  List<DropdownMenuItem<String>> _dropDownTypes;
  String _currentType;
  String tokenType, accessToken;
  Map<String, String> requestHeaders = Map();
  String _currentSearch;

  @override
  void initState() {
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
          "Pilih Checkin",
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
             
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var idEvent = widget.idevent;
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
          _currentType == "Schedule Checkin" ? ManajemeCreateCheckin(idevent: idEvent) : DirectCheckin(idevent: idEvent)
          ) );
        },
        child: Icon(Icons.arrow_forward_ios),
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


  void changedDropDownType(String selectedType) {
    setState(() {
      _currentType = selectedType;

    });
  }
}
