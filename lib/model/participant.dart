import 'dart:convert';

class UserParticipant {
  int id;
  String name;
  String email;
  int position;
  int eventId;
  String picProfile;

  UserParticipant({this.id = 0, this.name, this.position = 0,this.email, this.eventId = 0,this.picProfile});
}