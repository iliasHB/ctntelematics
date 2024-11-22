import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/math_util.dart';
import '../../../../core/widgets/advert.dart';
import '../../../../core/widgets/appBar.dart';

// class ProfilePage extends StatelessWidget {
//   final String firstname;
//   const ProfilePage(this.firstname, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final args =
//     // ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//     return Scaffold(
//       appBar: appBar(firstname: firstname == null ? "" : firstname, context),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Advert(),
//               Container(
//                 height: getVerticalSize(500),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 10, // Adjust spacing between grid items
//                   crossAxisSpacing: 10,
//                   childAspectRatio: 1.5, //
//                   children: const [
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.logout, color: Colors.green,),
//                           Text("Report")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(CupertinoIcons.map_pin_ellipse, color: Colors.green,),
//                           Text("Geofencing Setting")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.ac_unit_sharp, color: Colors.green,),
//                           Text("Maintenance")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.support_agent, color: Colors.green,),
//                           Text("Support")
//                         ],
//                       ),
//                     ),
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.wine_bar_outlined, color: Colors.green,),
//                           Text("Refer a Friend")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.lock, color: Colors.green,),
//                           Text("Change Password")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.notifications, color: Colors.green,),
//                           Text("Notification")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.payment, color: Colors.green,),
//                           Text("Pay  Now")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.bedroom_baby_outlined, color: Colors.green,),
//                           Text("Terms of Use")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.policy, color: Colors.green,),
//                           Text("Privacy Policy")
//                         ],
//                       ),
//                     ),
//
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.payment_sharp, color: Colors.green,),
//                           Text("Expenses")
//                         ],
//                       ),
//                     ),
//                     Card(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.logout, color: Colors.green,),
//                           Text("Logout")
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }