import 'dart:convert';

class Checkin {
  String id;
  String eventId;
  String checkinKey;
  String startTime;
  String endTime;
  String checkinDate;
  String sessionName;
  String titleEvent;
  String locationEvent;
  String eventName;

  Checkin({this.id,this.eventId ,this.titleEvent,this.locationEvent, 
  this.checkinKey, this.startTime,this.endTime, this.checkinDate,this.sessionName,
  this.eventName
  });
}
  // factory Checkin.fromJson(Map<String, dynamic> map) {
  //   return Checkin(
  //       id: map["id"], checkin_key: map["checkin_key"], start_time: map["start_time"],end_time: map["end_time"], checkin_date: map["checkin_date"]);
  // }

//   Map<String, dynamic> toJson() {
//     return {"id": id, "checkin_key": checkin_key, "start_time": start_time,"end_time": end_time, "checkin_date": checkin_date};
//   }

//   @override
//   String toString() {
//     return 'Checkin{id: $id, checkin_key: $checkin_key, start_time: $start_time, end_time: $end_time, checkin_date: $checkin_date}';
//   }

// }

// List<Checkin> checkinFromJson(String jsonData) {
//   final data = json.decode(jsonData);
//   return List<Checkin>.from(data.map((item) => Checkin.fromJson(item)));
// }

// String checkinToJson(Checkin data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }