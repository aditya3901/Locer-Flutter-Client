import 'package:flutter/material.dart';
import 'package:locer/utils/child_model.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/utils/parent_model.dart';
import 'package:locer/widgets/product_item.dart';

const String url =
    "https://locerappdemo.herokuapp.com/api/stores/location/841301";

class ShopScreen extends StatefulWidget {
  static const routeName = "/shop-screen";

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<ParentModel> categoryItems = [];
  Map<String, List<ChildModel>> map = {};

  @override
  void initState() {
    super.initState();
    getShopData();
  }

  void getShopData() async {
    NetworkHelper helper = NetworkHelper(url);
    var stores = await helper.getData();
    if (stores != null) {
      var store = stores[0];
      var products = store["products"];
      for (var product in products) {
        var type = product["type"];
        var title = product["title"];
        var price = product["price"];
        var imgUrl =
            "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg";
        var item = ChildModel(title, price, imgUrl);
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
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final title = arg["title"];
    final storeIndex = arg["index"];

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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      wordSpacing: -1,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Text(
                  "View more >",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
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
          title,
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
