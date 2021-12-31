import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:locer/screens/auth_screens/signup_screen.dart';
import 'package:locer/utils/models/user_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tabs_screen.dart';
import 'package:http/http.dart' as http;

const String _loginUrl = "https://locerappdemo.herokuapp.com/api/users/login";

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("current_user");
    if (json != null) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showSpinner = false;
  bool _secureText = true;
  final formKey = GlobalKey<FormState>();

  void validate() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _showSpinner = true;
      });
      try {
        final response = await http.post(
          Uri.parse(_loginUrl),
          body: {
            "email": _emailController.text,
            "password": _passwordController.text
          },
        );
        final jsonData = jsonDecode(response.body);
        if (jsonData["message"] == "Incorrect email or password!") {
          setState(() {
            _showSpinner = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Incorrect email or password!"),
              action: SnackBarAction(
                label: "Dismiss",
                onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
              ),
            ),
          );
        } else {
          final prefs = await SharedPreferences.getInstance();
          final currentUser = User(
            id: jsonData["_id"],
            name: jsonData["name"],
            email: jsonData["email"],
            token: jsonData["token"],
          );
          String json = jsonEncode(currentUser);
          prefs.setString("current_user", json);
          setState(() {
            _showSpinner = false;
          });
          Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        }
      } catch (e) {
        setState(() {
          _showSpinner = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/auth_bg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _secureText = !_secureText;
                                });
                              },
                              icon: Icon(
                                (_secureText)
                                    ? Icons.security
                                    : Icons.remove_red_eye,
                              ),
                            ),
                          ),
                          obscureText: _secureText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password required";
                            } else if (value.length < 6) {
                              return "Password must be of atleast 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          elevation: 6,
                          child: InkWell(
                            onTap: validate,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              width: double.infinity,
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/gmail.png",
                                  height: 25,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Login with Google",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(SignUpScreen.routeName);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                              text: "Don't have an account yet? ",
                              children: [
                                TextSpan(
                                  text: "SignUp",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
