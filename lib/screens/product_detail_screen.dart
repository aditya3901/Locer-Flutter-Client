import 'package:flutter/material.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/cart_item_model.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/networking.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProductDetailScreen extends StatefulWidget {
  ChildModel productItem;
  ProductDetailScreen(this.productItem);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavourite = false;
  int count = 1;
  bool addingToCart = false;

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

  Future<CartItem> createCartItem() async {
    String _url =
        "https://locerappdemo.herokuapp.com/api/stores/${widget.productItem.storeID}/products/${widget.productItem.id}";
    NetworkHelper helper = NetworkHelper(_url);
    var data = await helper.getData();
    var item = CartItem(
      widget.productItem.id,
      widget.productItem.title,
      widget.productItem.price * count,
      widget.productItem.imageUrl,
      count,
      data["product"]["countInStock"],
      widget.productItem.storeID,
      data["store"]["name"],
    );
    return item;
  }

  void addToCart(CartItem cartItem) async {
    // Check if product belongs to same store or not
    var list = await ProductsDatabase.instance.readAllCartItems();
    if (list.isNotEmpty) {
      // Same Store
      if (list[0].storeID == cartItem.storeID) {
        // Add to table if doesn't exist in cart
        CartItem? item = await ProductsDatabase.instance.readCart(cartItem.id);
        if (item == null) {
          await ProductsDatabase.instance.createCart(cartItem);
          setState(() {
            addingToCart = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Item added to cart."),
              action: SnackBarAction(
                label: "Dismiss",
                onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
              ),
            ),
          );
        }
        // Show SnackBar if already exist in cart
        else {
          setState(() {
            addingToCart = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Already exist in cart."),
              action: SnackBarAction(
                label: "Dismiss",
                onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
              ),
            ),
          );
        }
      }
      // Not Same Store
      else {
        setState(() {
          addingToCart = false;
        });
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Product can't be added to cart",
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
              subtitle: const Text(
                "Your cart already contains items from another store.\nRemove them to add items from new store.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    }
    // If cart is empty
    else {
      await ProductsDatabase.instance.createCart(cartItem);
      setState(() {
        addingToCart = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Item added to cart."),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/driver.png",
          height: 45,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: addingToCart,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                widget.productItem.imageUrl,
                width: double.infinity,
                height: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/driver.png",
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                          ),
                          child: Text(
                            widget.productItem.title,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                          ),
                          child: Text(
                            widget.productItem.description,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66CDAA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: IconButton(
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
                            widget.productItem.storeID,
                          );
                          await ProductsDatabase.instance.create(item);
                        } else if (isFavourite == true) {
                          isFavourite = false;
                          await ProductsDatabase.instance
                              .delete(widget.productItem.id);
                        }
                        setState(() {});
                      },
                      icon: (isFavourite)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 26,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: 26,
                            ),
                    ),
                  ),
                ],
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
                  color: Colors.black.withOpacity(0.1),
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
                    Card(
                      shape: const CircleBorder(),
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: IconButton(
                          onPressed: () {
                            if (count > 1) {
                              setState(() {
                                count--;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove),
                        ),
                      ),
                    ),
                    Text(
                      "$count",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      shape: const CircleBorder(),
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              count++;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    addingToCart = true;
                  });
                  final cartItem = await createCartItem();
                  addToCart(cartItem);
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
      ),
    );
  }
}
