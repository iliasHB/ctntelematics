import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entitties/req_entities/initiate_payment_req_entity.dart';
import '../bloc/eshop_bloc.dart';
import 'checkout.dart';

class PaymentGateway extends StatelessWidget {
  final String email,
      quantity,
      contact,
      address,
      locationId,
      productId,
      token,
      price;
  const PaymentGateway({
    super.key,
    required this.email,
    required this.quantity,
    required this.contact,
    required this.address,
    required this.locationId,
    required this.productId,
    required this.token,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
      alignment: Alignment.topCenter,
      child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.65),
          width: double.infinity,
          margin: const EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: PaymentMethod(
              email: email,
              quantity: quantity,
              contact: contact,
              address: address,
              locationId: locationId,
              productId: productId,
              token: token,
              price: price)),
    ));
  }
}

class PaymentMethod extends StatefulWidget {
  final String email;
  final String quantity;
  final String contact;
  final String address;
  final String locationId;
  final String productId;
  final String token;
  final String price;
  PaymentMethod(
      {super.key,
      required this.email,
      required this.quantity,
      required this.contact,
      required this.address,
      required this.locationId,
      required this.productId,
      required this.token,
      required this.price});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool isPaystackChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/atm.png"),
            const Text(
              "Choose choice of payment",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/Paystack.png"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Paystack", style: AppStyle.cardSubtitle),
                      const Spacer(),
                      Checkbox(
                        value: isPaystackChecked,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            isPaystackChecked = value ?? false;
                          });
                        },
                      ),

                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Amount to pay", style: AppStyle.cardSubtitle),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/naira.png",
                          height: 20,
                          width: 20,
                        ),
                        Text(
                          widget.price,
                          style: AppStyle.cardSubtitle
                              .copyWith(color: Colors.green),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<InitiatePaymentBloc, EshopState>(
                  listener: (context, state) {
                    if (state is InitiatePaymentDone) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PayStackWebView(
                                    auth_url: state.resp.authorization_url,
                                    callbackUrl: '',
                                  )));
                    } else if (state is EshopFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is EshopLoading) {
                      return const Center(
                          child: CustomContainerLoadingButton());
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: CustomPrimaryButton(
                            label: 'Proceed to pay',
                            onPressed: () {
                              if (!isPaystackChecked) {
                                // Show snackbar if checkbox is not checked
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please select a payment method.", style: AppStyle.cardfooter,),
                                    backgroundColor: Colors.black,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                // / if (_formKey.currentState?.validate() ?? false) {
                                final loginReqEntity = InitiatePaymentReqEntity(
                                  email: widget.email,
                                  quantity: widget.quantity,
                                  contact_phone: widget.contact,
                                  delivery_address: widget.address,
                                  location_id: widget.locationId,
                                  product_id: widget.productId,
                                );
                                context
                                    .read<InitiatePaymentBloc>()
                                    .add(InitiatePaymentEvent(loginReqEntity));
                              }

                              // }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                CustomSecondaryButton(
                    label: 'Cancel', onPressed: () => Navigator.pop(context))
              ],
            )
          ],
        )),
      ),
    );
  }

}
