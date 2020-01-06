import 'dart:convert';

class UserCheckin {
  int id;
  String name;
  String email;
  String position;
  int eventId;
  String picProfile;

  UserCheckin({this.id = 0, this.name, this.email ,this.position, this.eventId = 0,this.picProfile});

//   factory UserCheckin.fromJson(Map<String, dynamic> map) {
//     return UserCheckin(
//         id: map["id"], name: map["name"], numberOfRegist: map["numberOfRegist"],checkinTime: map["checkinTime"], eventId: map["eventId"],pic_profile: map["pic_profile"]);
//   }

//   Map<String, dynamic> toJson() {
//     return {"id": id, "name": name, "numberOfRegist": numberOfRegist,"checkinTime": checkinTime, "eventId": eventId, "pic_profile": pic_profile};
//   }

//   @override
//   String toString() {
//     return 'UserCheckin{id: $id, name: $name, numberOfRegist: $numberOfRegist, checkinTime: $checkinTime, eventId: $eventId, pic_profile: $pic_profile}';
//   }

// }

// List<UserCheckin> userCheckinFromJson(String jsonData) {
//   final data = json.decode(jsonData);
//   return List<UserCheckin>.from(data.map((item) => UserCheckin.fromJson(item)));
// }

// String userCheckinToJson(UserCheckin data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }
}