import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/appBar.dart';

class EshopPage extends StatefulWidget {
  const EshopPage({super.key});

  @override
  State<EshopPage> createState() => _EshopPageState();
}

class _EshopPageState extends State<EshopPage> {
  int _selectedTabIndex = 0;
  PrefUtils prefUtils = PrefUtils();
  String? first_name;
  String? last_name;
  String? middle_name;
  String? email;
  String? token;
  bool viewAdvert = false;
  @override
  void initState() {
    super.initState();
    _getAuthUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getAuthUser() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      first_name = authUser![0] == "" ? null : authUser[0];
      last_name = authUser[1] == "" ? null : authUser[1];
      middle_name = authUser[2] == "" ? null : authUser[2];
      email = authUser[3] == "" ? null : authUser[3];
      token = authUser[4] == "" ? null : authUser[4];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.square_grid_2x2),
          SizedBox(
            width: 10,
          ),
          Text("All Categories")
        ],
      ),
      const Row(
        children: [
          Icon(CupertinoIcons.square_grid_2x2),
          SizedBox(
            width: 10,
          ),
          Text("All Product")
        ],
      ),
    ];
    return Scaffold(
      appBar: AnimatedAppBar(
        firstname: first_name ?? "",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          // Changed SingleChildScrollView to ListView for better scrolling
          children: [
            Form(
              child: Card(
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.search),
                    suffixIcon: Icon(CupertinoIcons.mic_fill),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            viewAdvert == false
                ? Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Check Latest Stock',
                                  style: AppStyle.cardfooter
                                      .copyWith(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            viewAdvert = true;
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.chevron_down,
                          size: 15,
                        ))
                  ],
                ),
              ),
            )
                : Stack(children: [
              const Advert(),
              Positioned(
                right: 10,
                top: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        viewAdvert = false;
                      });
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    )),
              )
            ]),
            SizedBox(
              height: 50.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        side: BorderSide.none,
                        backgroundColor: _selectedTabIndex == index
                            ? Colors.green
                            : Colors.grey.shade200,
                        label: _tabs[index],
                        labelStyle: TextStyle(
                          color: _selectedTabIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            _selectedTabIndex == 0 ? Column(
              children: [
                _buildListSection("Engine Oil"),
                const SizedBox(height: 10),
                _buildListSection("Oil Filter"),
                const SizedBox(height: 10),
                _buildListSection("Air Filter"),
              ],
            ) : _buildGridSection(),

          ],
        ),
      ),
    );
  }

  Widget _buildListSection(String title) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return AllCategory(
                            productName: 'Mobile 10W - 20 Fully Synthetic',
                            productImage: 'assets/images/keg.png',
                            price: 500.0,
                            onAddToCart: () {},
                            onFavorite: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget _buildGridSection() {
    return Column(
      children: [
        SizedBox(
            height: 400,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust crossAxisCount as needed
                childAspectRatio: 0.995,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return AllProduct(
                  productName: 'Mobile 10W - 20 Fully Synthetic',
                  productImage: 'assets/images/keg.png',
                  price: 500.0,
                  onAddToCart: () {},
                  onFavorite: () {},
                );
              },
            )
        )
      ],
    );
  }
}

class AllCategory extends StatelessWidget {
  final String productName;
  final String productImage;
  final double price;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;

  const AllCategory({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.onAddToCart,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/productReview");
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          productImage,
                          height: 100,
                          width: 100,
                        ),
                        Center(
                          child: Text(
                            productName,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Text(
                          "\$ $price",
                          style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 20,
                  right: 15,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.favorite_border,
                            size: 15,
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class AllProduct extends StatelessWidget {
  final String productName;
  final String productImage;
  final double price;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;

  const AllProduct({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.onAddToCart,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/productReview");
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          productImage,
                          height: 100,
                          width: 100,
                        ),
                        Center(
                          child: Text(
                            productName,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Text(
                          "\$ $price",
                          style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 20,
                  right: 15,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.favorite_border,
                            size: 15,
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
