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
      String? updated_at, email, country, licence_number) {
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
              width: size.width,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "0",
                    //       style: TextStyle(
                    //           color: Colors.green.shade100,
                    //           fontSize: 60,
                    //           fontWeight: FontWeight.w900),
                    //     ),
                    //     const Text("KM/H",
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold))
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Driver: $name",
                          //       style: AppStyle.cardSubtitle
                          //     ),
                          //   ],
                          // ),
                          VehicleTooltip(
                              number_plate: number_plate,
                              driver: name,
                              vehicle_id: vin,
                              phone_no: phone,
                              location: address),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            // color: Colors.lightBlue,
                            width: size.width - 110,
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                // Flexible(
                                //   flex: 2,
                                //   child:
                                Container(
                                  padding: const EdgeInsets.all(00.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      // const Text(
                                      //   '3500.50KM',
                                      //   style: TextStyle(
                                      //     fontSize: 18,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
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
                                                onTap: () => Navigator.of(
                                                        context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            VehicleRouteHistory1(
                                                                brand!,
                                                                model!,
                                                                vin!,
                                                                double.parse(latitude!),
                                                                double.parse( longitude!),
                                                                token!))),

                                                // VehicleRouteHistory
                                                //     .showVehicleRouteDialog(
                                                //         context,
                                                //         brand,
                                                //         model,
                                                //         vin,
                                                //         latitude,
                                                //         longitude,
                                                //         token),
                                                // VehicleRouteHistory.showVehicleRouteDialog(
                                                //     context, brand, model, vin, latitude, longitude, token);

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
                                                    .showTopModal(context, brand,  model,
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
                                                            voltage_level: voltage_level!,
                                                            speed: speed!,
                                                            latitude: latitude!,
                                                            longitude: longitude!,
                                                            real_time_gps: real_time_gps,
                                                            status: status!,
                                                            gsm_signal_strength: gsm_signal_strength!,
                                                            updated_at: updated_at!,
                                                            number_plate: number_plate
                                                        );
                                                      });
                                                },
                                                child: const Icon(CupertinoIcons
                                                    .rectangle_on_rectangle)),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  VehicleDriverDialog
                                                      .showDriverDialog(
                                                          context, name, phone, email, country, licence_number, vin, address, number_plate);
                                                },
                                                child: const Icon(
                                                    CupertinoIcons.person)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Container(
                                //       // color: Colors.black12,
                                //       child:
                                //           Image.asset("assets/images/car.png")),
                                // ),
                              ],
                            ),
                          )
                        ],
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
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Driver: $driver", style: AppStyle.cardfooter),
            Text("Vehicle ID: $vehicle_id", style: AppStyle.cardfooter),
            Text("Phone Number: $phone_no", style: AppStyle.cardfooter),
            Text("Location: $location", style: AppStyle.cardfooter),
          ],
        ),
      ],
    );
  }
}
