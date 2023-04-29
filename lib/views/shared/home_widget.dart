import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:online_shop_shoes_2/controllers/product_provider.dart';
import 'package:online_shop_shoes_2/views/shared/app_style.dart';
import 'package:online_shop_shoes_2/views/shared/new_shoes.dart';
import 'package:online_shop_shoes_2/views/shared/product_card.dart';
import 'package:online_shop_shoes_2/views/ui/product_by_cat.dart';
import 'package:online_shop_shoes_2/views/ui/product_page.dart';
import 'package:provider/provider.dart';

import '../../models/sneakers_model.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget(
      {super.key, required Future<List<Sneakers>> male, required this.tabIndex})
      : _male = male;

  final Future<List<Sneakers>> _male;

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.405,
          child: FutureBuilder(
            future: _male,
            builder: (context, snapshpt) {
              if (snapshpt.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshpt.hasError) {
                return Text('Error ${snapshpt.error}');
              } else {
                final male = snapshpt.data;

                return ListView.builder(
                    itemCount: male!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      final shoe = snapshpt.data![index];
                      return GestureDetector(
                        onTap: () {
                          productNotifier.shoesSizes = shoe.sizes;

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                  category: shoe.category, id: shoe.id),
                            ),
                          );
                        },
                        child: ProductCard(
                          price: '\$${shoe.price}',
                          category: shoe.category,
                          id: shoe.id,
                          name: shoe.name,
                          image: shoe.imageUrl[0],
                        ),
                      );
                    });
              }
            },
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Shoes',
                    style: appstyle(24, Colors.black, FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  ProductByCat(tabIndex: tabIndex),
                            ),
                          );
                        },
                        child: Text(
                          'Show All',
                          style: appstyle(22, Colors.black, FontWeight.bold),
                        ),
                      ),
                      const Icon(
                        AntDesign.caretright,
                        size: 20,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.13,
          child: FutureBuilder(
            future: _male,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    final shoe = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NewShoes(imageUrl: shoe.imageUrl[1]),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
