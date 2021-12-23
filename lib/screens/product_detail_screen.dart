import 'package:flutter/material.dart';
import 'package:locer/utils/child_model.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = "/product-detail-screen";

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavourite = false;
  int count = 1;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as ChildModel;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          arg.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: arg.title,
              child: Image.network(
                arg.imageUrl,
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 14),
              child: Text(
                arg.title,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                "\u20B9${arg.price}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              padding: const EdgeInsets.symmetric(vertical: 2),
              margin: const EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (count > 0) {
                        setState(() {
                          count--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    "$count",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        count++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (count > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Item added to cart."),
                      action: SnackBarAction(
                        label: "Dismiss",
                        onPressed:
                            ScaffoldMessenger.of(context).hideCurrentSnackBar,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green,
                ),
                margin: const EdgeInsets.all(12),
                child: const Center(
                  child: Text(
                    "Add to cart",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isFavourite = !isFavourite;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: (isFavourite)
                    ? const Text("Item added to wishlist.")
                    : const Text("Item removed from wishlist."),
                action: SnackBarAction(
                  label: "Dismiss",
                  onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
                ),
              ),
            );
          });
        },
        child: (isFavourite)
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_outline),
      ),
    );
  }
}
