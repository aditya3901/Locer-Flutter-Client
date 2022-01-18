import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SnacksScreen extends StatefulWidget {
  @override
  State<SnacksScreen> createState() => _SnacksScreenState();
}

class _SnacksScreenState extends State<SnacksScreen> {
  final List<String> _subCats = [
    "Biscuits and cookies",
    "Noodle, Pasta and Vermicelli",
    "Breakfast cereals",
    "Snacks and namkeen",
    "Chocolates and candies",
    "Ready to cook and eat",
    "Frozen veggies and snacks",
    "Spread, sauces and ketchup",
    "Indian sweets",
    "Pickles and chutneys",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: _subCats.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Snacks & Branded Food",
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
          bottom: PreferredSize(
            child: TabBar(
              labelColor: (themeProvider.isDarkMode == true)
                  ? Colors.white
                  : Colors.black,
              isScrollable: true,
              tabs: _subCats.map((item) => Tab(child: Text(item))).toList(),
            ),
            preferredSize: const Size.fromHeight(30),
          ),
        ),
        body: Container(),
      ),
    );
  }
}
