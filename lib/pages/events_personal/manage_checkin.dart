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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyManageCheckin,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Kelola Waktu Checkin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            tooltip: 'Cari Checkin',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            tooltip: 'Tambahkan Checkin',
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManajemeCreateCheckin()));
            },
          ),
        ],
      ),
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
    );
  }
}
