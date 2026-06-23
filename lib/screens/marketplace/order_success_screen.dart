import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cultivest_app/screens/dashboard/main_wrapper.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  void initState() {
    super.initState();

    // 5 seconds ka timer set kar rahe hain
    Timer(const Duration(seconds: 5), () {
      // 5 second baad automatically Marketplace par le jaye ga
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper(initialIndex: 2)),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Thank You Text
                const Text(
                  'Thank You!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // 2. White Circle with Green Checkmark
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: primaryGreen, size: 60),
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Success Message
                const Text(
                  'Order placed successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                // 4. Sub-message
                const Text(
                  'Your order will be approved by\nthe seller.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
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

