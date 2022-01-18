import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class StaplesScreen extends StatefulWidget {
  @override
  State<StaplesScreen> createState() => _StaplesScreenState();
}

class _StaplesScreenState extends State<StaplesScreen> {
  final List<String> _subCats = [
    "Atta, Flours and Sooji",
    "Dal and Pulses",
    "Rice and Rice Products",
    "Edible oils",
    "Masala and Spices",
    "Salt, Sugar and Jaggery",
    "Soya Products, Wheat and others",
    "Dry fruits and nuts",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: _subCats.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Staples",
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
