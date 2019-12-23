import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _scaffoldKeylistmulticheckin;
var datepicker;
void showInSnackBar(String value) {
  _scaffoldKeylistmulticheckin.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class ListMultiCheckin extends StatefulWidget {
  ListMultiCheckin({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ListMultiCheckinState();
  }
}

class _ListMultiCheckinState extends State<ListMultiCheckin> {
  @override
  void initState() {
    _scaffoldKeylistmulticheckin = GlobalKey<ScaffoldState>();
    datepicker = FocusNode();
    super.initState();
  }
  void _handleSearchEnd() {
    setState(() {
      // ignore: new_with_non_type
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Daftar Checkin Peserta",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      _searchQuery.clear();
    });
  }

  final TextEditingController _searchQuery = new TextEditingController();

  
  Widget appBarTitle = Text("Daftar Checkin Peserta",style: TextStyle(fontSize: 16),);
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeylistmulticheckin,
      appBar: buildBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'images/imgavatar.png',
                        ),
                      ),
                    )),
                title: Text('Muhammad Bakhrul Bila Sakhil',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('081285270793'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'images/imgavatar.png',
                        ),
                      ),
                    )),
                title: Text('Muhammad Bakhrul Bila Sakhil',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('081285270793'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'images/imgavatar.png',
                        ),
                      ),
                    )),
                title: Text('Muhammad Bakhrul Bila Sakhil',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('081285270793'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Colors.grey,
                        ),
                        child:
                            Icon(Icons.remove, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(255, 0, 0, 1.0),
                        ),
                        child: Icon(Icons.close, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
              Card(
                  child: ListTile(
                leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'images/imgavatar.png',
                        ),
                      ),
                    )),
                title: Text('Muhammad Bakhrul Bila Sakhil',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('081285270793'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Colors.grey,
                        ),
                        child:
                            Icon(Icons.remove, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(255, 0, 0, 1.0),
                        ),
                        child: Icon(Icons.close, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.0),
                        height: 15.0,
                        alignment: Alignment.center,
                        width: 15.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 204, 65, 1.0),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                          color: Color.fromRGBO(0, 204, 65, 1.0),
                        ),
                        child: Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
              Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(217, 217, 217, 1.0), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          10.0) //                 <--- border radius here
                      ),
                  color: Color.fromRGBO(242, 242, 242, 1.0),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom:5.0),
                      child: Text(
                        'Keterangan Tambahan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 15.0,
                                alignment: Alignment.center,
                                width: 15.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(0, 204, 65, 1.0),
                                      width: 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          100.0) //                 <--- border radius here
                                      ),
                                  color: Color.fromRGBO(0, 204, 65, 1.0),
                                ),
                                child: Icon(Icons.check,
                                    size: 10, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('Sudah Checkin'),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 15.0,
                                alignment: Alignment.center,
                                width: 15.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          100.0) //                 <--- border radius here
                                      ),
                                  color: Colors.grey,
                                ),
                                child: Icon(Icons.remove,
                                    size: 10, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('Tidak ada Checkin'),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 15.0,
                                alignment: Alignment.center,
                                width: 15.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          100.0) //                 <--- border radius here
                                      ),
                                  color: Color.fromRGBO(255, 0, 0, 1.0),
                                ),
                                child: Icon(Icons.close,
                                    size: 10, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('Belum Checkin'),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
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
                      hintText: "Cari Berdasarkan Nama Peserta",
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
