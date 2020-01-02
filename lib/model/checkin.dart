import 'dart:convert';

class Checkin {
  int id;
  String checkin_key;
  String start_time;
  String end_time;
  String checkin_date;

  Checkin({this.id = 0, this.checkin_key, this.start_time,this.end_time, this.checkin_date});

  factory Checkin.fromJson(Map<String, dynamic> map) {
    return Checkin(
        id: map["id"], checkin_key: map["checkin_key"], start_time: map["start_time"],end_time: map["end_time"], checkin_date: map["checkin_date"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "checkin_key": checkin_key, "start_time": start_time,"end_time": end_time, "checkin_date": checkin_date};
  }

  @override
  String toString() {
    return 'Checkin{id: $id, checkin_key: $checkin_key, start_time: $start_time, end_time: $end_time, checkin_date: $checkin_date}';
  }

}

List<Checkin> checkinFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Checkin>.from(data.map((item) => Checkin.fromJson(item)));
}

String checkinToJson(Checkin data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}