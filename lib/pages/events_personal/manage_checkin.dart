import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:checkin_app/pages/events_personal/create_checkin.dart';
import 'edit_checkin.dart';
import 'package:flutter/cupertino.dart';

GlobalKey<ScaffoldState> _scaffoldKeyManageCheckin;
enum PageEnum {
  editCheckinPage,
}

class ManageCheckin extends StatefulWidget {
  ManageCheckin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManageCheckinState();
  }
}

class _ManageCheckinState extends State<ManageCheckin> {
  @override
  void initState() {
    _scaffoldKeyManageCheckin = GlobalKey<ScaffoldState>();
    super.initState();
  }

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.editCheckinPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManajemeEditCheckin()));
        break;
      default:
        break;
    }
  }
  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Kelola Waktu Checkin Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }

  final TextEditingController _searchQuery = new TextEditingController();

  
  Widget appBarTitle = Text("Kelola Waktu Checkin Event",style: TextStyle(fontSize: 16),);
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyManageCheckin,
      appBar: buildBar(context),
      // appBar: AppBar(
      //   backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      //   title: Text(
      //     "Kelola Waktu Checkin",
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 14,
      //     ),
      //   ),
      //   iconTheme: new IconThemeData(color: Colors.white),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(
      //         Icons.search,
      //         color: Colors.white,
      //       ),
      //       tooltip: 'Cari Checkin',
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 15.0,
                      alignment: Alignment.center,
                      width: 15.0,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                  ),
                ),
                trailing: PopupMenuButton<PageEnum>(
                  onSelected: _onSelect,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: PageEnum.editCheckinPage,
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                    ),
                  ],
                ),
                title: Text(
                  '12 September 2019 - KODECHECKIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text('04:00 - 04:30'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 15.0,
                      alignment: Alignment.center,
                      width: 15.0,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                  ),
                ),
                trailing: PopupMenuButton<PageEnum>(
                  onSelected: _onSelect,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: PageEnum.editCheckinPage,
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                    ),
                  ],
                ),
                title: Text(
                  '12 September 2019 - KODECHECKIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text('04:00 - 04:30'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 15.0,
                      alignment: Alignment.center,
                      width: 15.0,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                  ),
                ),
                trailing: PopupMenuButton<PageEnum>(
                  onSelected: _onSelect,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: PageEnum.editCheckinPage,
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                    ),
                  ],
                ),
                title: Text(
                  '12 September 2019 - KODECHECKIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text('04:00 - 04:30'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 15.0,
                      alignment: Alignment.center,
                      width: 15.0,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                  ),
                ),
                trailing: PopupMenuButton<PageEnum>(
                  onSelected: _onSelect,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: PageEnum.editCheckinPage,
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                    ),
                  ],
                ),
                title: Text(
                  '12 September 2019 - KODECHECKIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text('04:00 - 04:30'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 15.0,
                      alignment: Alignment.center,
                      width: 15.0,
                      color: Color.fromRGBO(41, 30, 47, 1),
                    ),
                  ),
                ),
                trailing: PopupMenuButton<PageEnum>(
                  onSelected: _onSelect,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: PageEnum.editCheckinPage,
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                    ),
                  ],
                ),
                title: Text(
                  '12 September 2019 - KODECHECKIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text('04:00 - 04:30'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManajemeCreateCheckin()));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
      ),
    );
  }
  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor:Color.fromRGBO(41, 30, 47, 1),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                // ignore: new_with_non_type
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = TextField(
                  controller: _searchQuery,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: InputBorder.none,
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Cari Kode Checkin Event",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 14,)),
                );
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ],
    );
  }
}
