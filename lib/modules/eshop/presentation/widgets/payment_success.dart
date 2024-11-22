import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Spacer(),
            const Spacer(),
            const Icon(Icons.check, size: 150, color: Colors.green,),
            const SizedBox(height: 30,),
            const Text("Payment Successful", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            const Text("Your ordered is confirmed. You will receive a confirmation email shortly with your order details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: ()=>Navigator.pushNamed(context, "/bottomNav"),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Continue Shopping", style: TextStyle(fontSize: 18),),
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
