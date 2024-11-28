import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/databse_helper.dart';
import '../../../vehincle/presentation/pages/vehicle_alert.dart';
import '../../../websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';

class VehicleAlert extends StatefulWidget {
  const VehicleAlert({super.key});

  @override
  State<VehicleAlert> createState() => _VehicleAlertState();
}

class _VehicleAlertState extends State<VehicleAlert> {
  bool viewAdvert = false;
  DB_notification db_notification = DB_notification();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "Alert",
                style: AppStyle.cardSubtitle,
              )
            ],
          ),
          // actions: [
          //   const Padding(
          //     padding: EdgeInsets.only(right: 10.0),
          //     child: Icon(Icons.filter_alt),
          //   )
          // ],
        ),
        body: Column(
          children: [
            viewAdvert == false
                ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
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
                    Icon(
                      Icons.warning,
                      size: 40,
                      color: Colors.green.shade300,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Flexible(
                        child: Text(
                      "Sometimes you may not get alert due to GPD coverage network errors, battery voltage issue and unsupported vehicle",
                      softWrap:
                          true, // This ensures the text wraps to the next line if needed.
                      //overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                      //maxLines: 5,
                    ))
                  ],
                ),
              ),
            ),


            BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
              builder: (context, vehicles) {
                if (vehicles.isEmpty) {
                  return InkWell(
                    onTap: () async {
                      final savedNotifications =
                      await db_notification.fetchCombinedNotifications();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AlertWidget(
                                  notifications: savedNotifications)));
                    },
                    // child: const CircleAvatar(
                    //   child: Icon(CupertinoIcons.bell_fill),
                    // ),
                  );
                }

                // Filter vehicles with geofence violations or exceeding speed limits
                final geofenceNotifications = vehicles.where((v) {
                  return !(v.locationInfo.withinGeofence?.isInGeofence ?? true);
                }).toList();

                final speedLimitNotifications = vehicles.where((v) {
                  final speedLimit =
                      double.tryParse(v.locationInfo.speedLimit?.toString() ?? '0') ?? 0;
                  final vehicleSpeed =
                      double.tryParse(v.locationInfo.tracker?.position?.speed?.toString() ?? '0') ?? 0;
                  return vehicleSpeed > speedLimit;
                }).toList();

                db_notification.saveNotifications(geofenceNotifications, speedLimitNotifications);

                return InkWell(
                  onTap: () async {
                    final savedNotifications = await db_notification.fetchCombinedNotifications();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AlertWidget(notifications: savedNotifications)));
                  },
                  // child: const Stack(
                  //   children: [
                  //     CircleAvatar(
                  //       child: Icon(CupertinoIcons.bell_fill),
                  //     ),
                  //     Positioned(
                  //         top: 0,
                  //         right: 1,
                  //         child: Badge(
                  //           smallSize: 10.0,
                  //         ))
                  //   ],
                  // ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
