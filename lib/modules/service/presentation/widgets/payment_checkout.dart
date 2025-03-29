import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/modules/service/domain/entitties/req_entities/request_service_req_entity.dart';
import 'package:ctntelematics/modules/service/presentation/bloc/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/payment_success.dart';
import '../../../../service_locator.dart';

class PaymentCheckoutWebView extends StatefulWidget {
  final String auth_url,
      callbackUrl,
      token,
      serviceId,
      phone,
      address,
      lga,
      state,
      reference;
  const PaymentCheckoutWebView(
      {super.key,
      required this.auth_url,
      required this.callbackUrl,
      required this.token,
      required this.serviceId,
      required this.phone,
      required this.address,
      required this.lga,
      required this.state,
      required this.reference});

  @override
  State<PaymentCheckoutWebView> createState() => _PaymentCheckoutWebViewState();
}

class _PaymentCheckoutWebViewState extends State<PaymentCheckoutWebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  PrefUtils prefUtils = PrefUtils();
  List<String>? userMeterInfo;
  bool reprint = false;
  var meter_number;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          print('onPageStarted: $url');
          if (mounted) {
            setState(() {
              loadingPercentage = 0;
            });
          }
        },
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              loadingPercentage = progress;
            });
          }
        },
        onPageFinished: (url) {
          print('onPageFinished: $url');
          if (mounted) {
            setState(() {
              loadingPercentage = 100;
            });
          }
        },
        onNavigationRequest: (navigation) {
          final host = Uri.parse(navigation.url).host.trim();
          final address = Uri.parse(navigation.url.trim());
          print("host: ${host}");
          print("address: ${address}");
          print("reference: ${widget.reference}");
          debugPrint(">>>>>>>> callbackUrl: ${widget.callbackUrl}");
          if (host.contains('https://standard.paystack.co/close')) {
            //Navigator.of(context).pop(); //close webview
          }

          if (host.toString().contains(widget.callbackUrl) ||
              address.toString().contains(widget.callbackUrl)) {
            print("-----------------verify payment here--------------------");
            Navigator.of(context).pop();
            RequestServiceReqEntity requestServiceReqEntity =
                RequestServiceReqEntity(
                    service_id: widget.serviceId,
                    contact_phone: widget.phone,
                    location_state: widget.state,
                    location_lgvt: widget.lga,
                    payment_ref: widget.reference,
                    location_address: widget.address,
                    token: widget.token);
            BlocProvider(
                create: (_) => sl<RequestServiceBloc>()
                  ..add(RequestServiceEvent(requestServiceReqEntity)),
                child: BlocConsumer<GetServicesBloc, ServiceState>(
                    builder: (context, state) {
                  if (state is ServiceLoading) {
                    return const CustomContainerLoadingButton();
                  } else if (state is GetServicesDone) {
                    return const PaymentSuccess(
                      pageRoute: "service",
                      desc:
                          "Your request is confirmed. You will receive a confirmation email shortly with your order details",
                    );
                  }
                  return Center(
                      child:
                          Text("No record found", style: AppStyle.cardfooter));
                }, listener: (context, state) {
                  if (state is ServiceFailure) {
                    if (state.message.contains("Unauthenticated")) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login", (route) => false);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                }));
          }
          return NavigationDecision.navigate;
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.auth_url),
      )
      ..setUserAgent('Paystack;Webview');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: const Text('Paystack Payment'),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}
