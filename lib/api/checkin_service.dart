import 'package:http/http.dart' show Client;


class UserCheckinService {
  final String baseUrl = "http://192.168.100.17";
  Client client = Client();

  // Future<List<Checkin>> getCheckin() async {
  //   final response = await client.get("$baseUrl/api/get_checkin.json");
  //   if (response.statusCode == 200) {
  //     return checkinFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<UserCheckin>> getUserCheckin() async {
  //   final response = await client.get("$baseUrl/api/get_user_checkin.json");
  //   if (response.statusCode == 200) {
  //     return userCheckinFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  //   Future<List<UserCheckin>> getMemberEvent() async {
  //   final response = await client.get("$baseUrl/api/get_user_checkin.json");
  //   if (response.statusCode == 200) {
  //     return userCheckinFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  // Future<bool> createCheckin(Checkin data) async {
  //   final response = await client.post(
  //     "$baseUrl/alamraya/lumen_mobile/public/checkin",
  //     headers: {"content-type": "application/json"},
  //     body: checkinToJson(data),
  //   );
  //   if (response.statusCode == 201) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<bool> updateProfile(Profile data) async {
  //   final response = await client.put(
  //     "$baseUrl/api/profile/${data.id}",
  //     headers: {"content-type": "application/json"},
  //     body: profileToJson(data),
  //   );
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<bool> deleteProfile(int id) async {
  //   final response = await client.delete(
  //     "$baseUrl/api/profile/$id",
  //     headers: {"content-type": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}