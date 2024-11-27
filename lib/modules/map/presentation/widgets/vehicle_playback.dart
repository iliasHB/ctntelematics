// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class VehiclePlayBackToolTip {
//   static showTopModal(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//           alignment: Alignment.topCenter,
//           child: Material(
//             child: Container(
//               height: 380,
//               width: double.infinity,
//               margin: const EdgeInsets.only(top: 50),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
//                     decoration: const BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.grey,
//                               offset: Offset(1, 1)
//                           )
//                         ]
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 0.0),
//                           child: InkWell(
//                             onTap: ()=>Navigator.pop(context),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.green.shade200,
//                               child: const Center(child: Icon(Icons.arrow_back_ios,)),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10,),
//                         const Text("PlayBack", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//                         const Spacer(),
//                         IconButton(
//                             onPressed: (){},
//                             icon: const Icon(CupertinoIcons.calendar))
//                       ],
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Text("DM-GA-32-7615", style: TextStyle(fontSize: 22),),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10.0),
//                     margin: const EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.filter_alt, size: 35,),
//                         SizedBox(width: 10,),
//                         Text("2024-08-31 00:00:00", style: TextStyle(fontSize: 18),),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10.0),
//                     margin: const EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.filter_alt, size: 35,),
//                         SizedBox(width: 10,),
//                         Text("2024-08-31 00:00:00", style: TextStyle(fontSize: 18),),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10.0),
//                     margin: const EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.filter_alt, size: 35,),
//                         SizedBox(width: 10,),
//                         Text("1min", style: TextStyle(fontSize: 18),),
//                         Spacer(),
//                         Icon(Icons.arrow_downward_outlined)
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0, -1),
//             end: Offset.zero,
//           ).animate(CurvedAnimation(
//             parent: anim1,
//             curve: Curves.easeInOut,
//           )),
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }
// }
