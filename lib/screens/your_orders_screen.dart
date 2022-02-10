import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:locer/providers/theme_provider.dart';
import 'package:locer/utils/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourOrdersScreen extends StatefulWidget {
  @override
  _YourOrdersScreenState createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  final List<Map<String, dynamic>> _ordersListPlaced = [];
  final List<Map<String, dynamic>> _ordersListAccepted = [];
  final List<Map<String, dynamic>> _ordersListShipped = [];
  final List<Map<String, dynamic>> _ordersListDelivered = [];
  bool _isLoading = false;

  Future<User> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("current_user");
    Map<String, dynamic> map = jsonDecode(json!);
    final user = User.fromJson(map);
    return user;
  }

  void getOrders() async {
    setState(() {
      _isLoading = true;
    });
    try {
      User user = await getUserData();
      final res = await http.get(
        Uri.parse("https://locerappdemo.herokuapp.com/api/orders/allmy"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${user.token}"
        },
      );
      var orders = jsonDecode(res.body);
      for (var order in orders) {
        if (order["isAccepted"] == false &&
            order["isShipped"] == false &&
            order["isDelivered"] == false) {
          _ordersListPlaced.add(order);
        } else {
          if (order["isDelivered"] == true) {
            _ordersListDelivered.add(order);
          } else if (order["isShipped"] == true) {
            _ordersListShipped.add(order);
          } else if (order["isAccepted"] == true) {
            _ordersListAccepted.add(order);
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Orders",
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                child: Text(
                  "Placed",
                  style: TextStyle(
                    color: (themeProvider.darkTheme == true)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Accepted",
                  style: TextStyle(
                    color: (themeProvider.darkTheme == true)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Shipped",
                  style: TextStyle(
                    color: (themeProvider.darkTheme == true)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Delivered",
                  style: TextStyle(
                    color: (themeProvider.darkTheme == true)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            placed(),
            accepted(),
            shipped(),
            delivered(),
          ],
        ),
      ),
    );
  }

  Widget orderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.tag),
                  SizedBox(width: 6),
                  Text(
                    "Order Id",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item["_id"],
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Location"),
                          const SizedBox(height: 4),
                          Text(
                            "${item["shippingAddress"]["postalCode"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const VerticalDivider(thickness: 1),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Price"),
                          const SizedBox(height: 4),
                          Text(
                            "\u20B9${item["totalPrice"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const VerticalDivider(thickness: 1),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Payment"),
                          const SizedBox(height: 4),
                          Text(
                            "${item["paymentMethod"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.clock),
                  const SizedBox(width: 8),
                  Text(
                    "${item["createdAt"]}",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget placed() {
    return (_isLoading)
        ? const Center(
            child: CupertinoActivityIndicator(radius: 18),
          )
        : (_ordersListPlaced.isEmpty)
            ? const Center(
                child: Text("No order placed yet"),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return orderItem(_ordersListPlaced[index]);
                },
                itemCount: _ordersListPlaced.length,
              );
  }

  Widget accepted() {
    return (_isLoading)
        ? const Center(
            child: CupertinoActivityIndicator(radius: 18),
          )
        : (_ordersListAccepted.isEmpty)
            ? const Center(
                child: Text("No order accepted yet"),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return orderItem(_ordersListAccepted[index]);
                },
                itemCount: _ordersListAccepted.length,
              );
  }

  Widget shipped() {
    return (_isLoading)
        ? const Center(
            child: CupertinoActivityIndicator(radius: 18),
          )
        : (_ordersListShipped.isEmpty)
            ? const Center(
                child: Text("No order shipped yet"),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return orderItem(_ordersListShipped[index]);
                },
                itemCount: _ordersListShipped.length,
              );
  }

  Widget delivered() {
    return (_isLoading)
        ? const Center(
            child: CupertinoActivityIndicator(radius: 18),
          )
        : (_ordersListDelivered.isEmpty)
            ? const Center(
                child: Text("No order delivered yet"),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return orderItem(_ordersListDelivered[index]);
                },
                itemCount: _ordersListDelivered.length,
              );
  }
}

// [{
//shippingAddress: {address: a, city: aa, state: a, postalCode: a, country: India},
//itemsPrice: 686,
//taxPrice: 0,
//shippingPrice: 25,
//totalPrice: 686,
//isPaid: false,
//isAccepted: false,
//isShipped: false,
//isDelivered: false,
//_id: 61d28025a528a100047cf8e5,
//user: 61cec14d58c69c0004c3fc39,
//orderItems: [{_id: 61d28025a528a100047cf8e6, id: 60cc492585a429452f2625e2, title: Green smoothie, price: 17.68, filename: 3.jpg, qty: 1, storeId: 60cc492585a429452f2625dc, storeName: Suvidha bazar}],
//paymentMethod: UPI,
//createdAt: 2022-01-03T04:48:37.026Z,
//updatedAt: 2022-01-03T04:48:37.026Z,
//__v: 0,
//}]
