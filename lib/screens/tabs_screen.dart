import 'package:flutter/material.dart';
import 'package:locer/screens/navBar_screens/cart_screen.dart';
import 'package:locer/screens/navBar_screens/home_screen.dart';
import 'package:locer/screens/navBar_screens/wishlist_screen.dart';
import 'package:locer/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs-screen";
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final _pinController = TextEditingController();
  final List<Widget> _pages = [
    HomeScreen(),
    WishlistScreen(),
    CartScreen(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> openDialog() => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Enter Pincode"),
            content: TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                hintText: "841301",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_pinController.text);
                  },
                  child: const Text("SUBMIT")),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/driver.png",
          height: 45,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final pin = await openDialog();
              if (pin == null || pin.isEmpty) return;
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("location_pin", pin);
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Restart to see updated stores."),
                    action: SnackBarAction(
                      label: "Dismiss",
                      onPressed:
                          ScaffoldMessenger.of(context).hideCurrentSnackBar,
                    ),
                  ),
                );
              });
            },
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }
}
