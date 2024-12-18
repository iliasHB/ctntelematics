import 'dart:async';

import 'package:ctntelematics/core/utils/app_export_util.dart';
// import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:ctntelematics/core/widgets/appBar.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import 'package:ctntelematics/modules/eshop/presentation/widgets/eshop_widget.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/maintenance.dart';
import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/provider_usecase.dart';
import '../../../../core/widgets/advert.dart';
import '../../../../core/widgets/vehicel_realTime_status.dart';
import '../../../../service_locator.dart';
import '../../../eshop/domain/entitties/req_entities/token_req_entity.dart';
import '../../../eshop/presentation/bloc/eshop_bloc.dart';
import '../../../eshop/presentation/widgets/product_review.dart';
import '../../../map/presentation/bloc/map_bloc.dart';
import '../../../websocket/data/datasources/pusher_service.dart';
import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';
import '../../domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/vehicle_search_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  PrefUtils prefUtils = PrefUtils();
  String? first_name;
  String? last_name;
  String? middle_name;
  String? email;
  String? token;
  String? userId, user_type;
  bool viewAdvert = false;
  bool vehiclePerformance = false;
  bool isLoading = true;
  bool mileage = false;
  bool odometer = false;
  bool maintenanceReminder = false;
  bool faultCodes = false;
  bool shopNow = false;
  bool quickLink = false;

  int vehicleCount = 0;
  int onlineCount = 0;
  int idleCount = 0;
  int offlineLength = 0;
  int offlineCount = 0;
  int packedCount = 0;

  // final  onlineVehicles = 0;
  @override
  void initState() {
    super.initState();
    _getAuthUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getAuthUser() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      if (authUser != null && authUser.isNotEmpty) {
        first_name = authUser[0].isEmpty ? null : authUser[0];
        last_name = authUser[1].isEmpty ? null : authUser[1];
        middle_name = authUser[2].isEmpty ? null : authUser[2];
        email = authUser[3].isEmpty ? null : authUser[3];
        token = authUser[4].isEmpty ? null : authUser[4];
        userId = authUser[8].isEmpty ? null : authUser[8];
        user_type = authUser[7].isEmpty ? null : authUser[7];
      }
      if (token != null && userId != null) {
        if (!sl.isRegistered<PusherService>()) {
          sl.registerSingleton<PusherService>(
              PusherService(token!, userId!, user_type!));
          final pusherService = sl<PusherService>();
          pusherService.initializePusher();
        }
      }
      isLoading = false;
    });
  }

  // Helper function to compute counts
  Map<String, int> _computeVehicleCounts(
      List<LastLocationRespEntity> vehicles) {
    return {
      'online': vehicles
          .where((v) =>
              v.vehicle?.details?.last_location?.status!.toLowerCase() ==
              "online")
          .length,
      'offline': vehicles
          .where((v) =>
              v.vehicle?.details?.last_location?.status!.toLowerCase() ==
              "offline")
          .length,
      'idling': vehicles
          .where((v) =>
              v.vehicle?.details?.last_location?.status!.toLowerCase() ==
              "idling")
          .length,
      'parked': vehicles
          .where((v) =>
              v.vehicle?.details?.last_location?.status!.toLowerCase() ==
              "parked")
          .length,
      'vehicles': vehicles.length
    };
  }

  // Helper function to compute counts
  Map<String, int> _computeVehicleSocketCounts(List<VehicleEntity> vehicles) {
    return {
      // 'moving': vehicles
      //     .where((v) => v.locationInfo.vehicleStatus.toLowerCase() == "moving")
      //     .length,
      'online': vehicles
          .where((v) =>
              v.locationInfo.tracker!.status?.toLowerCase() == "online" &&
                  v.locationInfo.vehicleStatus.toLowerCase() == "moving").length,
      // 'offline': vehicles
      //     .where((v) => v.locationInfo.vehicleStatus.toLowerCase() == "offline")
      //     .length,
      // 'idling': vehicles
      //     .where((v) => v.locationInfo.vehicleStatus.toLowerCase() == "idling")
      //     .length,
      // 'parked': vehicles
      //     .where((v) => v.locationInfo.vehicleStatus.toLowerCase() == "parked")
      //     .length,
    };
  }

  // void _updateVehicleStatus(VehicleEntity vehicle, String newStatus) {
  //   if (vehicle.locationInfo.tracker == null) {
  //     vehicle.locationInfo.tracker = newStatus; // Set the initial status
  //   }
  //   vehicle.previousStatus = vehicle.locationInfo?.vehicleStatus;
  //   vehicle.locationInfo?.vehicleStatus = newStatus;
  // }

  @override
  Widget build(BuildContext context) {
    final isShopNow = context.watch<ShopNowProvider>().isShopNow;
    final isVehicleTrip = context.watch<VehicleTripProvider>().isVehicleTrip;
    final isMaintenanceReminder =
        context.watch<MaintenanceReminderProvider>().isMaintenanceReminder;
    final isQuickLinkReminder = context.watch<QuickLinkProvider>().isQuickLink;
    final isOdometerReminder = context.watch<OdometerProvider>().isOdometer;
    final dashVehicleReqEntity =
        TokenReqEntity(token: token ?? "", contentType: 'application/json');
    return Scaffold(
      appBar: AnimatedAppBar(
        firstname: first_name ?? "",
        // onVehiclePerformanceSelected: (selectedPerformance) {
        //   setState(() {
        //     vehiclePerformance = selectedPerformance!;
        //   });
        // },
        // onMileageSelected: (selectedMileage) {
        //   setState(() {
        //     mileage = selectedMileage!;
        //   });
        // },
        // onOdometerSelected: (selectedOdometer) {
        //   setState(() {
        //     odometer = selectedOdometer!;
        //   });
        // },
        // onMaintenanceReminderSelected: (selectedMaintenanceReminder) {
        //   setState(() {
        //     maintenanceReminder = selectedMaintenanceReminder!;
        //   });
        // },
        // onFaultCodesSelected: (selectedFaultCodes) {
        //   setState(() {
        //     faultCodes = selectedFaultCodes!;
        //   });
        // },
        // onShopNowSelected: (selectedShopNow) {
        //   setState(() {
        //     shopNow = selectedShopNow!;
        //   });
        // },
        // onQuickLinkSelected: (selectedQuickLin) {
        //   setState(() {
        //     quickLink = selectedQuickLin!;
        //   });
        // },
        // onQuickLinkSelected: (selectedQuickLin) {
        //   setState(() {
        //     quickLink = selectedQuickLin!;
        //   });
        // },
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  )))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      // height: 350,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.green.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DashboardComponentTitle(
                                logo: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    // backgroundImage: AssetImage("assets/images/traffic_light.jpg",),
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/images/traffic_light.jpg",
                                        height: 30,
                                        width: 30,
                                      ),
                                    )),
                                title: 'Vehicle Status',
                                subTitle: 'Vehicle real-time update',
                              )),
                          const SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            height: getVerticalSize(280),
                            child: BlocProvider(
                              create: (_) => sl<LastLocationBloc>()
                                ..add(LastLocationEvent(dashVehicleReqEntity)),
                              child: BlocConsumer<LastLocationBloc, MapState>(
                                  builder: (context, state) {
                                if (state is MapLoading) {
                                  return const CustomContainerLoadingButton();
                                  //   const SizedBox(
                                  //   height: 25,
                                  //   width: 25,
                                  //   child: Center(
                                  //     child: CircularProgressIndicator(
                                  //       strokeWidth: 2.0,
                                  //       color: Colors.green,
                                  //     ),
                                  //   ),
                                  // );
                                } else if (state is GetLastLocationDone) {

                                  if(state.resp.isEmpty || state.resp == null){
                                    return Center(
                                      child: Text(
                                        'No vehicles available',
                                        style: AppStyle.cardfooter,
                                      ),
                                    );
                                  }

                                  final vehiclesData = state.resp;
                                  final vehicleCounts = _computeVehicleCounts(vehiclesData);

                                  return Column(
                                    children: [
                                      BlocListener<VehicleLocationBloc,
                                          List<VehicleEntity>>(
                                        listener: (context, vehicles) {
                                          // setState(() {
                                          //   vehicles.forEach((vehicle) {
                                          //     // Simulate status update
                                          //     final newStatus = _fetchNewStatusForVehicle(vehicle.locationInfo.vin);
                                          //     _updateVehicleStatus(vehicle, newStatus);
                                          //   });
                                          // });
                                        },
                                        child: BlocBuilder<VehicleLocationBloc,
                                            List<VehicleEntity>>(
                                          builder: (context, vehicles) {
                                            if (vehicles.isEmpty) {
                                              return VehicleStatusPieChart(
                                                onlineCount:
                                                    vehicleCounts['online'] ??
                                                        0,
                                                offlineCount:
                                                    vehicleCounts['offline'] ??
                                                        0,
                                                idlingCount:
                                                    vehicleCounts['idling'] ??
                                                        0,
                                                parkedCount:
                                                    vehicleCounts['parked'] ??
                                                        0,
                                              );
                                            }

                                            final vehicleWebsocketCounts =
                                                _computeVehicleSocketCounts(
                                                    vehicles);

                                            return VehicleStatusPieChart(
                                              onlineCount:
                                                  vehicleWebsocketCounts['online'] ?? 0,
                                              offlineCount:
                                                  VehicleRealTimeStatus
                                                      .checkStatusChange(
                                                          vehiclesData,
                                                          vehicles,
                                                          'offline',
                                                          vehicleCounts[
                                                              'offline']),
                                              idlingCount: VehicleRealTimeStatus
                                                  .checkStatusChange(
                                                      vehiclesData,
                                                      vehicles,
                                                      'idling',
                                                      vehicleCounts['idling']),
                                              parkedCount: VehicleRealTimeStatus
                                                  .checkStatusChange(
                                                      vehiclesData,
                                                      vehicles,
                                                      'parked',
                                                      vehicleCounts['parked']),

                                              // offlineCount: vehicleCounts['offline'] ?? 0,
                                              // idlingCount: vehicleCounts['idling'] ?? 0,
                                              // parkedCount: vehicleCounts['parked'] ?? 0
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          height: 80,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              _BuildVehicleStatus(
                                                  title: "Online",
                                                  count: BlocListener<
                                                      VehicleLocationBloc,
                                                      List<VehicleEntity>>(
                                                    listener:
                                                        (context, vehicles) {
                                                      // _updateVehicleCounts(vehicles);
                                                      setState(() {
                                                        vehicles;
                                                      });
                                                    },
                                                    child: BlocBuilder<
                                                        VehicleLocationBloc,
                                                        List<VehicleEntity>>(
                                                      builder:
                                                          (context, vehicles) {
                                                        if (vehicles.isEmpty) {
                                                          return Text(
                                                            '${vehicleCounts['online'] ?? 0}',
                                                            style: AppStyle
                                                                .cardfooter
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                            maxLines: 1, // Restrict to a single line for count as well
                                                            overflow: TextOverflow.ellipsis,
                                                          );
                                                        }
                                                        final vehicleWebsocketCounts =
                                                            _computeVehicleSocketCounts(
                                                                vehicles);
                                                        return Text(
                                                          "${vehicleWebsocketCounts['online'] ?? 0}",
                                                          style: AppStyle
                                                              .cardfooter
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                          maxLines: 1, // Restrict to a single line for count as well
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  symbol: const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    radius: 8,
                                                  )),
                                              _BuildVehicleStatus(
                                                  title: "Offline",
                                                  count: BlocListener<
                                                      VehicleLocationBloc,
                                                      List<VehicleEntity>>(
                                                    listener:
                                                        (context, vehicles) {
                                                      // _updateVehicleCounts(vehicles);
                                                      setState(() {
                                                        vehicles;
                                                      });
                                                    },
                                                    child: BlocBuilder<
                                                        VehicleLocationBloc,
                                                        List<VehicleEntity>>(
                                                      builder:
                                                          (context, vehicles) {
                                                        if (vehicles.isEmpty) {
                                                          return Text(
                                                            '${vehicleCounts['offline'] ?? 0}',
                                                            style: AppStyle
                                                                .cardfooter
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                            maxLines:
                                                                1, // Restrict to a single line for count as well
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          );
                                                        }
                                                        return Text(
                                                          '${VehicleRealTimeStatus.checkStatusChange(vehiclesData, vehicles, 'offline', vehicleCounts['offline'])}',
                                                          style: AppStyle
                                                              .cardfooter
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                          maxLines:
                                                              1, // Restrict to a single line for count as well
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  symbol: const CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    radius: 8,
                                                  )),
                                              _BuildVehicleStatus(
                                                  title: "Idling",
                                                  count: BlocListener<
                                                          VehicleLocationBloc,
                                                          List<VehicleEntity>>(
                                                      listener:
                                                          (context, vehicles) {
                                                    setState(() {
                                                      vehicles;
                                                    });
                                                  }, child: BlocBuilder<
                                                          VehicleLocationBloc,
                                                          List<VehicleEntity>>(
                                                    builder:
                                                        (context, vehicles) {
                                                      if (vehicles.isEmpty) {
                                                        return Text(
                                                          '${vehicleCounts['idling'] ?? 0}',
                                                          style: AppStyle
                                                              .cardfooter
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                          maxLines:
                                                              1, // Restrict to a single line for count as well
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      }
                                                      return Text(
                                                        '${VehicleRealTimeStatus.checkStatusChange(vehiclesData, vehicles, 'idling', vehicleCounts['idling'])}',
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                        maxLines:
                                                            1, // Restrict to a single line for count as well
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    },
                                                  )),
                                                  symbol: const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.yellow,
                                                    radius: 8,
                                                  )),
                                              _BuildVehicleStatus(
                                                  title: "Parked",
                                                  count: BlocListener<
                                                          VehicleLocationBloc,
                                                          List<VehicleEntity>>(
                                                      listener:
                                                          (context, vehicles) {
                                                    // _updateVehicleCounts(vehicles);
                                                    setState(() {
                                                      vehicles;
                                                    });
                                                  }, child: BlocBuilder<
                                                          VehicleLocationBloc,
                                                          List<VehicleEntity>>(
                                                    builder:
                                                        (context, vehicles) {
                                                      if (vehicles.isEmpty) {
                                                        return Text(
                                                          '${vehicleCounts['parked'] ?? 0}',
                                                          style: AppStyle
                                                              .cardfooter
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                          maxLines:
                                                              1, // Restrict to a single line for count as well
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      }
                                                      return Text(
                                                        '${VehicleRealTimeStatus.checkStatusChange(vehiclesData, vehicles, 'parked', vehicleCounts['parked'])}',
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                        maxLines:
                                                            1, // Restrict to a single line for count as well
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    },
                                                  )),
                                                  symbol: const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blueGrey,
                                                    radius: 8,
                                                  ))
                                            ],
                                          ))
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No records found',
                                        style: AppStyle.cardfooter,
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      CustomSecondaryButton(
                                          label: 'Refresh',
                                          onPressed: () {
                                            BlocProvider.of<LastLocationBloc>(
                                                    context)
                                                .add(LastLocationEvent(
                                                    dashVehicleReqEntity));
                                          })
                                    ],
                                  ));
                                }
                              }, listener: (context, state) {
                                if (state is MapFailure) {
                                  if (state.message
                                      .contains("Unauthenticated")) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/login", (route) => false);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                }
                              }),
                            ),
                          ),

                          ///------------
                          // BlocListener<VehicleLocationBloc,
                          //     List<VehicleEntity>>(
                          //   listener: (context, vehicles) {
                          //     // _updateVehicleCounts(vehicles);
                          //     setState(() {
                          //       vehicles;
                          //     });
                          //   },
                          //   child: BlocBuilder<VehicleLocationBloc,
                          //       List<VehicleEntity>>(
                          //     builder: (context, vehicles) {
                          //
                          //       if (vehicles.isEmpty) {
                          //         return SizedBox(
                          //           height: getVerticalSize(180),
                          //           child: BlocProvider(
                          //             create: (_) => sl<DashVehiclesBloc>()
                          //               ..add(DashVehicleEvent(
                          //                   dashVehicleReqEntity)),
                          //             child: BlocConsumer<DashVehiclesBloc,
                          //                     DashboardState>(
                          //                 builder: (context, state) {
                          //               if (state is DashboardLoading) {
                          //                 return GridView.count(
                          //                   crossAxisCount: 2,
                          //                   mainAxisSpacing: 10, // Adjust spacing between grid items
                          //                   crossAxisSpacing: 10,
                          //                   childAspectRatio: 1.9, //
                          //                   physics:
                          //                       const NeverScrollableScrollPhysics(),
                          //                   children: [
                          //                     VehicleStatusCard(
                          //                         status: 'Moving',
                          //                         count: Text(
                          //                           '0',
                          //                           style: AppStyle.cardfooter
                          //                               .copyWith(
                          //                                   fontWeight:
                          //                                       FontWeight
                          //                                           .w300),
                          //                           maxLines:
                          //                               1, // Restrict to a single line for count as well
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                         color: Colors.green,
                          //                         icon: const Icon(
                          //                             CupertinoIcons
                          //                                 .graph_circle_fill,
                          //                             color: Colors.white)),
                          //                     const VehicleStatusCard(
                          //                         status: 'Stopped',
                          //                         count: SizedBox(
                          //                           height: 15,
                          //                           width: 15,
                          //                           child:
                          //                           CircularProgressIndicator(
                          //                             strokeWidth: 2.0,
                          //                           ),
                          //                         ),
                          //                         color: Colors.red,
                          //                         icon: Icon(
                          //                           CupertinoIcons.square_fill,
                          //                           color: Colors.white,
                          //                         )),
                          //                     const VehicleStatusCard(
                          //                         status: 'Idling',
                          //                         count: SizedBox(
                          //                           height: 15,
                          //                           width: 15,
                          //                           child:
                          //                               CircularProgressIndicator(
                          //                             strokeWidth: 2.0,
                          //                           ),
                          //                         ),
                          //                         color: Colors.yellow,
                          //                         icon: Icon(
                          //                             CupertinoIcons
                          //                                 .square_split_2x1_fill,
                          //                             color: Colors.white)),
                          //                     const VehicleStatusCard(
                          //                       status: 'Parked',
                          //                       count: SizedBox(
                          //                         height: 15,
                          //                         width: 15,
                          //                         child:
                          //                         CircularProgressIndicator(
                          //                           strokeWidth: 2.0,
                          //                         ),
                          //                       ),
                          //                       color: Colors.black,
                          //                       icon: Icon(
                          //                           CupertinoIcons.wifi_slash,
                          //                           color: Colors.white),
                          //                     ),
                          //                   ],
                          //                 );
                          //                 // const Center(
                          //                 //   child: Padding(
                          //                 //     padding: EdgeInsets.only(top: 10.0),
                          //                 //     child: CircularProgressIndicator(
                          //                 //       strokeWidth: 2.0,
                          //                 //     ),
                          //                 //   ));
                          //               } else if (state is DashboardDone) {
                          //                 return GridView.count(
                          //                   crossAxisCount: 2,
                          //                   mainAxisSpacing:
                          //                       10, // Adjust spacing between grid items
                          //                   crossAxisSpacing: 10,
                          //                   childAspectRatio: 1.9, //
                          //                   physics:
                          //                       const NeverScrollableScrollPhysics(),
                          //                   children: [
                          //                     VehicleStatusCard(
                          //                         status: 'Moving',
                          //                         count: Text(
                          //                           '0',
                          //                           style: AppStyle.cardfooter
                          //                               .copyWith(
                          //                                   fontWeight:
                          //                                       FontWeight
                          //                                           .w300),
                          //                           maxLines:
                          //                               1, // Restrict to a single line for count as well
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                         color: Colors.green,
                          //                         icon: const Icon(
                          //                             CupertinoIcons
                          //                                 .graph_circle_fill,
                          //                             color: Colors.white)),
                          //                     VehicleStatusCard(
                          //                         status: 'Stopped',
                          //                         count: Text(
                          //                           state.resp.data!.length
                          //                               .toString(),
                          //                           style: AppStyle.cardfooter
                          //                               .copyWith(
                          //                                   fontWeight:
                          //                                       FontWeight
                          //                                           .w300),
                          //                           maxLines:
                          //                               1, // Restrict to a single line for count as well
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                         color: Colors.red,
                          //                         icon: const Icon(
                          //                           CupertinoIcons.square_fill,
                          //                           color: Colors.white,
                          //                         )),
                          //                     VehicleStatusCard(
                          //                         status: 'Idling',
                          //                         count: Text(
                          //                           state.resp.data!.length
                          //                               .toString(),
                          //                           style: AppStyle.cardfooter
                          //                               .copyWith(
                          //                                   fontWeight:
                          //                                       FontWeight
                          //                                           .w300),
                          //                           maxLines:
                          //                               1, // Restrict to a single line for count as well
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                         color: Colors.yellow,
                          //                         icon: const Icon(
                          //                             CupertinoIcons
                          //                                 .square_split_2x1_fill,
                          //                             color: Colors.white)),
                          //                     VehicleStatusCard(
                          //                       status: 'Parked',
                          //                       count: Text(
                          //                         state.resp.data!.length
                          //                             .toString(),
                          //                         style: AppStyle.cardfooter
                          //                             .copyWith(
                          //                                 fontWeight:
                          //                                     FontWeight.w300),
                          //                         maxLines:
                          //                             1, // Restrict to a single line for count as well
                          //                         overflow:
                          //                             TextOverflow.ellipsis,
                          //                       ),
                          //                       color: Colors.black,
                          //                       icon: const Icon(
                          //                           CupertinoIcons.wifi_slash,
                          //                           color: Colors.white),
                          //                     ),
                          //                   ],
                          //                 );
                          //               } else {
                          //                 return const Center(
                          //                     child: Text('No records found'));
                          //               }
                          //             }, listener: (context, state) {
                          //               if (state is DashboardFailure) {
                          //                 //if (state.message.contains("The Token has expired")) {
                          //                 Navigator.pushNamed(
                          //                     context, "/login");
                          //                 //}
                          //                 ScaffoldMessenger.of(context)
                          //                     .showSnackBar(
                          //                   SnackBar(
                          //                       content: Text(state.message)),
                          //                 );
                          //               }
                          //             }),
                          //           ),
                          //         );
                          //       }
                          //       // final movingVehicles = vehicles
                          //       //     .where(
                          //       //         (v) => v.locationInfo.vehicleStatus == "Moving")
                          //       //     .toList();
                          //
                          //       final movingVehicles = vehicles.where((v) {
                          //         return v.locationInfo.vehicleStatus ==
                          //             "Moving";
                          //       }).toList();
                          //       final stopVehicles = vehicles.where((v) {
                          //         return v.locationInfo.vehicleStatus ==
                          //             "Stopped";
                          //       }).toList();
                          //
                          //       final parkedVehicles = vehicles.where((v) {
                          //         return v.locationInfo.vehicleStatus ==
                          //             "Parked";
                          //       }).toList();
                          //       final idleVehicles = vehicles.where((v) {
                          //         return v.locationInfo.vehicleStatus ==
                          //             "Idling";
                          //       }).toList();
                          //
                          //       //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
                          //       return SizedBox(
                          //         height: getVerticalSize(180),
                          //         child: GridView.count(
                          //           crossAxisCount: 2,
                          //           mainAxisSpacing:
                          //               10, // Adjust spacing between grid items
                          //           crossAxisSpacing: 10,
                          //           childAspectRatio: 1.7, //
                          //           physics:
                          //               const NeverScrollableScrollPhysics(),
                          //           children: [
                          //             VehicleStatusCard(
                          //                 status: 'Moving',
                          //                 count: Text(
                          //                   movingVehicles.length.toString(),
                          //                   style: AppStyle.cardfooter.copyWith(
                          //                       fontWeight: FontWeight.w300),
                          //                   maxLines:
                          //                       1, // Restrict to a single line for count as well
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //                 color: Colors.green,
                          //                 icon: const Icon(
                          //                     CupertinoIcons.graph_circle_fill,
                          //                     color: Colors.white)),
                          //             VehicleStatusCard(
                          //                 status: 'Stopped',
                          //                 count: Text(
                          //                   stopVehicles.length.toString(),
                          //                   style: AppStyle.cardfooter.copyWith(
                          //                       fontWeight: FontWeight.w300),
                          //                   maxLines:
                          //                       1, // Restrict to a single line for count as well
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //                 color: Colors.red,
                          //                 icon: const Icon(
                          //                   CupertinoIcons.square_fill,
                          //                   color: Colors.white,
                          //                 )),
                          //             VehicleStatusCard(
                          //                 status: 'Idling',
                          //                 count: Text(
                          //                   idleVehicles.length.toString(),
                          //                   style: AppStyle.cardfooter.copyWith(
                          //                       fontWeight: FontWeight.w300),
                          //                   maxLines:
                          //                       1, // Restrict to a single line for count as well
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //                 color: Colors.yellow,
                          //                 icon: const Icon(
                          //                     CupertinoIcons
                          //                         .square_split_2x1_fill,
                          //                     color: Colors.white)),
                          //             VehicleStatusCard(
                          //               status: 'Parked',
                          //               count: Text(
                          //                 parkedVehicles.length.toString(),
                          //                 style: AppStyle.cardfooter.copyWith(
                          //                     fontWeight: FontWeight.w300),
                          //                 maxLines:
                          //                     1, // Restrict to a single line for count as well
                          //                 overflow: TextOverflow.ellipsis,
                          //               ),
                          //               color: Colors.black,
                          //               icon: const Icon(
                          //                   CupertinoIcons.wifi_slash,
                          //                   color: Colors.white),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/car.png",
                                      // fit: BoxFit.cover, // Ensures the image scales properly
                                      width: 40, // Adjust image width
                                      height: 40, // Adjust image height
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Vehicle',
                                          style: AppStyle.cardSubtitle
                                              .copyWith(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  VehicleSearchDialog.showVehicleSearchDialog(
                                      context, token);
                                },
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  size: 15,
                                ))
                          ],
                        ),
                      ),
                    ),
                    isShopNow == false
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: 24),
                    isShopNow == false
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            // height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DashboardComponentTitle(
                                      logo: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          CupertinoIcons.cart,
                                          size: 25,
                                          color: Colors.green,
                                        ),
                                      ),
                                      title: 'Shop Now',
                                      subTitle: 'Get your equipment',
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                BlocProvider(
                                  create: (_) => sl<EshopGetAllProductBloc>()
                                    ..add(EshopGetProductsEvent(
                                        EshopTokenReqEntity(token: token ?? ""))),
                                  child: BlocConsumer<EshopGetAllProductBloc, EshopState>(
                                    builder: (context, state) {
                                      if (state is EshopLoading) {
                                        return CustomContainerLoadingButton();
                                      } else if (state is EshopGetProductsDone) {
                                        // Check if the schedule data is empty
                                        if (state.resp.products.data == null ||
                                            state.resp.products.data.isEmpty) {
                                          return Center(
                                            child: Text(
                                              'No available product',
                                              style: AppStyle.cardfooter,
                                            ),
                                          );
                                        }

                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: getVerticalSize(220),
                                              child: GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: state.resp.products
                                                            .data.length >
                                                        7
                                                    ? 7
                                                    : state.resp.products.data
                                                        .length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent:
                                                      100, // Set a max extent for the width
                                                  mainAxisSpacing:
                                                      10, // Adjust spacing between grid items
                                                  crossAxisSpacing: 5,
                                                  childAspectRatio:
                                                      0.8, // Adjust aspect ratio to fit content
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var product = state.resp
                                                      .products.data[index];
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  ProductReview(
                                                                    productName:
                                                                        product
                                                                            .name,
                                                                    productImage:
                                                                        product
                                                                            .image,
                                                                    price: product
                                                                        .price,
                                                                    categoryId: product
                                                                        .category_id
                                                                        .toString(),
                                                                    description:
                                                                        product
                                                                            .description,
                                                                    token:
                                                                        token!,
                                                                    productId:
                                                                        product
                                                                            .id,
                                                                  )));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .white, // Background color
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0), // Rounded corners
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5), // Shadow color
                                                            spreadRadius:
                                                                1, // How far the shadow spreads
                                                            blurRadius:
                                                                5, // Softness of the shadow
                                                            offset: const Offset(
                                                                0,
                                                                3), // Position of the shadow (x, y)
                                                          ),
                                                        ],
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        // mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Center(
                                                            child:
                                                                Image.network(
                                                              'https://ecom.verifycentre.com${state.resp.products.data[index].image}',
                                                              height: 60,
                                                              width: 60,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                }
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                          .green,
                                                                      strokeWidth:
                                                                          2.0,
                                                                      value: loadingProgress.expectedTotalBytes !=
                                                                              null
                                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                                              (loadingProgress.expectedTotalBytes ?? 1)
                                                                          : null,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              errorBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Object
                                                                          error,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                return const Icon(
                                                                  Icons.error,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .red,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Text(
                                                            state
                                                                .resp
                                                                .products
                                                                .data[index]
                                                                .name,
                                                            style: AppStyle
                                                                .cardSubtitle
                                                                .copyWith(
                                                                    fontSize:
                                                                        12),
                                                            //overflow: TextOverflow.ellipsis,
                                                            //maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(),
                                                const Spacer(),
                                                // CustomSecondaryButton(label: label, onPressed: onPressed)
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                EshopWidget(
                                                                    token:
                                                                        token)));
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                            .green[
                                                        500], // Default here
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 0.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  label: Row(
                                                    children: [
                                                      Text(
                                                        'More',
                                                        style: AppStyle
                                                            .cardSubtitle
                                                            .copyWith(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.black,
                                                        size: 18,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      } else {
                                        return Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Unable to load Product',
                                                  style: AppStyle.cardfooter,
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                CustomSecondaryButton(
                                                    label: 'Refresh',
                                                    onPressed: () {
                                                      BlocProvider.of<EshopGetAllProductBloc>(
                                                          context)
                                                          .add(EshopGetProductsEvent(
                                                          EshopTokenReqEntity(token: token ?? "")));
                                                    })
                                              ],
                                            ));
                                      }
                                    },
                                    listener: (context, state) {
                                      if (state is EshopFailure) {
                                        if (state.message
                                            .contains("Unauthenticated")) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/login",
                                              (route) => false);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(state.message)),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                    isMaintenanceReminder == false
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: 24),
                    isMaintenanceReminder == false
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            // height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DashboardComponentTitle(
                                      logo: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          CupertinoIcons.rocket,
                                          size: 25,
                                          color: Colors.green,
                                        ),
                                      ),
                                      title: 'Maintenance Reminder',
                                      subTitle: 'Vehicle maintenance reminder',
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Maintenance(
                                                        token: token,
                                                      )));
                                        },
                                        child: _buildReminderCard()),
                                    // const SizedBox(height: 0),
                                    // _buildMaintenanceCard(),
                                    // const SizedBox(height: 0),
                                    // _buildMaintenanceCard(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    isVehicleTrip == false
                        ? Container()
                        : const SizedBox(height: 24),
                    isVehicleTrip == false
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            // height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DashboardComponentTitle(
                                      logo: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.roundabout_right_outlined,
                                          size: 25,
                                          color: Colors.green,
                                        ),
                                      ),
                                      title: 'Vehicle Trips',
                                      subTitle: "Recent Status",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MotorShieldCard(token: token),
                                    // const SizedBox(height: 0),
                                    // _buildMaintenanceCard(),
                                  ],
                                ),
                              ],
                            ),
                          ),

                    // SizedBox(height: 20,),
                    // isQuickLinkReminder == false
                    //     ? Container()
                    //     : Container(
                    //   padding: const EdgeInsets.all(16.0),
                    //   // height: 350,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade200,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //           padding: const EdgeInsets.all(8.0),
                    //           decoration: BoxDecoration(
                    //             color: Colors.green.shade200,
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //           child: DashboardComponentTitle(
                    //             logo: const CircleAvatar(
                    //               backgroundColor: Colors.white,
                    //               child: Icon(
                    //                 CupertinoIcons.link,
                    //                 size: 25,
                    //                 color: Colors.green,
                    //               ),
                    //             ),
                    //             title: 'Quick Link',
                    //             subTitle: "Recent Status",
                    //           )),
                    //       const SizedBox(height: 10,),
                    //       SizedBox(
                    //         // height: 170,
                    //         child: SingleChildScrollView(
                    //           scrollDirection: Axis.horizontal,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   SizedBox(
                    //                     width: 180, // Set a fixed width for each card
                    //                     child: VehicleStatusCard(
                    //                         status: 'Moving',
                    //                         count: Text('0',
                    //                           style: AppStyle.cardfooter.copyWith(
                    //                               fontWeight: FontWeight.w300),
                    //                           maxLines: 1,
                    //                           overflow: TextOverflow.ellipsis,
                    //                         ),
                    //                         color: Colors.green,
                    //                         icon: const Icon(
                    //                             CupertinoIcons.car_detailed,
                    //                             color: Colors.white)),
                    //                   ),
                    //                   SizedBox(
                    //                     width: 180, // Set a fixed width for each card
                    //                     child: VehicleStatusCard(
                    //                         status: 'Offline',
                    //                         count: SizedBox(
                    //                             height: 15,
                    //                             width: 15,
                    //                             child: Container()),
                    //                         color: Colors.red,
                    //                         icon: const Icon(
                    //                           CupertinoIcons.square_fill,
                    //                           color: Colors.white,
                    //                         )),
                    //                   ),
                    //                 ],
                    //               ),
                    //              Row(
                    //                children: [
                    //                  SizedBox(
                    //                    width: 180,
                    //                    child: VehicleStatusCard(
                    //                        status: 'Idling',
                    //                        count: SizedBox(
                    //                            height: 15,
                    //                            width: 15,
                    //                            child: Container()),
                    //                        color: Colors.yellow,
                    //                        icon: const Icon(
                    //                            CupertinoIcons.square_split_2x1_fill,
                    //                            color: Colors.white)),
                    //                  ),
                    //                  SizedBox(
                    //                    width: 180, // Set a f
                    //                    child: VehicleStatusCard(
                    //                      status: 'Parked',
                    //                      count: SizedBox(
                    //                          height: 15,
                    //                          width: 15,
                    //                          child: Container()),
                    //                      color: Colors.black,
                    //                      icon: Icon(CupertinoIcons.wifi_slash,
                    //                          color: Colors.white),
                    //                    ),
                    //                  ),
                    //                ],
                    //              )
                    //
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //
                    //
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(
                      height: 20,
                    ),
                    isOdometerReminder == false
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            // height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    // Icons.assistant_direction_outlined,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DashboardComponentTitle(
                                      title: 'Odometer',
                                      subTitle: "In KM, Top 10",
                                      logo: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.assistant_direction_outlined,
                                          size: 25,
                                          color: Colors.green,
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [_buildOdometerList()],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget DashboardComponentTitle(
      {required String title,
      required String subTitle,
      required CircleAvatar logo}) {
    return Row(
      children: [
        logo,
        const SizedBox(
          width: 10,
        ),
        Expanded(
          // Ensures the text wraps and respects constraints
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                ),
                Text(
                  subTitle,
                  style: AppStyle.cardfooter.copyWith(fontSize: 12),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
                  maxLines: 2, // Restricts to 2 lines
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        // color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: VehicleStatusCard1(
                status: 'Due',
                count: '0',
                color: Colors.white,
                icon: Icon(
                  Icons.warning,
                  color: Colors.yellow,
                  size: 30,
                )),
          ),
          Expanded(
            child: VehicleStatusCard1(
                status: 'Overdue',
                count: '0',
                color: Colors.white,
                icon: Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 30,
                )),
          ),
        ],
      ),
    );
  }
}

class VehicleStatusCard extends StatelessWidget {
  final String status;
  final Widget count;
  final Color color;
  final Icon icon;

  const VehicleStatusCard({
    Key? key,
    required this.status,
    required this.count,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: icon,
            ),
            const SizedBox(width: 10),
            Expanded(
              // Expanded allows the text to wrap within available space
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: AppStyle.cardfooter
                        .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                    maxLines: 1, // Restrict to a single line
                    overflow:
                        TextOverflow.ellipsis, // Add ellipsis if text overflows
                  ),
                  const SizedBox(height: 4),
                  count,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleStatusCard1 extends StatelessWidget {
  final String status;
  final dynamic count;
  final Color color;
  final Icon icon;

  const VehicleStatusCard1({
    Key? key,
    required this.status,
    required this.count,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: icon,
            ),
            const SizedBox(width: 10),
            Expanded(
              // Expanded allows the text to wrap within available space
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: AppStyle.cardfooter
                        .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                    maxLines: 1, // Restrict to a single line
                    overflow:
                        TextOverflow.ellipsis, // Add ellipsis if text overflows
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count,
                    style: AppStyle.cardfooter
                        .copyWith(fontWeight: FontWeight.w300),
                    maxLines: 1, // Restrict to a single line for count as well
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MotorShieldCard extends StatelessWidget {
  final String? token;
  const MotorShieldCard({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    final dashVehicleReqEntity = DashVehicleReqEntity(
        token: token ?? "", contentType: 'application/json');
    return BlocProvider(
      create: (_) => sl<VehicleTripBloc>()
        ..add(DashVehicleEvent(DashVehicleReqEntity(
            token: dashVehicleReqEntity.token,
            contentType: dashVehicleReqEntity.contentType))),
      child: BlocConsumer<VehicleTripBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const CustomContainerLoadingButton();
          } else if (state is VehicleTripDone) {
            // Check if the schedule data is empty
            if (state.resp.isEmpty || state.resp == null) {
              return Center(
                child: Text(
                  'No available trip',
                  style: AppStyle.cardfooter,
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Details Section
                _DetailItem(title: "Vehicle", value: state.resp[0].vehicleVin),
                _DetailItem(title: "Driver", value: state.resp[0].name),
                // _DetailItem(title: "Trip Status", value: state.resp.),
                _DetailItem(
                    title: "Start Time",
                    value: state.resp[0].tripLocations[0].createdAt),
                _DetailItem(
                    title: "Start Location",
                    value: state.resp[0].tripLocations[0].startLocation),
                _DetailItem(
                    title: "End Time",
                    value: state.resp[0].tripLocations[0].arrivalTime),
                _DetailItem(
                    title: "End Location",
                    value: state.resp[0].tripLocations[0].endLocation),
                _DetailItem(
                    title: "Start Latitude",
                    value: state.resp[0].tripLocations[0].startLat),
                _DetailItem(
                    title: "End Latitude",
                    value: state.resp[0].tripLocations[0].endLat),
                // _DetailItem(title: "Number of Event", value: ),
              ],
            );
          } else {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Unable to load trip',
                      style: AppStyle.cardfooter,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomSecondaryButton(
                        label: 'Refresh',
                        onPressed: () {
                          BlocProvider.of<EshopGetAllProductBloc>(
                              context)
                              .add(EshopGetProductsEvent(
                              EshopTokenReqEntity(token: token ?? "")));
                        })
                  ],
                ));
          }
        },
        listener: (context, state) {
          if (state is DashboardFailure) {
            if (state.message.contains("Unauthenticated")) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyle.cardSubtitle.copyWith(fontSize: 12)),
          Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class VehicleStatusPieChart extends StatelessWidget {
  final int onlineCount;
  final int offlineCount;
  final int idlingCount;
  final int parkedCount;

  const VehicleStatusPieChart({
    Key? key,
    required this.onlineCount,
    required this.offlineCount,
    required this.idlingCount,
    required this.parkedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('online:::::: $onlineCount');
    print('offlineCount:::::: $offlineCount');
    // print('idlingCount:::::: $idlingCount');
    print('parkedCount:::::: $parkedCount');
    final total = onlineCount + offlineCount + idlingCount + parkedCount;
    if (total == 0) {
      return Center(
          child: Text(
        'No data available',
        style: AppStyle.cardfooter,
      ));
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: offlineCount.toDouble(),
              color: Colors.red,
              title: '',
              radius: 50,
            ),
            PieChartSectionData(
              value: onlineCount.toDouble(),
              color: Colors.green,
              title: '',
              //title: '${(movingCount / total * 100).toStringAsFixed(1)}%',
              radius: 50,
            ),
            PieChartSectionData(
              value: idlingCount.toDouble(),
              color: Colors.yellow,
              title: '',
              //title: '${(idlingCount / total * 100).toStringAsFixed(1)}%',
              radius: 50,
            ),
            PieChartSectionData(
              value: parkedCount.toDouble(),
              color: Colors.blueGrey[800],
              title: '',
              //title: '${(parkedCount / total * 100).toStringAsFixed(1)}%',
              radius: 50,
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}

class _BuildVehicleStatus extends StatelessWidget {
  final String title;
  final dynamic count;
  final CircleAvatar symbol;
  const _BuildVehicleStatus(
      {super.key,
      required this.title,
      required this.count,
      required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: AppStyle.cardSubtitle.copyWith(fontSize: 12)),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              count,
              // style: AppStyle.cardfooter,
              const SizedBox(
                width: 5,
              ),
              symbol
            ],
          )
        ],
      ),
    );
  }
}

///
// final vehicleWebsocketCounts = _computeVehicleSocketCounts(vehicles);
//
// print('object websocket idling ::: ${vehicleWebsocketCounts['idling'] ?? 0}');
// return Text(
//   '${vehicleWebsocketCounts['idling']}',
//   style: AppStyle
//       .cardfooter
//       .copyWith(
//           fontWeight:
//               FontWeight
//                   .w300),
//   maxLines:
//       1, // Restrict to a single line for count as well
//   overflow: TextOverflow
//       .ellipsis,
// );
///

//   GridView.count(
//   crossAxisCount: 2,
//   mainAxisSpacing:
//       10, // Adjust spacing between grid items
//   crossAxisSpacing: 10,
//   childAspectRatio: 1.9, //
//   physics:
//       const NeverScrollableScrollPhysics(),
//   children: [
//     const VehicleStatusPieChart(
//       onlineCount: 0,
//       offlineCount: 0,
//       idlingCount: 0,
//       parkedCount: 0,
//     ),
//     const SizedBox(
//       height: 10,
//     ),
//     Container(
//         height: 80,
//         padding: const EdgeInsets.symmetric(
//             horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius:
//               BorderRadius.circular(10),
//           color: Colors.white,
//         ),
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: const [
//             _BuildVehicleStatus(
//                 title: "Online",
//                 count: SizedBox(
//                     height: 15,
//                     width: 15,
//                     child:
//                         CircularProgressIndicator()),
//                 symbol: CircleAvatar(
//                   backgroundColor:
//                       Colors.green,
//                   radius: 8,
//                 )),
//             _BuildVehicleStatus(
//                 title: "Offline",
//                 count: SizedBox(
//                     height: 15,
//                     width: 15,
//                     child:
//                         CircularProgressIndicator()),
//                 symbol: CircleAvatar(
//                   backgroundColor: Colors.red,
//                   radius: 8,
//                 )),
//             _BuildVehicleStatus(
//                 title: "Idling",
//                 count: SizedBox(
//                     height: 15,
//                     width: 15,
//                     child:
//                         CircularProgressIndicator()),
//                 symbol: CircleAvatar(
//                   backgroundColor:
//                       Colors.yellow,
//                   radius: 8,
//                 )),
//             _BuildVehicleStatus(
//                 title: "Parking",
//                 count: SizedBox(
//                     height: 15,
//                     width: 15,
//                     child:
//                         CircularProgressIndicator()),
//                 symbol: CircleAvatar(
//                   backgroundColor:
//                       Colors.blueGrey,
//                   radius: 8,
//                 ))
//           ],
//         ))
//     // VehicleStatusCard(
//     //     status: 'Moving',
//     //     count: Text(
//     //       '0',
//     //       style: AppStyle.cardfooter.copyWith(
//     //           fontWeight: FontWeight.w300),
//     //       maxLines:
//     //           1, // Restrict to a single line for count as well
//     //       overflow: TextOverflow.ellipsis,
//     //     ),
//     //     color: Colors.green,
//     //     icon: const Icon(
//     //         CupertinoIcons.graph_circle_fill,
//     //         color: Colors.white)),
//     // const VehicleStatusCard(
//     //     status: 'Offline',
//     //     count: SizedBox(
//     //       height: 15,
//     //       width: 15,
//     //       child: CircularProgressIndicator(
//     //         strokeWidth: 2.0,
//     //       ),
//     //     ),
//     //     color: Colors.red,
//     //     icon: Icon(
//     //       CupertinoIcons.square_fill,
//     //       color: Colors.white,
//     //     )),
//     // const VehicleStatusCard(
//     //     status: 'Idling',
//     //     count: SizedBox(
//     //       height: 15,
//     //       width: 15,
//     //       child: CircularProgressIndicator(
//     //         strokeWidth: 2.0,
//     //       ),
//     //     ),
//     //     color: Colors.yellow,
//     //     icon: Icon(
//     //         CupertinoIcons
//     //             .square_split_2x1_fill,
//     //         color: Colors.white)),
//     // const VehicleStatusCard(
//     //   status: 'Parked',
//     //   count: SizedBox(
//     //     height: 15,
//     //     width: 15,
//     //     child: CircularProgressIndicator(
//     //       strokeWidth: 2.0,
//     //     ),
//     //   ),
//     //   color: Colors.black,
//     //   icon: Icon(CupertinoIcons.wifi_slash,
//     //       color: Colors.white),
//     // ),
//   ],
// );
///

// Widget _buildMaintenanceCard() {
//   return Container(
//     padding: const EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           blurRadius: 6,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Engine Oil Filter - Air Filter Change",
//           style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//           maxLines: 1,
//           overflow:
//               TextOverflow.ellipsis, // Ensures text truncates if too long
//         ),
//         const SizedBox(height: 4), // Added spacing between lines
//         Text(
//           "DM-GA-16-9495",
//           style: AppStyle.cardfooter.copyWith(fontSize: 12),
//           maxLines: 1,
//           overflow:
//               TextOverflow.ellipsis, // Ensures text truncates if too long
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(12.0),
//           decoration: BoxDecoration(
//             color: Colors.green.shade100,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Row(
//             children: [
//               const Flexible(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.hourglass_bottom,
//                             size: 18, color: Colors.black87),
//                         SizedBox(width: 8),
//                         Flexible(
//                           child: Text(
//                             "10000KM",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow:
//                                 TextOverflow.ellipsis, // Handles long text
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Expired (4000KM)",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.red,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis, // Truncate text
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               Flexible(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.schedule, size: 18, color: Colors.black87),
//                         SizedBox(width: 8),
//                         Flexible(
//                           child: Text(
//                             "200 Days",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow:
//                                 TextOverflow.ellipsis, // Handles long text
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Expired Days Left (50 days)",
//                       style: AppStyle.cardfooter
//                           .copyWith(color: Colors.red, fontSize: 12),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis, // Truncate text
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
///----
Widget _buildOdometerList() {
  // final data = [
  //   {"name": "OBD Plug and Play", "value": 2894368940},
  //   {"name": "CM-U-11-0654-Y", "value": 216774},
  //   {"name": "DM-GA327615", "value": 56127},
  //   {"name": "Motor Sheild", "value": 56127},
  //   {"name": "DM-GA-39-3528-Arra", "value": 56127},
  //   {"name": "DM-GHA-171796", "value": 56127},
  // ];

  return Padding(
    padding: EdgeInsets.zero,
    child: ListView.separated(
      shrinkWrap: true, // Prevents ListView from expanding infinitely
      padding: EdgeInsets.zero,
      itemCount: 1,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            "No record found",
            style: AppStyle.cardfooter,
          ),
        );
        // final item = data[index];
        // return _buildOdometerRow(
        //     item["name"] as String, item["value"] as int);
      },
    ),
  );
}

///
Widget _buildOdometerRow(String name, int value) {
  return Row(
    children: [
      Expanded(
        flex: 4,
        child: Text(name, style: AppStyle.cardSubtitle.copyWith(fontSize: 12)),
      ),
      Expanded(
        flex: 6,
        child: Stack(
          children: [
            const Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 0,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              // top: 0,
              child: Container(
                // height: 100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(value.toString(),
                    style: AppStyle.cardfooter.copyWith(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
