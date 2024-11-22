import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Saved Card", style: TextStyle(fontSize: 16,),),
              Image.asset("assets/images/atm.png"),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 12,
                    child: const Icon(CupertinoIcons.add, size: 15, color: Colors.white,),
                  ),
                  const SizedBox(width: 5,),
                  const Text("Add New Card",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

                ],
              ),
              const SizedBox(height: 20,),
              const Text("Choose choice of payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/images/Vector.png"),
                        ),
                        const SizedBox(width: 10,),
                        const Text("Bank Transfers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                      ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset("assets/images/Paystack.png"),
                          ),
                          const SizedBox(width: 10,),
                          const Text("Paystack", style: TextStyle(fontSize: 16),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset("assets/images/Flutterwave.png"),
                          ),
                          const SizedBox(width: 10,),
                          const Text("Flutterwave", style: TextStyle(fontSize: 16),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset("assets/images/Paypal.png"),
                          ),
                          const SizedBox(width: 10,),
                          const Text("Paypal", style: TextStyle(fontSize: 16),)
                        ],
                      ),
                    ),
                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Amount to pay", style: TextStyle(fontSize: 18),),
                            const SizedBox(width: 10,),
                            Text("\$500.00", style: TextStyle(fontSize: 18, color: Colors.green.shade300), textAlign: TextAlign.center,)
                          ],
                        ),
                        const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, "/paymentSuccess"),
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text("Proceed to pay", style: TextStyle(fontSize: 18),),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
