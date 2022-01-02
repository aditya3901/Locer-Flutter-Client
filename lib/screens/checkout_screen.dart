import 'package:flutter/material.dart';
import 'package:locer/utils/models/cart_item_model.dart';

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
  double itemsCost = 0, shippingCost = 0, taxes = 0, totalCost = 0;

  Widget formField(
      String label, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
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
  void initState() {
    super.initState();
    calculateCost();
  }

  void calculateCost() {
    for (var item in widget.cart) {
      itemsCost += item.price;
    }
    totalCost = itemsCost + shippingCost + taxes;
    setState(() {});
  }

  void validate() {
    if (formKey.currentState!.validate()) {}
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
      body: SafeArea(
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
                          const Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 18),
                            child: Text(
                              "Shipping Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                            child: Text(
                              "Payment Method",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.payment),
                            title: const Text(
                              "UPI/Cash On Delivery",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            trailing: Checkbox(
                                value: isChecked,
                                onChanged: (val) {
                                  setState(() {
                                    isChecked = val!;
                                  });
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              "Order Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                                  const Text("Items Cost: "),
                                  Text(
                                    "\u20B9$itemsCost",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Shipping Cost: "),
                                  Text(
                                    "\u20B9$shippingCost",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Taxes: "),
                                  Text(
                                    "\u20B9$taxes",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total Cost: "),
                                  Text(
                                    "\u20B9$totalCost",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
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
                  margin: const EdgeInsets.all(12),
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
    );
  }
}
