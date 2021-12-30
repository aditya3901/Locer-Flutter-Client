import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme {
  static final lightTheme = ThemeData(
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
  );

  static final darkTheme = ThemeData(
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
  );
}
