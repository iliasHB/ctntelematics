// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class VehicleInfoPage extends StatelessWidget {
//   const VehicleInfoPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Row(
//             children: [
//               Text(
//                 "Vehicle Info",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           actions: const [
//             Padding(
//             padding: EdgeInsets.only(right: 8.0),
//             child: Icon(Icons.refresh),
//           )],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Card(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset("assets/images/car.png"),
//                       Center(
//                           child: Text(
//                             "DM-GA-32-7615",
//                             style: TextStyle(
//                                 fontSize: 25, color: Colors.green.shade300),
//                           )),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Card(
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Row(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       CupertinoIcons
//                                           .antenna_radiowaves_left_right,
//                                       size: 30,
//                                       color: Colors.green.shade300,
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     const Column(
//                                       children: [
//                                         Text("8000",
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.w500)),
//                                         Text(
//                                           "RPM",
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w500),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.gas_meter_outlined,
//                                       size: 30,
//                                       color: Colors.green.shade300,
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     const Column(
//                                       children: [
//                                         Text("40",
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.w500)),
//                                         Text(
//                                           "Liters",
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w500),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.speed_rounded,
//                                       size: 30,
//                                       color: Colors.green.shade300,
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     const Column(
//                                       children: [
//                                         Text("0",
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.w500)),
//                                         Text(
//                                           "KM/H",
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w500),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           const CircleAvatar(
//                             backgroundColor: Colors.red,
//                             radius: 5,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 const Text(
//                                   "Offline ",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 18),
//                                 ),
//                                 Text(
//                                   "20min 39s  ",
//                                   style: TextStyle(
//                                     color: Colors.redAccent.shade100,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           //Spacer(),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 const Text(
//                                   "Expire ",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 18),
//                                 ),
//                                 Text(
//                                   "On Unlimited",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.green.shade200),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           child: const Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Address ",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500, fontSize: 20),
//                               ),
//                               Text(
//                                 "123 Madison Avenue, New York, NY 10016",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 550,
//                 child: GridView.count(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 5.0,
//                   crossAxisSpacing: 5.0,
//                   children: [
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Coolant Temperature",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   CupertinoIcons.thermometer,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "60 C",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Ambient Air Temperature",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   CupertinoIcons.thermometer,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "40 C",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 " Engines Load",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.lan,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "47 %",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Engines Locked",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.key,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "49 C",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Engines Level",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.gas_meter_outlined,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "40 L",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "\nGPS LeveL",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   CupertinoIcons.location_solid,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "0",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "\nGSM Level",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.key,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "49 %",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "\nIgnition",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.vpn_key_rounded,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "OFF",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Total Mileage ECU",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.track_changes_outlined,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Text(
//                                 "0",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w400, fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Number of DCT",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.key,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "49 %",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Odometer",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.key,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "32650 Km",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Unplug Status",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.connect_without_contact,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "0",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Battery Voltage",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.battery_5_bar_outlined,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "40 V",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "RPM",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   CupertinoIcons.dot_radiowaves_left_right,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "8000 r/mn",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Distance since code clear",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.social_distance,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "320 km",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Module voltage control",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   Icons.warning,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "On",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Center(
//                               child: Text(
//                                 "Barometer Pressure",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.green.shade200,
//                                 child: const Icon(
//                                   CupertinoIcons.drop_triangle,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Flexible(
//                                 child: Text(
//                                   "30 N/A",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400, fontSize: 18),
//                                   softWrap: true,  // This ensures the text wraps to the next line if needed.
//                                   overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
//                                   maxLines: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
