import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption = "Delivery";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppStyle.cardSubtitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<String>(
                      title: Text("Delivery", style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
                      value: "Delivery",
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Email',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'abc@gmail.com',
                          hintStyle: AppStyle.cardfooter,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Contact',
                      style: AppStyle.cardSubtitle,
                    ),
                    TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: '0800000000000',
                          hintStyle: AppStyle.cardfooter,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Delivery Address',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: '8, Ajose Street, Lagos',
                          hintStyle: AppStyle.cardfooter,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Quantity',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                    ),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Enter the number of item',
                          hintStyle: AppStyle.cardfooter,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Checkout",
                          style: AppStyle.cardfooter.copyWith(fontSize: 16),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
