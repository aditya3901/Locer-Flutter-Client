class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    email = json["email"];
    phone = json["mobileNum"].toString();
    token = json["token"];
  }
}
