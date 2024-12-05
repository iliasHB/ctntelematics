import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_alert.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_analysis.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_dashboard.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_engine_lock.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_info.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_live_tracking.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_playback.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_quick_setting.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_tooltip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/math_util.dart';
import '../../../vehincle/presentation/pages/vehicle_alert.dart';
import '../../../vehincle/presentation/pages/vehicle_analytics.dart';

class VehicleOperation extends StatelessWidget {
  final String voltage_level,
      speed,
      latitude,
      longitude,
      status,
      updated_at,
      number_plate,
      gsm_signal_strength, vin, token, model, brand;
  final bool real_time_gps;
  const VehicleOperation(
      {super.key,
      required this.voltage_level,
      required this.speed,
      required this.latitude,
      required this.longitude,
      required this.real_time_gps,
      required this.status,
      required this.gsm_signal_strength,
      required this.updated_at,
      required this.number_plate, required this.vin, required this.token, required this.brand,required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 5,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          height: getVerticalSize(200),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10, // Adjust spacing between grid items
            crossAxisSpacing: 5,
            childAspectRatio: 1.5, //
            // scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  VehicleDashboard(token: token, vin: vin)));

                  // showModalBottomSheet(
                  //     context: context,
                  //     isDismissible: false,
                  //     isScrollControlled: true,
                  //     //useSafeArea: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           topRight: Radius.circular(20)),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return VehicleDashboard(token: token, vin: vin); //VehicleLiveTracking();
                  //     });
                },
                child: VehicleOperationCard(
                    status: 'Dashboard',
                    icon: Icon(
                        CupertinoIcons.square_grid_2x2, //.gps_fixed_rounded,
                        color: Colors.green.shade300)),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VehicleAnalytics(token: token, vin: vin,),
                  ));
                  // showModalBottomSheet(
                  //     context: context,
                  //     isDismissible: false,
                  //     isScrollControlled: true,
                  //     //useSafeArea: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           topRight: Radius.circular(20)),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return VehicleAnalytics(token: token, vin: vin,);
                  //     });
                }, //VehiclePlayBackToolTip.showTopModal(context),
                child: VehicleOperationCard(
                    status: 'Analytics',
                    icon: Icon(
                      Icons.auto_graph,
                      // CupertinoIcons.play_circle,
                      color: Colors.green.shade300,
                    )),
              ),
              InkWell(
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleInfo(
                    voltage_level: voltage_level,
                    speed: speed,
                    latitude: latitude,
                    longitude: longitude,
                    status: status,
                    updated_at: updated_at,
                    real_time_gps: real_time_gps,
                    gsm_signal_strength: gsm_signal_strength,
                    number_plate: number_plate,
                    brand: brand,
                    model: model,
                  )));
                  // showModalBottomSheet(
                  //     context: context,
                  //     isDismissible: false,
                  //     isScrollControlled: true,
                  //     //useSafeArea: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           topRight: Radius.circular(20)),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return VehicleInfo(
                  //           voltage_level: voltage_level,
                  //           speed: speed,
                  //           latitude: latitude,
                  //           longitude: longitude,
                  //           status: status,
                  //           updated_at: updated_at,
                  //           real_time_gps: real_time_gps,
                  //           gsm_signal_strength: gsm_signal_strength,
                  //           number_plate: number_plate,
                  //         brand: brand,
                  //         model: model,
                  //       );

                      // });
                },
                child: VehicleOperationCard(
                    status: 'Vehicle Info',
                    icon: Icon(CupertinoIcons.car_detailed,
                        color: Colors.green.shade300)),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  const VehicleEngineLock()));

                  // showModalBottomSheet(
                  //     context: context,
                  //     isDismissible: false,
                  //     isScrollControlled: true,
                  //     //useSafeArea: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           topRight: Radius.circular(20)),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return const VehicleEngineLock();
                  //     });
                },
                child: VehicleOperationCard(
                  status: 'Engine lock',
                  icon: Icon(CupertinoIcons.lock_fill,
                      color: Colors.green.shade300),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  const VehicleAlertPage()));
                  // showModalBottomSheet(
                  //     context: context,
                  //     isDismissible: false,
                  //     isScrollControlled: true,
                  //     //useSafeArea: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           topRight: Radius.circular(20)),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return const VehicleAlertPage();
                  //     });
                },
                child: VehicleOperationCard(
                    status: 'Alert',
                    icon: Icon(Icons.warning, color: Colors.green.shade300)),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  const VehicleQuickSetting()));

                  // showModalBottomSheet(
                  //     context: context,
                  //     isDismissible: false,
                  //     isScrollControlled: true,
                  //     //useSafeArea: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(20),
                  //           topRight: Radius.circular(20)),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return const VehicleQuickSetting();
                  //     });
                },
                child: VehicleOperationCard(
                  status: 'Quick Setting',
                  icon: Icon(CupertinoIcons.gear, color: Colors.green.shade300),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VehicleOperationCard extends StatelessWidget {
  final String status;
  final Icon icon;

  const VehicleOperationCard({required this.status, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(status,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
