import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_drivers.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_live_preview.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_operation.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_route_history.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_route_history_1.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class VehicleToolTipDialog {
  static showVehicleToolTipDialog(
      BuildContext context,
      String? number_plate,
      String? vin,
      String? address,
      String? phone,
      String? name,
      String? brand,
      String? model,
      String? token,
      String? latitude,
      String? longitude,
      String? voltage_level,
      String? speed,
      bool real_time_gps,
      String? status,
      String? gsm_signal_strength,
      String? updated_at,
      email,
      country,
      licence_number) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      // transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            // Added Material widget here
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(number_plate!,
                                      style: AppStyle.pageTitle
                                          .copyWith(color: Colors.red)),
                                ),
                                // Align(
                                //   alignment: Alignment.topRight,
                                //     child: Icon(Icons.cancel, size: 30,)),
                              ],
                            ),
                            VehicleTooltip(
                                number_plate: number_plate,
                                driver: name,
                                vehicle_id: vin,
                                phone_no: phone,
                                location: address),
                            Container(
                              padding: const EdgeInsets.all(0.0),
                              // color: Colors.lightBlue,
                              width: size.width - 110,
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(00.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 0.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                  onTap: () => Navigator
                                                          .of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              VehicleRouteHistory1(
                                                                  brand!,
                                                                  model!,
                                                                  vin!,
                                                                  double.parse(
                                                                      latitude!),
                                                                  double.parse(
                                                                      longitude!),
                                                                  token!))),
                        
                                                  child: const Icon(Icons.cable)),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    VehicleShare
                                                        .showVehicleShareDialog(
                                                            context,
                                                            brand,
                                                            model,
                                                            vin,
                                                            token,
                                                            latitude,
                                                            longitude);
                                                  },
                                                  child: const Icon(
                                                      Icons.share_outlined)),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () => VehicleLivePreview
                                                      .showTopModal(
                                                          context,
                                                          brand,
                                                          model,
                                                          vin,
                                                          token,
                                                          latitude,
                                                          longitude),
                                                  child: const Icon(CupertinoIcons
                                                      .photo_camera)),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isDismissible: false,
                                                        isScrollControlled: true,
                                                        //useSafeArea: true,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        builder: (BuildContext
                                                            context) {
                                                          return VehicleOperation(
                                                              voltage_level:
                                                                  voltage_level!,
                                                              speed: speed!,
                                                              latitude: latitude!,
                                                              longitude:
                                                                  longitude!,
                                                              real_time_gps:
                                                                  real_time_gps,
                                                              status: status ?? "N/A",
                                                              gsm_signal_strength:
                                                                  gsm_signal_strength!,
                                                              updated_at:
                                                                  updated_at!,
                                                              number_plate:
                                                                  number_plate,
                                                              vin: vin!,
                                                              token: token!,
                                                            brand: brand!,
                                                              model: model!
                                                          );
                                                        });
                                                  },
                                                  child: const Icon(CupertinoIcons
                                                      .circle_grid_3x3,)),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    VehicleDriverDialog
                                                        .showDriverDialog(
                                                            context,
                                                            name,
                                                            phone,
                                                            email,
                                                            country,
                                                            licence_number,
                                                            vin,
                                                            address,
                                                            number_plate);
                                                  },
                                                  child: const Icon(
                                                      CupertinoIcons.person)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}





class VehicleTooltip extends StatelessWidget {
  String? number_plate, driver, vehicle_id, phone_no, location;
  VehicleTooltip(
      {super.key,
      required this.number_plate,
      required this.driver,
      required this.vehicle_id,
      required this.phone_no,
      required this.location});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.8, // Adjust as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Driver: $driver", style: AppStyle.cardfooter),
                Text("Vehicle ID: $vehicle_id", style: AppStyle.cardfooter),
                Text("Phone Number: $phone_no", style: AppStyle.cardfooter),
                Text("Location: $location", style: AppStyle.cardfooter,),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
