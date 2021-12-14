import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/auth_screens/signup_screen.dart';
import 'package:locer/screens/product_detail_screen.dart';
import 'package:locer/screens/shop_screen.dart';
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
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(elevation: 0),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: LoginScreen(),
      routes: {
        SignUpScreen.routeName: (context) => SignUpScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        TabsScreen.routeName: (context) => TabsScreen(),
        ShopScreen.routeName: (context) => ShopScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
      },
    );
  }
}
