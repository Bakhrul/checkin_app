import 'dart:convert';

class UserParticipant {
  String id;
  String name;
  String email;
  int position;
  int eventId;
  String picProfile;

  UserParticipant({this.id, this.name, this.position = 0,this.email, this.eventId = 0,this.picProfile});
}