class User {
  String? id;
  String? name;
  String? email;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "token": token,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    email = json["email"];
    token = json["token"];
  }
}

