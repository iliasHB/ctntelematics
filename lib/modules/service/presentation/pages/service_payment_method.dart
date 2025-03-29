import 'package:ctntelematics/core/model/token_req_entity.dart';
import 'package:ctntelematics/modules/service/presentation/bloc/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/payment_checkout.dart';

class ServicePaymentGateway extends StatelessWidget {
  final String fee, token, serviceId, phone, address, lga, state;
  const ServicePaymentGateway({
    super.key,
    required this.fee,
    required this.token,
    required this.serviceId,
    required this.phone,
    required this.address,
    required this.lga,
    required this.state,
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
              fee: fee,
              token: token,
              serviceId: serviceId,
              phone: phone,
              address: address,
              lga: lga,
              state: state)),
    ));
  }
}

class PaymentMethod extends StatefulWidget {
  final String fee, token, serviceId, phone, address, lga, state;
  const PaymentMethod({
    super.key,
    required this.fee,
    required this.token,
    required this.serviceId,
    required this.phone,
    required this.address,
    required this.lga,
    required this.state,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool isPaystackChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(
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
                          widget.fee,
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
                BlocConsumer<InitiateServicePaymentBloc, ServiceState>(
                  listener: (context, state) {
                    if (state is InitializePaymentDone) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PaymentCheckoutWebView(
                                  auth_url: state.resp.authorization_url,
                                  callbackUrl: 'https://www.goal.com/en-ng',
                                  token: widget.token,
                                  serviceId: widget.serviceId,
                                  phone: widget.phone,
                                  address: widget.address,
                                  lga: widget.lga,
                                  state: widget.state,
                                reference: state.resp.reference
                              )));
                    } else if (state is ServiceFailure) {
                      if (state.message.contains("Unauthenticated")) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (route) => false);
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is ServiceLoading) {
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
                                      "Please select a payment method.",
                                      style: AppStyle.cardfooter,
                                    ),
                                    backgroundColor: Colors.black,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                TokenReqEntity tokenReq = TokenReqEntity(
                                    token: widget.token,
                                    serviceId: widget.serviceId);
                                context
                                    .read<InitiateServicePaymentBloc>()
                                    .add(InitializePaymentEvent(tokenReq));
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
