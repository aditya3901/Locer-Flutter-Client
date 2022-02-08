import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locer/screens/navBar_screens/cart_screen.dart';
import 'package:lottie/lottie.dart';

class OrderConfirmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/images/logo.svg",
          height: 45,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottiefiles/order_confirmed.json',
              width: double.infinity,
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) {
                  return CartScreen();
                }));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Return to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
