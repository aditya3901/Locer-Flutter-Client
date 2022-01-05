import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:locer/utils/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourOrdersScreen extends StatefulWidget {
  const YourOrdersScreen({Key? key}) : super(key: key);

  @override
  _YourOrdersScreenState createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  Future<User> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("current_user");
    Map<String, dynamic> map = jsonDecode(json!);
    final user = User.fromJson(map);
    return user;
  }

  // Get User's Orders
  void getOrders() async {
    try {
      User user = await getUserData();
      final res = await http.get(
        Uri.parse("https://locerappdemo.herokuapp.com/api/orders/allmy"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${user.token}"
        },
      );
      print(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
