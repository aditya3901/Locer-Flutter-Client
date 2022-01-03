import 'package:flutter/material.dart';
import 'package:locer/screens/navBar_screens/cart_screen.dart';
import 'package:locer/screens/navBar_screens/home_screen.dart';
import 'package:locer/screens/navBar_screens/wishlist_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs-screen";
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String _currentPage = "home";
  int _currentIndex = 0;
  List<String> pageKeys = ["home", "wishlist", "cart"];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "home": GlobalKey<NavigatorState>(),
    "wishlist": GlobalKey<NavigatorState>(),
    "cart": GlobalKey<NavigatorState>(),
  };
  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    }
    else{
      setState(() {
        _currentPage = tabItem;
        _currentIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteCurrentTab) {
          if (_currentPage != "home") {
            _selectTab("home", 1);
            return false;
          }
        }
        return isFirstRouteCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator("home"),
            _buildOffstageNavigator("wishlist"),
            _buildOffstageNavigator("cart"),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _selectTab(pageKeys[index], index);
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
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
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  String tabItem;
  TabNavigator({Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "home") {
      child = HomeScreen();
    } else if (tabItem == "wishlist") {
      child = WishlistScreen();
    } else {
      child = CartScreen();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
