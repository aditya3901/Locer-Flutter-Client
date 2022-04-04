import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/screens/auth_screens/login_screen.dart';
import 'package:locer/screens/auth_screens/signup_screen.dart';
import 'package:locer/screens/splash_screen.dart';
import 'package:locer/screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  // print(message.data.toString());
  // print(message.notification!.title);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(Phoenix(child: MyApp()));
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
            theme: themeProvider.darkTheme ? darkTheme : lightTheme,
            home: SplashScreen(),
            routes: {
              SignUpScreen.routeName: (context) => SignUpScreen(),
              LoginScreen.routeName: (context) => LoginScreen(),
              TabsScreen.routeName: (context) => TabsScreen(),
            },
          );
        });
  }
}
