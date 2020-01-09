import 'dart:convert';

class Event {
  int id;
  String title;
  String location;
  String dateEvent;
  String subtitle;
  String image;
  String userStatus;

  Event({this.id = 0, this.title, this.dateEvent,this.subtitle, this.location,this.image, this.userStatus});

}