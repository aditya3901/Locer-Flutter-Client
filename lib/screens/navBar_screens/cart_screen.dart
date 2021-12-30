import 'package:flutter/material.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/cart_item_model.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  List<CartItem> _cart = [];

  @override
  void initState() {
    super.initState();
    refreshCart();
  }

  Future refreshCart() async {
    setState(() {
      _isLoading = true;
    });
    _cart = await ProductsDatabase.instance.readAllCartItems();
    setState(() {
      _isLoading = false;
    });
  }

  Widget cartItem(CartItem item) {
    return Container(
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
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 2,
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      "${item.count}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await ProductsDatabase.instance.deleteCartItem(item.id);
                  refreshCart();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_cart.isNotEmpty)
        ? (_isLoading == true)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return cartItem(_cart[index]);
                      },
                      itemCount: _cart.length,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    margin: const EdgeInsets.all(12),
                    child: const Center(
                      child: Text(
                        "Confirm Order",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
        : const Center(
            child: Text("Add something to cart first."),
          );
  }
}
