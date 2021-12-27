import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/auth_screens/signup_screen.dart';
import 'package:locer/screens/product_detail_screen.dart';
import 'package:locer/screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFFFAFAFA),
          foregroundColor: Colors.black,
        ),
        fontFamily: GoogleFonts.robotoSlab().fontFamily,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.robotoSlab().fontFamily,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: LoginScreen(),
      routes: {
        SignUpScreen.routeName: (context) => SignUpScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        TabsScreen.routeName: (context) => TabsScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
      },
    );
  }
}
