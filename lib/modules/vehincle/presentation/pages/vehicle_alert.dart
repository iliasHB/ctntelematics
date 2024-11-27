import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleAlertPage extends StatefulWidget {
  const VehicleAlertPage({super.key});

  @override
  State<VehicleAlertPage> createState() => _VehicleAlertPageState();
}

class _VehicleAlertPageState extends State<VehicleAlertPage> {
  bool viewAdvert = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text("Alert", style: AppStyle.cardSubtitle, )],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.filter_alt),
          )
        ],
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
                  Icon(Icons.warning, size: 40, color: Colors.green.shade300,),
                  const SizedBox(width: 10,),
                  const Flexible(
                      child: Text("Sometimes you may not get alert due to GPD coverage network errors, battery voltage issue and unsupported vehicle",
                        softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //maxLines: 5,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
