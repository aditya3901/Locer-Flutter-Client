import 'package:flutter/material.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/tabs_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signup";
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Create an account. It's free!",
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
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
                            return "Password must of be atleast 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          border: const OutlineInputBorder(),
                          suffixIcon: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Send OTP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Phone Number required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _otpController,
                        decoration: const InputDecoration(
                          labelText: "OTP",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "OTP required";
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
                                "Sign Up",
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
                                "SignUp with Google",
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
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                        child: RichText(
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
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
