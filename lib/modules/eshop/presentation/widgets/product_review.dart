import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductReview extends StatelessWidget {
  const ProductReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              child: Image.asset("assets/images/keg.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mobil 10W - 20 Fully Synthetic",
                  style: AppStyle.cardSubtitle,
                ),
                const Icon(CupertinoIcons.heart)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "\$ 500.00",
                style: AppStyle.cardSubtitle.copyWith(color: Colors.green)
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // const Row(
            //   children: [
            //     Text(
            //       "Rating",
            //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            //     ),
            //     Icon(
            //       Icons.star,
            //       color: Colors.yellow,
            //     ),
            //     Icon(
            //       Icons.star,
            //       color: Colors.yellow,
            //     ),
            //     Icon(
            //       Icons.star,
            //       color: Colors.yellow,
            //     ),
            //     Icon(
            //       Icons.star,
            //       color: Colors.yellow,
            //     )
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            const Text("It acts as a lubricant between moving parts reducing"
                " friction and preventing wear and tear on component "
                "like pistons, bearings and camshafts."),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topLeft,
                child: Text('Other Categories', style: AppStyle.cardSubtitle, textAlign: TextAlign.start,)),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  child: Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, index) {
                          return const CategoryItem(
                              productImage: 'assets/images/shampoo.png',
                              productName: 'Lubricant',
                              price: '500');
                        }),
                  ),
                ))
              ],
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/paymentMethod"),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Buy",
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String productImage, productName, price;
  const CategoryItem(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.price});

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
      ],
    );
  }
}
