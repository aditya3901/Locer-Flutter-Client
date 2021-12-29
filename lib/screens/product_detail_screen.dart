import 'package:flutter/material.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/cart_item_model.dart';
import 'package:locer/utils/models/child_model.dart';

class ProductDetailScreen extends StatefulWidget {
  ChildModel productItem;
  ProductDetailScreen(this.productItem);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavourite = false;
  int count = 1;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    ChildModel? item =
        await ProductsDatabase.instance.readProduct(widget.productItem.id);
    if (item != null) {
      setState(() {
        isFavourite = item.isFavourite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.productItem.title,
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
              tag: widget.productItem.id,
              child: Image.network(
                widget.productItem.imageUrl,
                width: double.infinity,
                height: 320,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
                top: 14,
                right: 14,
              ),
              child: Text(
                widget.productItem.title,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
              ),
              child: Text(
                widget.productItem.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                "\u20B9${widget.productItem.price}",
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
                      if (count > 1) {
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
              onTap: () async {
                final cartItem = CartItem(
                  widget.productItem.id,
                  widget.productItem.title,
                  widget.productItem.price * count,
                  widget.productItem.imageUrl,
                  count,
                );
                CartItem? item =
                    await ProductsDatabase.instance.readCart(cartItem.id);
                // Add to table if doesn't exist in cart
                if (item == null) {
                  await ProductsDatabase.instance.createCart(cartItem);
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
                } else {
                  // Show SnackBar if already exist in cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Already exist in cart."),
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
        onPressed: () async {
          if (isFavourite == false) {
            isFavourite = true;
            final item = ChildModel(
              widget.productItem.id,
              widget.productItem.title,
              widget.productItem.description,
              widget.productItem.price,
              widget.productItem.imageUrl,
              isFavourite,
            );
            await ProductsDatabase.instance.create(item);
          } else if (isFavourite == true) {
            isFavourite = false;
            await ProductsDatabase.instance.delete(widget.productItem.id);
          }
          setState(() {
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
