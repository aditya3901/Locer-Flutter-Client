import 'package:flutter/material.dart';
import 'package:locer/screens/navBar_screens/cart_screen.dart';
import 'package:locer/screens/navBar_screens/home_screen.dart';
import 'package:locer/screens/navBar_screens/wishlist_screen.dart';
import 'package:locer/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs-screen";
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
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

  bool dark_mode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/driver.png",
          height: 45,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                dark_mode = !dark_mode;
              });
            },
            icon: (dark_mode == true)
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
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
