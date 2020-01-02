import 'dart:convert';

class UserCheckin {
  int id;
  String name;
  int number_of_regist;
  String checkin_time;
  int event_id;
  String pic_profile;

  UserCheckin({this.id = 0, this.name, this.number_of_regist = 0,this.checkin_time, this.event_id = 0,this.pic_profile});

  factory UserCheckin.fromJson(Map<String, dynamic> map) {
    return UserCheckin(
        id: map["id"], name: map["name"], number_of_regist: map["number_of_regist"],checkin_time: map["checkin_time"], event_id: map["event_id"],pic_profile: map["pic_profile"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "number_of_regist": number_of_regist,"checkin_time": checkin_time, "event_id": event_id, "pic_profile": pic_profile};
  }

  @override
  String toString() {
    return 'UserCheckin{id: $id, name: $name, number_of_regist: $number_of_regist, checkin_time: $checkin_time, event_id: $event_id, pic_profile: $pic_profile}';
  }

}

List<UserCheckin> userCheckinFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<UserCheckin>.from(data.map((item) => UserCheckin.fromJson(item)));
}

String userCheckinToJson(UserCheckin data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}