import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/databse_helper.dart';
import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../bloc/eshop_bloc.dart';
import 'checkout.dart';

class ProductReview extends StatefulWidget {
  final String productName;
  final String productImage;
  final String price;
  final String categoryId;
  final String description;
  final String token;
  final int productId;
  const ProductReview({
    super.key,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.token,
    required this.productId,
  });

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int quantity = 1; // Move quantity here so it persists across widget rebuilds
  bool showQty = false;

  String? productName;
  String? productImage;
  String? price;
  String? categoryId;
  String? description;
  int? productId;

  // double? unitPrice; // Store the original price as a double
  // double totalPrice = 0.0; // Store the total price dynamically

  double priceValue = 0.0; // Store the numeric price

  @override
  void initState() {
    super.initState();
    productName = widget.productName;
    productImage = widget.productImage;
    price = widget.price;
    priceValue = double.tryParse(price ?? '0.0') ?? 0.0;
    categoryId = widget.categoryId;
    description = widget.description;
    productId = widget.productId;
  }

  void onProductSelected({
    required String newProductName,
    required String newProductImage,
    required String newPrice,
    required String newCategoryId,
    required String newDescription,
    required int newProductId,
  }) {
    print('Product selected: $newProductName');
    setState(() {
      productName = newProductName;
      productImage = newProductImage;
      price = newPrice;
      categoryId = newCategoryId;
      description = newDescription;
      productId = newProductId;
      // Convert the price from string to double for calculation
      priceValue = double.tryParse(price ?? '0.0') ?? 0.0;
    });
  }

  double getTotalPrice() {
    return priceValue * quantity;
  }

  // void _updateTotalPrice() {
  //   setState(() {
  //     totalPrice = (unitPrice ?? 0.0) * quantity;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Center(
                  child: Image.network(
                    'https://ecom.verifycentre.com${productImage!}',
                    headers: {'Authorization': widget.token},
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
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
              ),
              const SizedBox(
                height: 10,
              ),

              Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        "Description: ",
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "$description",
                        style: AppStyle.cardfooter,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Product: $productName",
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  // const Icon(CupertinoIcons.heart)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text('Price: ',
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                    Image.asset(
                      'assets/images/naira.png',
                      height: 20,
                      width: 20,
                    ),
                    // Text(price.toString(), style: AppStyle.cardSubtitle.copyWith(color: Colors.green),),
                    Text(
                      getTotalPrice().toStringAsFixed(2), // Display total price
                      style:
                          AppStyle.cardSubtitle.copyWith(color: Colors.green),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Quantity Controls
              showQty == false
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quantity:", style: AppStyle.cardSubtitle),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: quantity > 1
                                  ? () {
                                      setState(() => quantity--);
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              label: const SizedBox(), // Remove the label
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets
                                    .zero, // Remove padding around the icon
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      2), // Minimized border radius
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('$quantity',
                                  style: AppStyle.cardSubtitle),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  // double pri = price + price;
                                  // print("price: $pri");
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const SizedBox(), // Remove the label
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets
                                    .zero, // Remove padding around the icon
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      2), // Minimized border radius
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              // Action Buttons
              Row(children: [
                showQty == false
                    ? Expanded(
                        child: CustomPrimaryButton(
                        label: 'Add to Cart',
                        onPressed: _addToCart,
                      ))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            quantity = 1;
                            showQty = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[500], // Default here
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomSecondaryButton(
                      label: "Buy Now",
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Checkout(
                                    productName: productName!,
                                    productImage: productImage!,
                                    price: getTotalPrice()
                                        .toString(), //priceValue.toString(),
                                    categoryId: categoryId!,
                                    description: description!,
                                    token: widget.token,
                                    productId: productId!,
                                    quantity: quantity,
                                  )))),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Other Categories',
                    style: AppStyle.cardSubtitle,
                    textAlign: TextAlign.start,
                  )),
              BlocProvider(
                create: (_) => sl<EshopGetAllProductBloc>()
                  ..add(EshopGetProductsEvent(
                      EshopTokenReqEntity(token: widget.token ?? ""))),
                child: BlocConsumer<EshopGetAllProductBloc, EshopState>(
                  builder: (context, state) {
                    if (state is EshopLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      );
                    } else if (state is EshopGetProductsDone) {
                      // Check if the schedule data is empty
                      if (state.resp.similar_goods.data == null ||
                          state.resp.similar_goods.data.isEmpty) {
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
                            itemCount: state.resp.similar_goods.data.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              childAspectRatio:
                                  1.11, // Adjust for width-to-height ratio
                              mainAxisSpacing: 0, // Removes vertical spacing
                              crossAxisSpacing: 0, // Removes horizontal spacing
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              var product =
                                  state.resp.similar_goods.data[index];
                              return CategoryItem(
                                  productName: product.name,
                                  productImage: product.image,
                                  price: product.price.toString(),
                                  token: widget.token,
                                  productId: product.id,
                                  onProductSelected: () => onProductSelected(
                                        newProductName: product.name,
                                        newProductImage: product.image,
                                        newPrice: product.price.toString(),
                                        newCategoryId:
                                            product.category_id.toString(),
                                        newDescription: product.description,
                                        newProductId: product.id,
                                      ),
                                  categoryId: widget.categoryId,
                                  description: widget.description);
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
                      if (state.message.contains("401")) {
                        Navigator.pushNamed(context, "/login");
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    setState(() {
      showQty = true;
    });
  }
}

class CategoryItem extends StatefulWidget {
  final String productImage, productName, price, token, categoryId, description;
  final int productId;
  final VoidCallback onProductSelected;
  CategoryItem({
    super.key,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.token,
    required this.productId,
    required this.onProductSelected,
    required this.categoryId,
    required this.description,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  DB_cart db_cart = DB_cart();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onProductSelected,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
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
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
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
                          style: AppStyle.cardfooter,
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
                            'assets/images/naira.png',
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            widget.price,
                            style: TextStyle(
                                color: Colors.green.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
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
          ),
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
          content: Text(
            'Product added to cart successfully!',
            style: AppStyle.cardfooter,
          ),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      // Show failure feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add product to cart.',
            style: AppStyle.cardfooter,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
