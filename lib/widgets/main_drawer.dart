import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/screens/your_orders_screen.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget drawerItem(String title, IconData icon, VoidCallback onTap) {
      return ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        leading: Icon(icon),
      );
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset(
                  "assets/images/driver.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            drawerItem(
              "Grocery & Pantry",
              Icons.home,
              () {
                Navigator.of(context).pop();
              },
            ),
            drawerItem(
              "Restaurants & Hotels",
              Icons.hotel,
              () {
                Navigator.of(context).pop();
              },
            ),
            drawerItem(
              "Your Orders",
              Icons.restaurant,
              () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return YourOrdersScreen();
                }));
              },
            ),
            drawerItem(
              "Locer Express",
              Icons.track_changes,
              () {
                Navigator.of(context).pop();
              },
            ),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Settings & Privacy",
              ),
            ),
            drawerItem(
              "Settings",
              Icons.settings,
              () {
                Navigator.of(context).pop();
              },
            ),
            drawerItem(
              "Help Center",
              Icons.help,
              () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text(
                "Dark Mode",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.dark_mode),
              trailing: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              ),
            ),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Communication",
              ),
            ),
            drawerItem(
              "Rate Us",
              Icons.star,
              () {
                Navigator.of(context).pop();
              },
            ),
            drawerItem(
              "Feedback",
              Icons.feedback,
              () {
                Navigator.of(context).pop();
              },
            ),
            drawerItem(
              "Logout",
              Icons.logout,
              () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                await ProductsDatabase.instance.clearWishlistTable();
                await ProductsDatabase.instance.clearCartTable();
                FirebaseAuth.instance.signOut();
                Phoenix.rebirth(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
