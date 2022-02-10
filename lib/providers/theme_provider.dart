import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  late bool _isDarkMode;

  bool get darkTheme => _isDarkMode;

  ThemeProvider() {
    _isDarkMode = false;
    _loadFromPref();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPref();
    notifyListeners();
  }

  _loadFromPref() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, _isDarkMode);
  }
}

ThemeData lightTheme = ThemeData(
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

ThemeData darkTheme = ThemeData(
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
