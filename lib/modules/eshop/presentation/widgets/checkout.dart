import 'dart:convert';
import 'dart:io';

import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/core/widgets/custom_input_decorator.dart';
import 'package:ctntelematics/modules/eshop/presentation/widgets/payment_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/initiate_payment_req_entity.dart';
import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../bloc/eshop_bloc.dart';

class Checkout extends StatefulWidget {
  final String productName, productImage, price, categoryId, description, token;
  final int productId, quantity;
  const Checkout(
      {super.key,
      required this.productName,
      required this.productImage,
      required this.price,
      required this.categoryId,
      required this.description,
      required this.token,
      required this.productId,
      required this.quantity});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption = "Delivery";
  PrefUtils prefUtils = PrefUtils();
  String? email;
  String? _selectedVendor;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the value from the parent widget
    _getAuthUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getAuthUser() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      if (authUser != null && authUser.isNotEmpty) {
        // first_name = authUser[0].isEmpty ? null : authUser[0];
        // last_name = authUser[1].isEmpty ? null : authUser[1];
        // middle_name = authUser[2].isEmpty ? null : authUser[2];
        email = authUser[3].isEmpty ? null : authUser[3];
        // token = authUser[4].isEmpty ? null : authUser[4];
        // userId = authUser[5].isEmpty ? null : authUser[5];
        // user_type = authUser[7].isEmpty ? null : authUser[7];
      }
    });
    _quantityController = TextEditingController(text: widget.quantity.toString());
    _emailController = TextEditingController(text: email);
    _amountController = TextEditingController(text: widget.price);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from the previous page
    // final arguments =
    // ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // // Access individual fields
    // final productName = arguments['productName'];
    // final productImage = arguments['productImage'];
    // // final price = double.parse(arguments['price']);
    // final categoryId = arguments['categoryId'];
    // final description = arguments['description'];
    // final token = arguments['token'];

    // void _buyNow() {
    //   Navigator.pushNamed(context, "/checkout", arguments: {
    //     'productName': productName,
    //     'productImage': productImage,
    //     'price': price,
    //     'quantity': quantity,
    //     'token': token
    //   });
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppStyle.cardSubtitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          "Delivery",
                          style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                        ),
                        fillColor:MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.green; // Color when selected
                          }
                          return Colors.grey; // Default color
                        }),
                        value: "Delivery",
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Email',
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration:
                            customInputDecoration(labelText: '', hintText: ''),
                        // InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[200],
                        //     hintText: 'abc@gmail.com',
                        //     hintStyle: AppStyle.cardfooter,
                        //     border: const OutlineInputBorder(
                        //         borderSide: BorderSide.none)
                        // ),
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Email address is empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Contact',
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                      ),
                      TextFormField(
                        controller: _contactController,
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.phone,
                        decoration: customInputDecoration(
                          labelText: '',
                          hintText: 'Enter your phone contact',
                          prefixIcon: Icon(Icons.phone, color: Colors.green),
                        ),
                        // InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[200],
                        //     hintText: 'Enter your contact number',
                        //     hintStyle: AppStyle.cardfooter,
                        //     border: const OutlineInputBorder(
                        //         borderSide: BorderSide.none)),

                        onChanged: (value) {
                          setState(() {
                            _contactController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Phone number is empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocProvider(
                        create: (_) => sl<DeliveryLocationBloc>()
                          ..add(const DeliveryLocationEvent(EshopTokenReqEntity())),
                        child: BlocConsumer<DeliveryLocationBloc, EshopState>(
                          builder: (context, state) {
                            if (state is EshopLoading) {
                              return const Center(
                                child: CustomContainerLoadingButton()
                              );
                            } else if (state is DeliveryLocationDone) {
                              // Check if vehicle data is null or empty
                              if (state.resp.data == null ||
                                  state.resp.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No location available',
                                    style: AppStyle.cardfooter,
                                  ),
                                );
                              }

                              return DropdownButtonFormField<String>(
                                value: _selectedVendor ??=
                                    (state.resp.data!.first.id.toString() ?? "Unknown Location") ,  // Default to the first VIN
                                items: state.resp.data!
                                    .map<DropdownMenuItem<String>>((location) {
                                  return DropdownMenuItem<String>(
                                    value: location.id.toString(), // Pass the VIN to the API
                                    child: Text(
                                      location.name ?? "Unknown location", // Display the brand
                                      style:
                                      AppStyle.cardfooter.copyWith(fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedVendor = value; // Update selected VIN
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Choose location',
                                  labelStyle: AppStyle.cardfooter,
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  prefixIcon: Icon(CupertinoIcons.map_pin_ellipse, color: Colors.green,)
                                ),
                              );
                            } else {
                              return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Unable to load vehicles',
                                        style: AppStyle.cardfooter.copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            BlocProvider.of<DeliveryLocationBloc>(context)
                                                .add(const DeliveryLocationEvent(EshopTokenReqEntity()));
                                          },
                                          icon: const Icon(Icons.refresh, color: Colors.green,))
                                      // CustomSecondaryButton(
                                      //     label: 'Refresh',
                                      //     onPressed: () {
                                      //       BlocProvider.of<ProfileVehiclesBloc>(context)
                                      //           .add(ProfileVehicleEvent(TokenReqEntity(
                                      //           token: widget.token ?? "",
                                      //           contentType: 'application/json')));
                                      //     })
                                    ],
                                  ));
                            }
                          },
                          listener: (context, state) {
                            if (state is EshopFailure) {
                              if(state.message.contains("Unauthenticated")){
                                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Delivery Address',
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                      ),
                      TextFormField(
                        controller: _addressController,
                        cursorColor: Colors.green,
                        decoration: customInputDecoration(
                          labelText: "",
                          hintText: 'Enter your address',
                          prefixIcon:
                              const Icon(CupertinoIcons.house, color: Colors.green),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _addressController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Address is empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Quantity',
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                      ),
                      TextFormField(
                        controller: _quantityController,
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.number,
                        decoration: customInputDecoration(
                            labelText: '',
                            hintText: '',
                            prefixIcon:
                                const Icon(Icons.balance, color: Colors.green)),
                        // InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[200],
                        //     hintText: 'Enter the number of item',
                        //     hintStyle: AppStyle.cardfooter,
                        //     border: const OutlineInputBorder(
                        //         borderSide: BorderSide.none)),
                        onChanged: (value) {
                          setState(() {
                            _quantityController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Quantity is empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Amount',
                        style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                      ),
                      TextFormField(
                        controller: _amountController,
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.number,
                        enabled: false,
                        decoration: customInputDecoration(
                            labelText: '',
                            hintText: '',
                            prefixIcon:
                                const Icon(Icons.wallet, color: Colors.green)),
                        // InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[200],
                        //     hintText: 'Enter the number of item',
                        //     hintStyle: AppStyle.cardfooter,
                        //     border: const OutlineInputBorder(
                        //         borderSide: BorderSide.none)),
                        onChanged: (value) {
                          setState(() {
                            _amountController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Amount is empty";
                          }
                          return null;
                        },
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),

              // CustomPrimaryButton(
              //   label: 'Checkout',
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
              // ),

              CustomPrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    String locationId = "1";
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(context, MaterialPageRoute(builder: (_)
                      => PaymentGateway(
                          email: _emailController.text.trim(),
                          quantity: widget.quantity.toString(),
                          contact: _contactController.text.trim(),
                          address: _addressController.text.trim(),
                          locationId: locationId,
                          productId: widget.productId.toString(),
                          token: widget.token,
                          price: widget.price
                      )));
                      // PaymentGateway.showPaymentTypeModal(
                      //     context,
                      //     _emailController.text.trim(),
                      //     widget.quantity.toString(),
                      //     _contactController.text.trim(),
                      //     _addressController.text.trim(),
                      //     locationId,
                      //     widget.productId.toString(),
                      //     widget.token,
                      //     widget.price
                      // );
                    }
                  }) //Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentMethod())))
            ],
          ),
        ),
      ),
    );
  }
}

class PayStackWebView extends StatefulWidget {
  final String auth_url, callbackUrl;
  const PayStackWebView(
      {super.key, required this.auth_url, required this.callbackUrl});

  @override
  State<PayStackWebView> createState() => _PayStackWebViewState();
}

class _PayStackWebViewState extends State<PayStackWebView> {
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
          final host = Uri.parse(navigation.url).host;
          final address = Uri.parse(navigation.url);
          print("host: ${host}");
          print("address: ${address}");
          debugPrint(">>>>>>>> callbackUrl: ${widget.callbackUrl}");
          if (host.contains('https://standard.paystack.co/close')) {
            //Navigator.of(context).pop(); //close webview
          }

          /// If paystack checkout page failed to close automatically after successful payment,
          /// Please check https://memmcol.com website if it up and running,
          /// if not up and running. There are two solutions
          /// 1. Visit your host provider for continue hosting of the website -> https://memmcol.com
          /// 2. change the website url to any live working url from the node backend (paystackInitialization.js file)
          /// then login to paystack dashboard and change the url to the same things you set in the node backend as well.
          /// This url is known as callback url and paystack uses the url to close the checkout page automatically when transaction is complete.
          if (host.toString().contains(widget.callbackUrl) ||
              address.toString().contains(widget.callbackUrl)) {
            print("-----------------verify payment here--------------------");
            Navigator.of(context).pop();

            /// Below class instance and method, verify user payment and generate token for the user.
            /// The class instance and method below is called only if the checkout page close by itself on successful payment
            // VerifyOnServer verifyOnServer = VerifyOnServer(widget.reference,
            //     widget.meterno, widget.isDual, widget.email, reprint);
            // verifyOnServer.VerifyPaystackPayment();
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

///------

// const String kNavigationExamplePage = '''
// <!DOCTYPE html><html>
// <head><title>Navigation Delegate Example</title></head>
// <body>
// <p>
// The navigation delegate is set to block navigation to the youtube website.
// </p>
// <ul>
// <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
// <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
// </ul>
// </body>
// </html>
// ''';
//
// const String kLocalExamplePage = '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body>
//
// <h1>Local demo page</h1>
// <p>
//   This is an example page used to demonstrate how to load a local file or HTML
//   string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
//   webview</a> plugin.
// </p>
//
// </body>
// </html>
// ''';
//
// const String kTransparentBackgroundPage = '''
//   <!DOCTYPE html>
//   <html>
//   <head>
//     <title>Transparent background test</title>
//   </head>
//   <style type="text/css">
//     body { background: transparent; margin: 0; padding: 0; }
//     #container { position: relative; margin: 0; padding: 0; width: 100vw; height: 100vh; }
//     #shape { background: red; width: 200px; height: 200px; margin: 0; padding: 0; position: absolute; top: calc(50% - 100px); left: calc(50% - 100px); }
//     p { text-align: center; }
//   </style>
//   <body>
//     <div id="container">
//       <p>Transparent background test</p>
//       <div id="shape"></div>
//     </div>
//   </body>
//   </html>
// ''';
//
// const String kLogExamplePage = '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body onload="console.log('Logging that the page is loading.')">
//
// <h1>Local demo page</h1>
// <p>
//   This page is used to test the forwarding of console logs to Dart.
// </p>
//
// <style>
//     .btn-group button {
//       padding: 24px; 24px;
//       display: block;
//       width: 25%;
//       margin: 5px 0px 0px 0px;
//     }
// </style>
//
// <div class="btn-group">
//     <button onclick="console.error('This is an error message.')">Error</button>
//     <button onclick="console.warn('This is a warning message.')">Warning</button>
//     <button onclick="console.info('This is a info message.')">Info</button>
//     <button onclick="console.debug('This is a debug message.')">Debug</button>
//     <button onclick="console.log('This is a log message.')">Log</button>
// </div>
//
// </body>
// </html>
// ''';
//
// class WebViewExample extends StatefulWidget {
//   const WebViewExample({super.key});
//
//   @override
//   State<WebViewExample> createState() => _WebViewExampleState();
// }
//
// class _WebViewExampleState extends State<WebViewExample> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // #docregion platform_features
//     late final PlatformWebViewControllerCreationParams params;
//     // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//     //   params = WebKitWebViewControllerCreationParams(
//     //     allowsInlineMediaPlayback: true,
//     //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//     //   );
//     // } else {
//       params = const PlatformWebViewControllerCreationParams();
//     // }
//
//     final WebViewController controller =
//     WebViewController.fromPlatformCreationParams(params);
//     // #enddocregion platform_features
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onHttpError: (HttpResponseError error) {
//             debugPrint('Error occurred on page: ${error.response?.statusCode}');
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//           onHttpAuthRequest: (HttpAuthRequest request) {
//             openDialog(request);
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(Uri.parse('https://flutter.dev'));
//
//     // setBackgroundColor is not currently supported on macOS.
//     if (kIsWeb || !Platform.isMacOS) {
//       controller.setBackgroundColor(const Color(0x80000000));
//     }
//
//     _controller = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green,
//       appBar: AppBar(
//         title: const Text('Flutter WebView example'),
//         // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//         actions: <Widget>[
//           NavigationControls(webViewController: _controller),
//           SampleMenu(webViewController: _controller),
//         ],
//       ),
//       body: WebViewWidget(controller: _controller),
//       floatingActionButton: favoriteButton(),
//     );
//   }
//
//   Widget favoriteButton() {
//     return FloatingActionButton(
//       onPressed: () async {
//         final String? url = await _controller.currentUrl();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Favorited $url')),
//           );
//         }
//       },
//       child: const Icon(Icons.favorite),
//     );
//   }
//
//   Future<void> openDialog(HttpAuthRequest httpRequest) async {
//     final TextEditingController usernameTextController =
//     TextEditingController();
//     final TextEditingController passwordTextController =
//     TextEditingController();
//
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Username'),
//                   autofocus: true,
//                   controller: usernameTextController,
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   controller: passwordTextController,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             // Explicitly cancel the request on iOS as the OS does not emit new
//             // requests when a previous request is pending.
//             TextButton(
//               onPressed: () {
//                 httpRequest.onCancel();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 httpRequest.onProceed(
//                   WebViewCredential(
//                     user: usernameTextController.text,
//                     password: passwordTextController.text,
//                   ),
//                 );
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Authenticate'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// enum MenuOptions {
//   showUserAgent,
//   listCookies,
//   clearCookies,
//   addToCache,
//   listCache,
//   clearCache,
//   navigationDelegate,
//   doPostRequest,
//   loadLocalFile,
//   loadFlutterAsset,
//   loadHtmlString,
//   transparentBackground,
//   setCookie,
//   logExample,
//   basicAuthentication,
// }
//
// class SampleMenu extends StatelessWidget {
//   SampleMenu({
//     super.key,
//     required this.webViewController,
//   });
//
//   final WebViewController webViewController;
//   late final WebViewCookieManager cookieManager = WebViewCookieManager();
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<MenuOptions>(
//       key: const ValueKey<String>('ShowPopupMenu'),
//       onSelected: (MenuOptions value) {
//         switch (value) {
//           case MenuOptions.showUserAgent:
//             _onShowUserAgent();
//           case MenuOptions.listCookies:
//             _onListCookies(context);
//           case MenuOptions.clearCookies:
//             _onClearCookies(context);
//           case MenuOptions.addToCache:
//             _onAddToCache(context);
//           case MenuOptions.listCache:
//             _onListCache();
//           case MenuOptions.clearCache:
//             _onClearCache(context);
//           case MenuOptions.navigationDelegate:
//             _onNavigationDelegateExample();
//           case MenuOptions.doPostRequest:
//             _onDoPostRequest();
//           case MenuOptions.loadLocalFile:
//             _onLoadLocalFileExample();
//           case MenuOptions.loadFlutterAsset:
//             _onLoadFlutterAssetExample();
//           case MenuOptions.loadHtmlString:
//             _onLoadHtmlStringExample();
//           case MenuOptions.transparentBackground:
//             _onTransparentBackground();
//           case MenuOptions.setCookie:
//             _onSetCookie();
//           case MenuOptions.logExample:
//             _onLogExample();
//           case MenuOptions.basicAuthentication:
//             _promptForUrl(context);
//         }
//       },
//       itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.showUserAgent,
//           child: Text('Show user agent'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.listCookies,
//           child: Text('List cookies'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.clearCookies,
//           child: Text('Clear cookies'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.addToCache,
//           child: Text('Add to cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.listCache,
//           child: Text('List cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.clearCache,
//           child: Text('Clear cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.navigationDelegate,
//           child: Text('Navigation Delegate example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.doPostRequest,
//           child: Text('Post Request'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadHtmlString,
//           child: Text('Load HTML string'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadLocalFile,
//           child: Text('Load local file'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadFlutterAsset,
//           child: Text('Load Flutter Asset'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           key: ValueKey<String>('ShowTransparentBackgroundExample'),
//           value: MenuOptions.transparentBackground,
//           child: Text('Transparent background example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.setCookie,
//           child: Text('Set cookie'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.logExample,
//           child: Text('Log example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.basicAuthentication,
//           child: Text('Basic Authentication Example'),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _onShowUserAgent() {
//     // Send a message with the user agent string to the Toaster JavaScript channel we registered
//     // with the WebView.
//     return webViewController.runJavaScript(
//       'Toaster.postMessage("User Agent: " + navigator.userAgent);',
//     );
//   }
//
//   Future<void> _onListCookies(BuildContext context) async {
//     final String cookies = await webViewController
//         .runJavaScriptReturningResult('document.cookie') as String;
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Text('Cookies:'),
//             _getCookieList(cookies),
//           ],
//         ),
//       ));
//     }
//   }
//
//   Future<void> _onAddToCache(BuildContext context) async {
//     await webViewController.runJavaScript(
//       'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
//     );
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Added a test entry to cache.'),
//       ));
//     }
//   }
//
//   Future<void> _onListCache() {
//     return webViewController.runJavaScript('caches.keys()'
//     // ignore: missing_whitespace_between_adjacent_strings
//         '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//         '.then((caches) => Toaster.postMessage(caches))');
//   }
//
//   Future<void> _onClearCache(BuildContext context) async {
//     await webViewController.clearCache();
//     await webViewController.clearLocalStorage();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Cache cleared.'),
//       ));
//     }
//   }
//
//   Future<void> _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(message),
//       ));
//     }
//   }
//
//   Future<void> _onNavigationDelegateExample() {
//     final String contentBase64 = base64Encode(
//       const Utf8Encoder().convert(kNavigationExamplePage),
//     );
//     return webViewController.loadRequest(
//       Uri.parse('data:text/html;base64,$contentBase64'),
//     );
//   }
//
//   Future<void> _onSetCookie() async {
//     await cookieManager.setCookie(
//       const WebViewCookie(
//         name: 'foo',
//         value: 'bar',
//         domain: 'httpbin.org',
//         path: '/anything',
//       ),
//     );
//     await webViewController.loadRequest(Uri.parse(
//       'https://httpbin.org/anything',
//     ));
//   }
//
//   Future<void> _onDoPostRequest() {
//     return webViewController.loadRequest(
//       Uri.parse('https://httpbin.org/post'),
//       method: LoadRequestMethod.post,
//       headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
//       body: Uint8List.fromList('Test Body'.codeUnits),
//     );
//   }
//
//   Future<void> _onLoadLocalFileExample() async {
//     final String pathToIndex = await _prepareLocalFile();
//     await webViewController.loadFile(pathToIndex);
//   }
//
//   Future<void> _onLoadFlutterAssetExample() {
//     return webViewController.loadFlutterAsset('assets/www/index.html');
//   }
//
//   Future<void> _onLoadHtmlStringExample() {
//     return webViewController.loadHtmlString(kLocalExamplePage);
//   }
//
//   Future<void> _onTransparentBackground() {
//     return webViewController.loadHtmlString(kTransparentBackgroundPage);
//   }
//
//   Widget _getCookieList(String cookies) {
//     if (cookies == '""') {
//       return Container();
//     }
//     final List<String> cookieList = cookies.split(';');
//     final Iterable<Text> cookieWidgets =
//     cookieList.map((String cookie) => Text(cookie));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: cookieWidgets.toList(),
//     );
//   }
//
//   static Future<String> _prepareLocalFile() async {
//     final String tmpDir = (await getTemporaryDirectory()).path;
//     final File indexFile = File(
//         <String>{tmpDir, 'www', 'index.html'}.join(Platform.pathSeparator));
//
//     await indexFile.create(recursive: true);
//     await indexFile.writeAsString(kLocalExamplePage);
//
//     return indexFile.path;
//   }
//
//   Future<void> _onLogExample() {
//     webViewController
//         .setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
//       debugPrint(
//           '== JS == ${consoleMessage.level.name}: ${consoleMessage.message}');
//     });
//
//     return webViewController.loadHtmlString(kLogExamplePage);
//   }
//
//   Future<void> _promptForUrl(BuildContext context) {
//     final TextEditingController urlTextController = TextEditingController();
//
//     return showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Input URL to visit'),
//           content: TextField(
//             decoration: const InputDecoration(labelText: 'URL'),
//             autofocus: true,
//             controller: urlTextController,
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 if (urlTextController.text.isNotEmpty) {
//                   final Uri? uri = Uri.tryParse(urlTextController.text);
//                   if (uri != null && uri.scheme.isNotEmpty) {
//                     webViewController.loadRequest(uri);
//                     Navigator.pop(context);
//                   }
//                 }
//               },
//               child: const Text('Visit'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   static getTemporaryDirectory() {}
// }
//
// class NavigationControls extends StatelessWidget {
//   const NavigationControls({super.key, required this.webViewController});
//
//   final WebViewController webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             if (await webViewController.canGoBack()) {
//               await webViewController.goBack();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No back history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () async {
//             if (await webViewController.canGoForward()) {
//               await webViewController.goForward();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No forward history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.replay),
//           onPressed: () => webViewController.reload(),
//         ),
//       ],
//     );
//   }
// }
