import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/models/store_model.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/widgets/category_shop_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaplesScreen extends StatefulWidget {
  @override
  State<StaplesScreen> createState() => _StaplesScreenState();
}

class _StaplesScreenState extends State<StaplesScreen> {
  List<Map<StoreModel, List<ChildModel>>> allProducts = [];
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
                var id = product["_id"];
                var title = product["title"];
                var desc = product["description"];
                var price = product["price"];
                int discountedPrice;
                if(product["discountedPrice"] != null){
                  discountedPrice = product["discountedPrice"];
                }else{
                  discountedPrice = product["price"];
                }
                var imgUrl =
                    "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${product["filename"]}";
                var item =
                    ChildModel(id, title, desc, price, discountedPrice, imgUrl, false, storeID);
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
        body: allProducts.isNotEmpty
            ? TabBarView(
                children: allProducts.map((item) {
                  var stores = item.keys.toList();
                  return ListView.builder(
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
