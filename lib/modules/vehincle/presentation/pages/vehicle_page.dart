import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/modules/dashboard/domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/req_entities/vehicle_req_entity.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/vehicle_resp_entity.dart';
import 'package:ctntelematics/modules/vehincle/presentation/bloc/vehicle_bloc.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_last_location.dart';
import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import 'package:ctntelematics/modules/websocket/presentation/bloc/vehicle_location_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/appBar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/format_data.dart';
import '../../../../service_locator.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../widgets/vehicle_state_update.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  bool isLoading = true;
  PrefUtils prefUtils = PrefUtils();
  String? first_name;
  String? last_name;
  String? middle_name;
  String? email;
  String? token;
  String? userId;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      if (authUser != null && authUser.isNotEmpty) {
        first_name = authUser[0].isEmpty ? null : authUser[0];
        last_name = authUser[1].isEmpty ? null : authUser[1];
        middle_name = authUser[2].isEmpty ? null : authUser[2];
        email = authUser[3].isEmpty ? null : authUser[3];
        token = authUser[4].isEmpty ? null : authUser[4];
        userId = authUser[5].isEmpty ? null : authUser[5];
      }
      if (token != null && userId != null) {
        sl<DashVehiclesBloc>().add(DashVehicleEvent(DashVehicleReqEntity(
            token: token!, contentType: 'application/json')));
      }
      isLoading = false;
    });
  }

  Map<String, int> _computeVehicleCounts(List<DashDatumEntity> vehicles) {
    return {
      'online': vehicles
          .where((v) =>
              v.last_location?.status == "online" ||
              v.last_location?.status == "Online")
          .length,
      'offline': vehicles
          .where((v) =>
              v.last_location?.status == "offline" ||
              v.last_location?.status == "Offline")
          .length,
      'idling': vehicles
          .where((v) =>
              v.last_location?.status == "idling" ||
              v.last_location?.status == "Idling")
          .length,
      'parked': vehicles
          .where((v) =>
              v.last_location?.status == "parked" ||
              v.last_location?.status == "Parked")
          .length,
      'vehicles': vehicles.length
    };
  }

  // Helper function to compute counts
  Map<String, int> _computeVehicleSocketCounts(List<VehicleEntity> vehicles) {
    return {
      'moving': vehicles
          .where((v) =>
              (v.locationInfo.vehicleStatus == "Moving" ||
                  v.locationInfo.vehicleStatus == "moving") &&
              (v.locationInfo.tracker!.status == "Online" ||
                  v.locationInfo.tracker!.status == "online"))
          .length,
      'offline': vehicles
          .where((v) =>
              v.locationInfo.vehicleStatus == "Offline" ||
              v.locationInfo.vehicleStatus == "offline")
          .length,
      'idling': vehicles
          .where((v) =>
              (v.locationInfo.vehicleStatus == "Idling" ||
                  v.locationInfo.vehicleStatus == "idling") &&
              (v.locationInfo.tracker!.status == "Online" ||
                  v.locationInfo.tracker!.status == "online"))
          .length,
      'parked': vehicles
          .where((v) =>
              (v.locationInfo.vehicleStatus == "Parked" ||
                  v.locationInfo.vehicleStatus == "parked") &&
              (v.locationInfo.tracker!.status == "Online" ||
                  v.locationInfo.tracker!.status == "online"))
          .length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedAppBar(
        firstname: first_name ?? "",
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.green,
            ))
          : Column(
              children: [
                BlocProvider(
                  create: (_) => sl<DashVehiclesBloc>()
                    ..add(DashVehicleEvent(DashVehicleReqEntity(
                        token: token ?? "", contentType: 'application/json'))),
                  child: BlocConsumer<DashVehiclesBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else if (state is DashboardDone) {
                        // Check if the vehicle data is empty
                        if (state.resp.data == null ||
                            state.resp.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No vehicles available',
                              style: AppStyle.cardfooter,
                            ),
                          );
                        }
                        final vehiclesData = state.resp.data ?? [];
                        final vehicleCounts = _computeVehicleCounts(vehiclesData);

                        return BlocListener<VehicleLocationBloc,
                            List<VehicleEntity>>(
                          listener: (context, vehicles) {},
                          child: BlocBuilder<VehicleLocationBloc,
                              List<VehicleEntity>>(
                            builder: (context, vehicles) {
                              if (vehicles.isEmpty) {
                                return Expanded(
                                  child: VehicleSubPage(
                                      onlineCount: vehicleCounts['online'] ?? 0,
                                      offlineCount: vehicleCounts['offline'] ?? 0,
                                      idlingCount: vehicleCounts['idling'] ?? 0,
                                      parkedCount: vehicleCounts['parked'] ?? 0,
                                      vehiclesData: vehiclesData,
                                      movingCount: 0,
                                      token: token!),
                                );
                              }

                              final vehicleWebsocketCounts =
                                  _computeVehicleSocketCounts(vehicles);

                              return Expanded(
                                child: VehicleSubPage(
                                    onlineCount: vehicleWebsocketCounts['online'] ?? 0,
                                    offlineCount: vehicleCounts['offline'] ?? 0,
                                    idlingCount: vehicleWebsocketCounts['idling'] ?? 0,
                                    parkedCount: vehicleCounts['parked'] ?? 0,
                                    vehiclesData: vehiclesData,
                                    movingCount: vehicleWebsocketCounts['moving'] ?? 0,
                                    token: token!),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  BlocProvider.of<DashVehiclesBloc>(context)
                                      .add(DashVehicleEvent(
                                          DashVehicleReqEntity(
                                              token: token ?? "",
                                              contentType:
                                                  'application/json')));
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
                )
              ],
            ),
    );
  }
}


//
//
// void _updateMarkers(List<LastLocationRespEntity> allVehicles, {required List<VehicleEntity> vehicles}) async {
//   List<Marker> updatedMarkers = List.from(_markers);
//
//   for (var vehicle in vehicles) {
//     print("vehicle status: ${vehicles[0].locationInfo.vehicleStatus}");
//     print("tracker status: ${vehicles[0].locationInfo.tracker?.status}");
//
//     if ((vehicle.locationInfo.vehicleStatus == "Moving" &&
//         vehicle.locationInfo.tracker!.status == "online" &&
//         vehicle.locationInfo.tracker!.position!.latitude != null &&
//         vehicle.locationInfo.tracker!.position!.longitude != null ||
//         vehicle.locationInfo.tracker!.status == "Online") ||
//         (vehicle.locationInfo.vehicleStatus == "Parked" &&
//             vehicle.locationInfo.tracker!.status == "online" &&
//             vehicle.locationInfo.tracker!.position!.latitude != null &&
//             vehicle.locationInfo.tracker!.position!.longitude != null ||
//             vehicle.locationInfo.tracker!.status == "Online") ||
//         (vehicle.locationInfo.vehicleStatus == "Idling" &&
//             vehicle.locationInfo.tracker!.status == "online" &&
//             vehicle.locationInfo.tracker!.position!.latitude != null &&
//             vehicle.locationInfo.tracker!.position!.longitude != null ||
//             vehicle.locationInfo.tracker!.status == "Online")) {
//       _addGeofencePolygon2(
//         vehicle.locationInfo.withinGeofence?.coordinates ?? [],
//       );
//
//       final currentPosition = LatLng(
//         double.parse(vehicle.locationInfo.tracker!.position!.latitude.toString()),
//         double.parse(vehicle.locationInfo.tracker!.position!.longitude.toString()),
//       );
//       final numberPlate = vehicle.locationInfo.numberPlate;
//
//       // Retrieve the previous position
//       final previousPosition = _previousPositions[numberPlate] ?? currentPosition;
//
//       // Cache the new position
//       _previousPositions[numberPlate] = currentPosition;
//
//       // Smoothly animate marker movement
//       _animateMarkerMovement(numberPlate, previousPosition, currentPosition, vehicle);
//
//       updatedMarkers.removeWhere((marker) => marker.markerId.value == numberPlate);
//     }
//   }
//
//   setState(() {
//     _markers = updatedMarkers;
//   });
// }
//


class VehicleSubPage extends StatefulWidget {
  final int onlineCount, offlineCount, idlingCount, parkedCount, movingCount;
  final List<DashDatumEntity> vehiclesData;
  final String token;
  const VehicleSubPage(
      {super.key,
      required this.onlineCount,
      required this.offlineCount,
      required this.idlingCount,
      required this.parkedCount,
      required this.vehiclesData,
      required this.movingCount,
      required this.token});

  @override
  State<VehicleSubPage> createState() => _VehicleSubPageState();
}

class _VehicleSubPageState extends State<VehicleSubPage> {
  int _selectedTabIndex = 0;
  // bool isLoading = true;
  // PrefUtils prefUtils = PrefUtils();
  // String? first_name;
  // String? last_name;
  // String? middle_name;
  // String? email;
  // String? token;
  // String? userId;
  // int vehicleCount = 0;
  // int movingCount = 0;
  // int idleCount = 0;
  // int offlineLength = 0;
  // int offlineCount = 0;
  // int packedCount = 0;

  @override
  void initState() {
    super.initState();
    // _initializeData();
  }

  // _initializeData() async {
  //   List<String>? authUser = await prefUtils.getStringList('auth_user');
  //   setState(() {
  //     if (authUser != null && authUser.isNotEmpty) {
  //       first_name = authUser[0].isEmpty ? null : authUser[0];
  //       last_name = authUser[1].isEmpty ? null : authUser[1];
  //       middle_name = authUser[2].isEmpty ? null : authUser[2];
  //       email = authUser[3].isEmpty ? null : authUser[3];
  //       token = authUser[4].isEmpty ? null : authUser[4];
  //       userId = authUser[5].isEmpty ? null : authUser[5];
  //     }
  //     if (token != null && userId != null) {
  //       sl<DashVehiclesBloc>().add(DashVehicleEvent(DashVehicleReqEntity(
  //           token: token!, contentType: 'application/json')));
  //     }
  //     isLoading = false;
  //   });
  // }
  //
  // Map<String, int> _computeVehicleCounts(List<DashDatumEntity> vehicles) {
  //   return {
  //     'online': vehicles
  //         .where((v) =>
  //             v.last_location?.status == "online" ||
  //             v.last_location?.status == "Online")
  //         .length,
  //     'offline': vehicles
  //         .where((v) =>
  //             v.last_location?.status == "offline" ||
  //             v.last_location?.status == "Offline")
  //         .length,
  //     'idling': vehicles
  //         .where((v) =>
  //             v.last_location?.status == "idling" ||
  //             v.last_location?.status == "Idling")
  //         .length,
  //     'parked': vehicles
  //         .where((v) =>
  //             v.last_location?.status == "parked" ||
  //             v.last_location?.status == "Parked")
  //         .length,
  //     'vehicles': vehicles.length
  //   };
  // }
  //
  // // Helper function to compute counts
  // Map<String, int> _computeVehicleSocketCounts(List<VehicleEntity> vehicles) {
  //   return {
  //     'moving': vehicles
  //         .where((v) =>
  //             (v.locationInfo.vehicleStatus == "Moving" ||
  //                 v.locationInfo.vehicleStatus == "moving") &&
  //             (v.locationInfo.tracker!.status == "Online" ||
  //                 v.locationInfo.tracker!.status == "online"))
  //         .length,
  //     'offline': vehicles
  //         .where((v) =>
  //             v.locationInfo.vehicleStatus == "Offline" ||
  //             v.locationInfo.vehicleStatus == "offline")
  //         .length,
  //     'idling': vehicles
  //         .where((v) =>
  //             (v.locationInfo.vehicleStatus == "Idling" ||
  //                 v.locationInfo.vehicleStatus == "idling") &&
  //             (v.locationInfo.tracker!.status == "Online" ||
  //                 v.locationInfo.tracker!.status == "online"))
  //         .length,
  //     'parked': vehicles
  //         .where((v) =>
  //             (v.locationInfo.vehicleStatus == "Parked" ||
  //                 v.locationInfo.vehicleStatus == "parked") &&
  //             (v.locationInfo.tracker!.status == "Online" ||
  //                 v.locationInfo.tracker!.status == "online"))
  //         .length,
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      "All (${widget.vehiclesData.length})",
      "Idle (${widget.idlingCount})",
      "Parked (${widget.parkedCount})",
      "Moving (${widget.movingCount})",
      "Offline (${widget.offlineCount})",
    ];

    return Column(
        children: [
          SizedBox(
            height: 45.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedTabIndex = index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      side: BorderSide.none,
                      backgroundColor: _selectedTabIndex == index
                          ? Colors.green
                          : Colors.grey.shade200,
                      label: Text(
                        tabs[index],
                        style: TextStyle(
                          color: _selectedTabIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dynamic Page Display
          Expanded(
            child: _buildSelectedPage(),
          ),
        ],
      );

  }

  Widget _buildSelectedPage() {
    switch (_selectedTabIndex) {
      case 0:
        return AllVehiclesPage(
          vehicles: widget.vehiclesData,
          token: widget.token,
        );
      case 1:
        return IdleVehiclesPage(
          data: widget.vehiclesData,
          token: widget.token,
        );
      case 2:
        return PackedVehiclesPage(
          data: widget.vehiclesData,
          token: widget.token,
        );
      case 3:
        return MovingVehiclesPage(
          vehicles: widget.vehiclesData,
          token: widget.token,
        );
      case 4:
        return OfflineVehiclesPage(
          data: widget.vehiclesData,
          token: widget.token,
        );
      default:
        return AllVehiclesPage(
          vehicles: widget.vehiclesData,
          token: widget.token,
        );
    }
  }
}

// BlocProvider(
//   create: (_) => sl<DashVehiclesBloc>()
//     ..add(DashVehicleEvent(DashVehicleReqEntity(
//         token: token ?? "", contentType: 'application/json'))),
//   child: BlocConsumer<DashVehiclesBloc, DashboardState>(
//     builder: (context, state) {
//       if (state is DashboardLoading) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.only(top: 10.0),
//             child: CircularProgressIndicator(
//               strokeWidth: 2.0,
//               color: Colors.green,
//             ),
//           ),
//         );
//       } else if (state is DashboardDone) {
//         // Check if the vehicle data is empty
//         if (state.resp.data == null ||
//             state.resp.data!.isEmpty) {
//           return Center(
//             child: Text(
//               'No vehicles available',
//               style: AppStyle.cardfooter,
//             ),
//           );
//         }
//
//         final vehiclesData = state.resp.data ?? [];
//         final vehicleCounts = _computeVehicleCounts(vehiclesData);
//
//         vehicleCount = vehicleCounts['vehicles'] ?? 0;
//         packedCount = vehicleCounts['parked'] ?? 0;
//         offlineLength = vehicleCounts['offline'] ?? 0;
//
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           setState(() {
//             vehicleCount;
//             packedCount;
//             offlineLength;
//           });
//         });
//
//         BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//           listener: (context, vehicles) {
//             // final vehicleWebsocketCounts = _computeVehicleSocketCounts(vehicles);
//             // print('idleCount-idleCount1: $idleCount');
//             // print('movingCount-movingCount2: $movingCount');
//           },
//           child: BlocBuilder<VehicleLocationBloc,
//               List<VehicleEntity>>(
//             builder: (context, vehicles) {
//               if (vehicles.isEmpty) {}
//
//               final vehicleWebsocketCounts = _computeVehicleSocketCounts(vehicles);
//
//               setState(() {
//                 idleCount = vehicleWebsocketCounts['idling'] ?? 0;
//                 movingCount = vehicleWebsocketCounts['moving'] ?? 0;
//               });
//               print('idleCount-idleCount: $idleCount');
//               print('movingCount-movingCount: $movingCount');
//               return Container();
//             },
//           ),
//         );
//
//         // Pass the data to the relevant page
//         switch (_selectedTabIndex) {
//           case 0:
//             return AllVehiclesPage(
//               vehicles: state.resp.data!,
//               token: token,
//             );
//           case 1:
//             return IdleVehiclesPage(
//               data: state.resp.data!,
//               token: token,
//             );
//           case 2:
//             return PackedVehiclesPage(
//               data: state.resp.data!,
//               token: token,
//             );
//
//           case 3:
//             return MovingVehiclesPage(
//               vehicles: state.resp.data!,
//               token: token,
//             );
//
//           case 4:
//             return OfflineVehiclesPage(
//               data: state.resp.data!,
//               token: token,
//             );
//           default:
//             return AllVehiclesPage(
//               vehicles: state.resp.data!,
//               token: token,
//             );
//         }
//       } else {
//         return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'No records found',
//                   style: AppStyle.cardfooter,
//                 ),
//                 const SizedBox(height: 10.0,),
//                 CustomSecondaryButton(
//                     label: 'Refresh',
//                     onPressed: () {
//                       BlocProvider.of<DashVehiclesBloc>(context)
//                           .add(DashVehicleEvent(DashVehicleReqEntity(
//                           token: token ?? "", contentType: 'application/json')));
//                     })
//               ],
//             ));
//       }
//     },
//     listener: (context, state) {
//       if (state is DashboardFailure) {
//         if (state.message.contains("Unauthenticated")) {
//           Navigator.pushNamedAndRemoveUntil(
//               context, "/login", (route) => false);
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(state.message)),
//         );
//       }
//     },
//   ),
// )

class AllVehiclesPage extends StatelessWidget {
  // final List<DatumEntity> vehicles;
  final List<DashDatumEntity> vehicles;
  final String? token;

  const AllVehiclesPage({
    super.key,
    this.token,
    required this.vehicles,
    /*required this.vehicles*/
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VehicleListItem(
        data: vehicles,
        token: token,
      ),
    );
  }
}

class MovingVehiclesPage extends StatefulWidget {
  // final List<DatumEntity> vehicles;
  final List<DashDatumEntity> vehicles;
  final String? token;

  const MovingVehiclesPage({super.key, this.token, required this.vehicles});

  @override
  State<MovingVehiclesPage> createState() => _MovingVehiclesPageState();
}

class _MovingVehiclesPageState extends State<MovingVehiclesPage> {
  //   List<VehicleEntity> _filterVehicles(List<VehicleEntity> vehicles) {
  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
      listener: (context, vehicles) {
        // _updateVehicleCounts(vehicles);
        setState(() {
          vehicles;
        });
      },
      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
        builder: (context, vehicles) {
          if (vehicles.isEmpty) {
            return const Text("No moving vehicle");
          }
          final movingVehicles = vehicles
              .where((v) =>
                  (v.locationInfo.vehicleStatus == "Moving" ||
                      v.locationInfo.vehicleStatus == "moving") &&
                  (v.locationInfo.tracker?.status == "online" ||
                      v.locationInfo.tracker?.status == "Online"))
              .toList();

          //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
          return Expanded(
            child: VehicleUpdateListener(
              vehicles: movingVehicles,
              token: widget.token,
            ),
          );
        },
      ),
    );
    //   VehicleListItem(
    //   data: movingVehicles,
    //   token: token,
    // );
  }
}




class OfflineVehiclesPage extends StatelessWidget {
  // final List<DatumEntity> data;
  final List<DashDatumEntity> data;
  final String? token;

  const OfflineVehiclesPage({super.key, this.token, required this.data});

  @override
  Widget build(BuildContext context) {
    final offlineLength = data
        .where((vehicle) =>
            vehicle.last_location?.status == 'offline' ||
            vehicle.last_location?.status == 'Offline')
        .toList();
    return Expanded(
      child: VehicleOffline(
        data: offlineLength,
        // vehicles: onlineVehicles,
        token: token,
      ),
    );

    //   BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
    //   listener: (context, vehicles) {},
    //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
    //     builder: (context, vehicles) {
    //       final offlineLength = data
    //           .where((vehicle) => vehicle.last_location?.status == 'offline' || vehicle.last_location?.status == 'Offline')
    //           .toList();
    //
    //       if (vehicles.isEmpty) {
    //         return VehicleOffline(
    //           data: offlineLength,
    //           token: token,
    //         );
    //       }
    //       // final onlineVehicles = vehicles
    //       //     .where((v) => v.locationInfo.tracker?.status != "online" || v.locationInfo.tracker?.status != "Online")
    //       //     .toList();
    //
    //       //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
    //       return VehicleOffline(
    //         data: data,
    //         // vehicles: onlineVehicles,
    //         token: token,
    //       );
    //     },
    //   ),
    // );
  }
}

class IdleVehiclesPage extends StatelessWidget {
  // final List<DatumEntity> data;
  final List<DashDatumEntity> data;
  final String? token;
  const IdleVehiclesPage({
    // required this.data,
    this.token,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
      listener: (context, vehicles) {},
      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
        builder: (context, vehicles) {
          if (vehicles.isEmpty) {
            return Text(
              "No Idle vehicle",
              style: AppStyle.cardfooter,
            );
          }
          final idleVehicles = vehicles
              .where((v) =>
                  (v.locationInfo.vehicleStatus == "Idling" ||
                      v.locationInfo.vehicleStatus == "idling") &&
                  (v.locationInfo.tracker?.status == "Online" ||
                      v.locationInfo.tracker?.status == "online"))
              .toList();
          return Expanded(
            child: VehicleIdleItem(
              // data: data,
              vehicles: idleVehicles,
              token: token,
            ),
          );
        },
      ),
    );
  }
}

class PackedVehiclesPage extends StatefulWidget {
  // final List<DatumEntity> data;
  final List<DashDatumEntity> data;
  final String? token;

  const PackedVehiclesPage({super.key, this.token, required this.data});

  @override
  State<PackedVehiclesPage> createState() => _PackedVehiclesPageState();
}

class _PackedVehiclesPageState extends State<PackedVehiclesPage> {
  // // Helper function to compute counts
  // Map<String, List<DashDatumEntity>> _computeVehicleCounts(List<DashDatumEntity> vehicles) {
  //   return {
  //     'parked': vehicles
  //         .where((v) =>
  //     v.last_location?.status == "parked" ||
  //         v.last_location?.status == "Parked").toList()
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    final packedVehicles = widget.data
        .where((v) =>
            v.last_location?.status == "Parked" ||
            v.last_location?.status == "parked")
        .toList();
    return Expanded(
      child: VehicleParked(
        data: packedVehicles,
        // vehicles: parkedVehicles,
        token: widget.token,
      ),
    );

    //     BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
    //   listener: (context, vehicles) {},
    //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
    //     builder: (context, vehicles) {
    //
    //       if (vehicles.isEmpty) {
    //         final packedCount = widget.data
    //             .where((vehicle) => vehicle.last_location?.status == 'parked' || vehicle.last_location?.status == 'Parked')
    //             .toList();
    //
    //         WidgetsBinding.instance.addPostFrameCallback((_) {
    //           setState(() {
    //             packedCount;
    //           });
    //         });
    //         return VehicleParked(
    //           data: vehicleCounts['parked'],
    //           token: widget.token,
    //         );
    //       }
    //       final parkedVehicles = vehicles
    //           .where((v) => v.locationInfo.vehicleStatus == "Parked")
    //           .toList();
    //
    //       return VehicleParked(
    //         data: widget.data,
    //         vehicles: parkedVehicles,
    //         token: widget.token,
    //       );
    //     },
    //   ),
    // );
  }
}

class VehicleListItem extends StatefulWidget {
  // final List<DatumEntity>? data;
  final List<DashDatumEntity> data;
  final String? token;

  const VehicleListItem({
    super.key,
    // this.data,
    this.token,
    required this.data,
    /*this.displayedVehicles*/
  });

  @override
  State<VehicleListItem> createState() => _VehicleListItemState();
}

class _VehicleListItemState extends State<VehicleListItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
              listener: (context, vehicles) {
                setState(() {
                  vehicles;
                });
              },
              child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                builder: (context, vehicles) {
                  return vehicles.isEmpty ||
                          widget.data[index].number_plate !=
                              vehicles[0].locationInfo.numberPlate
                      ? InkWell(
                          onTap: () {
                            widget.data[index].last_location?.latitude != null
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        VehicleRouteLastLocation(
                                      brand: widget.data[index].brand!,
                                      model: widget.data[index].model!,
                                      vin: widget.data[index].vin!,
                                      latitude: widget.data[index].last_location
                                                  ?.latitude !=
                                              null
                                          ? double.tryParse(widget.data[index]
                                              .last_location!.latitude!)
                                          : 0.000000,
                                      longitude: widget.data[index]
                                                  .last_location?.longitude !=
                                              null
                                          ? double.tryParse(widget.data[index]
                                              .last_location!.longitude!)
                                          : 0.000000,
                                      token: widget.token ?? '',
                                      number_plate: widget
                                          .data[index].number_plate
                                          .toString(),
                                      name: widget.data[index].driver?.name ??
                                          "N/A",
                                      email: widget.data[index].driver?.email ??
                                          "N/A",
                                      phone: widget.data[index].driver?.phone ??
                                          "N/A",
                                      status: widget.data[index].last_location!
                                              .status ??
                                          "N/A",
                                      updated_at: widget.data[index]
                                          .last_location!.created_at!,
                                      speed: widget.data[index].last_location
                                                  ?.speed !=
                                              null
                                          ? double.tryParse(widget.data[index]
                                                      .last_location!.speed!)
                                                  ?.toStringAsFixed(2) ??
                                              '0.00'
                                          : '0.00',

                                      voltage_level: widget.data[index]
                                              .last_location?.voltage_level ??
                                          "N/A",
                                      gsm_signal_strength: widget
                                              .data[index]
                                              .last_location
                                              ?.gsm_signal_strength ??
                                          "N/A",
                                      real_time_gps: widget.data[index]
                                              .last_location?.real_time_gps ??
                                          false,
                                      // ?? vehicle!.locationInfo.numberPlate,
                                    ),
                                  ))
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Vehicle coordinate is not found!')),
                                  );
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   "${(widget.data![index].last_location?.speed ?? 0.0).toStringAsFixed(2)}",

                                  Text(
                                    widget.data[index].last_location?.speed !=
                                            null
                                        ? double.tryParse(widget.data[index]
                                                    .last_location!.speed!)
                                                ?.toStringAsFixed(2) ??
                                            '0.00'
                                        : '0.00',
                                    style: AppStyle.cardTitle,
                                  ),
                                  const Text("KM/H",
                                      style: TextStyle(color: Colors.grey)),
                                  Icon(
                                    Icons.local_shipping,
                                    size: 40.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${widget.data[index].brand ?? "N/A"} ${widget.data[index].model ?? "N/A"}',
                                              style: AppStyle.cardSubtitle
                                                  .copyWith(fontSize: 12),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  widget
                                                          .data[index]
                                                          .last_location
                                                          ?.status ??
                                                      "N/A",
                                                  // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
                                                  //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
                                                  // widget.data![index]?.last_location?.status ?? "N/A",
                                                  style: AppStyle.cardfooter,
                                                ),
                                                Text(
                                                    FormatData.formatTimeAgo(
                                                        widget
                                                            .data[index]
                                                            // .created_at
                                                            .last_location!
                                                            .created_at
                                                            .toString()),
                                                    style: AppStyle.cardfooter
                                                        .copyWith(
                                                            fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(height: 5.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    const Icon(Icons.gps_fixed,
                                                        color: Colors.green),
                                                    Text('GPS',
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  children: [
                                                    const Icon(Icons.wifi,
                                                        color: Colors.green),
                                                    Text(
                                                        widget.data[index]
                                                                    .last_location !=
                                                                null
                                                            ? widget
                                                                .data[index]
                                                                .last_location!
                                                                .gsm_signal_strength
                                                                .toString()
                                                            : "N/A",
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  children: [
                                                    const Icon(Icons.power,
                                                        color: Colors.green),
                                                    Text("OFF",
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // Column(
                                            //   children: [
                                            //     Text("Expires On",
                                            //         style: AppStyle.cardfooter),
                                            //     Chip(
                                            //       backgroundColor:
                                            //           Colors.green.shade200,
                                            //       label: Text("Unlimited",
                                            //           style: AppStyle.cardfooter
                                            //               .copyWith(
                                            //                   fontSize: 11)),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VehicleRouteLastLocation(
                                brand: vehicles[0].locationInfo.brand,
                                model: vehicles[0].locationInfo.model,
                                // widget.data![index].model!,
                                vin: vehicles[0]
                                    .locationInfo
                                    .vin, //widget.data![index].vin!,
                                latitude: vehicles[0]
                                        .locationInfo
                                        .tracker
                                        ?.position
                                        ?.latitude ??
                                    0.000000,
                                longitude: vehicles[0]
                                        .locationInfo
                                        .tracker
                                        ?.position
                                        ?.longitude ??
                                    0.0000000,
                                token: widget.token ?? '',
                                number_plate: vehicles[0]
                                    .locationInfo
                                    .numberPlate
                                    .toString(),
                                name: widget.data[index].driver!.name ?? "N/A",
                                email:
                                    widget.data[index].driver!.email ?? "N/A",
                                phone:
                                    widget.data[index].driver!.phone ?? "N/A",
                                status:
                                    widget.data[index].last_location?.status ??
                                        "N/A",
                                updated_at: widget.data[index].updated_at!,
                                speed: vehicles[0]
                                            .locationInfo
                                            .tracker
                                            ?.position
                                            ?.speed !=
                                        null
                                    ? vehicles[0]
                                            .locationInfo
                                            .tracker!
                                            .position!
                                            .speed!
                                            .toStringAsFixed(2) ??
                                        widget.data[index].last_location!.speed!
                                    : '0.00',
                                // widget.data![index].last_location
                                //     ?.speed !=
                                //     null
                                //     ? double.tryParse(widget.data![index]
                                //     .last_location!.speed!)
                                //     ?.toStringAsFixed(2) ?? '0.00' : '0.00',
                                voltage_level: vehicles[0]
                                        .locationInfo
                                        .tracker
                                        ?.position
                                        ?.batteryLevel
                                        .toString() ??
                                    '0',
                                // widget.data![index]
                                //     .last_location?.voltage_level ?? "N/A",
                                gsm_signal_strength: vehicles[0]
                                        .locationInfo
                                        .tracker
                                        ?.position
                                        ?.gsmRssi
                                        .toString() ??
                                    '0',
                                // widget.data![index]
                                //     .last_location?.gsm_signal_strength ?? "N/A",
                                real_time_gps: widget.data[index].last_location
                                        ?.real_time_gps ??
                                    false,
                                // ?? vehicle!.locationInfo.numberPlate,
                              ),
                            ));
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    vehicles[0]
                                                .locationInfo
                                                .tracker
                                                ?.position
                                                ?.speed !=
                                            null
                                        ? vehicles[0]
                                            .locationInfo
                                            .tracker!
                                            .position!
                                            .speed!
                                            .toStringAsFixed(2)
                                        : widget.data[index].last_location
                                                ?.speed
                                                ?.toString() ??
                                            "0.00",
                                    style: AppStyle.cardTitle,
                                  ),
                                  const Text("KM/H",
                                      style: TextStyle(color: Colors.grey)),
                                  Icon(
                                    Icons.local_shipping,
                                    size: 40.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${vehicles[0].locationInfo.brand} ${vehicles[0].locationInfo.model}',
                                              style: AppStyle.cardSubtitle
                                                  .copyWith(fontSize: 12),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  vehicles[0]
                                                              .locationInfo
                                                              .tracker
                                                              ?.status !=
                                                          null
                                                      ? vehicles[0]
                                                          .locationInfo
                                                          .tracker!
                                                          .status
                                                          .toString()
                                                      : "N/A",
                                                  // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
                                                  //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
                                                  // widget.data![index]?.last_location?.status ?? "N/A",
                                                  style: AppStyle.cardfooter,
                                                ),
                                                Text(
                                                    FormatData.formatTimeAgo(
                                                        vehicles[0]
                                                            .locationInfo
                                                            .tracker!
                                                            .lastUpdate!
                                                        // .locationInfo
                                                        // .updatedAt
                                                        ),
                                                    style: AppStyle.cardfooter),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(height: 5.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    const Icon(Icons.gps_fixed,
                                                        color: Colors.green),
                                                    Text("GPS",
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  children: [
                                                    const Icon(Icons.wifi,
                                                        color: Colors.green),
                                                    Text(
                                                        vehicles[0]
                                                                    .locationInfo
                                                                    .tracker
                                                                    ?.position
                                                                    ?.gsmRssi !=
                                                                null
                                                            ? vehicles[0]
                                                                .locationInfo
                                                                .tracker!
                                                                .position!
                                                                .gsmRssi
                                                                .toString()
                                                            : 'N/A',
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  children: [
                                                    const Icon(Icons.power,
                                                        color: Colors.green),
                                                    Text(
                                                        vehicles[0]
                                                                .locationInfo
                                                                .tracker!
                                                                .position!
                                                                .ignition ??
                                                            "OFF",
                                                        style: AppStyle
                                                            .cardfooter
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // Column(
                                            //   children: [
                                            //     Text("Expires On",
                                            //         style: AppStyle.cardfooter),
                                            //     Chip(
                                            //       backgroundColor:
                                            //           Colors.green.shade200,
                                            //       label: Text("Unlimited",
                                            //           style: AppStyle.cardfooter
                                            //               .copyWith(
                                            //                   fontSize: 11)),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class VehicleUpdateListener extends StatelessWidget {
  final String? token;
  final List<VehicleEntity>? vehicles;

  const VehicleUpdateListener({
    super.key,
    this.token,
    required this.vehicles,
    /*this.displayedVehicles*/
  });

  @override
  Widget build(BuildContext context) {
    // Use `data` if it has elements; otherwise, use `displayedVehicles`
    // final effectiveDisplayedVehicles =
    //     vehicles != null && vehicles!.isNotEmpty ? vehicles : null;
    //
    // // Calculate itemCount based on which list is non-null and non-empty
    // final itemCount = effectiveDisplayedVehicles?.length ?? 0;

    return Expanded(
      // height: 600,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: vehicles!.length,
        itemBuilder: (context, index) {
          // Use `effectiveData` if available, otherwise `effectiveDisplayedVehicles`
          // final widget.data![index] = effectiveData != null ? effectiveData[index] : null;
          // final vehicle = effectiveDisplayedVehicles != null
          //     ? effectiveDisplayedVehicles[index]
          //     : null;
          final vehicle = vehicles![index];

          // Check if we have valid data; if not, skip rendering
          // if (widget.data![index] == null && vehicle == null) {
          //   return const SizedBox.shrink();
          // }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VehicleRouteLastLocationAndUpdate(
                    brand: vehicle.locationInfo.brand,
                    model: vehicle.locationInfo.model,
                    vin: vehicle.locationInfo.vin,
                    latitude:
                        vehicle.locationInfo.tracker?.position?.latitude ??
                            0.0000000,
                    longitude:
                        vehicle.locationInfo.tracker?.position?.longitude ??
                            0.0000000,
                    token: token ?? '',
                    number_plate: vehicle.locationInfo.numberPlate.toString(),
                    real_time_gps: true,
                    gsm_signal_strength: vehicle
                        .locationInfo.tracker!.position!.gsmRssi
                        .toString(),
                    voltage_level: vehicle
                        .locationInfo.tracker!.position!.batteryLevel
                        .toString(),
                    speed: vehicle.locationInfo.tracker!.position!.speed
                        .toString(),
                    updated_at: vehicle.locationInfo.tracker!.lastUpdate!,
                    status: vehicle.locationInfo.tracker!.status.toString(),
                    // ?? vehicle!.locationInfo.numberPlate,
                  ),
                ));
              },
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   widget.data![index].last_location
                      //       ?.speed != null
                      //       ? double.tryParse(widget.data![index].last_location!.speed!)
                      //       ?.toStringAsFixed(2) ?? '0.00'
                      //       : '0.00',
                      //   style: AppStyle.cardTitle,
                      // ),

                      Text(
                        vehicle.locationInfo.tracker?.position?.speed != null
                            ? double.tryParse(vehicle
                                        .locationInfo.tracker!.position!.speed
                                        .toString())
                                    ?.toStringAsFixed(2) ??
                                '0.00'
                            : '0.00',
                        style: AppStyle.cardTitle,
                      ),
                      const Text("KM/H", style: TextStyle(color: Colors.grey)),
                      Icon(
                        Icons.local_shipping,
                        size: 40.0,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // '${widget.data![index]!.brand} ${widget.data![index].model}',
                                  '${vehicle.locationInfo.brand} ${vehicle.locationInfo.model}',
                                  style: AppStyle.cardSubtitle
                                      .copyWith(fontSize: 12),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      // widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
                                      vehicle.locationInfo.tracker!.status ??
                                          "N/A",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                        FormatData.formatTimeAgo(vehicle
                                            .locationInfo.tracker!.lastUpdate!),
                                        style: const TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.gps_fixed,
                                            color: Colors.green),
                                        Text("GPS",
                                            style: AppStyle.cardfooter
                                                .copyWith(fontSize: 10)),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      children: [
                                        const Icon(Icons.wifi,
                                            color: Colors.green),
                                        Text(
                                            vehicles![index]
                                                        .locationInfo
                                                        .tracker
                                                        ?.position
                                                        ?.gsmRssi !=
                                                    null
                                                ? vehicles![index]
                                                    .locationInfo
                                                    .tracker!
                                                    .position!
                                                    .gsmRssi
                                                    .toString()
                                                : 'N/A',
                                            style: AppStyle.cardfooter
                                                .copyWith(fontSize: 10)),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      children: [
                                        const Icon(Icons.power,
                                            color: Colors.green),
                                        Text(
                                            vehicles![index]
                                                    .locationInfo
                                                    .tracker!
                                                    .position
                                                    ?.ignition ??
                                                "OFF",
                                            style: AppStyle.cardfooter
                                                .copyWith(fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VehicleIdleItem extends StatefulWidget {
  // final List<DatumEntity>? data;
  final String? token;
  final List<VehicleEntity> vehicles;

  const VehicleIdleItem({
    super.key,
    // this.data,
    this.token,
    required this.vehicles,
    /*this.displayedVehicles*/
  });

  @override
  State<VehicleIdleItem> createState() => _VehicleIdleItemState();
}

class _VehicleIdleItemState extends State<VehicleIdleItem> {
  // late List<DatumEntity> filteredVehicles;
  // late List<VehicleEntity> filteredIdleVehicles;

  @override
  void initState() {
    super.initState();
    // _filterVehicles();
  }

  // void _filterVehicles() {
  //   setState(() {
  //     filteredVehicles = widget.data!.where((vehicle) {
  //       return vehicle.last_location?.status?.toLowerCase() != "moving";
  //     }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final effectiveDisplayedVehicles =
        widget.vehicles != null && widget.vehicles.isNotEmpty
            ? widget.vehicles
            : null;

    // Calculate itemCount based on which list is non-null and non-empty
    // final itemCount = effectiveDisplayedVehicles?.length ?? 0;

    final itemCount = widget.vehicles.isEmpty ? 0 : widget.vehicles.length;
    return Expanded(
      // height: 600,
      child: ListView.builder(
        shrinkWrap: true, // Prevents ListView from expanding infinitely
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final vehicle = effectiveDisplayedVehicles![index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                if (vehicle.locationInfo.tracker?.position?.latitude != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VehicleRouteLastLocation(
                        brand: vehicle.locationInfo.brand ?? '',
                        model: vehicle.locationInfo.model ?? '',
                        vin: vehicle.locationInfo.vin ?? '',
                        latitude: double.tryParse(vehicle
                            .locationInfo.tracker!.position!.latitude
                            .toString()),
                        longitude: double.tryParse(vehicle
                            .locationInfo.tracker!.position!.longitude
                            .toString()),
                        token: widget.token ?? '',
                        number_plate: vehicle.locationInfo.numberPlate ?? '',
                        // name: widget.data![index].driver!.name!,
                        // email: widget.data![index].driver!.email!,
                        // phone: widget.data![index].driver!.phone!,
                        status: vehicle.locationInfo.tracker!.status!,
                        updated_at: vehicle.locationInfo.updatedAt,
                        speed: vehicle.locationInfo.tracker!.position!.speed
                            .toString(),
                        voltage_level: vehicle
                            .locationInfo.tracker!.position!.batteryLevel
                            .toString(),
                        gsm_signal_strength: vehicle
                            .locationInfo.tracker!.position!.gsmRssi
                            .toString(),
                        real_time_gps: true,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vehicle coordinate is not found!'),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vehicle.locationInfo.tracker?.position?.speed != null
                            ? double.tryParse(vehicle
                                        .locationInfo.tracker!.position!.speed
                                        .toString())
                                    ?.toStringAsFixed(2) ??
                                '0.00'
                            : '0.00',
                        style: AppStyle.cardTitle,
                      ),

                      // Text(
                      //   vehicle.last_location?.speed?.toString() ?? "0.00",
                      //   style: AppStyle.cardTitle,
                      // ),
                      const Text("KM/H", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.local_shipping,
                          size: 40.0, color: Colors.grey.shade600),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Card(
                      child: _buildVehicleDetails(vehicle),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleDetails(VehicleEntity vehicle) {
    // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${vehicle.locationInfo.brand} ${vehicle.locationInfo.model}',
                style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
              ),
              Column(
                children: [
                  Text(
                    vehicle.locationInfo.tracker?.status ?? "N/A",
                    style: AppStyle.cardfooter,
                  ),
                  Text(
                    FormatData.formatTimeAgo(
                        vehicle.locationInfo.updatedAt.toString() ??
                            '2024-11-26T17:36:13.000000Z'),
                    style: AppStyle.cardfooter.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        _buildVehicleStats(vehicle),
      ],
    );
  }

  Widget _buildVehicleStats(VehicleEntity vehicle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatIcon(Icons.gps_fixed, "true"),
              const SizedBox(width: 15),
              _buildStatIcon(
                  Icons.wifi,
                  vehicle.locationInfo.tracker?.position?.gsmRssi.toString() ??
                      "N/A"),
              const SizedBox(width: 15),
              _buildStatIcon(Icons.power,
                  vehicle.locationInfo.tracker?.position?.ignition ?? "OFF"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
      ],
    );
  }
}

class VehicleParked extends StatefulWidget {
  final List<DashDatumEntity> data;
  final String? token;
  // final List<VehicleEntity>? vehicles;

  const VehicleParked({
    super.key,
    // this.data,
    this.token,
    // this.vehicles,
    required this.data,
    // required this.data,
    // /*this.displayedVehicles*/
  });

  @override
  State<VehicleParked> createState() => _VehicleParkedState();
}

class _VehicleParkedState extends State<VehicleParked> {
  // late List<DatumEntity> filteredVehicles;
  // late List<VehicleEntity> filteredIdleVehicles;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final effectiveDisplayedVehicles =
    //     widget.vehicles != null && widget.vehicles!.isNotEmpty
    //         ? widget.vehicles
    //         : null;
    ///----
    // final displayedVehicles =
    //     widget.data != null && widget.data.isNotEmpty ? widget.data : null;
    //
    // final itemCount =
    //     widget.vehicles == null ? widget.data.length : widget.vehicles!.length;

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true, // Prevents ListView from expanding infinitely
        padding: EdgeInsets.zero,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final vehicle = widget.data[index]; //displayedVehicles![index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                if (vehicle.last_location!.latitude != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VehicleRouteLastLocation(
                        brand: vehicle.brand ?? 'N/A',
                        model: vehicle.model ?? 'N/A',
                        vin: vehicle.vin ?? 'N/A',
                        latitude: double.tryParse(
                            vehicle.last_location!.latitude ?? "0.000000"),
                        longitude: double.tryParse(
                            vehicle.last_location!.longitude ?? "0.000000"),
                        token: widget.token ?? '',
                        number_plate: vehicle.number_plate ?? '',
                        name: vehicle.driver?.name ?? "N/A",
                        email: vehicle.driver?.email ?? "N/A",
                        phone: vehicle.driver?.phone ?? "N/A",
                        status: vehicle.last_location?.status ?? "N/A",
                        updated_at: vehicle.last_location?.updated_at ?? "N/A",
                        speed: vehicle.last_location?.speed ?? "N/A",
                        voltage_level:
                            vehicle.last_location?.voltage_level ?? "N/A",
                        gsm_signal_strength:
                            vehicle.last_location?.gsm_signal_strength ?? "N/A",
                        real_time_gps: true,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Vehicle coordinate is not found!',
                        style: AppStyle.cardfooter,
                      ),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vehicle.last_location?.speed != null
                            ? double.tryParse(
                                        vehicle.last_location!.speed.toString())
                                    ?.toStringAsFixed(2) ??
                                '0.00'
                            : '0.00',
                        style: AppStyle.cardTitle,
                      ),

                      // Text(
                      //   vehicle.last_location?.speed?.toString() ?? "0.00",
                      //   style: AppStyle.cardTitle,
                      // ),
                      const Text("KM/H", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.local_shipping,
                          size: 40.0, color: Colors.grey.shade600),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Card(
                      child: _buildVehicleDetails(vehicle),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleDetails(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
    // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                ),
                Column(
                  children: [
                    Text(
                      vehicle.last_location?.status ?? "N/A",
                      style: AppStyle.cardfooter,
                    ),
                    Text(
                      FormatData.formatTimeAgo(
                          vehicle.updated_at ?? '2024-11-26T17:36:13.000000Z'),
                      style: AppStyle.cardfooter.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          _buildVehicleStats(vehicle),
        ],
      ),
    );
  }

  Widget _buildVehicleStats(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatIcon(Icons.gps_fixed, "true"),
              const SizedBox(width: 15),
              _buildStatIcon(Icons.wifi,
                  vehicle.last_location?.gsm_signal_strength ?? "N/A"),
              const SizedBox(width: 15),
              _buildStatIcon(Icons.power, "OFF"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
      ],
    );
  }
}

class VehicleOffline extends StatefulWidget {
  // final List<DatumEntity>? data;
  final List<DashDatumEntity> data;
  final String? token;
  // final List<VehicleEntity>? vehicles;

  const VehicleOffline({
    super.key,
    this.token,
    // this.vehicles,
    required this.data,
    // required this.data,
  });

  @override
  State<VehicleOffline> createState() => _VehicleOfflineState();
}

class _VehicleOfflineState extends State<VehicleOffline> {
  // late List<DatumEntity> filteredVehicles;
  // late List<VehicleEntity> filteredIdleVehicles;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayedVehicles =
        widget.data != null && widget.data.isNotEmpty ? widget.data : null;

    // final itemCount = widget.vehicles == null
    //     ? widget.data.length
    //     : widget.data.length;

    return Expanded(
      // height: 600,
      child: ListView.builder(
        shrinkWrap: true, // Prevents ListView from expanding infinitely
        padding: EdgeInsets.zero,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          // final vehicle = effectiveDisplayedVehicles![index];
          final vehicle = widget.data[index]; //displayedVehicles![index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                if (vehicle.last_location!.latitude != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VehicleRouteLastLocation(
                        brand: vehicle.brand ?? 'N/A',
                        model: vehicle.model ?? 'N/A',
                        vin: vehicle.vin ?? 'N/A',
                        latitude: double.tryParse(
                            vehicle.last_location!.latitude ?? "0.000000"),
                        longitude: double.tryParse(
                            vehicle.last_location!.longitude ?? "0.000000"),
                        token: widget.token ?? '',
                        number_plate: vehicle.number_plate ?? '',
                        name: vehicle.driver?.name ?? "N/A",
                        email: vehicle.driver?.email ?? "N/A",
                        phone: vehicle.driver?.phone ?? "N/A",
                        status: vehicle.last_location?.status ?? "N/A",
                        updated_at: vehicle.last_location?.updated_at ?? "N/A",
                        speed: vehicle.last_location?.speed ?? "N/A",
                        voltage_level:
                            vehicle.last_location?.voltage_level ?? "N/A",
                        gsm_signal_strength:
                            vehicle.last_location?.gsm_signal_strength ?? "N/A",
                        real_time_gps: true,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vehicle coordinate is not found!'),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vehicle.last_location?.speed != null
                            ? double.tryParse(
                                        vehicle.last_location!.speed.toString())
                                    ?.toStringAsFixed(2) ??
                                '0.00'
                            : '0.00',
                        style: AppStyle.cardTitle,
                      ),

                      // Text(
                      //   vehicle.last_location?.speed?.toString() ?? "0.00",
                      //   style: AppStyle.cardTitle,
                      // ),
                      const Text("KM/H", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.local_shipping,
                          size: 40.0, color: Colors.grey.shade600),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Card(
                      child: _buildVehicleDetails(vehicle),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleDetails(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
    // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                ),
                Column(
                  children: [
                    Text(
                      vehicle.last_location?.status ?? "N/A",
                      style: AppStyle.cardfooter,
                    ),
                    Text(
                      FormatData.formatTimeAgo(vehicle.updated_at!),
                      style: AppStyle.cardfooter.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          _buildVehicleStats(vehicle),
        ],
      ),
    );
  }

  Widget _buildVehicleStats(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatIcon(Icons.gps_fixed, "true"),
              const SizedBox(width: 15),
              _buildStatIcon(Icons.wifi,
                  vehicle.last_location?.gsm_signal_strength ?? "N/A"),
              const SizedBox(width: 15),
              _buildStatIcon(Icons.power, "OFF"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
      ],
    );
  }

//   BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//   listener: (context, vehicles) {
//     setState(() {
//       vehicles;
//     });
//   },
//   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//     builder: (context, vehicles) {
//       return vehicles.isEmpty ||
//               widget.data![index].number_plate !=
//                   vehicles[0].locationInfo.numberPlate
//           ? InkWell(
//               onTap: () {
//                 widget.data![index].last_location!.latitude != null
//                     ? Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) =>
//                             VehicleRouteLastLocation(
//                                 brand: widget.data![index].brand!,
//                                 model: widget.data![index].model!,
//                                 vin: widget.data![index].vin!,
//                                 latitude:
//                                     // double.tryParse(
//                                     //     widget.data![index].last_location!.latitude!),
//                                     widget.data![index].last_location
//                                                 ?.latitude !=
//                                             null
//                                         ? double.tryParse(widget
//                                             .data![index]
//                                             .last_location!
//                                             .latitude!)
//                                         : 0.000000,
//                                 longitude:
//                                     // double.tryParse(widget.data![index].last_location!.longitude!),
//                                     widget.data![index].last_location
//                                                 ?.longitude !=
//                                             null
//                                         ? double.tryParse(widget
//                                             .data![index]
//                                             .last_location!
//                                             .longitude!)
//                                         : 0.000000,
//                                 token: widget.token ?? '',
//                                 number_plate: widget
//                                     .data![index].number_plate
//                                     .toString()
//                                 // ?? vehicle!.locationInfo.numberPlate,
//                                 ),
//                       ))
//                     : ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text(
//                                 'Vehicle coordinate is not found!')),
//                       );
//               },
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         widget.data![index].last_location?.speed
//                                 ?.toString() ??
//                             "0.00",
//                         style: AppStyle.cardTitle,
//                       ),
//                       const Text("KM/H",
//                           style: TextStyle(color: Colors.grey)),
//                       Icon(
//                         Icons.local_shipping,
//                         size: 40.0,
//                         color: Colors.grey.shade600,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: Card(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.all(8.0),
//                             padding: const EdgeInsets.all(8.0),
//                             color: Colors.white,
//                             child: Row(
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   '${widget.data![index].brand} ${widget.data![index].model}',
//                                   style: AppStyle.cardSubtitle
//                                       .copyWith(fontSize: 12),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       widget.data![index]
//                                               .last_location?.status
//                                               ?.toString() ??
//                                           "N/A",
//                                       // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
//                                       //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
//                                       // widget.data![index]?.last_location?.status ?? "N/A",
//                                       style: AppStyle.cardfooter,
//                                     ),
//                                     Text(
//                                         FormatData.formatTimeAgo(
//                                             widget
//                                                 .data![index]
//                                                 .last_location!
//                                                 .updated_at
//                                                 .toString()),
//                                         style: AppStyle.cardfooter
//                                             .copyWith(fontSize: 12)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 5.0),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0),
//                             child: Row(
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       children: [
//                                         const Icon(Icons.gps_fixed,
//                                             color: Colors.green),
//                                         Text(
//                                             widget
//                                                 .data![index]
//                                                 .last_location!
//                                                 .gps_positioned
//                                                 .toString(),
//                                             style: AppStyle.cardfooter
//                                                 .copyWith(
//                                                     fontSize: 10)),
//                                       ],
//                                     ),
//                                     const SizedBox(width: 15),
//                                     Column(
//                                       children: [
//                                         const Icon(Icons.wifi,
//                                             color: Colors.green),
//                                         Text(
//                                             widget
//                                                 .data![index]
//                                                 .last_location!
//                                                 .gsm_signal_strength
//                                                 .toString(),
//                                             style: AppStyle.cardfooter
//                                                 .copyWith(
//                                                     fontSize: 10)),
//                                       ],
//                                     ),
//                                     const SizedBox(width: 15),
//                                     Column(
//                                       children: [
//                                         const Icon(Icons.power,
//                                             color: Colors.green),
//                                         Text("OFF",
//                                             style: AppStyle.cardfooter
//                                                 .copyWith(
//                                                     fontSize: 10)),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text("Expires On",
//                                         style: AppStyle.cardfooter),
//                                     Chip(
//                                       backgroundColor:
//                                           Colors.green.shade200,
//                                       label: Text("Unlimited",
//                                           style: AppStyle.cardfooter
//                                               .copyWith(
//                                                   fontSize: 11)),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : vehicles[0].locationInfo.vehicleStatus == "moving"
//               ? Container()
//               : InkWell(
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => VehicleRouteLastLocation(
//                           brand: vehicles[0].locationInfo.brand,
//                           model: vehicles[0].locationInfo.model,
//                           // widget.data![index].model!,
//                           vin: vehicles[0]
//                               .locationInfo
//                               .vin, //widget.data![index].vin!,
//                           latitude: vehicles[0]
//                                   .locationInfo
//                                   .tracker
//                                   ?.position
//                                   ?.latitude ??
//                               0.000000,
//                           longitude: vehicles[0]
//                                   .locationInfo
//                                   .tracker
//                                   ?.position
//                                   ?.longitude ??
//                               0.0000000,
//                           token: widget.token ?? '',
//                           number_plate: vehicles[0]
//                               .locationInfo
//                               .numberPlate
//                               .toString()
//                           // ?? vehicle!.locationInfo.numberPlate,
//                           ),
//                     ));
//                   },
//                   child: Row(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             vehicles[0]
//                                         .locationInfo
//                                         .tracker
//                                         ?.position
//                                         ?.speed !=
//                                     null
//                                 ? vehicles[0]
//                                     .locationInfo
//                                     .tracker!
//                                     .position!
//                                     .speed
//                                     .toString()
//                                 : widget.data![index].last_location
//                                         ?.speed
//                                         ?.toString() ??
//                                     "0.00",
//                             style: AppStyle.cardTitle,
//                           ),
//                           const Text("KM/H",
//                               style: TextStyle(color: Colors.grey)),
//                           Icon(
//                             Icons.local_shipping,
//                             size: 40.0,
//                             color: Colors.grey.shade600,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 10.0),
//                       Expanded(
//                         child: Card(
//                           child: Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.all(8.0),
//                                 padding: const EdgeInsets.all(8.0),
//                                 color: Colors.white,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       '${vehicles[0].locationInfo.brand} ${vehicles[0].locationInfo.model}',
//                                       style: AppStyle.cardSubtitle
//                                           .copyWith(fontSize: 12),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           vehicles[0]
//                                                       .locationInfo
//                                                       .tracker
//                                                       ?.status !=
//                                                   null
//                                               ? vehicles[0]
//                                                   .locationInfo
//                                                   .tracker!
//                                                   .status
//                                                   .toString()
//                                               : "N/A",
//                                           // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
//                                           //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
//                                           // widget.data![index]?.last_location?.status ?? "N/A",
//                                           style: AppStyle.cardfooter,
//                                         ),
//                                         Text(
//                                             FormatData.formatTimeAgo(
//                                                 vehicles[0]
//                                                     .locationInfo
//                                                     .updatedAt),
//                                             style:
//                                                 AppStyle.cardfooter),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Column(
//                                           children: [
//                                             const Icon(
//                                                 Icons.gps_fixed,
//                                                 color: Colors.green),
//                                             Text("true",
//                                                 style: AppStyle
//                                                     .cardfooter
//                                                     .copyWith(
//                                                         fontSize:
//                                                             10)),
//                                           ],
//                                         ),
//                                         const SizedBox(width: 15),
//                                         Column(
//                                           children: [
//                                             const Icon(Icons.wifi,
//                                                 color: Colors.green),
//                                             Text(
//                                                 vehicles[0]
//                                                     .locationInfo
//                                                     .tracker!
//                                                     .position!
//                                                     .gsmRssi
//                                                     .toString(),
//                                                 style: AppStyle
//                                                     .cardfooter
//                                                     .copyWith(
//                                                         fontSize:
//                                                             10)),
//                                           ],
//                                         ),
//                                         const SizedBox(width: 15),
//                                         Column(
//                                           children: [
//                                             const Icon(Icons.power,
//                                                 color: Colors.green),
//                                             Text(
//                                                 vehicles[0]
//                                                     .locationInfo
//                                                     .tracker!
//                                                     .position!
//                                                     .ignition,
//                                                 style: AppStyle
//                                                     .cardfooter
//                                                     .copyWith(
//                                                         fontSize:
//                                                             10)),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text("Expires On",
//                                             style:
//                                                 AppStyle.cardfooter),
//                                         Chip(
//                                           backgroundColor:
//                                               Colors.green.shade200,
//                                           label: Text("Unlimited",
//                                               style: AppStyle
//                                                   .cardfooter
//                                                   .copyWith(
//                                                       fontSize: 11)),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//     },
//   ),
// );
}

//
// class VehicleSubPage extends StatefulWidget {
//   final int onlineCount, offlineCount, idlingCount, parkedCount;
//   const VehicleSubPage({super.key, required this.onlineCount, required this.offlineCount, required this.idlingCount, required this.parkedCount});
//
//   @override
//   State<VehicleSubPage> createState() => _VehicleSubPageState();
// }
//
// class _VehicleSubPageState extends State<VehicleSubPage> {
//   int _selectedTabIndex = 0;
//   bool isLoading = true;
//   PrefUtils prefUtils = PrefUtils();
//   String? first_name;
//   String? last_name;
//   String? middle_name;
//   String? email;
//   String? token;
//   String? userId;
//   int vehicleCount = 0;
//   int movingCount = 0;
//   int idleCount = 0;
//   int offlineLength = 0;
//   int offlineCount = 0;
//   int packedCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   _initializeData() async {
//     List<String>? authUser = await prefUtils.getStringList('auth_user');
//     setState(() {
//       if (authUser != null && authUser.isNotEmpty) {
//         first_name = authUser[0].isEmpty ? null : authUser[0];
//         last_name = authUser[1].isEmpty ? null : authUser[1];
//         middle_name = authUser[2].isEmpty ? null : authUser[2];
//         email = authUser[3].isEmpty ? null : authUser[3];
//         token = authUser[4].isEmpty ? null : authUser[4];
//         userId = authUser[5].isEmpty ? null : authUser[5];
//       }
//       if (token != null && userId != null) {
//         sl<DashVehiclesBloc>().add(DashVehicleEvent(DashVehicleReqEntity(
//             token: token!, contentType: 'application/json')));
//       }
//       isLoading = false;
//     });
//   }
//
//   Map<String, int> _computeVehicleCounts(List<DashDatumEntity> vehicles) {
//     return {
//       'online': vehicles
//           .where((v) =>
//       v.last_location?.status == "online" ||
//           v.last_location?.status == "Online")
//           .length,
//       'offline': vehicles
//           .where((v) =>
//       v.last_location?.status == "offline" ||
//           v.last_location?.status == "Offline")
//           .length,
//       'idling': vehicles
//           .where((v) =>
//       v.last_location?.status == "idling" ||
//           v.last_location?.status == "Idling")
//           .length,
//       'parked': vehicles
//           .where((v) =>
//       v.last_location?.status == "parked" ||
//           v.last_location?.status == "Parked")
//           .length,
//       'vehicles': vehicles.length
//     };
//   }
//
//   // Helper function to compute counts
//   Map<String, int> _computeVehicleSocketCounts(List<VehicleEntity> vehicles) {
//     return {
//       'moving': vehicles
//           .where((v) =>
//       (v.locationInfo.vehicleStatus == "Moving" ||
//           v.locationInfo.vehicleStatus == "moving") &&
//           (v.locationInfo.tracker!.status == "Online" ||
//               v.locationInfo.tracker!.status == "online"))
//           .length,
//       'offline': vehicles
//           .where((v) =>
//       v.locationInfo.vehicleStatus == "Offline" ||
//           v.locationInfo.vehicleStatus == "offline")
//           .length,
//       'idling': vehicles
//           .where((v) =>
//       (v.locationInfo.vehicleStatus == "Idling" ||
//           v.locationInfo.vehicleStatus == "idling") &&
//           (v.locationInfo.tracker!.status == "Online" ||
//               v.locationInfo.tracker!.status == "online"))
//           .length,
//       'parked': vehicles
//           .where((v) =>
//       (v.locationInfo.vehicleStatus == "Parked" ||
//           v.locationInfo.vehicleStatus == "parked") &&
//           (v.locationInfo.tracker!.status == "Online" ||
//               v.locationInfo.tracker!.status == "online"))
//           .length,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> tabs = [
//       "All ($vehicleCount)",
//       "Idle ($idleCount)",
//       "Parked ($packedCount)",
//       "Moving ($movingCount)",
//       "Offline ($offlineLength)",
//     ];
//
//     return Scaffold(
//       appBar: AnimatedAppBar(
//         firstname: first_name ?? "",
//       ),
//       body: isLoading
//           ? const Center(
//           child: CircularProgressIndicator(
//             strokeWidth: 2.0,
//             color: Colors.green,
//           ))
//           : Column(
//         children: [
//           SizedBox(
//             height: 45.0,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: tabs.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() => _selectedTabIndex = index);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Chip(
//                       side: BorderSide.none,
//                       backgroundColor: _selectedTabIndex == index
//                           ? Colors.green
//                           : Colors.grey.shade200,
//                       label: Text(
//                         tabs[index],
//                         style: TextStyle(
//                           color: _selectedTabIndex == index
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           BlocProvider(
//             create: (_) => sl<DashVehiclesBloc>()
//               ..add(DashVehicleEvent(DashVehicleReqEntity(
//                   token: token ?? "", contentType: 'application/json'))),
//             child: BlocConsumer<DashVehiclesBloc, DashboardState>(
//               builder: (context, state) {
//                 if (state is DashboardLoading) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 10.0),
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.0,
//                         color: Colors.green,
//                       ),
//                     ),
//                   );
//                 } else if (state is DashboardDone) {
//                   // Check if the vehicle data is empty
//                   if (state.resp.data == null ||
//                       state.resp.data!.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No vehicles available',
//                         style: AppStyle.cardfooter,
//                       ),
//                     );
//                   }
//
//                   final vehiclesData = state.resp.data ?? [];
//                   final vehicleCounts = _computeVehicleCounts(vehiclesData);
//
//                   vehicleCount = vehicleCounts['vehicles'] ?? 0;
//                   packedCount = vehicleCounts['parked'] ?? 0;
//                   offlineLength = vehicleCounts['offline'] ?? 0;
//
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     setState(() {
//                       vehicleCount;
//                       packedCount;
//                       offlineLength;
//                     });
//                   });
//
//                   BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//                     listener: (context, vehicles) {
//                       // final vehicleWebsocketCounts = _computeVehicleSocketCounts(vehicles);
//                       // print('idleCount-idleCount1: $idleCount');
//                       // print('movingCount-movingCount2: $movingCount');
//                     },
//                     child: BlocBuilder<VehicleLocationBloc,
//                         List<VehicleEntity>>(
//                       builder: (context, vehicles) {
//                         if (vehicles.isEmpty) {}
//
//                         final vehicleWebsocketCounts = _computeVehicleSocketCounts(vehicles);
//
//                         setState(() {
//                           idleCount = vehicleWebsocketCounts['idling'] ?? 0;
//                           movingCount = vehicleWebsocketCounts['moving'] ?? 0;
//                         });
//                         print('idleCount-idleCount: $idleCount');
//                         print('movingCount-movingCount: $movingCount');
//                         return Container();
//                       },
//                     ),
//                   );
//
//                   // Pass the data to the relevant page
//                   switch (_selectedTabIndex) {
//                     case 0:
//                       return AllVehiclesPage(
//                         vehicles: state.resp.data!,
//                         token: token,
//                       );
//                     case 1:
//                       return IdleVehiclesPage(
//                         data: state.resp.data!,
//                         token: token,
//                       );
//                     case 2:
//                       return PackedVehiclesPage(
//                         data: state.resp.data!,
//                         token: token,
//                       );
//
//                     case 3:
//                       return MovingVehiclesPage(
//                         vehicles: state.resp.data!,
//                         token: token,
//                       );
//
//                     case 4:
//                       return OfflineVehiclesPage(
//                         data: state.resp.data!,
//                         token: token,
//                       );
//                     default:
//                       return AllVehiclesPage(
//                         vehicles: state.resp.data!,
//                         token: token,
//                       );
//                   }
//                 } else {
//                   return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'No records found',
//                             style: AppStyle.cardfooter,
//                           ),
//                           const SizedBox(height: 10.0,),
//                           CustomSecondaryButton(
//                               label: 'Refresh',
//                               onPressed: () {
//                                 BlocProvider.of<DashVehiclesBloc>(context)
//                                     .add(DashVehicleEvent(DashVehicleReqEntity(
//                                     token: token ?? "", contentType: 'application/json')));
//                               })
//                         ],
//                       ));
//                 }
//               },
//               listener: (context, state) {
//                 if (state is DashboardFailure) {
//                   if (state.message.contains("Unauthenticated")) {
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, "/login", (route) => false);
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.message)),
//                   );
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
