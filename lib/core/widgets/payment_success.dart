import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/theme/app_style.dart';

class PaymentSuccess extends StatelessWidget {
  final String? pageRoute, desc;
  const PaymentSuccess({super.key, this.pageRoute, this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.check,
              size: 150,
              color: Colors.green,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Payment Successful",
              style: AppStyle.cardTitle
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              pageRoute == "service"
                  ? desc!
                  : "Your ordered is confirmed. You will receive a confirmation email shortly with your order details",
              style: AppStyle.cardTitle.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/bottomNav"),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Continue",
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
