import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';

class VehicleInfo extends StatelessWidget {
  final String voltage_level,
      speed,
      latitude,
      longitude,
      status,
      updated_at,
      number_plate,
      gsm_signal_strength,
      brand,
      model;
  final bool real_time_gps;
  const VehicleInfo(
      {super.key,
      required this.voltage_level,
      required this.speed,
      required this.latitude,
      required this.longitude,
      required this.real_time_gps,
      required this.status,
      required this.gsm_signal_strength,
      required this.updated_at,
      required this.number_plate,
      required this.brand,
      required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "Vehicle Info",
                style: AppStyle.cardSubtitle,
              ),
            ],
          ),
          // actions: [
          //   const Padding(
          //     padding: EdgeInsets.only(right: 8.0),
          //     child: Icon(Icons.refresh),
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
            builder: (context, vehicles) {
              if (vehicles.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/car.png"),
                            Center(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(brand,
                                        style: AppStyle.cardTitle.copyWith(
                                            color: Colors.green[700])),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(model,
                                        style: AppStyle.cardTitle.copyWith(
                                            color: Colors.green[700])),
                                  ],
                                ),
                                Text(number_plate,
                                    style: AppStyle.cardSubtitle),
                              ],
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     Icon(
                                      //       CupertinoIcons
                                      //           .antenna_radiowaves_left_right,
                                      //       size: 30,
                                      //       color: Colors.green.shade300,
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 10,
                                      //     ),
                                      //     const Column(
                                      //       children: [
                                      //         Text("8000",
                                      //             style: TextStyle(
                                      //                 fontSize: 18,
                                      //                 fontWeight: FontWeight.w500)),
                                      //         Text(
                                      //           "RPM",
                                      //           style: TextStyle(
                                      //               fontSize: 18,
                                      //               fontWeight: FontWeight.w500),
                                      //         )
                                      //       ],
                                      //     )
                                      //   ],
                                      // ),
                                      // const Spacer(),
                                      // Row(
                                      //   children: [
                                      //     Icon(
                                      //       Icons.gas_meter_outlined,
                                      //       size: 30,
                                      //       color: Colors.green.shade300,
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 10,
                                      //     ),
                                      //     const Column(
                                      //       children: [
                                      //         Text("40",
                                      //             style: TextStyle(
                                      //                 fontSize: 18,
                                      //                 fontWeight: FontWeight.w500)),
                                      //         Text(
                                      //           "Liters",
                                      //           style: TextStyle(
                                      //               fontSize: 18,
                                      //               fontWeight: FontWeight.w500),
                                      //         )
                                      //       ],
                                      //     )
                                      //   ],
                                      // ),
                                      // const Spacer(),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.speed_rounded,
                                            size: 30,
                                            color: Colors.green.shade300,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              Text(speed,
                                                  style:
                                                      AppStyle.cardSubtitle),
                                              Text(
                                                "KM/H",
                                                style: AppStyle.cardSubtitle
                                                    .copyWith(fontSize: 12),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 3,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        status,
                                        style: AppStyle.cardSubtitle
                                            .copyWith(fontSize: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                          FormatData.formatTimeAgo(
                                              updated_at),
                                          style: AppStyle.cardfooter
                                              .copyWith(color: Colors.red)),
                                    ],
                                  ),
                                ),
                                //Spacer(),
                                // Expanded(
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       const Text(
                                //         "Expire ",
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.w500,
                                //             fontSize: 18),
                                //       ),
                                //       Text(
                                //         "On Unlimited",
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.w500,
                                //             color: Colors.green.shade200),
                                //       )
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Coordinate ",
                                      style: AppStyle.cardSubtitle
                                          .copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      '${latitude}, ${longitude}',
                                      style: AppStyle.cardfooter
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 550,
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        children: [
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //         "Coolant Temperature",
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //             fontSize: 18, fontWeight: FontWeight.w500),
                          //       )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               CupertinoIcons.thermometer,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "60 C",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Ambient Air Temperature",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               CupertinoIcons.thermometer,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "40 C",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             " Engines Load",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.lan,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "47 %",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Engines Locked",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.key,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "49 C",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Engines Level",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.gas_meter_outlined,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "40 L",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  "\nGPS LeveL",
                                  textAlign: TextAlign.center,
                                  style: AppStyle.cardSubtitle
                                      .copyWith(fontSize: 12),
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green.shade200,
                                      child: const Icon(
                                        CupertinoIcons.location_solid,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        real_time_gps.toString(),
                                        style: AppStyle.cardfooter
                                            .copyWith(fontSize: 12),
                                        softWrap:
                                            true, // This ensures the text wraps to the next line if needed.
                                        overflow: TextOverflow
                                            .ellipsis, // You can change this to TextOverflow.clip if preferred.
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  "\nGSM Level",
                                  textAlign: TextAlign.center,
                                  style: AppStyle.cardSubtitle
                                      .copyWith(fontSize: 12),
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green.shade200,
                                      child: const Icon(
                                        Icons.key,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        gsm_signal_strength,
                                        style: AppStyle.cardfooter
                                            .copyWith(fontSize: 12),
                                        softWrap:
                                            true, // This ensures the text wraps to the next line if needed.
                                        overflow: TextOverflow
                                            .ellipsis, // You can change this to TextOverflow.clip if preferred.
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  "\nIgnition",
                                  textAlign: TextAlign.center,
                                  style: AppStyle.cardSubtitle
                                      .copyWith(fontSize: 12),
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green.shade200,
                                      child: const Icon(
                                        Icons.vpn_key_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "OFF",
                                        style: AppStyle.cardfooter
                                            .copyWith(fontSize: 12),
                                        softWrap:
                                            true, // This ensures the text wraps to the next line if needed.
                                        overflow: TextOverflow
                                            .ellipsis, // You can change this to TextOverflow.clip if preferred.
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Total Mileage ECU",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.track_changes_outlined,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Text(
                          //             "0",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w400, fontSize: 18),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Number of DCT",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.key,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "49 %",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Center(
                          //           child: Text(
                          //         "Odometer",
                          //         textAlign: TextAlign.center,
                          //         style:
                          //             AppStyle.cardSubtitle.copyWith(fontSize: 12),
                          //       )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.key,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           Flexible(
                          //             child: Text(
                          //               "0 km",
                          //               style: AppStyle.cardfooter
                          //                   .copyWith(fontSize: 12),
                          //               softWrap:
                          //                   true, // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow
                          //                   .ellipsis, // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Unplug Status",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.connect_without_contact,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "0",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //
                          //
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Battery Voltage",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.battery_5_bar_outlined,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //            Flexible(
                          //             child: Text(
                          //              voltage_level +"V",
                          //               style: const TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "RPM",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               CupertinoIcons.dot_radiowaves_left_right,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "8000 r/mn",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Distance since code clear",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.social_distance,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "320 km",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //
                          //
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Module voltage control",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               Icons.warning,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "On",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Center(
                          //           child: Text(
                          //             "Barometer Pressure",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           )),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundColor: Colors.green.shade200,
                          //             child: const Icon(
                          //               CupertinoIcons.drop_triangle,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Flexible(
                          //             child: Text(
                          //               "30 N/A",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w400, fontSize: 18),
                          //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //               maxLines: 2,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              final vehicleStatus = vehicles.where((v) {
                return (v.locationInfo.vehicleStatus == "Idling" ||
                        v.locationInfo.vehicleStatus == "Moving" ||
                        v.locationInfo.vehicleStatus == "Parked" ||
                        v.locationInfo.vehicleStatus == "Stopped" ||
                        v.locationInfo.tracker?.status == "online" ||
                        v.locationInfo.tracker?.status == "offline") &&
                    v.locationInfo.numberPlate == number_plate;
                // && v.locationInfo.tracker?.position?.ignition == "on";
              }).toList();

              //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/car.png"),
                          Center(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(brand,
                                      style: AppStyle.cardTitle.copyWith(
                                          color: Colors.green[700])),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(model,
                                      style: AppStyle.cardTitle.copyWith(
                                          color: Colors.green[700])),
                                ],
                              ),
                              Text(number_plate,
                                  style: AppStyle.cardSubtitle),
                            ],
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       CupertinoIcons
                                    //           .antenna_radiowaves_left_right,
                                    //       size: 30,
                                    //       color: Colors.green.shade300,
                                    //     ),
                                    //     const SizedBox(
                                    //       width: 10,
                                    //     ),
                                    //     const Column(
                                    //       children: [
                                    //         Text("8000",
                                    //             style: TextStyle(
                                    //                 fontSize: 18,
                                    //                 fontWeight: FontWeight.w500)),
                                    //         Text(
                                    //           "RPM",
                                    //           style: TextStyle(
                                    //               fontSize: 18,
                                    //               fontWeight: FontWeight.w500),
                                    //         )
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),
                                    // const Spacer(),
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.gas_meter_outlined,
                                    //       size: 30,
                                    //       color: Colors.green.shade300,
                                    //     ),
                                    //     const SizedBox(
                                    //       width: 10,
                                    //     ),
                                    //     const Column(
                                    //       children: [
                                    //         Text("40",
                                    //             style: TextStyle(
                                    //                 fontSize: 18,
                                    //                 fontWeight: FontWeight.w500)),
                                    //         Text(
                                    //           "Liters",
                                    //           style: TextStyle(
                                    //               fontSize: 18,
                                    //               fontWeight: FontWeight.w500),
                                    //         )
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),
                                    // const Spacer(),

                                    Row(
                                      children: [
                                        Icon(
                                          Icons.speed_rounded,
                                          size: 30,
                                          color: Colors.green.shade300,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(speed,
                                                style: AppStyle.cardSubtitle),
                                            Text(
                                              "KM/H",
                                              style: AppStyle.cardSubtitle
                                                  .copyWith(fontSize: 12),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 3,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      vehicleStatus[0]
                                              .locationInfo
                                              .tracker
                                              ?.status ??
                                          status,
                                      style: AppStyle.cardSubtitle
                                          .copyWith(fontSize: 12),
                                    ),
                                    const Spacer(),
                                    Text(FormatData.formatTimeAgo(updated_at),
                                        style: AppStyle.cardfooter
                                            .copyWith(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Coordinate ",
                                    style: AppStyle.cardSubtitle
                                        .copyWith(fontSize: 12),
                                  ),
                                  Text(
                                    "${vehicleStatus[0].locationInfo.tracker?.position?.latitude.toString() ?? latitude}, "
                                    "${vehicleStatus[0].locationInfo.tracker?.position?.longitude.toString() ?? longitude}",
                                    // '${latitude}, ${longitude}',
                                    style: AppStyle.cardfooter
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 550,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      children: [
                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                "\nGPS LeveL",
                                textAlign: TextAlign.center,
                                style: AppStyle.cardSubtitle
                                    .copyWith(fontSize: 12),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade200,
                                    child: const Icon(
                                      CupertinoIcons.location_solid,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      real_time_gps.toString(),
                                      style: AppStyle.cardfooter
                                          .copyWith(fontSize: 12),
                                      softWrap:
                                          true, // This ensures the text wraps to the next line if needed.
                                      overflow: TextOverflow
                                          .ellipsis, // You can change this to TextOverflow.clip if preferred.
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                "\nGSM Level",
                                textAlign: TextAlign.center,
                                style: AppStyle.cardSubtitle
                                    .copyWith(fontSize: 12),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade200,
                                    child: const Icon(
                                      Icons.key,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${vehicleStatus[0].locationInfo.tracker?.position?.gsmRssi ?? gsm_signal_strength}",
                                      //gsm_signal_strength,
                                      style: AppStyle.cardfooter
                                          .copyWith(fontSize: 12),
                                      softWrap:
                                          true, // This ensures the text wraps to the next line if needed.
                                      overflow: TextOverflow
                                          .ellipsis, // You can change this to TextOverflow.clip if preferred.
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                "\nIgnition",
                                textAlign: TextAlign.center,
                                style: AppStyle.cardSubtitle
                                    .copyWith(fontSize: 12),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade200,
                                    child: const Icon(
                                      Icons.vpn_key_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${vehicleStatus[0].locationInfo.tracker?.position?.ignition ?? 'OFF'}",
                                      style: AppStyle.cardfooter
                                          .copyWith(fontSize: 12),
                                      softWrap:
                                          true, // This ensures the text wraps to the next line if needed.
                                      overflow: TextOverflow
                                          .ellipsis, // You can change this to TextOverflow.clip if preferred.
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Total Mileage ECU",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.track_changes_outlined,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Text(
                        //             "0",
                        //             style: TextStyle(
                        //                 fontWeight: FontWeight.w400, fontSize: 18),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Number of DCT",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.key,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Flexible(
                        //             child: Text(
                        //               "49 %",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Center(
                        //           child: Text(
                        //         "Odometer",
                        //         textAlign: TextAlign.center,
                        //         style:
                        //             AppStyle.cardSubtitle.copyWith(fontSize: 12),
                        //       )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.key,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Flexible(
                        //             child: Text(
                        //               "0 km",
                        //               style: AppStyle.cardfooter
                        //                   .copyWith(fontSize: 12),
                        //               softWrap:
                        //                   true, // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow
                        //                   .ellipsis, // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Unplug Status",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.connect_without_contact,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Flexible(
                        //             child: Text(
                        //               "0",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //
                        //
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Battery Voltage",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.battery_5_bar_outlined,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //            Flexible(
                        //             child: Text(
                        //              voltage_level +"V",
                        //               style: const TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "RPM",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               CupertinoIcons.dot_radiowaves_left_right,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Flexible(
                        //             child: Text(
                        //               "8000 r/mn",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Distance since code clear",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.social_distance,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Flexible(
                        //             child: Text(
                        //               "320 km",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //
                        //
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Module voltage control",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               Icons.warning,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Flexible(
                        //             child: Text(
                        //               "On",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Card(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const Center(
                        //           child: Text(
                        //             "Barometer Pressure",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 18, fontWeight: FontWeight.w500),
                        //           )),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.green.shade200,
                        //             child: const Icon(
                        //               CupertinoIcons.drop_triangle,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           const Flexible(
                        //             child: Text(
                        //               "30 N/A",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w400, fontSize: 18),
                        //               softWrap: true,  // This ensures the text wraps to the next line if needed.
                        //               overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                        //               maxLines: 2,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
