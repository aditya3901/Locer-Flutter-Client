import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/models/parent_model.dart';
import 'package:locer/widgets/product_item.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  CategoryScreen(this.category);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<ParentModel> categoryItems = [
    ParentModel("Jagdamba Kirana Bhandar", [
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
    ]),
    ParentModel("All In One Supermarket", [
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
    ]),
    ParentModel("Shri Tulsi Kirana Store", [
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
      ChildModel(
        "id",
        "Maggie 2 Minute Noodle",
        "description",
        10,
        "",
        false,
        "storeID",
      ),
    ]),
  ];

  List<Tab> tabs = const [
    Tab(child: Text("Toast & Khari")),
    Tab(child: Text("Cakes & Muffins")),
    Tab(child: Text("Breads & Buns")),
    Tab(child: Text("Baked Cookies")),
    Tab(child: Text("Bakery Snacks")),
    Tab(child: Text("Cheese & Ghee")),
    Tab(child: Text("Paneer & Tofu")),
    Tab(child: Text("Ice Cream")),
  ];

  List<Widget> tabContent = [
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category,
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
          bottom: PreferredSize(
            child: TabBar(
              labelColor: (themeProvider.isDarkMode == true)
                  ? Colors.white
                  : Colors.black,
              isScrollable: true,
              tabs: tabs,
            ),
            preferredSize: const Size.fromHeight(30),
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemBuilder: (ctx, index) {
                return shopItem(
                  categoryItems[index].categoryTitle,
                  categoryItems[index].items,
                );
              },
              itemCount: categoryItems.length,
            ),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget shopItem(String catTitle, List<ChildModel> items) {
    return Column(
      children: [
        // Category Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.5,
                  color: Colors.black54,
                ),
              ),
              margin: const EdgeInsets.only(top: 8, left: 8),
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                "assets/images/driver.png",
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Kirana & General Store",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Product Item List
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return ProductItem(items[index]);
            },
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}
