import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'create.dart';

import 'manage_absenpeserta.dart';
import 'manage_checkin.dart';
import 'list_multicheckin.dart';
import 'point_person.dart';
import 'manage_peserta.dart';

GlobalKey<ScaffoldState> _scaffoldKeypersonalevent;
enum PageEnum {
  kelolaPesertaPage,
  kelolaWaktuCheckinPage,
  kelolaAbsenPesertaPage,
  kelolaCheckinPesertaPage,
  kelolaHasilAKhirPage,
}

void showInSnackBar(String value) {
  _scaffoldKeypersonalevent.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ManajemenEventPersonal extends StatefulWidget {
  ManajemenEventPersonal({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventPersonalState();
  }
}

class _ManajemenEventPersonalState extends State<ManajemenEventPersonal> {
  var height;
  var futureheight;
  var pastheight;

  @override
  void initState() {
    _scaffoldKeypersonalevent = new GlobalKey<ScaffoldState>();
    super.initState();
  }

  void currentEvent() {
    setState(() {
      if (height == 0.0) {
        height = null;
      } else {
        height = 0.0;
      }
    });
  }

  void futureEvent() {
    setState(() {
      if (futureheight == 0.0) {
        futureheight = null;
      } else {
        futureheight = 0.0;
      }
    });
  }

  void pastEvent() {
    setState(() {
      if (pastheight == 0.0) {
        pastheight = null;
      } else {
        pastheight = 0.0;
      }
    });
  }

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.kelolaPesertaPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManagePeserta()));
        break;
      case PageEnum.kelolaWaktuCheckinPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManageCheckin()));
        break;
      case PageEnum.kelolaAbsenPesertaPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ManageAbsenPeserta()));
        break;
      case PageEnum.kelolaCheckinPesertaPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ListMultiCheckin()));
        break;
      case PageEnum.kelolaHasilAKhirPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => PointEvents()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeypersonalevent,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(41, 30, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "Event yang anda buat",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: 'Buat Event Sekarang',
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManajemeCreateEvent(),
              ));
              },
            ),
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              InkWell(
                  onTap: currentEvent,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(('Event Berlangsung  ( 1 Event )').toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          Icon(height == null
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
                        ],
                      ),
                    ),
                  )),
              Container(
                height: height,
                child: Card(
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
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: PageEnum.kelolaPesertaPage,
                          child: Text("Kelola Peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaWaktuCheckinPage,
                          child: Text("Kelola waktu checkin"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaAbsenPesertaPage,
                          child: Text("Kelola absen peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaCheckinPesertaPage,
                          child: Text("Kelola checkin peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaHasilAKhirPage,
                          child: Text("Hasil akhir checkin peserta"),
                        ),
                        PopupMenuItem(
                          child: Text("Hapus Event"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Divider(),
              ),
              InkWell(
                  onTap: futureEvent,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              ('Event Yang Akan Datang ( 2 Event )')
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          Icon(futureheight == null
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
                        ],
                      ),
                    ),
                  )),
              Container(
                height: futureheight,
                child: Card(
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
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: PageEnum.kelolaPesertaPage,
                          child: Text("Kelola Peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaWaktuCheckinPage,
                          child: Text("Kelola waktu checkin"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaAbsenPesertaPage,
                          child: Text("Kelola absen peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaCheckinPesertaPage,
                          child: Text("Kelola checkin peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaHasilAKhirPage,
                          child: Text("Hasil akhir checkin peserta"),
                        ),
                        PopupMenuItem(
                          child: Text("Hapus Event"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: futureheight,
                child: Card(
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
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: PageEnum.kelolaPesertaPage,
                          child: Text("Kelola Peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaWaktuCheckinPage,
                          child: Text("Kelola waktu checkin"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaAbsenPesertaPage,
                          child: Text("Kelola absen peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaCheckinPesertaPage,
                          child: Text("Kelola checkin peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaHasilAKhirPage,
                          child: Text("Hasil akhir checkin peserta"),
                        ),
                        PopupMenuItem(
                          child: Text("Hapus Event"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Divider(),
              ),
              InkWell(
                  onTap: pastEvent,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              ('Event Telah Selesai ( 1 Event )').toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          Icon(pastheight == null
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
                        ],
                      ),
                    ),
                  )),
              Container(
                height: pastheight,
                child: Card(
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
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: PageEnum.kelolaPesertaPage,
                          child: Text("Kelola Peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaWaktuCheckinPage,
                          child: Text("Kelola waktu checkin"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaAbsenPesertaPage,
                          child: Text("Kelola absen peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaCheckinPesertaPage,
                          child: Text("Kelola checkin peserta"),
                        ),
                        PopupMenuItem(
                          value: PageEnum.kelolaHasilAKhirPage,
                          child: Text("Hasil akhir checkin peserta"),
                        ),
                        PopupMenuItem(
                          child: Text("Hapus Event"),
                        ),
                      ],
                    ),
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
