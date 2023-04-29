import 'package:flutter/material.dart';

import '../shared/app_style.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Profile Page',
          style: appstyle(40, Colors.black, FontWeight.bold),
        ),
      ),
    );
  }
}
