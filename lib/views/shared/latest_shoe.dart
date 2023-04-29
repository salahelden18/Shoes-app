import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:online_shop_shoes_2/views/shared/stagger_tile.dart';

import '../../models/sneakers_model.dart';

class LatestShoes extends StatelessWidget {
  const LatestShoes({
    super.key,
    required Future<List<Sneakers>> male,
  }) : _male = male;

  final Future<List<Sneakers>> _male;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _male,
      builder: (context, snapshpt) {
        if (snapshpt.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshpt.hasError) {
          return Text('Error ${snapshpt.error}');
        } else {
          final male = snapshpt.data;

          return StaggeredGridView.countBuilder(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 16,
              itemCount: male!.length,
              scrollDirection: Axis.vertical,
              staggeredTileBuilder: (index) => StaggeredTile.extent(
                    (index % 2 == 0) ? 1 : 1,
                    (index % 4 == 1 || index % 4 == 3)
                        ? MediaQuery.of(context).size.height * 0.35
                        : MediaQuery.of(context).size.height * 0.3,
                  ),
              itemBuilder: (ctx, index) {
                final shoe = snapshpt.data![index];
                return StaggerTile(
                  imageUrl: shoe.imageUrl[1],
                  name: shoe.name,
                  price: '\$${shoe.price}',
                );
              });
        }
      },
    );
  }
}
