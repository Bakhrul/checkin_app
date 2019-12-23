import 'package:checkin_app/pages/event_following/detail.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'check_in.dart';
import 'package:flutter/cupertino.dart';

GlobalKey<ScaffoldState> _scaffoldKeyEventAll;

void showInSnackBar(String value) {
  _scaffoldKeyEventAll.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

enum PageEnum{
    kelolaCheckinPage,
    kelolaHistoryPage,
  }

class ManajemenEventFollowing extends StatefulWidget {
  ManajemenEventFollowing({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventFollowingState();
  }
}

class _ManajemenEventFollowingState extends State<ManajemenEventFollowing> {
  @override
  void initState() {
    _scaffoldKeyEventAll = GlobalKey<ScaffoldState>();
    super.initState();
  }
  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.kelolaCheckinPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => CheckIn()));
        break;
        case PageEnum.kelolaHistoryPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManajemenEventDetailFollowing()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyEventAll,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "Semua Event Yang Di Ikuti",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              tooltip: 'Notifikasi',
              onPressed: () {},
            ),
          ],
          backgroundColor: Color.fromRGBO(41, 30, 47, 1),),
      body: Padding(
        padding: const EdgeInsets.only(top:10.0,bottom: 10.0,right: 5.0,left: 5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior pertama',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  onTap: (){                   
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ManajemenEventDetailFollowing()
                    ) 
                    );
                  },
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '12/31/2019',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '12/31/2019',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Komunitas Dev Junior',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('12:00 - 13:00'),
                  ),
                  trailing: PopupMenuButton<PageEnum>(
                    onSelected: _onSelect,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PageEnum.kelolaCheckinPage,
                        child: Text("Checkin Sekarang"),
                      ),
                      PopupMenuItem(
                        value: PageEnum.kelolaHistoryPage,
                        child: Text("Lihat Detail"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
