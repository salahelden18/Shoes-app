import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:online_shop_shoes_2/controllers/product_provider.dart';
import 'package:online_shop_shoes_2/models/sneakers_model.dart';
import 'package:online_shop_shoes_2/services/helper.dart';
import 'package:online_shop_shoes_2/views/shared/app_style.dart';
import 'package:provider/provider.dart';

import '../shared/checkout_button.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.category, required this.id});
  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  final _cartBox = Hive.box('cart_box');

  late Future<Sneakers> _sneaker;

  void getShoes() {
    if (widget.category == 'Men\'s Running') {
      _sneaker = Helper().getMaleSneakersById(widget.id);
    } else if (widget.category == 'Women\'s Running') {
      _sneaker = Helper().getFemaleSneakersById(widget.id);
    } else {
      _sneaker = Helper().getKidsSneakersById(widget.id);
    }
  }

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await _cartBox.add(newCart);
  }

  @override
  void initState() {
    super.initState();
    getShoes();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: _sneaker,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            }
            final sneaker = snapshot.data;
            return Consumer<ProductNotifier>(
              builder: (context, provider, _) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leadingWidth: 0,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              provider.shoesSizes.clear();
                            },
                            child: const Icon(
                              AntDesign.close,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: null,
                            child: const Icon(
                              Ionicons.ellipsis_horizontal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                    snap: false,
                    floating: true,
                    backgroundColor: Colors.transparent,
                    expandedHeight: size.height,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          SizedBox(
                            height: size.height * 0.5,
                            width: double.infinity,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sneaker!.imageUrl.length,
                              controller: pageController,
                              onPageChanged: (page) {
                                provider.activePage = page;
                              },
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: size.height * 0.39,
                                      width: double.infinity,
                                      color: Colors.grey.shade300,
                                      child: CachedNetworkImage(
                                        imageUrl: sneaker.imageUrl[index],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Positioned(
                                      top: size.height * 0.1,
                                      right: 20,
                                      child: const Icon(
                                        AntDesign.hearto,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List<Widget>.generate(
                                          sneaker.imageUrl.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  provider.activePage != index
                                                      ? Colors.grey
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              child: Container(
                                height: size.height * 0.645,
                                width: size.width,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sneaker.name,
                                        style: appstyle(
                                            40, Colors.black, FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            sneaker.category,
                                            style: appstyle(
                                              20,
                                              Colors.grey,
                                              FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          RatingBar.builder(
                                            initialRating: 4,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 22,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 1,
                                            ),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${sneaker.price}',
                                            style: appstyle(
                                              26,
                                              Colors.black,
                                              FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Colors',
                                                style: appstyle(
                                                  18,
                                                  Colors.black,
                                                  FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              const CircleAvatar(
                                                radius: 7,
                                                backgroundColor: Colors.black,
                                              ),
                                              const CircleAvatar(
                                                radius: 7,
                                                backgroundColor: Colors.red,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Select Size',
                                                style: appstyle(
                                                    20,
                                                    Colors.black,
                                                    FontWeight.w600),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(
                                                'View Size Guide',
                                                style: appstyle(20, Colors.grey,
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: ListView.builder(
                                              itemCount: 3,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                final sizes =
                                                    provider.shoesSizes[index];

                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: ChoiceChip(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      side: const BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                    disabledColor: Colors.white,
                                                    label: Text(
                                                      sizes['size'],
                                                      style: appstyle(
                                                        18,
                                                        sizes['isSelected']
                                                            ? Colors.white
                                                            : Colors.black,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    selected: provider
                                                            .shoesSizes[index]
                                                        ['isSelected'],
                                                    onSelected: (newState) {
                                                      if (provider.sizes
                                                          .contains(
                                                              sizes['size'])) {
                                                        provider.sizes.remove(
                                                            sizes['size']);
                                                      } else {
                                                        provider.sizes
                                                            .add(sizes['size']);
                                                      }
                                                      provider
                                                          .toggleCheck(index);
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Divider(
                                        indent: 10,
                                        endIndent: 10,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: size.width * 0.8,
                                        child: Text(
                                          sneaker.title,
                                          style: appstyle(
                                            26,
                                            Colors.black,
                                            FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        sneaker.description,
                                        style: appstyle(
                                          14,
                                          Colors.black,
                                          FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.justify,
                                        maxLines: 4,
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: CheckoutButton(
                                            size: size,
                                            label: 'Add To Bag',
                                            onTap: () async {
                                              _createCart({
                                                'id': sneaker.id,
                                                'name': sneaker.name,
                                                'category': sneaker.category,
                                                'imageUrl': sneaker.imageUrl[0],
                                                'price': sneaker.price,
                                                'qty': 1,
                                                'sizes': sneaker.sizes,
                                              });
                                              provider.sizes.clear();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
