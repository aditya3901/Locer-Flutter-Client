import 'package:flutter/material.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/utils/models/parent_model.dart';
import 'package:locer/widgets/product_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(
                    catTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      wordSpacing: -1,
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
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: (categoryItems.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
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
