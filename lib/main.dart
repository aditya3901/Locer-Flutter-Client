import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/auth_screens/signup_screen.dart';
import 'package:locer/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            home: TabsScreen(),
            routes: {
              SignUpScreen.routeName: (context) => SignUpScreen(),
              LoginScreen.routeName: (context) => LoginScreen(),
              TabsScreen.routeName: (context) => TabsScreen(),
            },
          );
        });
  }
}
