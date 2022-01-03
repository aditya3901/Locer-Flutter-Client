import 'package:flutter/material.dart';
import 'package:locer/screens/tabs_screen.dart';
import 'package:lottie/lottie.dart';

class OrderConfirmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
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
                    .pushReplacementNamed(TabsScreen.routeName);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.home,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Return Home',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
