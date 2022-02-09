import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/screens/checkout_screen.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/cart_item_model.dart';
import 'package:locer/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

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
                          color: Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),
                      const Divider(thickness: 0.8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Price: \u20B9",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Provider.of<ThemeProvider>(context).isDarkMode
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
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Card(
                  elevation: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
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
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/images/logo.svg",
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {
              refreshCart();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: (_cart.isNotEmpty)
          ? (_isLoading == true)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return cartItem(_cart[index]);
                        },
                        itemCount: _cart.length,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return CheckoutScreen(_cart);
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                        ),
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, top: 10, bottom: 18),
                        child: const Center(
                          child: Text(
                            "Proceed to Checkout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/empty_cart.png",
                    width: double.infinity,
                  ),
                  const Text(
                    "Your cart is empty!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
