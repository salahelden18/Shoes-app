import 'package:flutter/material.dart';

import '../shared/app_style.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Cart Page',
          style: appstyle(40, Colors.black, FontWeight.bold),
        ),
      ),
    );
  }
}
