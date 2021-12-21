import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget drawerItem(String title, IconData icon) {
      return ListTile(
        onTap: () {
          Navigator.of(context).pop();
        },
        title: Text(
          title,
          style: const TextStyle(
            // fontWeight: FontWeight.bold,
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
            drawerItem("Your Orders", Icons.home),
            drawerItem("Recipes", Icons.favorite),
            drawerItem("Locer Express", Icons.track_changes),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Settings & Privacy",
                // style: TextStyle(fontSize: 16),
              ),
            ),
            drawerItem("Settings", Icons.settings),
            drawerItem("Help Center", Icons.help),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Communication",
                // style: TextStyle(fontSize: 16),
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
