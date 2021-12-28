import 'package:flutter/material.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/widgets/product_item.dart';

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
    return (_items.isNotEmpty)
        ? (isLoading == true)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.4,
                  ),
                  itemBuilder: (ctx, index) {
                    return ProductItem(_items[index]);
                  },
                  itemCount: _items.length,
                ),
              )
        : const Center(
            child: Text("No product added to wishlist!"),
          );
  }
}
