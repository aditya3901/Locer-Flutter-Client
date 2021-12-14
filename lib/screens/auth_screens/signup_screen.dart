import 'package:flutter/material.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/tabs_screen.dart';
import 'package:email_auth/email_auth.dart';

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

  bool _secureText = true;
  final formKey = GlobalKey<FormState>();
  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    emailAuth = EmailAuth(sessionName: "Test Session");
  }

  void validate() {
    if (formKey.currentState!.validate()) {
      verifyOTP();
    }
  }

  void sendOTP() async {
    var res = await emailAuth.sendOtp(recipientMail: _emailController.text);
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("OTP Sent"),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Unable to send OTP"),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
    }
  }

  void verifyOTP() {
    var res = emailAuth.validateOtp(
      recipientMail: _emailController.text,
      userOtp: _otpController.text,
    );
    if (res) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("OTP verification failed"),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
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
                          labelStyle:
                              TextStyle(fontWeight: FontWeight.bold),
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
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          border: const OutlineInputBorder(),
                          suffixIcon: TextButton(
                            onPressed: sendOTP,
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: const Text(
                              "Login",
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
