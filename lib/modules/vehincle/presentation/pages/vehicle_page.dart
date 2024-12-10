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
          .where((v) => v.last_location?.status!.toLowerCase() == "online")
          .length,
      'offline': vehicles
          .where((v) => v.last_location?.status!.toLowerCase() == "offline")
          .length,
      'idling': vehicles
          .where((v) => v.last_location?.status!.toLowerCase() == "idling")
          .length,
      'parked': vehicles
          .where((v) => v.last_location?.status!.toLowerCase() == "parked")
          .length,
      'vehicles': vehicles.length
    };
  }

  // Helper function to compute counts
  Map<String, int> _computeVehicleSocketCounts(List<VehicleEntity> vehicles) {
    return {
      'moving': vehicles
          .where((v) =>
              v.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
              v.locationInfo.tracker!.status!.toLowerCase() == "online")
          .length,
      'offline': vehicles
          .where((v) => v.locationInfo.vehicleStatus.toLowerCase() == "offline")
          .length,
      'idling': vehicles
          .where((v) =>
              v.locationInfo.vehicleStatus.toLowerCase() == "idling" &&
              v.locationInfo.tracker!.status!.toLowerCase() == "online")
          .length,
      'parked': vehicles
          .where((v) =>
              v.locationInfo.vehicleStatus.toLowerCase() == "parked" &&
              v.locationInfo.tracker!.status!.toLowerCase() == "online")
          .length,
    };
  }

  //print("Status changed for vehicle ${currentVehicle.locationInfo.numberPlate} "
  //               "from ${previousVehicle.last_location?.status} "
  //               "to ${currentVehicle.locationInfo.vehicleStatus} "
  //               "at ${DateTime.now()}");

  int checkStatusChange(List<DashDatumEntity> vehicles, List<VehicleEntity> websocketVehicle, String state, int? vehicleCount) {
    int totalVehicle = 0;
    for (var currentVehicle in websocketVehicle) {
      // Find the previous status of the current vehicle by matching vehicleId
      var previousVehicle = vehicles.firstWhere(
        (vehicle) => vehicle.number_plate == currentVehicle.locationInfo.numberPlate,
        orElse: () => DashDatumEntity(id: null, brand: '', model: '', year: '', type: '', vin: '', number_plate: '', user_id: null, vehicle_owner_id: null, created_at: '', updated_at: '', driver: null, owner: null, tracker: null, last_location: null), // If no previous vehicle is found, use null
      );

      if (previousVehicle != null) {
        // Compare the current status with the previous status
        if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() != previousVehicle.last_location?.status!.toLowerCase() ){

          // // If status changed and matches the given state, update totalVehicle count
          // if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() == state) {
          //   totalVehicle = vehicles.length - websocketVehicle.length;
          // }
          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() != state && state == "parked") {
            totalVehicle = vehicleCount! - currentVehicle.locationInfo.vehicleStatus.length;
          }

          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() != state && state == "idling") {
            totalVehicle = vehicleCount! - currentVehicle.locationInfo.vehicleStatus.length;
          }

          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() != state && state == "offline") {
            totalVehicle = vehicleCount! - currentVehicle.locationInfo.vehicleStatus.length;
          }

          // // Optionally, update the previous vehicle status in the list
          // previousVehicle.last_location?.status = currentVehicle.locationInfo.vehicleStatus;
        } else {
          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() == state && state == "parked") {
            totalVehicle = vehicleCount!;
          }

          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() == state && state == "idling") {
            totalVehicle = vehicleCount!;
          }

          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() == state && state == "offline") {
            totalVehicle = vehicleCount!;
          }
        }
      } else {}
    }

    // Ensure totalVehicle is never negative
    if (totalVehicle < 0) {
      totalVehicle = 0;
    }
    return totalVehicle;
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
                        final vehicleCounts =
                            _computeVehicleCounts(vehiclesData);

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
                                      offlineCount:
                                          vehicleCounts['offline'] ?? 0,
                                      idlingCount: vehicleCounts['idling'] ?? 0,
                                      parkedCount: vehicleCounts['parked'] ?? 0,
                                      vehiclesData: vehiclesData,
                                      movingCount: 0,
                                      token: token!),
                                );
                              }

                              final vehicleWebsocketCounts = _computeVehicleSocketCounts(vehicles);

                              return Expanded(
                                child: VehicleSubPage(
                                    onlineCount: vehicleWebsocketCounts['online'] ?? 0,
                                    offlineCount: checkStatusChange(vehiclesData, vehicles, 'offline', vehicleCounts['offline']),
                                    idlingCount: checkStatusChange(vehiclesData, vehicles, 'idling', vehicleCounts['idling']),
                                    parkedCount: checkStatusChange(vehiclesData, vehicles, 'parked', vehicleCounts['parked']),
                                    vehiclesData: vehiclesData,
                                    movingCount: vehicleWebsocketCounts['moving'] ?? 0,
                                    token: token!

                                    // onlineCount: vehicleWebsocketCounts['online'] ?? 0,
                                    // offlineCount: vehicleCounts['offline'] ?? 0,
                                    //
                                    // idlingCount: (vehicleCounts['idling'] == null
                                    //     && vehicleWebsocketCounts['idling']  == null)
                                    //     ? 0
                                    //     : (vehicleCounts['idling']! - vehicleWebsocketCounts['idling']!),
                                    //
                                    // parkedCount: (vehicleCounts['parked'] == null
                                    //     && vehicleWebsocketCounts['parked']  == null)
                                    //     ? 0
                                    //     : (vehicleCounts['parked']! - vehicleWebsocketCounts['moving']!),
                                    // vehiclesData: vehiclesData,
                                    // movingCount: vehicleWebsocketCounts['moving'] ?? 0,
                                    // token: token!
                                    ),
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

  @override
  void initState() {
    super.initState();
  }

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
    final idleVehicles = data
        .where((v) => v.last_location?.status!.toLowerCase() == "idling")
        .toList();
    return idleVehicles.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "No idle vehicle",
              style: AppStyle.cardfooter,
            ))
        : Expanded(
            child: VehicleIdle(
              data: idleVehicles,
              // vehicles: parkedVehicles,
              token: token,
            ),
          );

    //   BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
    //   listener: (context, vehicles) {},
    //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
    //     builder: (context, vehicles) {
    //       if (vehicles.isEmpty) {
    //         return Text(
    //           "No Idle vehicle",
    //           style: AppStyle.cardfooter,
    //         );
    //       }
    //       final idleVehicles = vehicles
    //           .where((v) =>
    //       (v.locationInfo.vehicleStatus == "Idling" ||
    //           v.locationInfo.vehicleStatus == "idling") &&
    //           (v.locationInfo.tracker?.status == "Online" ||
    //               v.locationInfo.tracker?.status == "online"))
    //           .toList();
    //       return Expanded(
    //         child: VehicleIdleItem(
    //           // data: data,
    //           vehicles: idleVehicles,
    //           token: token,
    //         ),
    //       );
    //     },
    //   ),
    // );
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
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "No moving vehicle",
                style: AppStyle.cardfooter,
              ),
            );
          }
          final movingVehicles = vehicles
              .where((v) =>
                  v.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
                  v.locationInfo.tracker?.status!.toLowerCase() == "online")
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
  }
}

class PackedVehiclesPage extends StatelessWidget {
  // final List<DatumEntity> data;
  final List<DashDatumEntity> data;
  final String? token;

  const PackedVehiclesPage({super.key, this.token, required this.data});

  // // Helper function to compute counts
  @override
  Widget build(BuildContext context) {
    final packedVehicles = data
        .where((v) => v.last_location?.status!.toLowerCase() == "parked")
        .toList();
    return packedVehicles.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "No parked vehicle",
              style: AppStyle.cardfooter,
            ))
        : Expanded(
            child: VehicleParked(
              data: packedVehicles,
              // vehicles: parkedVehicles,
              token: token,
            ),
          );
  }
}

class OfflineVehiclesPage extends StatelessWidget {
  final List<DashDatumEntity> data;
  final String? token;

  const OfflineVehiclesPage({super.key, this.token, required this.data});

  @override
  Widget build(BuildContext context) {
    final offlineLength = data
        .where((vehicle) =>
            vehicle.last_location?.status!.toLowerCase() == 'offline')
        .toList();
    return offlineLength.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "No offline vehicle",
              style: AppStyle.cardfooter,
            ))
        : Expanded(
            child: VehicleOffline(
              data: offlineLength,
              // vehicles: onlineVehicles,
              token: token,
            ),
          );
  }
}

class VehicleListItem extends StatefulWidget {
  final List<DashDatumEntity> data;
  final String? token;

  const VehicleListItem({
    super.key,
    this.token,
    required this.data,
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
                                                          .vehicleStatus ??
                                                      "N/A",
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

///----offline-----
class VehicleOffline extends StatefulWidget {
  final List<DashDatumEntity> data;
  final String? token;

  const VehicleOffline({
    super.key,
    this.token,
    required this.data,
  });

  @override
  State<VehicleOffline> createState() => _VehicleOfflineState();
}

class _VehicleOfflineState extends State<VehicleOffline> {
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
                      : Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

///----idle-----
class VehicleIdle extends StatefulWidget {
  final List<DashDatumEntity> data;
  final String? token;

  const VehicleIdle({
    super.key,
    this.token,
    required this.data,
  });

  @override
  State<VehicleIdle> createState() => _VehicleIdleState();
}

class _VehicleIdleState extends State<VehicleIdle> {
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
                      : Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

///----parked-----
class VehicleParked extends StatefulWidget {
  final List<DashDatumEntity> data;
  final String? token;

  const VehicleParked({
    super.key,
    this.token,
    required this.data,
  });

  @override
  State<VehicleParked> createState() => _VehicleParkedState();
}

class _VehicleParkedState extends State<VehicleParked> {
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
                      : Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

///-----vehicleStatus------

// class VehicleStatus extends StatefulWidget {
//   // final List<DatumEntity>? data;
//   final List<DashDatumEntity> data;
//   final String? token;
//   // final List<VehicleEntity>? vehicles;
//
//   const VehicleStatus({
//     super.key,
//     this.token,
//     // this.vehicles,
//     required this.data,
//     // required this.data,
//   });
//
//   @override
//   State<VehicleStatus> createState() => _VehicleStatusState();
// }
//
// class _VehicleStatusState extends State<VehicleStatus> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final displayedVehicles =
//         widget.data != null && widget.data.isNotEmpty ? widget.data : null;
//
//     return Expanded(
//       // height: 600,
//       child: ListView.builder(
//         shrinkWrap: true, // Prevents ListView from expanding infinitely
//         padding: EdgeInsets.zero,
//         itemCount: widget.data.length,
//         itemBuilder: (context, index) {
//           // final vehicle = effectiveDisplayedVehicles![index];
//           final vehicle = widget.data[index]; //displayedVehicles![index];
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: InkWell(
//               onTap: () {
//                 if (vehicle.last_location!.latitude != null) {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => VehicleRouteLastLocation(
//                         brand: vehicle.brand ?? 'N/A',
//                         model: vehicle.model ?? 'N/A',
//                         vin: vehicle.vin ?? 'N/A',
//                         latitude: double.tryParse(
//                             vehicle.last_location!.latitude ?? "0.000000"),
//                         longitude: double.tryParse(
//                             vehicle.last_location!.longitude ?? "0.000000"),
//                         token: widget.token ?? '',
//                         number_plate: vehicle.number_plate ?? '',
//                         name: vehicle.driver?.name ?? "N/A",
//                         email: vehicle.driver?.email ?? "N/A",
//                         phone: vehicle.driver?.phone ?? "N/A",
//                         status: vehicle.last_location?.status ?? "N/A",
//                         updated_at: vehicle.last_location?.updated_at ?? "N/A",
//                         speed: vehicle.last_location?.speed ?? "N/A",
//                         voltage_level:
//                             vehicle.last_location?.voltage_level ?? "N/A",
//                         gsm_signal_strength:
//                             vehicle.last_location?.gsm_signal_strength ?? "N/A",
//                         real_time_gps: true,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Vehicle coordinate is not found!'),
//                     ),
//                   );
//                 }
//               },
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         vehicle.last_location?.speed != null
//                             ? double.tryParse(
//                                         vehicle.last_location!.speed.toString())
//                                     ?.toStringAsFixed(2) ??
//                                 '0.00'
//                             : '0.00',
//                         style: AppStyle.cardTitle,
//                       ),
//
//                       // Text(
//                       //   vehicle.last_location?.speed?.toString() ?? "0.00",
//                       //   style: AppStyle.cardTitle,
//                       // ),
//                       const Text("KM/H", style: TextStyle(color: Colors.grey)),
//                       Icon(Icons.local_shipping,
//                           size: 40.0, color: Colors.grey.shade600),
//                     ],
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: Card(
//                       child: _buildVehicleDetails(vehicle),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildVehicleDetails(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
//     // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(8.0),
//             padding: const EdgeInsets.all(8.0),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${vehicle.brand} ${vehicle.model}',
//                   style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       vehicle.last_location?.status ?? "N/A",
//                       style: AppStyle.cardfooter,
//                     ),
//                     Text(
//                       FormatData.formatTimeAgo(
//                           vehicle.last_location!.created_at!),
//                       style: AppStyle.cardfooter.copyWith(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 5.0),
//           _buildVehicleStats(vehicle),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVehicleStats(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _buildStatIcon(Icons.gps_fixed, "true"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.wifi,
//                   vehicle.last_location?.gsm_signal_strength ?? "N/A"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.power, "OFF"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatIcon(IconData icon, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green),
//         Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
//       ],
//     );
//   }
// }

///------parked------
// class VehicleParked extends StatefulWidget {
//   final List<DashDatumEntity> data;
//   final String? token;
//   // final List<VehicleEntity>? vehicles;
//
//   const VehicleParked({
//     super.key,
//     // this.data,
//     this.token,
//     // this.vehicles,
//     required this.data,
//     // required this.data,
//     // /*this.displayedVehicles*/
//   });
//
//   @override
//   State<VehicleParked> createState() => _VehicleParkedState();
// }
//
// class _VehicleParkedState extends State<VehicleParked> {
//   // late List<DatumEntity> filteredVehicles;
//   // late List<VehicleEntity> filteredIdleVehicles;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final effectiveDisplayedVehicles =
//     //     widget.vehicles != null && widget.vehicles!.isNotEmpty
//     //         ? widget.vehicles
//     //         : null;
//     ///----
//     // final displayedVehicles =
//     //     widget.data != null && widget.data.isNotEmpty ? widget.data : null;
//     //
//     // final itemCount =
//     //     widget.vehicles == null ? widget.data.length : widget.vehicles!.length;
//
//     return Expanded(
//       child: ListView.builder(
//         shrinkWrap: true, // Prevents ListView from expanding infinitely
//         padding: EdgeInsets.zero,
//         itemCount: widget.data.length,
//         itemBuilder: (context, index) {
//           final vehicle = widget.data[index]; //displayedVehicles![index];
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: InkWell(
//               onTap: () {
//                 if (vehicle.last_location!.latitude != null) {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => VehicleRouteLastLocation(
//                         brand: vehicle.brand ?? 'N/A',
//                         model: vehicle.model ?? 'N/A',
//                         vin: vehicle.vin ?? 'N/A',
//                         latitude: double.tryParse(
//                             vehicle.last_location!.latitude ?? "0.000000"),
//                         longitude: double.tryParse(
//                             vehicle.last_location!.longitude ?? "0.000000"),
//                         token: widget.token ?? '',
//                         number_plate: vehicle.number_plate ?? '',
//                         name: vehicle.driver?.name ?? "N/A",
//                         email: vehicle.driver?.email ?? "N/A",
//                         phone: vehicle.driver?.phone ?? "N/A",
//                         status: vehicle.last_location?.status ?? "N/A",
//                         updated_at: vehicle.last_location?.updated_at ?? "N/A",
//                         speed: vehicle.last_location?.speed ?? "N/A",
//                         voltage_level:
//                         vehicle.last_location?.voltage_level ?? "N/A",
//                         gsm_signal_strength:
//                         vehicle.last_location?.gsm_signal_strength ?? "N/A",
//                         real_time_gps: true,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Vehicle coordinate is not found!',
//                         style: AppStyle.cardfooter,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         vehicle.last_location?.speed != null
//                             ? double.tryParse(
//                             vehicle.last_location!.speed.toString())
//                             ?.toStringAsFixed(2) ??
//                             '0.00'
//                             : '0.00',
//                         style: AppStyle.cardTitle,
//                       ),
//
//                       // Text(
//                       //   vehicle.last_location?.speed?.toString() ?? "0.00",
//                       //   style: AppStyle.cardTitle,
//                       // ),
//                       const Text("KM/H", style: TextStyle(color: Colors.grey)),
//                       Icon(Icons.local_shipping,
//                           size: 40.0, color: Colors.grey.shade600),
//                     ],
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: Card(
//                       child: _buildVehicleDetails(vehicle),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildVehicleDetails(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
//     // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(8.0),
//             padding: const EdgeInsets.all(8.0),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${vehicle.brand} ${vehicle.model}',
//                   style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       vehicle.last_location?.status ?? "N/A",
//                       style: AppStyle.cardfooter,
//                     ),
//                     Text(
//                       FormatData.formatTimeAgo(
//                           vehicle.updated_at ?? '2024-11-26T17:36:13.000000Z'),
//                       style: AppStyle.cardfooter.copyWith(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 5.0),
//           _buildVehicleStats(vehicle),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVehicleStats(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _buildStatIcon(Icons.gps_fixed, "true"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.wifi,
//                   vehicle.last_location?.gsm_signal_strength ?? "N/A"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.power, "OFF"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatIcon(IconData icon, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green),
//         Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
//       ],
//     );
//   }
// }

///------idle--------
// class VehicleIdleItem extends StatefulWidget {
//   // final List<DatumEntity>? data;
//   final String? token;
//   final List<VehicleEntity> vehicles;
//
//   const VehicleIdleItem({
//     super.key,
//     // this.data,
//     this.token,
//     required this.vehicles,
//     /*this.displayedVehicles*/
//   });
//
//   @override
//   State<VehicleIdleItem> createState() => _VehicleIdleItemState();
// }
//
// class _VehicleIdleItemState extends State<VehicleIdleItem> {
//   // late List<DatumEntity> filteredVehicles;
//   // late List<VehicleEntity> filteredIdleVehicles;
//
//   @override
//   void initState() {
//     super.initState();
//     // _filterVehicles();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final effectiveDisplayedVehicles =
//     widget.vehicles != null && widget.vehicles.isNotEmpty
//         ? widget.vehicles
//         : null;
//
//     final itemCount = widget.vehicles.isEmpty ? 0 : widget.vehicles.length;
//     return Expanded(
//       // height: 600,
//       child: ListView.builder(
//         shrinkWrap: true, // Prevents ListView from expanding infinitely
//         padding: EdgeInsets.zero,
//         itemCount: itemCount,
//         itemBuilder: (context, index) {
//           final vehicle = effectiveDisplayedVehicles![index];
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: InkWell(
//               onTap: () {
//                 if (vehicle.locationInfo.tracker?.position?.latitude != null) {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => VehicleRouteLastLocation(
//                         brand: vehicle.locationInfo.brand ?? '',
//                         model: vehicle.locationInfo.model ?? '',
//                         vin: vehicle.locationInfo.vin ?? '',
//                         latitude: double.tryParse(vehicle
//                             .locationInfo.tracker!.position!.latitude
//                             .toString()),
//                         longitude: double.tryParse(vehicle
//                             .locationInfo.tracker!.position!.longitude
//                             .toString()),
//                         token: widget.token ?? '',
//                         number_plate: vehicle.locationInfo.numberPlate ?? '',
//                         // name: widget.data![index].driver!.name!,
//                         // email: widget.data![index].driver!.email!,
//                         // phone: widget.data![index].driver!.phone!,
//                         status: vehicle.locationInfo.tracker!.status!,
//                         updated_at: vehicle.locationInfo.updatedAt,
//                         speed: vehicle.locationInfo.tracker!.position!.speed
//                             .toString(),
//                         voltage_level: vehicle
//                             .locationInfo.tracker!.position!.batteryLevel
//                             .toString(),
//                         gsm_signal_strength: vehicle
//                             .locationInfo.tracker!.position!.gsmRssi
//                             .toString(),
//                         real_time_gps: true,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Vehicle coordinate is not found!'),
//                     ),
//                   );
//                 }
//               },
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         vehicle.locationInfo.tracker?.position?.speed != null
//                             ? double.tryParse(vehicle
//                             .locationInfo.tracker!.position!.speed
//                             .toString())
//                             ?.toStringAsFixed(2) ??
//                             '0.00'
//                             : '0.00',
//                         style: AppStyle.cardTitle,
//                       ),
//
//                       // Text(
//                       //   vehicle.last_location?.speed?.toString() ?? "0.00",
//                       //   style: AppStyle.cardTitle,
//                       // ),
//                       const Text("KM/H", style: TextStyle(color: Colors.grey)),
//                       Icon(Icons.local_shipping,
//                           size: 40.0, color: Colors.grey.shade600),
//                     ],
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: Card(
//                       child: _buildVehicleDetails(vehicle),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildVehicleDetails(VehicleEntity vehicle) {
//     // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: const EdgeInsets.all(8.0),
//           padding: const EdgeInsets.all(8.0),
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '${vehicle.locationInfo.brand} ${vehicle.locationInfo.model}',
//                 style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//               ),
//               Column(
//                 children: [
//                   Text(
//                     vehicle.locationInfo.tracker?.status ?? "N/A",
//                     style: AppStyle.cardfooter,
//                   ),
//                   Text(
//                     FormatData.formatTimeAgo(
//                         vehicle.locationInfo.createdAt ??
//                             '2024-11-26T17:36:13.000000Z'),
//                     style: AppStyle.cardfooter.copyWith(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 5.0),
//         _buildVehicleStats(vehicle),
//       ],
//     );
//   }
//
//   Widget _buildVehicleStats(VehicleEntity vehicle) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _buildStatIcon(Icons.gps_fixed, "true"),
//               const SizedBox(width: 15),
//               _buildStatIcon(
//                   Icons.wifi,
//                   vehicle.locationInfo.tracker?.position?.gsmRssi.toString() ??
//                       "N/A"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.power,
//                   vehicle.locationInfo.tracker?.position?.ignition ?? "OFF"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatIcon(IconData icon, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green),
//         Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
//       ],
//     );
//   }
// }

///------offline------
// class VehicleOffline extends StatefulWidget {
//   // final List<DatumEntity>? data;
//   final List<DashDatumEntity> data;
//   final String? token;
//   // final List<VehicleEntity>? vehicles;
//
//   const VehicleOffline({
//     super.key,
//     this.token,
//     // this.vehicles,
//     required this.data,
//     // required this.data,
//   });
//
//   @override
//   State<VehicleOffline> createState() => _VehicleOfflineState();
// }
//
// class _VehicleOfflineState extends State<VehicleOffline> {
//   // late List<DatumEntity> filteredVehicles;
//   // late List<VehicleEntity> filteredIdleVehicles;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final displayedVehicles =
//     widget.data != null && widget.data.isNotEmpty ? widget.data : null;
//
//     return Expanded(
//       // height: 600,
//       child: ListView.builder(
//         shrinkWrap: true, // Prevents ListView from expanding infinitely
//         padding: EdgeInsets.zero,
//         itemCount: widget.data.length,
//         itemBuilder: (context, index) {
//           // final vehicle = effectiveDisplayedVehicles![index];
//           final vehicle = widget.data[index]; //displayedVehicles![index];
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: InkWell(
//               onTap: () {
//                 if (vehicle.last_location!.latitude != null) {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => VehicleRouteLastLocation(
//                         brand: vehicle.brand ?? 'N/A',
//                         model: vehicle.model ?? 'N/A',
//                         vin: vehicle.vin ?? 'N/A',
//                         latitude: double.tryParse(
//                             vehicle.last_location!.latitude ?? "0.000000"),
//                         longitude: double.tryParse(
//                             vehicle.last_location!.longitude ?? "0.000000"),
//                         token: widget.token ?? '',
//                         number_plate: vehicle.number_plate ?? '',
//                         name: vehicle.driver?.name ?? "N/A",
//                         email: vehicle.driver?.email ?? "N/A",
//                         phone: vehicle.driver?.phone ?? "N/A",
//                         status: vehicle.last_location?.status ?? "N/A",
//                         updated_at: vehicle.last_location?.updated_at ?? "N/A",
//                         speed: vehicle.last_location?.speed ?? "N/A",
//                         voltage_level:
//                         vehicle.last_location?.voltage_level ?? "N/A",
//                         gsm_signal_strength:
//                         vehicle.last_location?.gsm_signal_strength ?? "N/A",
//                         real_time_gps: true,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Vehicle coordinate is not found!'),
//                     ),
//                   );
//                 }
//               },
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         vehicle.last_location?.speed != null
//                             ? double.tryParse(
//                             vehicle.last_location!.speed.toString())
//                             ?.toStringAsFixed(2) ??
//                             '0.00'
//                             : '0.00',
//                         style: AppStyle.cardTitle,
//                       ),
//
//                       // Text(
//                       //   vehicle.last_location?.speed?.toString() ?? "0.00",
//                       //   style: AppStyle.cardTitle,
//                       // ),
//                       const Text("KM/H", style: TextStyle(color: Colors.grey)),
//                       Icon(Icons.local_shipping,
//                           size: 40.0, color: Colors.grey.shade600),
//                     ],
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: Card(
//                       child: _buildVehicleDetails(vehicle),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildVehicleDetails(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
//     // print('TimeStamp : ${vehicle.last_location?.updated_at.toString()}');
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(8.0),
//             padding: const EdgeInsets.all(8.0),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${vehicle.brand} ${vehicle.model}',
//                   style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       vehicle.last_location?.status ?? "N/A",
//                       style: AppStyle.cardfooter,
//                     ),
//                     Text(
//                       FormatData.formatTimeAgo(vehicle.updated_at!),
//                       style: AppStyle.cardfooter.copyWith(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 5.0),
//           _buildVehicleStats(vehicle),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVehicleStats(DashDatumEntity vehicle /*DatumEntity vehicle*/) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _buildStatIcon(Icons.gps_fixed, "true"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.wifi,
//                   vehicle.last_location?.gsm_signal_strength ?? "N/A"),
//               const SizedBox(width: 15),
//               _buildStatIcon(Icons.power, "OFF"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatIcon(IconData icon, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green),
//         Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 10)),
//       ],
//     );
//   }
//
// //   BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
// //   listener: (context, vehicles) {
// //     setState(() {
// //       vehicles;
// //     });
// //   },
// //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
// //     builder: (context, vehicles) {
// //       return vehicles.isEmpty ||
// //               widget.data![index].number_plate !=
// //                   vehicles[0].locationInfo.numberPlate
// //           ? InkWell(
// //               onTap: () {
// //                 widget.data![index].last_location!.latitude != null
// //                     ? Navigator.of(context).push(MaterialPageRoute(
// //                         builder: (context) =>
// //                             VehicleRouteLastLocation(
// //                                 brand: widget.data![index].brand!,
// //                                 model: widget.data![index].model!,
// //                                 vin: widget.data![index].vin!,
// //                                 latitude:
// //                                     // double.tryParse(
// //                                     //     widget.data![index].last_location!.latitude!),
// //                                     widget.data![index].last_location
// //                                                 ?.latitude !=
// //                                             null
// //                                         ? double.tryParse(widget
// //                                             .data![index]
// //                                             .last_location!
// //                                             .latitude!)
// //                                         : 0.000000,
// //                                 longitude:
// //                                     // double.tryParse(widget.data![index].last_location!.longitude!),
// //                                     widget.data![index].last_location
// //                                                 ?.longitude !=
// //                                             null
// //                                         ? double.tryParse(widget
// //                                             .data![index]
// //                                             .last_location!
// //                                             .longitude!)
// //                                         : 0.000000,
// //                                 token: widget.token ?? '',
// //                                 number_plate: widget
// //                                     .data![index].number_plate
// //                                     .toString()
// //                                 // ?? vehicle!.locationInfo.numberPlate,
// //                                 ),
// //                       ))
// //                     : ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                             content: Text(
// //                                 'Vehicle coordinate is not found!')),
// //                       );
// //               },
// //               child: Row(
// //                 children: [
// //                   Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         widget.data![index].last_location?.speed
// //                                 ?.toString() ??
// //                             "0.00",
// //                         style: AppStyle.cardTitle,
// //                       ),
// //                       const Text("KM/H",
// //                           style: TextStyle(color: Colors.grey)),
// //                       Icon(
// //                         Icons.local_shipping,
// //                         size: 40.0,
// //                         color: Colors.grey.shade600,
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(width: 10.0),
// //                   Expanded(
// //                     child: Card(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             margin: const EdgeInsets.all(8.0),
// //                             padding: const EdgeInsets.all(8.0),
// //                             color: Colors.white,
// //                             child: Row(
// //                               mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Text(
// //                                   '${widget.data![index].brand} ${widget.data![index].model}',
// //                                   style: AppStyle.cardSubtitle
// //                                       .copyWith(fontSize: 12),
// //                                 ),
// //                                 Column(
// //                                   children: [
// //                                     Text(
// //                                       widget.data![index]
// //                                               .last_location?.status
// //                                               ?.toString() ??
// //                                           "N/A",
// //                                       // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
// //                                       //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
// //                                       // widget.data![index]?.last_location?.status ?? "N/A",
// //                                       style: AppStyle.cardfooter,
// //                                     ),
// //                                     Text(
// //                                         FormatData.formatTimeAgo(
// //                                             widget
// //                                                 .data![index]
// //                                                 .last_location!
// //                                                 .updated_at
// //                                                 .toString()),
// //                                         style: AppStyle.cardfooter
// //                                             .copyWith(fontSize: 12)),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           const SizedBox(height: 5.0),
// //                           Padding(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 8.0),
// //                             child: Row(
// //                               mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     Column(
// //                                       children: [
// //                                         const Icon(Icons.gps_fixed,
// //                                             color: Colors.green),
// //                                         Text(
// //                                             widget
// //                                                 .data![index]
// //                                                 .last_location!
// //                                                 .gps_positioned
// //                                                 .toString(),
// //                                             style: AppStyle.cardfooter
// //                                                 .copyWith(
// //                                                     fontSize: 10)),
// //                                       ],
// //                                     ),
// //                                     const SizedBox(width: 15),
// //                                     Column(
// //                                       children: [
// //                                         const Icon(Icons.wifi,
// //                                             color: Colors.green),
// //                                         Text(
// //                                             widget
// //                                                 .data![index]
// //                                                 .last_location!
// //                                                 .gsm_signal_strength
// //                                                 .toString(),
// //                                             style: AppStyle.cardfooter
// //                                                 .copyWith(
// //                                                     fontSize: 10)),
// //                                       ],
// //                                     ),
// //                                     const SizedBox(width: 15),
// //                                     Column(
// //                                       children: [
// //                                         const Icon(Icons.power,
// //                                             color: Colors.green),
// //                                         Text("OFF",
// //                                             style: AppStyle.cardfooter
// //                                                 .copyWith(
// //                                                     fontSize: 10)),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 Column(
// //                                   children: [
// //                                     Text("Expires On",
// //                                         style: AppStyle.cardfooter),
// //                                     Chip(
// //                                       backgroundColor:
// //                                           Colors.green.shade200,
// //                                       label: Text("Unlimited",
// //                                           style: AppStyle.cardfooter
// //                                               .copyWith(
// //                                                   fontSize: 11)),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             )
// //           : vehicles[0].locationInfo.vehicleStatus == "moving"
// //               ? Container()
// //               : InkWell(
// //                   onTap: () {
// //                     Navigator.of(context).push(MaterialPageRoute(
// //                       builder: (context) => VehicleRouteLastLocation(
// //                           brand: vehicles[0].locationInfo.brand,
// //                           model: vehicles[0].locationInfo.model,
// //                           // widget.data![index].model!,
// //                           vin: vehicles[0]
// //                               .locationInfo
// //                               .vin, //widget.data![index].vin!,
// //                           latitude: vehicles[0]
// //                                   .locationInfo
// //                                   .tracker
// //                                   ?.position
// //                                   ?.latitude ??
// //                               0.000000,
// //                           longitude: vehicles[0]
// //                                   .locationInfo
// //                                   .tracker
// //                                   ?.position
// //                                   ?.longitude ??
// //                               0.0000000,
// //                           token: widget.token ?? '',
// //                           number_plate: vehicles[0]
// //                               .locationInfo
// //                               .numberPlate
// //                               .toString()
// //                           // ?? vehicle!.locationInfo.numberPlate,
// //                           ),
// //                     ));
// //                   },
// //                   child: Row(
// //                     children: [
// //                       Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Text(
// //                             vehicles[0]
// //                                         .locationInfo
// //                                         .tracker
// //                                         ?.position
// //                                         ?.speed !=
// //                                     null
// //                                 ? vehicles[0]
// //                                     .locationInfo
// //                                     .tracker!
// //                                     .position!
// //                                     .speed
// //                                     .toString()
// //                                 : widget.data![index].last_location
// //                                         ?.speed
// //                                         ?.toString() ??
// //                                     "0.00",
// //                             style: AppStyle.cardTitle,
// //                           ),
// //                           const Text("KM/H",
// //                               style: TextStyle(color: Colors.grey)),
// //                           Icon(
// //                             Icons.local_shipping,
// //                             size: 40.0,
// //                             color: Colors.grey.shade600,
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(width: 10.0),
// //                       Expanded(
// //                         child: Card(
// //                           child: Column(
// //                             crossAxisAlignment:
// //                                 CrossAxisAlignment.start,
// //                             children: [
// //                               Container(
// //                                 margin: const EdgeInsets.all(8.0),
// //                                 padding: const EdgeInsets.all(8.0),
// //                                 color: Colors.white,
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Text(
// //                                       '${vehicles[0].locationInfo.brand} ${vehicles[0].locationInfo.model}',
// //                                       style: AppStyle.cardSubtitle
// //                                           .copyWith(fontSize: 12),
// //                                     ),
// //                                     Column(
// //                                       children: [
// //                                         Text(
// //                                           vehicles[0]
// //                                                       .locationInfo
// //                                                       .tracker
// //                                                       ?.status !=
// //                                                   null
// //                                               ? vehicles[0]
// //                                                   .locationInfo
// //                                                   .tracker!
// //                                                   .status
// //                                                   .toString()
// //                                               : "N/A",
// //                                           // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
// //                                           //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
// //                                           // widget.data![index]?.last_location?.status ?? "N/A",
// //                                           style: AppStyle.cardfooter,
// //                                         ),
// //                                         Text(
// //                                             FormatData.formatTimeAgo(
// //                                                 vehicles[0]
// //                                                     .locationInfo
// //                                                     .updatedAt),
// //                                             style:
// //                                                 AppStyle.cardfooter),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 5.0),
// //                               Padding(
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 8.0),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Row(
// //                                       children: [
// //                                         Column(
// //                                           children: [
// //                                             const Icon(
// //                                                 Icons.gps_fixed,
// //                                                 color: Colors.green),
// //                                             Text("true",
// //                                                 style: AppStyle
// //                                                     .cardfooter
// //                                                     .copyWith(
// //                                                         fontSize:
// //                                                             10)),
// //                                           ],
// //                                         ),
// //                                         const SizedBox(width: 15),
// //                                         Column(
// //                                           children: [
// //                                             const Icon(Icons.wifi,
// //                                                 color: Colors.green),
// //                                             Text(
// //                                                 vehicles[0]
// //                                                     .locationInfo
// //                                                     .tracker!
// //                                                     .position!
// //                                                     .gsmRssi
// //                                                     .toString(),
// //                                                 style: AppStyle
// //                                                     .cardfooter
// //                                                     .copyWith(
// //                                                         fontSize:
// //                                                             10)),
// //                                           ],
// //                                         ),
// //                                         const SizedBox(width: 15),
// //                                         Column(
// //                                           children: [
// //                                             const Icon(Icons.power,
// //                                                 color: Colors.green),
// //                                             Text(
// //                                                 vehicles[0]
// //                                                     .locationInfo
// //                                                     .tracker!
// //                                                     .position!
// //                                                     .ignition,
// //                                                 style: AppStyle
// //                                                     .cardfooter
// //                                                     .copyWith(
// //                                                         fontSize:
// //                                                             10)),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                     Column(
// //                                       children: [
// //                                         Text("Expires On",
// //                                             style:
// //                                                 AppStyle.cardfooter),
// //                                         Chip(
// //                                           backgroundColor:
// //                                               Colors.green.shade200,
// //                                           label: Text("Unlimited",
// //                                               style: AppStyle
// //                                                   .cardfooter
// //                                                   .copyWith(
// //                                                       fontSize: 11)),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //     },
// //   ),
// // );
// }
