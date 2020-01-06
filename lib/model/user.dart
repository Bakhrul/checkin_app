class DataUsers {
  List<User> users;

  DataUsers({this.users});

  DataUsers.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<User>();
      json['users'].forEach((value) {
        users.add(new User.fromJson(value));
      });
    }
  }
}

class User {
  String id;
  String name;
  String email;
  String password;

  User({this.id, this.name, this.email,this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }
}

List<User> getUserSuggestions(String query, List<User> users) {
  List<User> matchedUsers = new List();

  matchedUsers.addAll(users);
  matchedUsers.retainWhere((user) => user.name.toLowerCase().contains(query.toLowerCase()));

  if (query == '') {
    return users;
  } else {
    return matchedUsers;
  }
}