import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class PersonalCareScreen extends StatefulWidget {
  @override
  State<PersonalCareScreen> createState() => _PersonalCareScreenState();
}

class _PersonalCareScreenState extends State<PersonalCareScreen> {
  final List<String> _subCats = [
    "Hair care",
    "Oral care",
    "Bath and hand wash",
    "Body wash and bathing accessories",
    "Feminine Hygiene",
    "Men's grooming",
    "Deo and Fragrances",
    "Health and wellness",
    "Skin care",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: _subCats.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Personal Care",
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
