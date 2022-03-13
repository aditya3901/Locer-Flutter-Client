import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens.dart';

const String _registerUrl =
    "https://locerappdemo.herokuapp.com/api/users/register";

class VerifyEmailScreen extends StatefulWidget {
  final String username, email, password, phone;
  VerifyEmailScreen(this.username, this.email, this.password, this.phone);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool showSpinner = false;
  bool canResentEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResentEmail = false;
      });
      await Future.delayed(const Duration(seconds: 4));
      setState(() {
        canResentEmail = true;
      });
      timer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => checkEmailVerified(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isEmailVerified) {
      timer?.cancel();
      setState(() {
        showSpinner = true;
      });
      try {
        final response = await http.post(
          Uri.parse(_registerUrl),
          body: {
            "name": widget.username,
            "email": widget.email,
            "password": widget.password,
            "mobileNum": widget.phone
          },
        );
        final jsonData = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        String json = jsonEncode(jsonData); // Convert Json to String
        prefs.setString("current_user", json);
        setState(() {
          showSpinner = false;
        });
        Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/auth_bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "A verification mail has been sent to your email: ${widget.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: canResentEmail ? sendVerificationEmail : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                    ),
                    icon: const Icon(Icons.mail, size: 25),
                    label: const Text(
                      "Resent Email",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
