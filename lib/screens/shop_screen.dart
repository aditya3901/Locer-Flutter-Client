import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/screens/product_detail_screen.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/utils/models/parent_model.dart';
import 'package:locer/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ShopScreen extends StatefulWidget {
  String title;
  int index;
  ShopScreen(this.title, this.index);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String storeID = "";
  List<ParentModel> categoryItems = [];
  Map<String, List<ChildModel>> map = {};
  List<ChildModel> searchItems = [];

  @override
  void initState() {
    super.initState();
    getShopData();
  }

  void getShopData() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString("location_pin") ?? "841301";
    String url = "https://locerappdemo.herokuapp.com/api/stores/location/$pin";
    NetworkHelper helper = NetworkHelper(url);
    var stores = await helper.getData();
    if (stores != null) {
      var store = stores[widget.index];
      storeID = store["_id"];
      var products = store["products"];
      for (var product in products) {
        var type = product["type"];
        var id = product["_id"];
        var title = product["title"];
        var desc = product["description"];
        var price = product["price"];
        var imgUrl =
            "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${product["filename"]}";
        var item = ChildModel(id, title, desc, price, imgUrl, false, storeID);
        searchItems.add(item); // For Searching over all Products
        if (map.containsKey(type)) {
          map[type]?.add(item);
        } else {
          List<ChildModel> temp = [item];
          map[type] = temp;
        }
      }
      for (var key in map.keys) {
        var categoryItem = ParentModel(key, map[key]!);
        setState(() {
          categoryItems.add(categoryItem);
        });
      }
    }
  }

  Widget buildFoodShimmer() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[300]!,
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 222,
              top: 4,
            ),
            height: 34,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[300]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 160,
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    bottom: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget shopItem(String catTitle, List<ChildModel> items) {
      return Column(
        children: [
          // Category Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: 10,
                  ),
                  child: Text(
                    catTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<ThemeProvider>(context).isDarkMode
                          ? Colors.white
                          : Colors.black54,
                    ),
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
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return ProductItem(items[index]);
              },
              itemCount: items.length,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(searchItems),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: (categoryItems.isEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (_, index) {
                  return buildFoodShimmer();
                },
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return shopItem(
                    categoryItems[index].categoryTitle,
                    categoryItems[index].items,
                  );
                },
                itemCount: categoryItems.length,
              ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<ChildModel> searchItems;
  CustomSearchDelegate(this.searchItems);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Widget searchItem(ChildModel item) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ProductDetailScreen(item);
          }));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black12, width: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: FadeInImage(
                      placeholder: const AssetImage("assets/images/driver.png"),
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.contain,
                      height: 80,
                      width: 80,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        "assets/images/driver.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Price: \u20B9",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Provider.of<ThemeProvider>(context)
                                          .isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${item.price}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<ChildModel> matchQuery = [];
    for (var product in searchItems) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return searchItem(matchQuery[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Widget searchItem(ChildModel item) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ProductDetailScreen(item);
          }));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black12, width: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: FadeInImage(
                      placeholder: const AssetImage("assets/images/driver.png"),
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.contain,
                      height: 80,
                      width: 80,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        "assets/images/driver.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Price: \u20B9",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Provider.of<ThemeProvider>(context)
                                          .isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${item.price}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<ChildModel> matchQuery = [];
    for (var product in searchItems) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return searchItem(matchQuery[index]);
      },
    );
  }
}
