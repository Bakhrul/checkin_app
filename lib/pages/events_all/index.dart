import 'package:checkin_app/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'detail_event.dart';
import 'dart:async';
import 'package:checkin_app/storage/storage.dart';
import 'package:checkin_app/model/search_event.dart';
import '../register_event/step_register_three.dart';
import '../register_event/step_register_six.dart';
import 'package:checkin_app/routes/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

GlobalKey<ScaffoldState> _scaffoldKeyEventAll;
void showInSnackBar(String value) {
  _scaffoldKeyEventAll.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

enum PageEnum {
  kelolaRegisterPage,
}

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

class ManajemenEvent extends StatefulWidget {
  ManajemenEvent({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ManajemenEventState();
  }
}

class _ManajemenEventState extends State<ManajemenEvent> {

  List<SearchEvent> _event = [];
  SearchEvent searchEvent = new SearchEvent();
  int page = 1;
  bool _isLoading = true;
  bool _isLoadingCategory = true;
  bool _isLoadingPagination = false;
  ScrollController pageScroll = new ScrollController();
  int manyPage = 0;
  TextEditingController _searchQuery = new TextEditingController();
  String userId;
  List listCategory = [];
  int categoryNow = 0;
  Map dataUser;

  @override
  void initState() {
    _getUserData();
    getHeaderHTTP();
    _getCategory();
    _getAll(0,_searchQuery.text);
    _scaffoldKeyEventAll = GlobalKey<ScaffoldState>();
    super.initState();
    _searchQuery.addListener((){
      setState((){
        page = 1;
        _isLoading = true;
      });
      _getAll(categoryNow,_searchQuery.text);
    });
    pageScroll.addListener((){
       if(pageScroll.position.pixels == pageScroll.position.maxScrollExtent){
         _getPage(categoryNow,_searchQuery.text);
       }
    });
  }

  @override
  void dispose() {
    pageScroll.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

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

  _getUserData() async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    final ongoingevent = await http.get(
        url('api/user'),
        headers: requestHeaders
      );
      print(ongoingevent.body);
      if (ongoingevent.statusCode == 200) {

        Map rawData = json.decode(ongoingevent.body);
         
        if(mounted){
          setState((){
            dataUser = rawData;
          });
          print(dataUser);
        } 
      }
  }

  _getAll(int type,String query) async {

    print('_getAll()');

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    Map<String, dynamic> body = {'category_id':type.toString(),'query_search':query.toString()};

    try{
      final ongoingevent = await http.post(
        url('api/event/page/$page'),
        headers: requestHeaders,
        body:body
      );
      print(ongoingevent.body);
      if (ongoingevent.statusCode == 200) {

        Map rawData = json.decode(ongoingevent.body);
         
        if(mounted){
          setState((){
            userId = rawData['user_id'];
            manyPage = rawData['num_page'];
            
            _event.clear();

            for(var x in rawData['data']){
              _event.add(SearchEvent.fromJson(x));
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
      });
      Fluttertoast.showToast(msg: "Timed out, Try again");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('$e');
    }
  }

  Future _getPage(int type, String query) async {

    print('_getPage()');

     await new Future.delayed(new Duration(milliseconds:10));

    if(manyPage != 0){
      if(page == manyPage){
        return false;
      }else{
        setState((){
        page = page + 1;
          _isLoadingPagination = true;
        });
      }
    }
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    Map<String, dynamic> body = {'category_id':type.toString(),'query_search':query.toString()};

    final ongoingevent = await http.post(
        url('api/event/page/$page'),
        headers: requestHeaders,
        body:body
      );

    print(ongoingevent.body);

    if (ongoingevent.statusCode == 200) {

      Map rawData = json.decode(ongoingevent.body);

      if(mounted){
        List<SearchEvent> temp = new List();
        for(var x in rawData['data']){
            temp.add(SearchEvent.fromJson(x));
        }

        _event.addAll(temp);

        setState((){
          print('false');
          _isLoadingPagination = false;
        });
      } 
    }
      return _event;
  }

  _getCategory() async {

    print('_getCategory');

    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
  
    try{

      final ongoingevent = await http.get(
          url('api/listkategorievent'),
          headers: requestHeaders,
      );

  
      if (ongoingevent.statusCode == 200) {
        var dataRaw = json.decode(ongoingevent.body);
        for(var x in dataRaw['kategori']){
            listCategory.add(x);
        }
        setState((){
          _isLoadingCategory = false;
        });
      } else if (ongoingevent.statusCode == 401){
        setState((){
          _isLoadingCategory = false;
        });
      } else {
        setState((){
          _isLoadingCategory = false;
        });
      }
    } on TimeoutException catch(_) {
      Fluttertoast.showToast(msg: "Timed out, Try again");
      setState((){
        _isLoadingCategory = false;
      });
    } catch(e) {
      setState((){
        _isLoadingCategory = false;
      });
      print(e);
    }
   

  }

  Future<dynamic> _wish(String wish,int eventId,int index) async {
    var storage = new DataStore();
    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    int newWish = wish == '1'? 0:1;
    Map<String, dynamic> body = {'event_id':eventId.toString(),'wish':newWish.toString()};

    try{

      final ongoingevent = await http.post(
        url('api/wish'),
        headers: requestHeaders,
        body:body
      );

      if (ongoingevent.statusCode == 200) {

        setState((){
          _event[index].wish = newWish.toString();
        });

      }

    } on TimeoutException catch(_) {
       Fluttertoast.showToast(msg : "Time out , please try again later");
    } catch(e) {
       print(e);
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
        "Semua Event",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
      
      _searchQuery.clear();
      _isLoading = true;
      page = 1;
      _getAll(0,_searchQuery.text);
    });
  }

  Widget appBarTitle = Text(
    "Semua Event",
    style: TextStyle(fontSize: 16),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.kelolaRegisterPage:
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => RegisterEvents()));
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
      appBar: buildBar(context),
      body: _isLoadingCategory ? 
        Center(
          child:CircularProgressIndicator()
        ):
      Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(('Cari Event Berdasarkan Kategori').toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, bottom: 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: categoryNow == 0 ? Color.fromRGBO(41, 30, 47, 1):Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {
                               setState((){
                                  _isLoading = true;
                                  categoryNow = 0;
                                  page = 1;
                                  _getAll(0,_searchQuery.text);
                               });
                            },
                            child: Text(
                              "Semua",
                              style: TextStyle(
                                  color: categoryNow == 0 ? Colors.white:Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                    for(var x in listCategory)
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ButtonTheme(
                          minWidth: 0.0,
                          height: 0,
                          child: RaisedButton(
                            color: categoryNow == x['c_id'] ? Color.fromRGBO(41, 30, 47, 1):Colors.transparent,
                            elevation: 0.0,
                            highlightColor: Colors.transparent,
                            highlightElevation: 0.0,
                            padding: EdgeInsets.only(
                                top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
                            onPressed: () {
                               setState((){
                                 _isLoading = true;
                                 page = 1;
                                 categoryNow = x['c_id'];
                                 _getAll(x['c_id'],_searchQuery.text);
                               });
                            },
                            child: Text(
                              x['c_name'],
                              style: TextStyle(
                                  color: categoryNow == x['c_id'] ? Colors.white:Color.fromRGBO(41, 30, 47, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(41, 30, 47, 1),
                                )),
                          ),
                        )),
                  ]),
                ),
              ),
              Expanded(
                    child:
                      _isLoading ? 
                      Center(
                        child:CircularProgressIndicator()
                      ):
                      ListView(
                      controller: pageScroll,
                      children:<Widget>[
                        for(var x = 0;x < _event.length; ++x)
                       new InkWell(
                        child: Container(
                            margin: EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                            child: Column(
                              children: <Widget>[
                                Card(
                                  elevation: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                  width: 80.0,
                                                  height: 80.0,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(5.0),
                                                            topRight:
                                                                const Radius.circular(
                                                                    5.0),
                                                            bottomLeft:
                                                                const Radius.circular(
                                                                    5.0),
                                                            bottomRight: const Radius
                                                                .circular(5.0)),
                                                    image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                        'images/bg-header.jpg',
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, right: 5.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _event[x].start+' - '+_event[x].end,
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 5.0),
                                                      child:
                                                          Text(_event[x].title,
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                fontSize: 16,
                                                              )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        _event[x].location,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      userId == _event[x].userEvent ? Container(child:Text(''),height:0):
                                      Column(
                                        children:<Widget>[Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Divider()),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0, bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                decoration: new BoxDecoration(
                                                  color: _event[x].color,
                                                  borderRadius: new BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(5.0),
                                                      topRight:
                                                          const Radius.circular(5.0),
                                                      bottomLeft:
                                                          const Radius.circular(5.0),
                                                      bottomRight:
                                                          const Radius.circular(5.0)),
                                                ),
                                                padding: EdgeInsets.all(5.0),
                                                width: 120.0,
                                                child: Text(
                                                  _event[x].statusRegistered,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 0),
                                              child: ButtonTheme(
                                                minWidth: 0, //wraps child's width
                                                height: 0,
                                                child: FlatButton(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.favorite,
                                                        color: _event[x].wish == '1'
                                                            ? Colors.pink
                                                            : Colors.grey,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                  color: Colors.white,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  padding: EdgeInsets.all(5.0),
                                                  onPressed:() async {
                                                    _wish(_event[x].wish,_event[x].id,x);
                                                  } 
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                        ])
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  switch(_event[x].statusRegistered){
                                  case 'Sudah Terdaftar':
                                       return SuccesRegisteredEvent(
                                         id:_event[x].id,
                                         creatorId:_event[x].userEvent,
                                         selfEvent: userId == _event[x].userEvent ? true:false
                                       );
                                       break;
                                  case 'Proses Daftar':
                                       return WaitingEvent(
                                         id:_event[x].id,
                                         creatorId:_event[x].userEvent,
                                         selfEvent: userId == _event[x].userEvent ? true:false,
                                       );
                                       break;
                                  case 'Ditolak':
                                       return RegisterEvents(
                                         id:_event[x].id,
                                         creatorId:_event[x].userEvent,
                                         selfEvent: true,
                                         dataUser:dataUser
                                         );
                                       break;
                                  case 'Ditolak Admin':
                                       return RegisterEvents(
                                         id:_event[x].id,
                                         creatorId:_event[x].userEvent,
                                         dataUser:dataUser,
                                         selfEvent: true
                                         );
                                       break;
                                  case 'Sudah Terdaftar Admin':
                                       return RegisterEvents(
                                         id:_event[x].id,
                                         creatorId:_event[x].userEvent,
                                         dataUser:dataUser,
                                         selfEvent: true
                                         );
                                       break;
                                  default:
                                       return RegisterEvents(
                                         id:_event[x].id,
                                         creatorId:_event[x].userEvent,
                                         dataUser:dataUser,
                                         selfEvent: userId == _event[x].userEvent ? true:false
                                         );
                                       break;
                                }
                                }
                              ));
                          }
                        ),
                        Container(
                          height:_isLoadingPagination ? 50:0,
                          child:Center(
                            child:CircularProgressIndicator()
                          )
                        )
                      ] 
                    )
                  )
            ],
          ),
        ),
      );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: Color.fromRGBO(41, 30, 47, 1),
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
                          EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
                      border: InputBorder.none,
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Cari Berdasarkan Nama, Kategori , Tempat",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
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
