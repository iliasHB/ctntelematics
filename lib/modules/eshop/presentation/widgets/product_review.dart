import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../bloc/eshop_bloc.dart';

class ProductReview extends StatefulWidget {
  const ProductReview({super.key});

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int quantity = 1; // Move quantity here so it persists across widget rebuilds
  bool showQty = false;
  @override
  Widget build(BuildContext context) {

    // Retrieve arguments passed from the previous page
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // Access individual fields
    final productName = arguments['productName'];
    final productImage = arguments['productImage'];
    final price = double.parse(arguments['price']);
    final categoryId = arguments['categoryId'];
    final description = arguments['description'];
    final token = arguments['token'];

    void _buyNow() {
      Navigator.pushNamed(context, "/checkout", arguments: {
        'productName': productName,
        'productImage': productImage,
        'price': price,
        'quantity': quantity,
      });
    }

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
                    'https://ecom.verifycentre.com'+productImage,
                    headers: {'Authorization': token},
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
                  child: Text(
                    "description: $description",
                    style: AppStyle.cardfooter,
                    textAlign: TextAlign.start,
                  )),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Product: $productName",
                    style: AppStyle.cardSubtitle,
                  ),
                  const Icon(CupertinoIcons.heart)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(price.toString(), style: AppStyle.cardSubtitle),
              ),
          
              SizedBox(
                height: 20,
              ),
          
              // Quantity Controls
              showQty == false ? Container() : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quantity:", style: AppStyle.cardSubtitle),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: quantity > 1
                            ? () {
                                setState(() => quantity--);
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        label: const SizedBox(), // Remove the label
                        style: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.zero, // Remove padding around the icon
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                2), // Minimized border radius
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('$quantity', style: AppStyle.cardSubtitle),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            double pri = price + price;
                            print("price: $pri");
                            quantity++;
                          });
          
                        },
                        icon: const Icon(Icons.add),
                        label: const SizedBox(), // Remove the label
                        style: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.zero, // Remove padding around the icon
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
              SizedBox(
                height: 10,
              ),
              // Action Buttons
              Row(children: [
                showQty == false ? Expanded(
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Add to Cart",
                          style: AppStyle.cardSubtitle
                              .copyWith(color: Colors.green[800])),
                    ),
                  ),
                ) : OutlinedButton(onPressed: (){
                  setState(() {
                    quantity = 1;
                    showQty = false;
                  });
          
                }, child: Icon(Icons.delete, color: Colors.red,)),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _buyNow,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Buy Now",
                          style: AppStyle.cardSubtitle
                              .copyWith(color: Colors.green)),
                    ),
                  ),
                ),
              ]),
              SizedBox(
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
                      EshopTokenReqEntity(token: token ?? ""))),
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
                                  0.9, // Adjust for width-to-height ratio
                              mainAxisSpacing: 0, // Removes vertical spacing
                              crossAxisSpacing: 0, // Removes horizontal spacing
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryItem(
                                productName: state.resp.products.data[index].name,
                                productImage:
                                    state.resp.products.data[index].image,
                                price: state.resp.products.data[index].price
                                    .toString(),
                                token: token
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

class CategoryItem extends StatelessWidget {
  final String productImage, productName, price, token;
  const CategoryItem(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.price, required this.token});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.network(
                    'https://ecom.verifycentre.com$productImage',
                    headers: {'Authorization': token},
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
      ],
    );
  }
}
