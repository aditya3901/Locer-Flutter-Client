import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locer/screens/navBar_screens/cart_screen.dart';
import 'package:locer/screens/navBar_screens/home_screen.dart';
import 'package:locer/screens/navBar_screens/wishlist_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs-screen";
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    // If app is on foreground
    FirebaseMessaging.onMessage.listen((message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "${message.notification?.title}",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            subtitle: Text(
              "${message.notification?.body}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Later",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
      return;
    });
    // If app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "${message.notification?.title}",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            subtitle: Text(
              "${message.notification?.body}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Later",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
      return;
    });
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      WishlistScreen(),
      CartScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: ("Wishlist"),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        activeColorPrimary: CupertinoColors.systemOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_cart),
        title: ("Cart"),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        activeColorPrimary: CupertinoColors.systemGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      resizeToAvoidBottomInset: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 500),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
