import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/widgets/advert.dart';

class VehicleEngineLockPage extends StatefulWidget {
  const VehicleEngineLockPage({super.key});

  @override
  State<VehicleEngineLockPage> createState() => _VehicleEngineLockPageState();
}

class _VehicleEngineLockPageState extends State<VehicleEngineLockPage> {
  @override
  Widget build(BuildContext context) {
    bool viewAdvert = false;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text("Engine Lock", style: AppStyle.cardSubtitle,)],
        ),
      ),
      body: Column(
        children: [
          viewAdvert == false
              ? Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Check Latest Stock',
                                style: AppStyle.cardfooter
                                    .copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          viewAdvert = true;
                        });
                      },
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 15,
                      ))
                ],
              ),
            ),
          )
              : Stack(children: [
            const Advert(),
            Positioned(
              right: 10,
              top: 0,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      viewAdvert = false;
                    });
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  )),
            )
          ]),
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 10),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       // mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         SizedBox(
          //             height: 100,
          //             width: 100,
          //             child: Image.asset("assets/images/car.png")),
          //         const Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Text(
          //                     "DM-GA-32-7615",
          //                     style: TextStyle(
          //                         fontSize: 20, fontWeight: FontWeight.w500),
          //                   ),
          //                   Text("3456789962309234345",
          //                       style: TextStyle(fontSize: 16)),
          //                 ],
          //               ),
          //               //Spacer(),
          //               Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Text(
          //                     "Device not support - BL 35434",
          //                     style: TextStyle(
          //                         fontSize: 20,
          //                         fontWeight: FontWeight.w400,
          //                     ),
          //                     softWrap: true,  // This ensures the text wraps to the next line if needed.
          //                   )),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
