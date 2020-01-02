// import 'dart:convert';

// class Event {
//   int id;
//   String name;
//   String venue;
//   String date_start;
//   String status;
//   String promotion;
//   String like;
//   String pic_banner;

//   Event({this.id = 0, this.checkin_key, this.start_time,this.end_time, this.checkin_date});

//   factory Event.fromJson(Map<String, dynamic> map) {
//     return Event(
//         id: map["id"], checkin_key: map["checkin_key"], start_time: map["start_time"],end_time: map["end_time"], checkin_date: map["checkin_date"]);
//   }

//   Map<String, dynamic> toJson() {
//     return {"id": id, "checkin_key": checkin_key, "start_time": start_time,"end_time": end_time, "checkin_date": checkin_date};
//   }

//   @override
//   String toString() {
//     return 'Event{id: $id, checkin_key: $checkin_key, start_time: $start_time, end_time: $end_time, checkin_date: $checkin_date}';
//   }

// }

// List<Event> checkinFromJson(String jsonData) {
//   final data = json.decode(jsonData);
//   return List<Event>.from(data.map((item) => Event.fromJson(item)));
// }

// String checkinToJson(Event data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }