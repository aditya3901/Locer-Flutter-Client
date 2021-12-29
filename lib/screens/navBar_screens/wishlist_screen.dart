import 'package:flutter/material.dart';
import 'package:locer/screens/product_detail_screen.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/child_model.dart';

class WishlistScreen extends StatefulWidget {
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool isLoading = true;
  List<ChildModel> _items = [];

  @override
  void initState() {
    super.initState();
    refreshProducts();
  }

  Future refreshProducts() async {
    setState(() {
      isLoading = true;
    });
    _items = await ProductsDatabase.instance.readAll();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget wishlistItem(ChildModel item) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ProductDetailScreen(item);
          })).then((_) => refreshProducts());
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: Hero(
                  tag: item.id,
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/images/driver.png"),
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.contain,
                    height: 80,
                    width: 80,
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\u20B9${item.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.favorite,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return (_items.isNotEmpty)
        ? (isLoading == true)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14.0,
                      bottom: 20,
                    ),
                    child: Text(
                      "Your Favourites",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return wishlistItem(_items[index]);
                      },
                      itemCount: _items.length,
                    ),
                  ),
                ],
              )
        : const Center(
            child: Text("No product added to wishlist!"),
          );
  }
}
