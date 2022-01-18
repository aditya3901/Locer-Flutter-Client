import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BeveragesScreen extends StatefulWidget {
  @override
  State<BeveragesScreen> createState() => _BeveragesScreenState();
}

class _BeveragesScreenState extends State<BeveragesScreen> {
  final List<String> _subCats = [
    "Tea",
    "Coffee",
    "Fruit juices",
    "Energy and soft drinks",
    "Health drinks and supplement",
    "Soda and flavoured water",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: _subCats.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Beverages",
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
