import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget drawerItem(String title, IconData icon) {
      return ListTile(
        onTap: () {
          Navigator.of(context).pop();
        },
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
            drawerItem("Grocery & Pantry", Icons.home),
            drawerItem("Restaurants & Hotels", Icons.hotel),
            drawerItem("Your Orders", Icons.restaurant),
            drawerItem("Locer Express", Icons.track_changes),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Settings & Privacy",
              ),
            ),
            drawerItem("Settings", Icons.settings),
            drawerItem("Help Center", Icons.help),
            ListTile(
              title: const Text(
                "Dark Mode",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.dark_mode),
              trailing: Switch.adaptive(
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
            drawerItem("Rate Us", Icons.star),
            drawerItem("Feedback", Icons.feedback),
            drawerItem("Logout", Icons.logout),
          ],
        ),
      ),
    );
  }
}
