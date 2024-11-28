import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entitties/req_entities/initiate_payment_req_entity.dart';
import '../bloc/eshop_bloc.dart';
import 'checkout.dart';

class PaymentGateway {
  static showPaymentTypeModal(
      BuildContext context,
      String email,
      String quantity,
      String contact,
      String address,
      String locationId,
      String productId,
      String token,
      String price) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
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
                    price: price)

                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                //       decoration: const BoxDecoration(
                //           color: Colors.white,
                //           boxShadow: [
                //             BoxShadow(
                //                 color: Colors.grey,
                //                 offset: Offset(1, 1)
                //             )
                //           ]
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(left: 0.0),
                //             child: InkWell(
                //               onTap: ()=>Navigator.pop(context),
                //               child: CircleAvatar(
                //                 backgroundColor: Colors.green.shade200,
                //                 child: const Center(child: Icon(Icons.arrow_back_ios,)),
                //               ),
                //             ),
                //           ),
                //           const SizedBox(width: 10,),
                //           const Text("PlayBack", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                //           const Spacer(),
                //           IconButton(
                //               onPressed: (){},
                //               icon: const Icon(CupertinoIcons.calendar))
                //         ],
                //       ),
                //     ),
                //     const Padding(
                //       padding: EdgeInsets.all(10.0),
                //       child: Text("DM-GA-32-7615", style: TextStyle(fontSize: 22),),
                //     ),
                //     Container(
                //       padding: const EdgeInsets.all(10.0),
                //       margin: const EdgeInsets.all(10.0),
                //       decoration: BoxDecoration(
                //           color: Colors.grey.shade100
                //       ),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.filter_alt, size: 35,),
                //           SizedBox(width: 10,),
                //           Text("2024-08-31 00:00:00", style: TextStyle(fontSize: 18),),
                //         ],
                //       ),
                //     ),
                //     Container(
                //       padding: const EdgeInsets.all(10.0),
                //       margin: const EdgeInsets.all(10.0),
                //       decoration: BoxDecoration(
                //           color: Colors.grey.shade100
                //       ),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.filter_alt, size: 35,),
                //           SizedBox(width: 10,),
                //           Text("2024-08-31 00:00:00", style: TextStyle(fontSize: 18),),
                //         ],
                //       ),
                //     ),
                //     Container(
                //       padding: const EdgeInsets.all(10.0),
                //       margin: const EdgeInsets.all(10.0),
                //       decoration: BoxDecoration(
                //           color: Colors.grey.shade100
                //       ),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.filter_alt, size: 35,),
                //           SizedBox(width: 10,),
                //           Text("1min", style: TextStyle(fontSize: 18),),
                //           Spacer(),
                //           Icon(Icons.arrow_downward_outlined)
                //         ],
                //       ),
                //     )
                //   ],
                // ),
                ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class PaymentMethod extends StatelessWidget {
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
            // const Text(
            //   "Saved Card",
            //   style: TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
            Image.asset("assets/images/atm.png"),
            // Row(
            //   children: [
            //     CircleAvatar(
            //       backgroundColor: Colors.green.shade200,
            //       radius: 12,
            //       child: const Icon(CupertinoIcons.add, size: 15, color: Colors.white,),
            //     ),
            //     const SizedBox(width: 5,),
            //     const Text("Add New Card",
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            //
            //   ],
            // ),
            // const SizedBox(height: 20,),
            const Text(
              "Choose choice of payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Row(
                //   children: [
                //     CircleAvatar(
                //       backgroundColor: Colors.white,
                //       child: Image.asset("assets/images/Vector.png"),
                //     ),
                //     const SizedBox(width: 10,),
                //     const Text("Bank Transfers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                //   ],
                //   ),
                // ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                  ),
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
                          onChanged: (value) {
                            isPaystackChecked == value;
                          }),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                //   child: Row(
                //     children: [
                //       CircleAvatar(
                //         backgroundColor: Colors.white,
                //         child: Image.asset("assets/images/Flutterwave.png"),
                //       ),
                //       const SizedBox(width: 10,),
                //       const Text("Flutterwave", style: TextStyle(fontSize: 16),)
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                //   child: Row(
                //     children: [
                //       CircleAvatar(
                //         backgroundColor: Colors.white,
                //         child: Image.asset("assets/images/Paypal.png"),
                //       ),
                //       const SizedBox(width: 10,),
                //       const Text("Paypal", style: TextStyle(fontSize: 16),)
                //     ],
                //   ),
                // ),

                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Amount to pay",
                      style: AppStyle.cardSubtitle
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/naira.png", height: 20, width: 20,),
                        Text(
                          price,
                          style: AppStyle.cardSubtitle.copyWith(color: Colors.green),
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
                      print("url: ${state.resp.authorization_url}");
                      print("access_code: ${state.resp.access_code}");
                      print("success: ${state.resp.success}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PayStackWebView(
                                    auth_url: state.resp.authorization_url,
                                    callbackUrl: '',
                                  )));
                      print("success: ${state.resp.success}");

                      // print("token::::::${state.resp.token}");
                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   '/bottomNav',
                      //       (route) => false,
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(state.resp.success)));
                    } else if (state is EshopFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is EshopLoading) {
                      return const Center(
                        child: SizedBox(
                          height: 30, // Adjust the height
                          width: 30, // Adjust the width
                          child: CircularProgressIndicator(
                            strokeWidth: 3, // Adjust the thickness
                            color: Colors
                                .green, // Optional: Change the color to match your theme
                          ),
                        ),
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: CustomPrimaryButton(
                            label: 'Proceed to pay',
                            onPressed: () {
                              print('email: $email');
                              print('quantity: $quantity');
                              print('contact: $contact');
                              print('address: $address');
                              print('locationId: $locationId');
                              print('token: $token');

                              // if (_formKey.currentState?.validate() ?? false) {
                                final loginReqEntity = InitiatePaymentReqEntity(
                                    email: email,
                                    quantity: quantity,
                                    contact_phone: contact,
                                    delivery_address: address,
                                    location_id: locationId,
                                    product_id: productId,
                                    token: token);
                                context
                                    .read<InitiatePaymentBloc>()
                                    .add(InitiatePaymentEvent(loginReqEntity));
                              // }
                            },
                          ),
                        ),
                      ],
                    );

                    //   ElevatedButton(
                    //   onPressed: () {
                    //     if (_formKey.currentState?.validate() ?? false) {
                    //       final loginReqEntity = InitiatePaymentReqEntity(
                    //           email: _emailController.text.trim(),
                    //           quantity: widget.quantity.toString(),
                    //           contact_phone: _contactController.text.trim(),
                    //           delivery_address: _addressController.text.trim(),
                    //           location_id: '1',
                    //           product_id: widget.productId.toString(),
                    //           token: widget.token);
                    //       context
                    //           .read<InitiatePaymentBloc>()
                    //           .add(InitiatePaymentEvent(loginReqEntity));
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.green[100],
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //     child: Text(
                    //       'Checkout',
                    //       style: AppStyle.cardfooter
                    //           .copyWith(fontSize: 16, color: Colors.green[800]),
                    //     ),
                    //   ),
                    // );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                CustomSecondaryButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context))


                // Row(
                //   children: [
                //     Expanded(
                //         child: CustomPrimaryButton(
                //             label: 'Proceed to pay',
                //             onPressed: () {
                //               // Navigator.pushNamed(context, "/paymentSuccess")
                //             })
                //         // OutlinedButton(
                //         //     onPressed: () => Navigator.pushNamed(context, "/paymentSuccess"),
                //         //     child: const Padding(
                //         //       padding: EdgeInsets.all(15.0),
                //         //       child: Text("Proceed to pay", style: TextStyle(fontSize: 18),),
                //         //     )),
                //         ),
                //   ],
                // ),
              ],
            )
          ],
        )),
      ),
    );
  }
}
