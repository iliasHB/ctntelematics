import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/advert.dart';


class VehicleQuickSetting extends StatefulWidget {
  const VehicleQuickSetting({super.key});

  @override
  State<VehicleQuickSetting> createState() => _VehicleQuickSettingState();
}

class _VehicleQuickSettingState extends State<VehicleQuickSetting> {
  bool viewAdvert = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Quick Setting",
              style: AppStyle.cardSubtitle
            ),
          ],
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 30,
                    child: Image.asset("assets/images/car.png",),
                  ),
                  const SizedBox(width: 10,),
                  Text("Update Icon", style: AppStyle.cardfooter)
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 30,
                    child: const Icon(Icons.personal_injury, size: 30, color: Colors.white,)
                  ),
                  const SizedBox(width: 10,),
                  Text("Update Engine", style: AppStyle.cardfooter)
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 30,
                    child: const Icon(CupertinoIcons.news_solid, size: 30, color: Colors.white,)
                  ),
                  const SizedBox(width: 10,),
                  Text("Cost Per Liter", style: AppStyle.cardfooter)
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.green.shade200,
                      radius: 30,
                      child: const Icon(CupertinoIcons.timelapse, size: 30, color: Colors.white,)
                  ),
                  const SizedBox(width: 10,),
                  Text("Update Time & Date", style: AppStyle.cardfooter)
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.green.shade200,
                      radius: 30,
                      child: const Icon(CupertinoIcons.chart_pie, size: 30, color: Colors.white,)
                  ),
                  const SizedBox(width: 10,),
                  Text("Mileage per km", style: AppStyle.cardfooter)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
