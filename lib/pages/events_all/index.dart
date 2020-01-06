import 'package:checkin_app/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'detail_event.dart';
import 'package:checkin_app/model/search_event.dart';
import '../register_event/step_register_three.dart';
import '../register_event/step_register_six.dart';
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
  bool _isLoadingPagination = false;
  ScrollController pageScroll = new ScrollController();
  int manyPage;
  TextEditingController _searchQuery = new TextEditingController();

  @override
  void initState() {
    _getAll();
    _scaffoldKeyEventAll = GlobalKey<ScaffoldState>();
    super.initState();
    _searchQuery.addListener(_search);
    pageScroll.addListener((){
       if(pageScroll.position.pixels == pageScroll.position.maxScrollExtent){
         _getPage();
       }
    });
  }

  @override
  void dispose() {
    pageScroll.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  Future<List<SearchEvent>> _search() async {
       
       setState((){
         _isLoading = true;
         page = manyPage;
       });

       Map<String, String> head = {'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MWEwNGQzM2NmNzBlNWZjMDk0MGYwMTA5NTQ4ZDFlZjc1NTdjYTNkZjc2ZGE2NTk0ZDg0OTM0ZWIxZWZmOTVmODMwNDUzYWNjMDBiOWQ2In0.eyJhdWQiOiIxIiwianRpIjoiYTQxYTA0ZDMzY2Y3MGU1ZmMwOTQwZjAxMDk1NDhkMWVmNzU1N2NhM2RmNzZkYTY1OTRkODQ5MzRlYjFlZmY5NWY4MzA0NTNhY2MwMGI5ZDYiLCJpYXQiOjE1Nzc5ODE4NzEsIm5iZiI6MTU3Nzk4MTg3MSwiZXhwIjoxNjA5NjA0MjcxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.T34QK_ocXFDmQCUQhnwMshAvHKqN0a0Jr_13Q8Bv02ez4u19KVH_h6a3Bk90HnpKOJPU3AcOTsanL0H57tGKxV9rFm8nnI1oKm-ZIoASR4MT9XrWd0T2Zj09qBJQY_-pfFRqk1r8G78ic9-_NaMmUhJxua8IdzNs_0DvySm2oIofKEDN4D14IPiSEUwlEBtMHIJXo8eKtiEGMrJbXYD0-P9tJL3vdflZGFTL72OvJdRNjpVgnCQMAuSFVTAtytQDEMnIjH41rNCbw-whyaalQBVIjWIGtwIaAtOX_3b_NcaNF0j8xtRkFMR2bV3p7cLJ77oQmvTVVcguTW15b3TPLje9K0aaYgUVwRpgiGxP3ySwJXfuoarrZ_sFNTMNA0awMlTh5J3iDgfnX33SuLnDOERu3WYd0dpx6fefGbYtbz73J9l7vY2ub5KozWJ3VxpLjIq0UbPor6m_qL7knys-NMDCDfK7uM6ZiI5ioV8W8gN3BPZ2bYYN6rqWtVqKxs5mFQJpRdS11Q-J50Qyf_wTqP3aigUzOGfeqSzmKSmmUfv1CHCQ6rs_RL8UdeHhWmvxDxnMIzdwLqZoBUG5zr1IQn6IXLkp7gwKV4gHRkxOnQuYIJwNPEi1bFm8N9y-e0Kl3ymTBODo-6B9VDGR6WmI0PYlf-yq4eXnghIkEsFnG6w'};
       Map<String, dynamic> body = {'search':_searchQuery.text.toString()};
       var data = await http.post('http://localhost:8000/api/search',headers:head,body:body);

       if(data.statusCode == 200){

        Map rawData = json.decode(data.body);
        
        if(mounted){
            setState((){
            _event.clear();
            for(var x in rawData['data']){
              _event.add(SearchEvent.fromJson(x));
            }

            _isLoading = false;

          });
        } 
      }

      return _event;
  }

  Future<List> _getAll() async {
     Map<String, String> head = {'Content-Type':'application/json','Accept':'application/json','Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MWEwNGQzM2NmNzBlNWZjMDk0MGYwMTA5NTQ4ZDFlZjc1NTdjYTNkZjc2ZGE2NTk0ZDg0OTM0ZWIxZWZmOTVmODMwNDUzYWNjMDBiOWQ2In0.eyJhdWQiOiIxIiwianRpIjoiYTQxYTA0ZDMzY2Y3MGU1ZmMwOTQwZjAxMDk1NDhkMWVmNzU1N2NhM2RmNzZkYTY1OTRkODQ5MzRlYjFlZmY5NWY4MzA0NTNhY2MwMGI5ZDYiLCJpYXQiOjE1Nzc5ODE4NzEsIm5iZiI6MTU3Nzk4MTg3MSwiZXhwIjoxNjA5NjA0MjcxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.T34QK_ocXFDmQCUQhnwMshAvHKqN0a0Jr_13Q8Bv02ez4u19KVH_h6a3Bk90HnpKOJPU3AcOTsanL0H57tGKxV9rFm8nnI1oKm-ZIoASR4MT9XrWd0T2Zj09qBJQY_-pfFRqk1r8G78ic9-_NaMmUhJxua8IdzNs_0DvySm2oIofKEDN4D14IPiSEUwlEBtMHIJXo8eKtiEGMrJbXYD0-P9tJL3vdflZGFTL72OvJdRNjpVgnCQMAuSFVTAtytQDEMnIjH41rNCbw-whyaalQBVIjWIGtwIaAtOX_3b_NcaNF0j8xtRkFMR2bV3p7cLJ77oQmvTVVcguTW15b3TPLje9K0aaYgUVwRpgiGxP3ySwJXfuoarrZ_sFNTMNA0awMlTh5J3iDgfnX33SuLnDOERu3WYd0dpx6fefGbYtbz73J9l7vY2ub5KozWJ3VxpLjIq0UbPor6m_qL7knys-NMDCDfK7uM6ZiI5ioV8W8gN3BPZ2bYYN6rqWtVqKxs5mFQJpRdS11Q-J50Qyf_wTqP3aigUzOGfeqSzmKSmmUfv1CHCQ6rs_RL8UdeHhWmvxDxnMIzdwLqZoBUG5zr1IQn6IXLkp7gwKV4gHRkxOnQuYIJwNPEi1bFm8N9y-e0Kl3ymTBODo-6B9VDGR6WmI0PYlf-yq4eXnghIkEsFnG6w'};
      
     var data = await http.get('http://localhost:8000/api/event/page/$page',headers:head);

      if(data.statusCode == 200){

        Map rawData = json.decode(data.body);

        if(mounted){
            setState((){
            manyPage = rawData['num_page'];
            _event.clear();

            for(var x in rawData['data']){
              _event.add(SearchEvent.fromJson(x));
            }

            _isLoading = false;
          });
        } 
      }

      return _event;
  }

  Future _getPage() async {
      if(page == manyPage){
        return false;
      }

      setState((){
          _isLoadingPagination = true;
          page = page + 1; 
      });

      Map<String, String> head = {'Content-Type':'application/json','Accept':'application/json','Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MWEwNGQzM2NmNzBlNWZjMDk0MGYwMTA5NTQ4ZDFlZjc1NTdjYTNkZjc2ZGE2NTk0ZDg0OTM0ZWIxZWZmOTVmODMwNDUzYWNjMDBiOWQ2In0.eyJhdWQiOiIxIiwianRpIjoiYTQxYTA0ZDMzY2Y3MGU1ZmMwOTQwZjAxMDk1NDhkMWVmNzU1N2NhM2RmNzZkYTY1OTRkODQ5MzRlYjFlZmY5NWY4MzA0NTNhY2MwMGI5ZDYiLCJpYXQiOjE1Nzc5ODE4NzEsIm5iZiI6MTU3Nzk4MTg3MSwiZXhwIjoxNjA5NjA0MjcxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.T34QK_ocXFDmQCUQhnwMshAvHKqN0a0Jr_13Q8Bv02ez4u19KVH_h6a3Bk90HnpKOJPU3AcOTsanL0H57tGKxV9rFm8nnI1oKm-ZIoASR4MT9XrWd0T2Zj09qBJQY_-pfFRqk1r8G78ic9-_NaMmUhJxua8IdzNs_0DvySm2oIofKEDN4D14IPiSEUwlEBtMHIJXo8eKtiEGMrJbXYD0-P9tJL3vdflZGFTL72OvJdRNjpVgnCQMAuSFVTAtytQDEMnIjH41rNCbw-whyaalQBVIjWIGtwIaAtOX_3b_NcaNF0j8xtRkFMR2bV3p7cLJ77oQmvTVVcguTW15b3TPLje9K0aaYgUVwRpgiGxP3ySwJXfuoarrZ_sFNTMNA0awMlTh5J3iDgfnX33SuLnDOERu3WYd0dpx6fefGbYtbz73J9l7vY2ub5KozWJ3VxpLjIq0UbPor6m_qL7knys-NMDCDfK7uM6ZiI5ioV8W8gN3BPZ2bYYN6rqWtVqKxs5mFQJpRdS11Q-J50Qyf_wTqP3aigUzOGfeqSzmKSmmUfv1CHCQ6rs_RL8UdeHhWmvxDxnMIzdwLqZoBUG5zr1IQn6IXLkp7gwKV4gHRkxOnQuYIJwNPEi1bFm8N9y-e0Kl3ymTBODo-6B9VDGR6WmI0PYlf-yq4eXnghIkEsFnG6w'};
      
      var data = await http.get('http://localhost:8000/api/event/page/$page',headers:head);

      if(data.statusCode == 200){

        Map rawData = json.decode(data.body);

        if(mounted){
            setState((){
            for(var x in rawData['data']){
              _event.add(SearchEvent.fromJson(x));
            }
            _isLoadingPagination = false;
            print(page);
          });
        } 
      }

      return _event;
  }

  Future<dynamic> _wish(String wish,int eventId,int index) async {
    int newWish = wish == '1'? 0:1;
    Map<String, String> head = {'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE0MWEwNGQzM2NmNzBlNWZjMDk0MGYwMTA5NTQ4ZDFlZjc1NTdjYTNkZjc2ZGE2NTk0ZDg0OTM0ZWIxZWZmOTVmODMwNDUzYWNjMDBiOWQ2In0.eyJhdWQiOiIxIiwianRpIjoiYTQxYTA0ZDMzY2Y3MGU1ZmMwOTQwZjAxMDk1NDhkMWVmNzU1N2NhM2RmNzZkYTY1OTRkODQ5MzRlYjFlZmY5NWY4MzA0NTNhY2MwMGI5ZDYiLCJpYXQiOjE1Nzc5ODE4NzEsIm5iZiI6MTU3Nzk4MTg3MSwiZXhwIjoxNjA5NjA0MjcxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.T34QK_ocXFDmQCUQhnwMshAvHKqN0a0Jr_13Q8Bv02ez4u19KVH_h6a3Bk90HnpKOJPU3AcOTsanL0H57tGKxV9rFm8nnI1oKm-ZIoASR4MT9XrWd0T2Zj09qBJQY_-pfFRqk1r8G78ic9-_NaMmUhJxua8IdzNs_0DvySm2oIofKEDN4D14IPiSEUwlEBtMHIJXo8eKtiEGMrJbXYD0-P9tJL3vdflZGFTL72OvJdRNjpVgnCQMAuSFVTAtytQDEMnIjH41rNCbw-whyaalQBVIjWIGtwIaAtOX_3b_NcaNF0j8xtRkFMR2bV3p7cLJ77oQmvTVVcguTW15b3TPLje9K0aaYgUVwRpgiGxP3ySwJXfuoarrZ_sFNTMNA0awMlTh5J3iDgfnX33SuLnDOERu3WYd0dpx6fefGbYtbz73J9l7vY2ub5KozWJ3VxpLjIq0UbPor6m_qL7knys-NMDCDfK7uM6ZiI5ioV8W8gN3BPZ2bYYN6rqWtVqKxs5mFQJpRdS11Q-J50Qyf_wTqP3aigUzOGfeqSzmKSmmUfv1CHCQ6rs_RL8UdeHhWmvxDxnMIzdwLqZoBUG5zr1IQn6IXLkp7gwKV4gHRkxOnQuYIJwNPEi1bFm8N9y-e0Kl3ymTBODo-6B9VDGR6WmI0PYlf-yq4eXnghIkEsFnG6w'};
    Map<String, dynamic> body = {'event_id':eventId.toString(),'wish':newWish.toString()};
    var data = await http.post('http://localhost:8000/api/wish',headers:head,body:body);

    if(data.statusCode == 200){
      setState((){
        _event[index].wish = newWish.toString();
      });
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
      _getAll();
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
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   width: double.infinity,
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Text(('Cari Event Berdasarkan Kategori').toUpperCase(),
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.w500,
              //             )),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 10.0, bottom: 0),
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(children: <Widget>[
              //       Container(
              //           margin: EdgeInsets.only(right: 10.0),
              //           child: ButtonTheme(
              //             minWidth: 0.0,
              //             height: 0,
              //             child: RaisedButton(
              //               color: Color.fromRGBO(41, 30, 47, 1),
              //               elevation: 0.0,
              //               highlightColor: Colors.transparent,
              //               highlightElevation: 0.0,
              //               padding: EdgeInsets.only(
              //                   top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
              //               onPressed: () {},
              //               child: Text(
              //                 'Semua',
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(18.0),
              //                   side: BorderSide(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                   )),
              //             ),
              //           )),
              //       Container(
              //           margin: EdgeInsets.only(right: 10.0),
              //           child: ButtonTheme(
              //             minWidth: 0.0,
              //             height: 0,
              //             child: RaisedButton(
              //               color: Colors.transparent,
              //               elevation: 0.0,
              //               highlightColor: Colors.transparent,
              //               highlightElevation: 0.0,
              //               padding: EdgeInsets.only(
              //                   top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
              //               onPressed: () {},
              //               child: Text(
              //                 'Teknologi',
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(18.0),
              //                   side: BorderSide(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                   )),
              //             ),
              //           )),
              //       Container(
              //           margin: EdgeInsets.only(right: 10.0),
              //           child: ButtonTheme(
              //             minWidth: 0.0,
              //             height: 0,
              //             child: RaisedButton(
              //               color: Colors.transparent,
              //               elevation: 0.0,
              //               highlightColor: Colors.transparent,
              //               highlightElevation: 0.0,
              //               padding: EdgeInsets.only(
              //                   top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
              //               onPressed: () {},
              //               child: Text(
              //                 'Kesehatan',
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(18.0),
              //                   side: BorderSide(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                   )),
              //             ),
              //           )),
              //       Container(
              //           margin: EdgeInsets.only(right: 10.0),
              //           child: ButtonTheme(
              //             minWidth: 0.0,
              //             height: 0,
              //             child: RaisedButton(
              //               color: Colors.transparent,
              //               elevation: 0.0,
              //               highlightColor: Colors.transparent,
              //               highlightElevation: 0.0,
              //               padding: EdgeInsets.only(
              //                   top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
              //               onPressed: () {},
              //               child: Text(
              //                 'Financial',
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(18.0),
              //                   side: BorderSide(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                   )),
              //             ),
              //           )),
              //       Container(
              //           margin: EdgeInsets.only(right: 10.0),
              //           child: ButtonTheme(
              //             minWidth: 0.0,
              //             height: 0,
              //             child: RaisedButton(
              //               color: Colors.transparent,
              //               elevation: 0.0,
              //               highlightColor: Colors.transparent,
              //               highlightElevation: 0.0,
              //               padding: EdgeInsets.only(
              //                   top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
              //               onPressed: () {},
              //               child: Text(
              //                 'Keuangan',
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(18.0),
              //                   side: BorderSide(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                   )),
              //             ),
              //           )),
              //       Container(
              //           margin: EdgeInsets.only(right: 10.0),
              //           child: ButtonTheme(
              //             minWidth: 0.0,
              //             height: 0,
              //             child: RaisedButton(
              //               color: Colors.transparent,
              //               elevation: 0.0,
              //               highlightColor: Colors.transparent,
              //               highlightElevation: 0.0,
              //               padding: EdgeInsets.only(
              //                   top: 7.0, left: 15.0, right: 15.0, bottom: 7.0),
              //               onPressed: () {},
              //               child: Text(
              //                 'Pertambangan',
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(18.0),
              //                   side: BorderSide(
              //                     color: Color.fromRGBO(41, 30, 47, 1),
              //                   )),
              //             ),
              //           )),
              //     ]),
              //   ),
              // ),
              Expanded(
                    child:
                      _isLoading ? 
                      Center(
                        child:CircularProgressIndicator()
                      ):
                      ListView.builder(
                      itemCount:_event.length,
                      controller: pageScroll,
                      itemBuilder:(BuildContext context, index){
                      return new InkWell(
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
                                                      _event[index].start+' - '+_event[index].end,
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
                                                          Text(_event[index].title,
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
                                                        _event[index].location,
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
                                      Container(
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
                                                  color: _event[index].color,
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
                                                  _event[index].statusRegistered,
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
                                                        color: _event[index].wish == '1'
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
                                                    _wish(_event[index].wish,_event[index].id,index);
                                                  } 
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                  switch(_event[index].statusRegistered){
                                  case 'sudah terdaftar':
                                       return SuccesRegisteredEvent();
                                       break;
                                  case 'proses':
                                       return WaitingEvent();
                                       break;
                                  default:
                                       return RegisterEvents(id:_event[index].id);
                                       break;
                                }
                                }
                              ));
                        });
                       } 
                    )
                  ),
                  Container(
                    height:_isLoadingPagination ? 50:0,
                    child:Center(
                      child:CircularProgressIndicator()
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
