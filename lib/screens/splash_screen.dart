import 'dart:async';
import 'package:flutter/material.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    Timer(
      const Duration(milliseconds: 600),
      () async {
        final prefs = await SharedPreferences.getInstance();
        final json = prefs.getString("current_user");
        if (json != null) {
          Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          "assets/images/logo.svg",
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
