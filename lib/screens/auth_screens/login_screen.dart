import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locer/screens/auth_screens/signup_screen.dart';
import '../tabs_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _secureText = true;
  final formKey = GlobalKey<FormState>();

  void validate() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/auth_bg.jpeg"),
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
                            return "Password must of be atleast 6 characters";
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Don't have an account yet? "),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(SignUpScreen.routeName);
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
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
    );
  }
}
