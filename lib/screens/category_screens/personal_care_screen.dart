import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import '../../utils/models/models.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/widgets/category_shop_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalCareScreen extends StatefulWidget {
  @override
  State<PersonalCareScreen> createState() => _PersonalCareScreenState();
}

class _PersonalCareScreenState extends State<PersonalCareScreen> {
  List<Map<StoreModel, List<ChildModel>>> allProducts = [];
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
  void initState() {
    super.initState();
    getProducts();
  }

  void getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString("location_pin") ?? "841301";
    String url = "https://locerappdemo.herokuapp.com/api/stores/location/$pin";
    NetworkHelper helper = NetworkHelper(url);
    var stores = await helper.getData();
    if (stores != null) {
      for (var subCat in _subCats) {
        Map<StoreModel, List<ChildModel>> filteredStores = {};
        for (var store in stores) {
          var storeItem = StoreModel(
            store["name"],
            store["type"],
            "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${store["filename"]}",
          );
          var storeID = store["_id"];
          var products = store["products"];
          List<ChildModel> storeProducts = [];
          if (products != null && products != []) {
            for (var product in products) {
              if (product["subType"]
                  .toString()
                  .toLowerCase()
                  .contains(subCat.toLowerCase())) {
                var countInStock = product["countInStock"];
                var id = product["_id"];
                var title = product["title"];
                var desc = product["description"] ?? "";
                var price = product["price"];
                int discountedPrice;
                var dp = product["discountedPrice"] ?? product["price"];
                if (dp is int) {
                  discountedPrice = dp;
                } else {
                  double d = dp;
                  discountedPrice = d.toInt();
                }
                var imgUrl =
                    "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${product["filename"]}";
                var item =
                    ChildModel(countInStock, id, title, desc, price, discountedPrice, imgUrl, false, storeID);
                storeProducts.add(item);
              }
            }
            filteredStores[storeItem] = storeProducts;
          }
        }
        setState(() {
          allProducts.add(filteredStores);
        });
      }
    }
  }

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
          bottom: TabBar(
            labelColor: (themeProvider.darkTheme == true)
                ? Colors.white
                : Colors.black,
            isScrollable: true,
            tabs: _subCats.map((item) => Tab(child: Text(item))).toList(),
          ),
        ),
        body: allProducts.isNotEmpty
            ? TabBarView(
                children: allProducts.map((item) {
                  var stores = item.keys.toList();
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      return CategoryShopItem(
                          stores[index], item[stores[index]]!);
                    },
                    itemCount: item.length,
                  );
                }).toList(),
              )
            : const Center(
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            ),
      ),
    );
  }
}
