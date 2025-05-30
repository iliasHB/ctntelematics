import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/eshop/presentation/widgets/product_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/databse_helper.dart';
import '../../../../core/widgets/appBar.dart';
import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../bloc/eshop_bloc.dart';

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
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.square_grid_2x2),
          const SizedBox(
            width: 10,
          ),
          Text(
            "All Categories",
            style: AppStyle.cardfooter.copyWith(fontSize: 14),
          )
        ],
      ),
      Row(
        children: [
          const Icon(CupertinoIcons.square_grid_2x2),
          const SizedBox(
            width: 10,
          ),
          Text(
            "All Product",
            style: AppStyle.cardfooter.copyWith(fontSize: 14),
          )
        ],
      ),
      Row(
        children: [
          const Icon(CupertinoIcons.cart_badge_plus),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Cart",
            style: AppStyle.cardfooter.copyWith(fontSize: 14),
          )
        ],
      ),
    ];
    return Scaffold(
      appBar: AnimatedAppBar(
        firstname: first_name ?? "", pageRoute: 'Eshop',
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
                    // suffixIcon: Icon(CupertinoIcons.mic_fill),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
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
            _selectedTabIndex == 0
                ? Column(
                    children: [
                      _buildListSection("Filters"),
                      const SizedBox(height: 10),
                      // _buildListSection("Oil Filter"),
                      // const SizedBox(height: 10),
                      // _buildListSection("Air Filter"),
                    ],
                  )
                : _selectedTabIndex == 1
                    ? _buildGridSection()
                    : _buildUserCartSection(),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        BlocProvider(
          create: (_) => sl<EshopGetAllProductBloc>()
            ..add(
                EshopGetProductsEvent(EshopTokenReqEntity(token: token ?? ""))),
          child: BlocConsumer<EshopGetAllProductBloc, EshopState>(
            builder: (context, state) {
              if (state is EshopLoading) {
                return const Center(
                  child: CustomContainerLoadingButton()
                );
              } else if (state is EshopGetProductsDone) {
                // Check if the schedule data is empty
                if (state.resp.products.data == null ||
                    state.resp.products.data.isEmpty) {
                  return Center(
                    child: Text(
                      'No available product',
                      style: AppStyle.cardfooter,
                    ),
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.resp.products.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AllCategory(
                                productName:
                                    state.resp.products.data[index].name,
                                productImage:
                                    state.resp.products.data[index].image,
                                price: state.resp.products.data[index].price
                                    .toString(),
                                onAddToCart: () {},
                                onFavorite: () {},
                                categoryId: state
                                    .resp.products.data[index].category_id
                                    .toString(),
                                description:
                                    state.resp.products.data[index].description,
                                token: token,
                                productId: state.resp.products.data[index].id);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No records found',
                          style: AppStyle.cardfooter,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        CustomSecondaryButton(
                            label: 'Refresh',
                            onPressed: () {
                              BlocProvider.of<EshopGetAllProductBloc>(
                                  context)
                                  .add(EshopGetProductsEvent(
                                  EshopTokenReqEntity(token: token ?? "")));
                            })
                      ],
                    ));
              }
            },
            listener: (context, state) {
              if (state is EshopFailure) {
                if (state.message.contains("Unauthenticated")) {
                  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection() {
    return BlocProvider(
      create: (_) => sl<EshopGetAllProductBloc>()
        ..add(EshopGetProductsEvent(EshopTokenReqEntity(token: token ?? ""))),
      child: BlocConsumer<EshopGetAllProductBloc, EshopState>(
        builder: (context, state) {
          if (state is EshopLoading) {
            return const Center(
              child: CustomContainerLoadingButton()
            );
          } else if (state is EshopGetProductsDone) {
            // Check if the schedule data is empty
            if (state.resp.products.data == null ||
                state.resp.products.data.isEmpty) {
              return Center(
                child: Text(
                  'No available product',
                  style: AppStyle.cardfooter,
                ),
              );
            }

            return Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: state.resp.products.data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    childAspectRatio: 1.05, // Adjust for width-to-height ratio
                    mainAxisSpacing: 0, // Removes vertical spacing
                    crossAxisSpacing: 0, // Removes horizontal spacing
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return AllProduct(
                      productName: state.resp.products.data[index].name,
                      productImage: state.resp.products.data[index].image,
                      price: state.resp.products.data[index].price.toString(),
                      onAddToCart: () {},
                      onFavorite: () {},
                      categoryId: state.resp.products.data[index].category_id
                          .toString(),
                      description: state.resp.products.data[index].description,
                      token: token!,
                      productId: state.resp.products.data[index].id,
                    );
                  },
                )
              ],
            );
          } else {
            return Center(
                child: Text(
              'No records found',
              style: AppStyle.cardfooter,
            ));
          }
        },
        listener: (context, state) {
          if (state is EshopFailure) {
            if (state.message.contains("Unauthenticated")) {
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserCartSection() {
    return FutureBuilder<List<CartProducts>>(
      future: _fetchCartItems(), // Fetch cart items from the database
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomContainerLoadingButton());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        } else {
          final cartItems = snapshot.data!;
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: cartItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 1.1, // Adjust for width-to-height ratio
              mainAxisSpacing: 0, // Removes vertical spacing
              crossAxisSpacing: 0, // Removes horizontal spacing
            ),
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return AllCartProduct(
                productName: item.name!,
                productImage: item.image!,
                price: item.price!,
                onAddToCart: () {},
                onFavorite: () {},
                categoryId: item.category_id.toString(),
                description: item.description!,
                token: token!,
                productId: item.productId!,
              );
            },
          );
        }
      },
    );
  }

  Future<List<CartProducts>> _fetchCartItems() async {
    final dbCart = DB_cart();
    return await dbCart.fetchUserCart();
  }
}

class AllCategory extends StatefulWidget {
  final String productName;
  final String productImage;
  final String price;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;
  final String categoryId;
  final String description;
  final String? token;
  final int productId;

  AllCategory({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.onAddToCart,
    required this.onFavorite,
    required this.categoryId,
    required this.description,
    required this.token,
    required this.productId,
  });

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  DB_cart db_cart = DB_cart();

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProductReview(
                              productName: widget.productName,
                              productImage: widget.productImage,
                              price: widget.price,
                              categoryId: widget.categoryId,
                              description: widget.description,
                              token: widget.token!,
                              productId: widget.productId)));
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
                        Center(
                          child: Image.network(
                            'https://ecom.verifycentre.com${widget.productImage}',
                            height: 100,
                            width: 100,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: Container(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.green,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                        // Image.asset(
                        //   productImage,
                        //   height: 100,
                        //   width: 100,
                        // ),
                        Center(
                          child: Text(
                            widget.productName,
                            style: AppStyle.cardfooter
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/naira.png",
                              height: 20,
                              width: 20,
                            ),
                            Text(widget.price,
                                style: AppStyle.cardSubtitle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[800])),
                          ],
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
                      InkWell(
                        onTap: () {
                          saveProductToCart(
                            widget.productName,
                            widget.productImage,
                            widget.price,
                            widget.categoryId,
                            widget.description,
                            widget.productId,
                          );
                          // db_cart.saveProducts(
                          //
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green[700],
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       border: Border.all(width: 1, color: Colors.grey),
                      //       borderRadius: BorderRadius.circular(50)),
                      //   child: const CircleAvatar(
                      //     radius: 15,
                      //     backgroundColor: Colors.white,
                      //     child: Icon(
                      //       Icons.favorite_border,
                      //       size: 15,
                      //     ),
                      //   ),
                      // )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  saveProductToCart(String productName, String productImage, String price,
      String categoryId, String description, int productId) async {
    bool isSaved = await db_cart.saveProducts(
        productName, productImage, price, categoryId, description, productId);

    if (isSaved) {
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added to cart successfully!', style: AppStyle.cardfooter,),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      // Show failure feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product to cart.', style: AppStyle.cardfooter),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class AllProduct extends StatefulWidget {
  final String productName;
  final String productImage;
  final String price;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;
  final String categoryId, description, token;
  final int productId;

  const AllProduct({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.onAddToCart,
    required this.onFavorite,
    required this.categoryId,
    required this.description,
    required this.token,
    required this.productId,
  });

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {

  DB_cart db_cart = DB_cart();
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProductReview(
                              productName: widget.productName,
                              productImage: widget.productImage,
                              price: widget.price,
                              categoryId: widget.categoryId,
                              description: widget.description,
                              token: widget.token,
                              productId: widget.productId)));
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
                        Center(
                          child: Image.network(
                            'https://ecom.verifycentre.com${widget.productImage}',
                            headers: {'Authorization': widget.token},
                            height: 100,
                            width: 100,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.green,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.productName,
                            style: AppStyle.cardfooter
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/naira.png",
                              height: 20,
                              width: 20,
                            ),
                            Text(widget.price,
                                style: AppStyle.cardSubtitle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[800])),
                          ],
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
                      InkWell(
                        onTap: (){
                          saveProductToCart(
                            widget.productName,
                            widget.productImage,
                            widget.price,
                            widget.categoryId,
                            widget.description,
                            widget.productId,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green[700],
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
  saveProductToCart(String productName, String productImage, String price,
      String categoryId, String description, int productId) async {
    bool isSaved = await db_cart.saveProducts(
        productName, productImage, price, categoryId, description, productId);

    if (isSaved) {
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added to cart successfully!', style: AppStyle.cardfooter,),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      // Show failure feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product to cart.', style: AppStyle.cardfooter,),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}



class AllCartProduct extends StatefulWidget {
  final String productName;
  final String productImage;
  final String price;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;
  final String categoryId, description, token;
  final int productId;

  const AllCartProduct({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.onAddToCart,
    required this.onFavorite,
    required this.categoryId,
    required this.description,
    required this.token,
    required this.productId,
  });

  @override
  State<AllCartProduct> createState() => _AllCartProductState();
}

class _AllCartProductState extends State<AllCartProduct> {

  DB_cart db_cart = DB_cart();
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProductReview(
                              productName: widget.productName,
                              productImage: widget.productImage,
                              price: widget.price,
                              categoryId: widget.categoryId,
                              description: widget.description,
                              token: widget.token,
                              productId: widget.productId)));

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
                        Center(
                          child: Image.network(
                            'https://ecom.verifycentre.com${widget.productImage}',
                            headers: {'Authorization': widget.token},
                            height: 100,
                            width: 100,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.green,
                                    value: loadingProgress.expectedTotalBytes !=
                                        null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                        // Image.asset(
                        //   productImage,
                        //   height: 100,
                        //   width: 100,
                        // ),
                        Center(
                          child: Text(
                            widget.productName,
                            style: AppStyle.cardfooter
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/naira.png",
                              height: 20,
                              width: 20,
                            ),
                            Text(widget.price,
                                style: AppStyle.cardSubtitle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[800])),
                          ],
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
                      InkWell(
                        onTap: (){
                          deleteCartProduct(
                            context,
                            widget.productId,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.red[500],
                            child: const Icon(
                             CupertinoIcons.delete,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }


  Future<void> deleteCartProduct(BuildContext context, int productId) async {
    bool isDeleted = await db_cart.deleteProduct(productId);

    if (isDeleted) {
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product removed from cart successfully!', style: AppStyle.cardfooter,),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      // Show failure feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove product from cart.', style: AppStyle.cardfooter,),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
