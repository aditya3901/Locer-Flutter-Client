import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/models/store_model.dart';
import 'package:locer/utils/models/user_model.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/widgets/category_row.dart';
import 'package:locer/widgets/main_drawer.dart';
import 'package:locer/widgets/stores_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../product_detail_screen.dart';
import '../shop_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";
  final _pinController = TextEditingController();
  int activeIndex = 0;
  final urlImages = [
    "assets/images/carousel_image1.jpg",
    "assets/images/carousel_image2.png",
    "assets/images/carousel_image3.jpeg",
    "assets/images/carousel_image4.jpeg",
  ];
  List<ChildModel> searchItems = [];
  List<StoreModel> searchShops = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    getSearchItems();
  }

  void getSearchItems() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString("location_pin") ?? "841301";
    String url = "https://locerappdemo.herokuapp.com/api/stores/location/$pin";
    NetworkHelper helper = NetworkHelper(url);
    var stores = await helper.getData();
    if (stores != null) {
      for (var store in stores) {
        // Add Store to Shop List
        var storeItem = StoreModel(
          store["name"],
          store["type"],
          "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${store["filename"]}",
        );
        searchShops.add(storeItem);
        // Add Product to Products List
        var storeID = store["_id"];
        var products = store["products"];
        if (products != null && products != []) {
          for (var product in products) {
            var countInStock = product["countInStock"];
            var id = product["_id"];
            var title = product["title"];
            var desc = product["description"];
            var price = product["price"];
            int mrp;
            if (product["mrp"] != null) {
              mrp = product["mrp"];
            } else {
              mrp = product["price"];
            }
            var imgUrl =
                "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${product["filename"]}";

            // Temporary Description if desc is null
            desc ??= "";

            var item = ChildModel(countInStock, id, title, desc, price, mrp,
                imgUrl, false, storeID);
            searchItems.add(item); // For Searching over all Products
          }
        }
      }
    }
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("current_user");
    if (json != null) {
      Map<String, dynamic> map = jsonDecode(json);
      final user = User.fromJson(map);
      setState(() {
        username = user.name!;
      });
    }
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter Pincode"),
          content: TextField(
            controller: _pinController,
            decoration: const InputDecoration(
              hintText: "841301",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_pinController.text);
                },
                child: const Text("SUBMIT")),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/images/logo.svg",
          height: 30,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final pin = await openDialog();
              if (pin == null || pin.isEmpty) return;
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("location_pin", pin);
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Restart to see updated stores."),
                    action: SnackBarAction(
                      label: "Dismiss",
                      onPressed:
                          ScaffoldMessenger.of(context).hideCurrentSnackBar,
                    ),
                  ),
                );
              });
            },
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomHomeSearchDelegate(searchItems, searchShops),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Welcome User
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              username.isNotEmpty ? "Hi, $username!" : "Hi, Buddy!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          // Categories
          CategoryRow(),
          // Carousel Slider
          const SizedBox(height: 16),
          Column(
            children: [
              CarouselSlider.builder(
                itemCount: urlImages.length,
                itemBuilder: (ctx, index, realIndex) {
                  final image = urlImages[index];
                  return buildImage(image, index);
                },
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 26),
              buildIndicator(),
            ],
          ),
          // Stores List
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 8,
            ),
            child: Text(
              "Your Stores",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          StoresList(),
        ],
      ),
    );
  }

  Widget buildImage(String image, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        image,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: urlImages.length,
        effect: const SwapEffect(
          dotHeight: 12.0,
          dotWidth: 12.0,
          activeDotColor: Colors.green,
          dotColor: Colors.black12,
        ),
      );
}

class CustomHomeSearchDelegate extends SearchDelegate {
  List<ChildModel> searchItems;
  List<StoreModel> searchShops;
  CustomHomeSearchDelegate(this.searchItems, this.searchShops);

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
    Widget productItem(ChildModel item) {
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
                                  Provider.of<ThemeProvider>(context).darkTheme
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
                                          .darkTheme
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

    Widget storeItem(StoreModel store, int index) {
      return ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ShopScreen(store.title, index);
          }));
        },
        leading: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            child: FadeInImage(
              fit: BoxFit.cover,
              width: 58,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/driver.png",
                width: 58,
                fit: BoxFit.cover,
              ),
              placeholder: const AssetImage("assets/images/driver.png"),
              image: NetworkImage(store.imageUrl),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          store.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(store.description),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
        ),
      );
    }

    List<ChildModel> matchProductQuery = [];
    List<StoreModel> matchShopQuery = [];
    for (var shop in searchShops) {
      if (shop.title.toLowerCase().contains(query.toLowerCase())) {
        matchShopQuery.add(shop);
      }
    }
    for (var product in searchItems) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        matchProductQuery.add(product);
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: matchShopQuery.length,
            itemBuilder: (context, index) {
              int shopIndex = 0;
              for (var i = 0; i < searchShops.length; i++) {
                if (searchShops[i] == matchShopQuery[index]) {
                  shopIndex = i;
                }
              }
              return storeItem(matchShopQuery[index], shopIndex);
            },
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: matchProductQuery.length,
            itemBuilder: (context, index) {
              return productItem(matchProductQuery[index]);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Widget productItem(ChildModel item) {
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
                                  Provider.of<ThemeProvider>(context).darkTheme
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
                                          .darkTheme
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

    Widget storeItem(StoreModel store, int index) {
      return ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ShopScreen(store.title, index);
          }));
        },
        leading: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            child: FadeInImage(
              fit: BoxFit.cover,
              width: 58,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/driver.png",
                width: 58,
                fit: BoxFit.cover,
              ),
              image: NetworkImage(store.imageUrl),
              placeholder: const AssetImage("assets/images/driver.png"),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          store.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(store.description),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
        ),
      );
    }

    List<ChildModel> matchProductQuery = [];
    List<StoreModel> matchShopQuery = [];
    for (var shop in searchShops) {
      if (shop.title.toLowerCase().contains(query.toLowerCase())) {
        matchShopQuery.add(shop);
      }
    }
    for (var product in searchItems) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        matchProductQuery.add(product);
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: matchShopQuery.length,
            itemBuilder: (context, index) {
              int shopIndex = 0;
              for (var i = 0; i < searchShops.length; i++) {
                if (searchShops[i] == matchShopQuery[index]) {
                  shopIndex = i;
                }
              }
              return storeItem(matchShopQuery[index], shopIndex);
            },
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: matchProductQuery.length,
            itemBuilder: (context, index) {
              return productItem(matchProductQuery[index]);
            },
          ),
        ],
      ),
    );
  }
}
