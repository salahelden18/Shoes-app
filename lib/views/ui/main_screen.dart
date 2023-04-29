import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:online_shop_shoes_2/controllers/main_screen_provider.dart';
import 'package:online_shop_shoes_2/views/ui/cart_page.dart';
import 'package:online_shop_shoes_2/views/ui/favorite_page.dart';
import 'package:online_shop_shoes_2/views/ui/home_page.dart';
import 'package:online_shop_shoes_2/views/ui/profile_page.dart';
import 'package:online_shop_shoes_2/views/ui/search_page.dart';
import 'package:provider/provider.dart';

import '../shared/bottom_nav.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = const [
    HomePage(),
    SearchPage(),
    Favorites(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (ctx, mainScreenNotifier, _) => Scaffold(
        backgroundColor: const Color(0xffE2E2E2),
        body: pageList[mainScreenNotifier.pageIndex],
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
