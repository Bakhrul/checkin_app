import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'create.dart';

import 'manage_absenpeserta.dart';
import 'manage_checkin.dart';
import 'list_multicheckin.dart';
import 'point_person.dart';
import 'manage_peserta.dart';

import '../events_all/detail.dart';

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
  @override
  void initState() {
    _scaffoldKeypersonalevent = new GlobalKey<ScaffoldState>();
    super.initState();
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'Jumlah event yang dibuat',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('16 Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                fontSize: 15),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'Jumlah event sudah diselenggarakan',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('16 Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                fontSize: 15),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'Jumlah event yang dibatalkan',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('16 Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                fontSize: 15),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Daftar Event',
                      style: TextStyle(fontSize: 16),
                    ),
                    ButtonTheme(
                      minWidth: 0, //wraps child's width
                      height: 0,
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 16,
                            ),
                            Text('Buat Event',
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                        color: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManajemeCreateEvent(),
                              ));
                        },
                      ),
                    ),
                  ],
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
                  onTap: (){                   
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ManajemenEventDetail()
                    ) 
                    );
                  },
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
                  onTap: (){                   
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ManajemenEventDetail()
                    ) 
                    );
                  },
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
                  onTap: (){                   
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ManajemenEventDetail()
                    ) 
                    );
                  },
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
                  onTap: (){                   
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ManajemenEventDetail()
                    ) 
                    );
                  },
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
                  onTap: (){                   
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ManajemenEventDetail()
                    ) 
                    );
                  },
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
            ],
          ),
        ),
      ),
    );
  }
}
