import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/cart_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:locer/utils/models/user_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _cartUrl = "https://locerappdemo.herokuapp.com/api/orders";

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cart;
  CheckoutScreen(this.cart);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinController = TextEditingController();
  bool isChecked = false;
  bool _isSending = false;
  double itemsCost = 0, shippingCost = 0, taxes = 0, totalCost = 0;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    calculateCost();
  }

  void calculateCost() {
    for (var item in widget.cart) {
      itemsCost += item.price;
    }
    shippingCost = 25;
    totalCost = itemsCost + shippingCost + taxes;
    setState(() {});
  }

  Future<User> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("current_user");
    Map<String, dynamic> map = jsonDecode(json!);
    final user = User.fromJson(map);
    return user;
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Enter your phone"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "9876543210",
            ),
            controller: _phoneController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_phoneController.text.isNotEmpty) {
                  Navigator.of(context).pop(_phoneController.text);
                }
              },
              child: const Text("SUBMIT"),
            ),
          ],
        ),
      );

  Future<bool> _checkPhone(User user) async {
    int phoneNum = int.parse(user.phone!);
    if (phoneNum > 5999999999 && phoneNum <= 9999999999) {
      return true;
    } else {
      final retPhone = await openDialog();
      int phone = int.parse(retPhone!);
      if (phone > 5999999999 && phone <= 9999999999) {
        user.phone = retPhone;
        return true;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Invalid Phone Number"),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
      return false;
    }
  }

  void validate() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      try {
        User user = await getUserData();
        // Check If Phone Number is Present
        bool isPresent = await _checkPhone(user);
        if (isPresent) {
          var items = [];
          for (var item in widget.cart) {
            items.add(item.toJson());
          }
          var body = {
            "user": user.id,
            "userMobileNum": user.phone,
            "orderItems": items,
            "shippingAddress": {
              "address": _addressController.text,
              "city": _cityController.text,
              "state": _stateController.text,
              "postalCode": _pinController.text,
              "country": "India"
            },
            "itemsPrice": itemsCost,
            "shippingPrice": shippingCost,
            "taxPrice": taxes,
            "totalPrice": totalCost,
            "paymentMethod": "UPI"
          };
          final response = await http.post(
            Uri.parse(_cartUrl),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: "Bearer ${user.token}"
            },
            body: jsonEncode(body),
          );
          await ProductsDatabase.instance.clearCartTable();
          setState(() {
            _isSending = false;
          });
          print(response.body);
          // Send to Order Completion Page
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) {
              return OrderConfirmed();
            }),
            (Route route) => false,
          );
        } else {
          setState(() {
            _isSending = false;
          });
        }
      } catch (e) {
        // print(e);
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Widget formField(
      String label, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$label required";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Checkout",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSending,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 18),
                              child: Text(
                                "Shipping Address",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      color: Colors.green,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            formField(
                              "Address",
                              Icons.location_history,
                              _addressController,
                            ),
                            const SizedBox(height: 8),
                            formField(
                              "City",
                              Icons.location_city,
                              _cityController,
                            ),
                            const SizedBox(height: 8),
                            formField(
                              "State",
                              Icons.location_on,
                              _stateController,
                            ),
                            const SizedBox(height: 8),
                            formField(
                              "PIN",
                              Icons.pin,
                              _pinController,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text(
                                "Payment Method",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      color: Colors.green,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            CheckboxListTile(
                              contentPadding: const EdgeInsets.all(0),
                              value: isChecked,
                              onChanged: (val) {
                                setState(() {
                                  isChecked = val!;
                                });
                              },
                              title: const Text(
                                "UPI/Cash On Delivery",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(
                                "Order Summary",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      color: Colors.green,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Items Cost: ",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "\u20B9$itemsCost",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Shipping Cost: ",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "\u20B9$shippingCost",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Taxes: ",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "\u20B9$taxes",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Cost: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "\u20B9$totalCost",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (isChecked) {
                      validate();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    margin: const EdgeInsets.only(
                        top: 8, left: 8, right: 8, bottom: 14),
                    child: const Center(
                      child: Text(
                        "Submit Order",
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
            ),
          ),
        ),
      ),
    );
  }
}
