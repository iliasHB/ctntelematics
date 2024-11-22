import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/widgets/advert.dart';

class VehicleEngineLockPage extends StatelessWidget {
  const VehicleEngineLockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Text("Engine Lock")],
        ),
      ),
      body: Column(
        children: [
          const Advert(),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/car.png")),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "DM-GA-32-7615",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Text("3456789962309234345",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        //Spacer(),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Device not support - BL 35434",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                              ),
                              softWrap: true,  // This ensures the text wraps to the next line if needed.
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
