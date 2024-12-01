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
  int _selectedTabIndex = 0;
  bool isLoading = true;
  PrefUtils prefUtils = PrefUtils();
  String? first_name;
  String? last_name;
  String? middle_name;
  String? email;
  String? token;
  String? userId;
  int vehicleCount = 0;
  int movingCount = 0;
  int idleCount = 0;
  int offlineLength = 0;
  int offlineCount = 0;
  int packedCount = 0;

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
        // if (!sl.isRegistered<PusherService>()) {
        //   sl.registerSingleton<PusherService>(PusherService(token!, userId!));
        //   final pusherService = sl<PusherService>();
        //   pusherService.initializePusher();
        // }
        sl<DashVehiclesBloc>().add(DashVehicleEvent(
            DashVehicleReqEntity(token: token!, contentType: 'application/json')));
      }
      isLoading = false;
    });
  }

  List<VehicleEntity> _filterVehicles(List<VehicleEntity> vehicles) {
    switch (_selectedTabIndex) {
      case 1:
        return vehicles
            .where((v) => v.locationInfo.vehicleStatus == "Moving")
            .toList();
      // case 2:
      //   return vehicles
      //       .where((v) => v.locationInfo.vehicleStatus == "Stopped")
      //       .toList();
      // case 3:
      //   return vehicles
      //       .where((v) => v.locationInfo.vehicleStatus == "Idle")
      //       .toList();
      //
      // case 4:
      //   return vehicles
      //       .where((v) => v.locationInfo.vehicleStatus == "Parked")
      //       .toList();
      default:
        return vehicles;
    }
  }

  void _updateVehicleCounts(List<VehicleEntity> vehicles) {
    movingCount = vehicles
        .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Moving')
        .length;
    // stoppedCount = vehicles
    //     .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Stopped')
    //     .length;
    // idleCount = vehicles
    //     .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Idle')
    //     .length;
    // packedCount = vehicles
    //     .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Parked')
    //     .length;
    // vehicleCount = vehicles.length;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      "All ($vehicleCount)",
      "Idle ($idleCount)",
      "Parked ($packedCount)",
      "Moving ($movingCount)",
      "Offline ($offlineLength)",
    ];

    return Scaffold(
      appBar: AnimatedAppBar(
        firstname: first_name ?? "",
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                            child: CircularProgressIndicator(strokeWidth: 2.0),
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

                        vehicleCount = state.resp.data?.length ?? 0;

                        offlineLength = state.resp.data
                                ?.where((vehicle) =>
                                    vehicle.last_location?.status == 'offline')
                                .length ??
                            0;

                        packedCount = state.resp.data
                                ?.where((vehicle) =>
                                    vehicle.last_location?.status == 'parked')
                                .length ?? 0;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            vehicleCount;
                          });
                        });

                        BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
                          listener: (context, vehicles) {
                            // _updateVehicleCounts(vehicles);
                              setState(() {
                                vehicles;
                              });
                          },
                          child: BlocBuilder<VehicleLocationBloc,
                              List<VehicleEntity>>(
                            builder: (context, vehicles) {
                              if (vehicles.isEmpty) {
                                //return const Text("No moving vehicle");
                              }
                              final movingVehicles = vehicles
                                  .where((v) =>
                                      v.locationInfo.vehicleStatus == "Moving")
                                  .toList();

                              final idlingVehicles = vehicles.where((v) {
                                return v.locationInfo.vehicleStatus == "Idling";
                              }).toList();

                              final onlineVehicles = vehicles.where((v) {
                                return v.locationInfo.tracker?.status ==
                                    "online";
                              }).toList();


                              movingCount == movingVehicles.length;
                              packedCount = packedCount;//vehicleCount - movingVehicles.length;
                              idleCount = idlingVehicles.length;
                              offlineLength = offlineLength - onlineVehicles.length;

                              //List<VehicleEntity> displayedVehicles =_filterVehicles(vehicles);
                              // _updateVehicleCounts(vehicles);
                              return Container();
                            },
                          ),
                        );

                        // Pass the data to the relevant page
                        switch (_selectedTabIndex) {
                          case 0:
                            return AllVehiclesPage(
                              vehicles: state.resp.data!,
                              token: token,
                            );
                          case 1:
                            return IdleVehiclesPage(
                              data: state.resp.data!,
                              token: token,
                            );
                          case 2:
                            return PackedVehiclesPage(
                              data: state.resp.data!,
                              token: token,
                            );

                          case 3:
                            return MovingVehiclesPage(
                              vehicles: state.resp.data!,
                              token: token,
                            );

                          case 4:
                            return OfflineVehiclesPage(
                              data: state.resp.data!,
                              token: token,
                            );
                          default:
                            return AllVehiclesPage(
                              vehicles: state.resp.data!,
                              token: token,
                            );
                        }
                      } else {
                        return Center(
                            child: Text(
                          'No records found',
                          style: AppStyle.cardfooter,
                        ));
                      }
                    },
                    listener: (context, state) {
                      if (state is DashboardFailure) {
                        if (state.message.contains("Unauthenticated")) {
                        Navigator.pushNamed(context, "/login");
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

class AllVehiclesPage extends StatelessWidget {
  // final List<DatumEntity> vehicles;
  final List<DashDatumEntity> vehicles;
  final String? token;

  const AllVehiclesPage({super.key, this.token, required this.vehicles, /*required this.vehicles*/});

  @override
  Widget build(BuildContext context) {
    return VehicleListItem(
      data: vehicles,
      token: token,
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
              .where((v) => v.locationInfo.vehicleStatus == "Moving")
              .toList();

          //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
          return VehicleUpdateListener(
            vehicles: movingVehicles,
            token: widget.token,
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
    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
      listener: (context, vehicles) {},
      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
        builder: (context, vehicles) {
         final  offlineLength = data.where((vehicle) =>
          vehicle.last_location?.status == 'offline').toList();

          if (vehicles.isEmpty) {
            return VehicleOffline(
              data: offlineLength,
              token: token,
            );
          }
          final offlineVehicles = vehicles
              .where((v) => v.locationInfo.tracker?.status != "offline")
              .toList();

          //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
          return VehicleOffline(
            data: data,
            vehicles: offlineVehicles,
            token: token,
          );
        },
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
    this.token, required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
      listener: (context, vehicles) {},
      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
        builder: (context, vehicles) {
          if (vehicles.isEmpty) {
            return const Text("No Idle vehicle");
          }
          final idleVehicles = vehicles
              .where((v) => v.locationInfo.vehicleStatus == "Idling")
              .toList();
          return VehicleIdleItem(
            // data: data,
            vehicles: idleVehicles,
            token: token,
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
      listener: (context, vehicles) {},
      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
        builder: (context, vehicles) {
          if (vehicles.isEmpty) {
            final packedCount = data.where((vehicle) =>
            vehicle.last_location?.status == 'parked').toList();

            return VehicleParked(
              data: packedCount,
              token: token,
            );
          }
          final parkedVehicles = vehicles
              .where((v) => v.locationInfo.tracker?.status != "parked")
              .toList();
          return VehicleParked(
            data: data,
            vehicles: parkedVehicles,
            token: token,
          );
        },
      ),
    );
    //   BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
    //   listener: (context, vehicles) {
    //     // _updateVehicleCounts(vehicles);
    //     // setState(() {
    //     //   vehicles;
    //     // });
    //   },
    //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
    //     builder: (context, vehicles) {
    //       if (vehicles.isEmpty) {
    //         return const Text("No Packed vehicle");
    //       }
    //
    //       final packedVehicles = vehicles
    //           .where((v) => v.locationInfo.vehicleStatus == "Parked")
    //           .toList();
    //
    //       // List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
    //
    //       return VehicleUpdateListener(
    //         vehicles: packedVehicles,
    //         token: token,
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
    this.token, required this.data,
    /*this.displayedVehicles*/
  });

  @override
  State<VehicleListItem> createState() => _VehicleListItemState();
}

class _VehicleListItemState extends State<VehicleListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        // height: 600,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
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
                                      latitude: widget.data[index]
                                                  .last_location?.latitude !=
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
                                      email:
                                          widget.data[index].driver?.email ??
                                              "N/A",
                                      phone:
                                          widget.data[index].driver?.phone ??
                                              "N/A",
                                      status: widget.data[index].last_location!
                                              .status ??
                                          "N/A",
                                      updated_at:
                                          widget.data[index].updated_at!,
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
                                                  widget.data[index]
                                                          .last_location?.status ??
                                                      "N/A",
                                                  // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
                                                  //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
                                                  // widget.data![index]?.last_location?.status ?? "N/A",
                                                  style: AppStyle.cardfooter,
                                                ),
                                                Text(
                                                    FormatData.formatTimeAgo(
                                                        widget.data[index]
                                                            .updated_at
                                                            // .last_location!
                                                            // .updated_at
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
                                        widget
                                            .data[index].last_location!.speed!
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
                                                            .updatedAt),
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
            );
          },
        ),
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
    final effectiveDisplayedVehicles =
        vehicles != null && vehicles!.isNotEmpty ? vehicles : null;

    // Calculate itemCount based on which list is non-null and non-empty
    final itemCount = effectiveDisplayedVehicles?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        // height: 600,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Use `effectiveData` if available, otherwise `effectiveDisplayedVehicles`
            // final widget.data![index] = effectiveData != null ? effectiveData[index] : null;
            final vehicle = effectiveDisplayedVehicles != null
                ? effectiveDisplayedVehicles[index]
                : null;

            // Check if we have valid data; if not, skip rendering
            // if (widget.data![index] == null && vehicle == null) {
            //   return const SizedBox.shrink();
            // }

            return InkWell(
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
                    updated_at: vehicle.locationInfo.updatedAt,
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
                        vehicle!.locationInfo.tracker?.position?.speed != null
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
                                        FormatData.formatTimeAgo(
                                            vehicle.locationInfo.updatedAt),
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        Text("GSM",
                                            style: AppStyle.cardfooter
                                                .copyWith(fontSize: 10)),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      children: [
                                        const Icon(Icons.power,
                                            color: Colors.green),
                                        Text("Ignition",
                                            style: AppStyle.cardfooter
                                                .copyWith(fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     Text("Expires On",
                                //         style: AppStyle.cardfooter),
                                //     Chip(
                                //       backgroundColor: Colors.green.shade200,
                                //       label: Text("Unlimited",
                                //           style: AppStyle.cardfooter
                                //               .copyWith(fontSize: 11)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        // height: 600,
        child: ListView.builder(
          shrinkWrap: true, // Prevents ListView from expanding infinitely
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final vehicle = effectiveDisplayedVehicles![index];

            return InkWell(
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
            );
          },
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
  // final List<DatumEntity>? data;
  final List<DashDatumEntity> data;
  final String? token;
  final List<VehicleEntity>? vehicles;

  const VehicleParked({
    super.key,
    // this.data,
    this.token,
    this.vehicles, required this.data,
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

    final displayedVehicles =
        widget.data != null && widget.data.isNotEmpty ? widget.data : null;

    final itemCount = widget.vehicles == null
        ? widget.data.length
        : widget.vehicles!.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        // height: 600,
        child: ListView.builder(
          shrinkWrap: true, // Prevents ListView from expanding infinitely
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // final vehicle = effectiveDisplayedVehicles![index];
            final vehicle = displayedVehicles![index];

            return InkWell(
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
                      content: Text('Vehicle coordinate is not found!', style: AppStyle.cardfooter,),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildVehicleDetails(DashDatumEntity vehicle/*DatumEntity vehicle*/) {
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

  Widget _buildVehicleStats(DashDatumEntity vehicle/*DatumEntity vehicle*/) {
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

class VehicleOffline extends StatefulWidget {
  // final List<DatumEntity>? data;
  final List<DashDatumEntity> data;
  final String? token;
  final List<VehicleEntity>? vehicles;

  const VehicleOffline({
    super.key,
    this.token,
    this.vehicles, required this.data,
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

    final itemCount = widget.vehicles == null
        ? widget.data.length
        : widget.data.length - widget.vehicles!.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        // height: 600,
        child: ListView.builder(
          shrinkWrap: true, // Prevents ListView from expanding infinitely
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // final vehicle = effectiveDisplayedVehicles![index];
            final vehicle = displayedVehicles![index];

            return InkWell(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildVehicleDetails(DashDatumEntity vehicle/*DatumEntity vehicle*/) {
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

  Widget _buildVehicleStats(DashDatumEntity vehicle/*DatumEntity vehicle*/) {
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

///----idle-----
// class VehicleIdleItem extends StatefulWidget {
//   final List<DatumEntity>? data;
//   final String? token;
//   final List<VehicleEntity> vehicles;
//
//   const VehicleIdleItem({
//     super.key,
//     this.data,
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
//   late List<DatumEntity> filteredVehicles;
//   late List<VehicleEntity> filteredIdleVehicles;
//
//   @override
//   void initState() {
//     super.initState();
//     _filterVehicles();
//   }
//
//   void _filterVehicles() {
//     setState(() {
//       filteredVehicles = widget.data!.where((vehicle) {
//         return vehicle.last_location?.status?.toLowerCase() != "moving";
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final itemCount = widget.vehicles.isEmpty ? 0 : widget.vehicles.length;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: ListView.builder(
//         shrinkWrap: true, // Prevents ListView from expanding infinitely
//         padding: EdgeInsets.zero,
//         itemCount: filteredVehicles.length - itemCount,
//         itemBuilder: (context, index) {
//           final vehicle = filteredVehicles[index];
//
//           return InkWell(
//             onTap: () {
//               if (vehicle.last_location?.latitude != null) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => VehicleRouteLastLocation(
//                       brand: vehicle.brand ?? '',
//                       model: vehicle.model ?? '',
//                       vin: vehicle.vin ?? '',
//                       latitude: double.tryParse(
//                           vehicle.last_location?.latitude ?? '') ??
//                           0.0,
//                       longitude: double.tryParse(
//                           vehicle.last_location?.longitude ?? '') ??
//                           0.0,
//                       token: widget.token ?? '',
//                       number_plate: vehicle.number_plate ?? '',
//                       name: widget.data![index].driver!.name!,
//                       email: widget.data![index].driver!.email!,
//                       phone: widget.data![index].driver!.phone!,
//                     ),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Vehicle coordinate is not found!'),
//                   ),
//                 );
//               }
//             },
//             child: Row(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       vehicle.last_location?.speed?.toString() ?? "0.00",
//                       style: AppStyle.cardTitle,
//                     ),
//                     const Text("KM/H", style: TextStyle(color: Colors.grey)),
//                     Icon(Icons.local_shipping,
//                         size: 40.0, color: Colors.grey.shade600),
//                   ],
//                 ),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   child: Card(
//                     child: _buildVehicleDetails(vehicle),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

///-----
// class VehiclePage extends StatefulWidget {
//   const VehiclePage({super.key});
//
//   @override
//   State<VehiclePage> createState() => _VehiclePageState();
// }
//
// class _VehiclePageState extends State<VehiclePage> {
//   int _selectedTabIndex = 0;
//   bool isLoading = true;
//   PrefUtils prefUtils = PrefUtils();
//   String? first_name;
//   String? last_name;
//   String? middle_name;
//   String? email;
//   String? token;
//   String? userId;
//   int movingCount = 0;
//   int idleCount = 0;
//   int stoppedCount = 0;
//   int offlineCount = 0;
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
//         userId = authUser[5].isEmpty
//             ? null
//             : authUser[5]; // assuming userId is at index 5
//       }
//       if (token != null && userId != null) {
//         // Check if PusherService is already registered
//         if (!sl.isRegistered<PusherService>()) {
//           print("not registered anywhere");
//           sl.registerSingleton<PusherService>(PusherService(token!, userId!));
//           // sl.registerFactory<PusherService>(() => PusherService(token!, userId!));
//           // Retrieve the PusherService and initialize only if it hasn’t been already
//           final pusherService = sl<PusherService>();
//           pusherService.initializePusher();
//         }
//
//         // Trigger the event for the VehiclesBloc with token information
//         sl<VehiclesBloc>().add(GetVehicleEvent(
//             VehicleReqEntity(token: token!, contentType: 'application/json')));
//         // BlocProvider.of<RouteHistoryBloc>(context)
//         //     .add(RouteHistoryEvent(routeHistoryReqEntity));
//       }
//       // if (token != null && userId != null) {
//       //   // sl.unregister<PusherService>();
//       //   // Register PusherService dynamically in GetIt
//       //   // sl.registerFactory<PusherService>(() => PusherService(token!, userId!));
//       //   if (!GetIt.instance.isRegistered<PusherService>()) {
//       //     GetIt.instance.registerLazySingleton<PusherService>(() => PusherService(token!, userId!));
//       //     // Initialize PusherService through BLoC
//       //     final pusherService = sl<PusherService>();
//       //     pusherService.initializePusher(); // Connect and listen to channels
//       //
//       //   }
//       //
//       //
//       //   // Add any additional events here if necessary
//       //   sl<VehiclesBloc>().add(GetVehicleEvent(
//       //       VehicleReqEntity(token: token!, contentType: 'application/json')));
//       // }
//
//       isLoading = false;
//     });
//   }
//
//   List<VehicleEntity> _filterVehicles(List<VehicleEntity> vehicles) {
//     switch (_selectedTabIndex) {
//       case 1:
//         return vehicles
//             .where((v) => v.locationInfo.vehicleStatus == "Moving")
//             .toList();
//       // case 1:
//       //   return vehicles
//       //       .where((v) => v.locationInfo.tracker.status == "online")
//       //       .toList();
//       // case 2:
//       //   return vehicles
//       //       .where((v) => v.locationInfo.vehicleStatus == "Offline")
//       //       .toList();
//       case 2:
//         return vehicles
//             .where((v) => v.locationInfo.vehicleStatus == "Stopped")
//             .toList();
//       case 3:
//         return vehicles
//             .where((v) => v.locationInfo.vehicleStatus == "Idle")
//             .toList();
//       default:
//         return vehicles;
//     }
//   }
//
//   void _updateVehicleCounts(List<VehicleEntity> vehicles) {
//     // Calculate vehicle counts by status
//     movingCount = vehicles
//         .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Moving')
//         .length;
//     // offlineCount = vehicles
//     //     .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Offline')
//     //     .length;
//     stoppedCount = vehicles
//         .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Stopped')
//         .length;
//     idleCount = vehicles
//         .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Idle')
//         .length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> tabs = [
//       "All",
//       "Moving ($movingCount)",
//       "Stopped ($stoppedCount)",
//       "Idle ($idleCount)",
//     ];
//
//     return Scaffold(
//       appBar: AnimatedAppBar(
//         firstname: first_name ?? "",
//       ),
//       // appBar(firstname: first_name ?? "", context),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Top Tabs
//                 SizedBox(
//                   height: 45.0,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: tabs.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() => _selectedTabIndex = index);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Chip(
//                             side: BorderSide.none,
//                             backgroundColor: _selectedTabIndex == index
//                                 ? Colors.green
//                                 : Colors.grey.shade200,
//                             label: Text(
//                               tabs[index],
//                               style: TextStyle(
//                                 color: _selectedTabIndex == index
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Listen for state changes and update counts
//                 BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//                   listener: (context, vehicles) {
//                     _updateVehicleCounts(vehicles);
//                     setState(() {
//                       vehicles;
//                     }); // Trigger rebuild to update counts in tabs
//                   },
//                   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                     builder: (context, vehicles) {
//                       if (vehicles.isEmpty) {
//                         //return const Center(child: Text("waiting for update"));
//                         return VehicleListItem(token: token);
//                       }
//
//                       // Select the appropriate vehicle list based on the selected tab
//                       List<VehicleEntity> displayedVehicles;
//                       switch (_selectedTabIndex) {
//                         case 1:
//                           displayedVehicles = vehicles
//                               .where((vehicle) =>
//                                   vehicle.locationInfo.vehicleStatus ==
//                                   'Moving')
//                               .toList();
//                           break;
//                         // case 2:
//                         //   displayedVehicles = vehicles
//                         //       .where((vehicle) =>
//                         //           vehicle.locationInfo.vehicleStatus ==
//                         //           'offline')
//                         //       .toList();
//                         //   break;
//                         case 3:
//                           displayedVehicles = vehicles
//                               .where((vehicle) =>
//                                   vehicle.locationInfo.vehicleStatus ==
//                                   'Stopped')
//                               .toList();
//                           break;
//                         case 3:
//                           displayedVehicles = vehicles
//                               .where((vehicle) =>
//                                   vehicle.locationInfo.vehicleStatus ==
//                                   'Idling')
//                               .toList();
//                           break;
//                         default:
//                           displayedVehicles = vehicles;
//                       }
//
//                       return Expanded(
//                         child: ListView.builder(
//                           padding: const EdgeInsets.all(0.0),
//                           itemCount: displayedVehicles.length,
//                           itemBuilder: (context, index) {
//                             final vehicle = displayedVehicles[index];
//                             String dateTimeString =
//                                 "${vehicle.locationInfo.tracker!.position!.fixTime}";
//                             String numberString =
//                                 "${vehicle.locationInfo.tracker?.position?.speed}";
//                             double number = double.parse(numberString);
//                             String speed = number.toStringAsFixed(2);
//                             String time =
//                                 dateTimeString.split("T")[1].split(".")[0];
//                             return InkWell(
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         VehicleRouteLastLocation(
//                                             brand: vehicle.locationInfo.brand,
//                                             model: vehicle.locationInfo.model,
//                                             vin: vehicle.locationInfo.vin,
//                                             latitude: vehicle.locationInfo
//                                                 .tracker!.position!.latitude,
//                                             longitude: vehicle.locationInfo
//                                                 .tracker!.position!.longitude,
//                                             token: token!,
//                                             number_plate: vehicle
//                                                 .locationInfo.numberPlate)));
//                                 // Navigator.pushNamed(
//                                 //     context, '/vehicleRouteLastLocation',
//                                 //     arguments: {
//                                 //       "latitude": vehicle.locationInfo.tracker!
//                                 //           .position!.latitude!
//                                 //           .toDouble(),
//                                 //       "longitude": vehicle.locationInfo.tracker!
//                                 //           .position!.latitude!
//                                 //           .toDouble(),
//                                 //       "token": token
//                                 //     });
//                                 ///-------
//                                 // RouteLastLocation(vehicle.locationInfo.tracker!.position!.latitude!.toDouble(),
//                                 //     vehicle.locationInfo.tracker!.position!.longitude!.toDouble());
//                               },
//                               child: Container(
//                                 // width: getHorizontalSize(300),
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 10.0, vertical: 5.0),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     //crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       // Vehicle Speed and Icon
//                                       Column(
//                                         // crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             speed,
//                                             style: const TextStyle(
//                                                 fontSize: 24,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           const Text(
//                                             "KM/H",
//                                             style:
//                                                 TextStyle(color: Colors.grey),
//                                           ),
//                                           Icon(
//                                             Icons.local_shipping,
//                                             size: 40.0,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(width: 10.0),
//                                       // Vehicle Details
//                                       Expanded(
//                                         child: Card(
//                                           // margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 margin:
//                                                     const EdgeInsets.all(8.0),
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 //width: getHorizontalSize(250),
//                                                 color: Colors.white,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       "${vehicle.locationInfo.brand} ${vehicle.locationInfo.model}",
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 16.0),
//                                                     ),
//                                                     Column(
//                                                       children: [
//                                                         Text(
//                                                           vehicle.locationInfo
//                                                               .tracker!.status
//                                                               .toString(),
//                                                           style: const TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal,
//                                                               fontSize: 14.0),
//                                                         ),
//                                                         Text(
//                                                           time,
//                                                           style: const TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal,
//                                                               fontSize: 14.0),
//                                                           softWrap: true,
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 5.0),
//                                               // const Row(
//                                               //   children: [
//                                               //     Icon(Icons.gps_fixed, color: Colors.green),
//                                               //     SizedBox(width: 5.0),
//                                               //     Icon(Icons.network_cell, color: Colors.green),
//                                               //     SizedBox(width: 5.0),
//                                               //     Icon(Icons.power, color: Colors.green),
//                                               //   ],
//                                               // ),
//                                               // const SizedBox(height: 5.0),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     const Row(
//                                                       children: [
//                                                         Column(
//                                                           children: [
//                                                             Icon(
//                                                                 Icons.gps_fixed,
//                                                                 color: Colors
//                                                                     .green),
//                                                             Text(
//                                                               "GPS",
//                                                               style: TextStyle(
//                                                                   fontSize: 12),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           width: 15,
//                                                         ),
//                                                         Column(
//                                                           children: [
//                                                             Icon(Icons.wifi,
//                                                                 color: Colors
//                                                                     .green),
//                                                             Text(
//                                                               "GSM",
//                                                               style: TextStyle(
//                                                                   fontSize: 12),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           width: 15,
//                                                         ),
//                                                         Column(
//                                                           children: [
//                                                             Icon(Icons.power,
//                                                                 color: Colors
//                                                                     .green),
//                                                             Text(
//                                                               "Ignition",
//                                                               style: TextStyle(
//                                                                   fontSize: 12),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Column(
//                                                       children: [
//                                                         const Text(
//                                                           "Expires On",
//                                                           style: TextStyle(
//                                                               fontSize: 14),
//                                                         ),
//                                                         Chip(
//                                                           backgroundColor:
//                                                               Colors.green
//                                                                   .shade200,
//                                                           label: const Text(
//                                                             "Unlimited",
//                                                             style: TextStyle(
//                                                                 fontSize: 12.0),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//
//                             //   Card(
//                             //   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                             //   child: Padding(
//                             //     padding: const EdgeInsets.all(16.0),
//                             //     child: Column(
//                             //       crossAxisAlignment: CrossAxisAlignment.start,
//                             //       children: [
//                             //         Text('Brand: ${vehicle.locationInfo.brand}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text('Model: ${vehicle.locationInfo.model}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'NumberPlate: ${vehicle.locationInfo.numberPlate}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text('Year: ${vehicle.locationInfo.year}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text('VIN: ${vehicle.locationInfo.vin}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'Tracker Unique ID: ${vehicle.locationInfo.tracker?.uniqueId}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'Location: (${vehicle.locationInfo.tracker?.position?.latitude}, ${vehicle.locationInfo.tracker?.position?.longitude})',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'Speed: ${vehicle.locationInfo.tracker?.position?.speed} km/h',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'Owner: ${vehicle.locationInfo.owner?.firstName} ${vehicle.locationInfo.owner?.lastName}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'Owner Phone: ${vehicle.locationInfo.owner?.phone}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //         Text(
//                             //             'Status: ${vehicle.locationInfo.vehicleStatus}',
//                             //             style: TextStyle(fontSize: 20)),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 // Expanded(
//                 //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                 //     builder: (context, vehicles) {
//                 //       if (vehicles.isEmpty) {
//                 //         return const Center(
//                 //             child: Text('Waiting for vehicle updates...'));
//                 //       }
//                 //
//                 //       // Filter vehicles by status
//                 //       final allVehicles = vehicles;
//                 //       final movingVehicles = vehicles
//                 //           .where((vehicle) =>
//                 //               vehicle.locationInfo.vehicleStatus == 'Moving')
//                 //           .toList();
//                 //       final idleVehicles = vehicles
//                 //           .where((vehicle) =>
//                 //               vehicle.locationInfo.vehicleStatus == 'Idle')
//                 //           .toList();
//                 //       final stoppedVehicles = vehicles
//                 //           .where((vehicle) =>
//                 //               vehicle.locationInfo.vehicleStatus == 'Stopped')
//                 //           .toList();
//                 //
//                 //       // Update counts for tabs
//                 //       setState(() {
//                 //         movingCount = movingVehicles.length;
//                 //         idleCount = idleVehicles.length;
//                 //         stoppedCount = stoppedVehicles.length;
//                 //       });
//                 //
//                 //       // Select the appropriate vehicle list based on the selected tab
//                 //       List<VehicleEntity> displayedVehicles;
//                 //       switch (_selectedTabIndex) {
//                 //         case 1:
//                 //           displayedVehicles = movingVehicles;
//                 //           break;
//                 //         case 2:
//                 //           displayedVehicles = idleVehicles;
//                 //           break;
//                 //         case 3:
//                 //           displayedVehicles = stoppedVehicles;
//                 //           break;
//                 //         default:
//                 //           displayedVehicles = allVehicles;
//                 //       }
//                 //
//                 //       final filteredVehicles = _filterVehicles(vehicles);
//                 //       return ListView.builder(
//                 //         itemCount: filteredVehicles.length,
//                 //         itemBuilder: (context, index) {
//                 //           final vehicle = displayedVehicles[index];
//                 //           // final vehicle = filteredVehicles[index];
//                 //           return Card(
//                 //             margin: const EdgeInsets.symmetric(vertical: 8.0),
//                 //             child: Padding(
//                 //               padding: const EdgeInsets.all(16.0),
//                 //               child: Column(
//                 //                 crossAxisAlignment: CrossAxisAlignment.start,
//                 //                 children: [
//                 //                   Text('Brand: ${vehicle.locationInfo.brand}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text('Model: ${vehicle.locationInfo.model}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'NumberPlate: ${vehicle.locationInfo.numberPlate}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text('Year: ${vehicle.locationInfo.year}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text('VIN: ${vehicle.locationInfo.vin}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'Tracker Unique ID: ${vehicle.locationInfo.tracker?.uniqueId}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'Location: (${vehicle.locationInfo.tracker?.position?.latitude}, ${vehicle.locationInfo.tracker?.position?.longitude})',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'Speed: ${vehicle.locationInfo.tracker?.position?.speed} km/h',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'Owner: ${vehicle.locationInfo.owner?.firstName} ${vehicle.locationInfo.owner?.lastName}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'Owner Phone: ${vehicle.locationInfo.owner?.phone}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                   Text(
//                 //                       'Status: ${vehicle.locationInfo.vehicleStatus}',
//                 //                       style: TextStyle(fontSize: 20)),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           );
//                 //         },
//                 //       );
//                 //     },
//                 //   ),
//                 // ),
//               ],
//             ),
//     );
//   }
// }
///-------
// class VehicleListItem extends StatelessWidget {
//   final String? token;
//   const VehicleListItem({super.key, this.token});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: BlocProvider(
//           create: (_) => sl<VehiclesBloc>()
//             ..add(GetVehicleEvent(VehicleReqEntity(
//                 token: token ?? "", contentType: 'application/json'))),
//           child: BlocConsumer<VehiclesBloc, VehicleState>(
//               builder: (context, state) {
//             if (state is VehicleLoading) {
//               return const Center(
//                   child: Padding(
//                 padding: EdgeInsets.only(top: 10.0),
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.0,
//                 ),
//               ));
//             } else if (state is VehicleDone) {
//               return SizedBox(
//                 height: 500,
//                 child: ListView.builder(
//                   itemCount:
//                       state.resp.data == null ? 0 : state.resp.data!.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => VehicleRouteLastLocation(
//                                   brand: state.resp.data![index].brand!,
//                                   model: state.resp.data![index].model!,
//                                   vin: state.resp.data![index].vin!,
//                                   latitude: double.parse(state.resp.data![index]
//                                       .last_location!.latitude!),
//                                   longitude: double.parse(state.resp
//                                       .data![index].last_location!.longitude!),
//                                   token: token!,
//                                   number_plate:
//                                       state.resp.data![index].number_plate!,
//                                 )));
//                         // Navigator.pushNamed(
//                         //     context, '/vehicleRouteLastLocation',
//                         //     arguments: {
//                         //       "latitude": state.resp.data![index].last_location!.latitude,
//                         //       "longitude": state
//                         //           .resp.data![index].last_location!.longitude,
//                         //       "token": token,
//                         //       "model": state.resp.data![index].model,
//                         //       "brand": state.resp.data![index].brand,
//                         //       "number_plate": state.resp.data![index].number_plate,
//                         //       "address":
//                         //           state.resp.data![index].driver!.country,
//                         //       "vin": state.resp.data![index].vin,
//                         //       "name": state.resp.data![index].driver!.name,
//                         //       "phone": state.resp.data![index].driver!.phone,
//                         //     });
//                       },
//                       child: Row(
//                         //crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Vehicle Speed and Icon
//                           Column(
//                             // crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 state.resp.data![index].last_location!.speed
//                                     .toString(),
//                                 style: const TextStyle(
//                                     fontSize: 24, fontWeight: FontWeight.bold),
//                               ),
//                               const Text(
//                                 "KM/H",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               Icon(
//                                 Icons.local_shipping,
//                                 size: 40.0,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 10.0),
//                           // Vehicle Details
//                           Expanded(
//                             child: Card(
//                               // margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     margin: const EdgeInsets.all(8.0),
//                                     padding: const EdgeInsets.all(8.0),
//                                     //width: getHorizontalSize(250),
//                                     color: Colors.white,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           '${state.resp.data![index].brand.toString()} '
//                                           '${state.resp.data![index].model.toString()}',
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16.0),
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(
//                                               state.resp.data![index]
//                                                   .last_location!.status
//                                                   .toString(),
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 14.0),
//                                             ),
//                                             const Text(
//                                               "7 min 20s",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 14.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5.0),
//                                   // const Row(
//                                   //   children: [
//                                   //     Icon(Icons.gps_fixed, color: Colors.green),
//                                   //     SizedBox(width: 5.0),
//                                   //     Icon(Icons.network_cell, color: Colors.green),
//                                   //     SizedBox(width: 5.0),
//                                   //     Icon(Icons.power, color: Colors.green),
//                                   //   ],
//                                   // ),
//                                   // const SizedBox(height: 5.0),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Row(
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Icon(Icons.gps_fixed,
//                                                     color: Colors.green),
//                                                 Text(
//                                                   "GPS",
//                                                   style:
//                                                       TextStyle(fontSize: 12),
//                                                 )
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               width: 15,
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Icon(Icons.wifi,
//                                                     color: Colors.green),
//                                                 Text(
//                                                   "GSM",
//                                                   style:
//                                                       TextStyle(fontSize: 12),
//                                                 )
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               width: 15,
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Icon(Icons.power,
//                                                     color: Colors.green),
//                                                 Text(
//                                                   "Ignition",
//                                                   style:
//                                                       TextStyle(fontSize: 12),
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             const Text(
//                                               "Expires On",
//                                               style: TextStyle(fontSize: 14),
//                                             ),
//                                             Chip(
//                                               backgroundColor:
//                                                   Colors.green.shade200,
//                                               label: const Text(
//                                                 "Unlimited",
//                                                 style:
//                                                     TextStyle(fontSize: 12.0),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             } else {
//               return const Center(child: Text('No records found'));
//             }
//           }, listener: (context, state) {
//             if (state is VehicleFailure) {
//               //if (state.message.contains("The Token has expired")) {
//               Navigator.pushNamed(context, "/login");
//               //}
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           }),
//         ),
//
//         ///
//       ),
//     );
//   }
// }

///-------vehiclepage-----

// class _VehiclePageState extends State<VehiclePage> {
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
//   int stoppedCount = 0;
//   int offlineCount = 0;
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
//         if (!sl.isRegistered<PusherService>()) {
//           sl.registerSingleton<PusherService>(PusherService(token!, userId!));
//           final pusherService = sl<PusherService>();
//           pusherService.initializePusher();
//         }
//         sl<VehiclesBloc>().add(GetVehicleEvent(
//             VehicleReqEntity(token: token!, contentType: 'application/json')));
//       }
//       isLoading = false;
//     });
//   }
//
//   List<VehicleEntity> _filterVehicles(List<VehicleEntity> vehicles) {
//     switch (_selectedTabIndex) {
//       case 1:
//         return vehicles
//             .where((v) => v.locationInfo.vehicleStatus == "Moving")
//             .toList();
//       case 2:
//         return vehicles
//             .where((v) => v.locationInfo.vehicleStatus == "Stopped")
//             .toList();
//       case 3:
//         return vehicles
//             .where((v) => v.locationInfo.vehicleStatus == "Idle")
//             .toList();
//       default:
//         return vehicles;
//     }
//   }
//
//   void _updateVehicleCounts(List<VehicleEntity> vehicles) {
//     movingCount = vehicles
//         .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Moving')
//         .length;
//     stoppedCount = vehicles
//         .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Stopped')
//         .length;
//     idleCount = vehicles
//         .where((vehicle) => vehicle.locationInfo.vehicleStatus == 'Idle')
//         .length;
//     vehicleCount = vehicles.length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> tabs = [
//       "All ($vehicleCount)",
//       "Moving ($movingCount)",
//       "Stopped ($stoppedCount)",
//       "Idle ($idleCount)",
//     ];
//
//     return Scaffold(
//       appBar: AnimatedAppBar(
//         firstname: first_name ?? "",
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 SizedBox(
//                   height: 45.0,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: tabs.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() => _selectedTabIndex = index);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Chip(
//                             side: BorderSide.none,
//                             backgroundColor: _selectedTabIndex == index
//                                 ? Colors.green
//                                 : Colors.grey.shade200,
//                             label: Text(
//                               tabs[index],
//                               style: TextStyle(
//                                 color: _selectedTabIndex == index
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//                   listener: (context, vehicles) {
//                     _updateVehicleCounts(vehicles);
//                     setState(() {
//                       vehicles;
//                     });
//                   },
//                   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                     builder: (context, vehicles) {
//                       if (vehicles.isEmpty) {
//                         return BlocProvider(
//                           create: (_) => sl<VehiclesBloc>()
//                             ..add(GetVehicleEvent(VehicleReqEntity(
//                                 token: token ?? "",
//                                 contentType: 'application/json'))),
//                           child: BlocConsumer<VehiclesBloc, VehicleState>(
//                             builder: (context, state) {
//                               if (state is VehicleLoading) {
//                                 return const Center(
//                                   child: Padding(
//                                     padding: EdgeInsets.only(top: 10.0),
//                                     child: CircularProgressIndicator(
//                                         strokeWidth: 2.0),
//                                   ),
//                                 );
//                               } else if (state is VehicleDone) {
//                                 // Check if the vehicle data is empty
//                                 if (state.resp.data == null ||
//                                     state.resp.data!.isEmpty) {
//                                   return const Center(
//                                     child: Text(
//                                       'No vehicles available',
//                                       style: TextStyle(
//                                           fontSize: 16.0, color: Colors.grey),
//                                     ),
//                                   );
//                                 }
//                                 return VehicleListItem(
//                                     data: state.resp.data, token: token);
//                               } else {
//                                 return const Center(
//                                     child: Text('No records found'));
//                               }
//                             },
//                             listener: (context, state) {
//                               if (state is VehicleFailure) {
//                                 Navigator.pushNamed(context, "/login");
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(state.message)),
//                                 );
//                               }
//                             },
//                           ),
//                         );
//                       }
//
//                       List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);
//
//                       return VehicleListItem(
//                         displayedVehicles: displayedVehicles,
//                         token: token,
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

///----
///
// class VehicleListItem extends StatelessWidget {
//   final List<DatumEntity>? data;
//   final String? token;
//   final List<VehicleEntity>? vehicles;
//
//   const VehicleListItem({
//     super.key,
//     this.data,
//     this.token,
//     required this.vehicles,
//     /*this.displayedVehicles*/
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Use `data` if it has elements; otherwise, use `displayedVehicles`
//     final effectiveData = data != null && data!.isNotEmpty ? data : null;
//     final effectiveDisplayedVehicles =
//         vehicles != null && vehicles!.isNotEmpty ? vehicles : null;
//
//     // Calculate itemCount based on which list is non-null and non-empty
//     final itemCount =
//         effectiveData?.length ?? effectiveDisplayedVehicles?.length ?? 0;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: ListView.builder(
//         shrinkWrap: true, // Prevents ListView from expanding infinitely
//         padding: EdgeInsets.zero,
//         itemCount: itemCount,
//         itemBuilder: (context, index) {
//           // Use `effectiveData` if available, otherwise `effectiveDisplayedVehicles`
//           final widget.data![index] =
//               effectiveData != null ? effectiveData[index] : null;
//           final vehicle = effectiveDisplayedVehicles != null
//               ? effectiveDisplayedVehicles[index]
//               : null;
//
//           // Check if we have valid data; if not, skip rendering
//           // if (widget.data![index] == null && vehicle == null) {
//           //   return const SizedBox.shrink();
//           // }
//
//           print(
//               "::::::status:::: ${vehicle?.locationInfo.tracker!.status.toString()}");
//           return InkWell(
//             onTap: () {
//               widget.data![index]!.last_location!.latitude != null
//                   ? Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => VehicleRouteLastLocation(
//                           brand:
//                               widget.data![index].brand ?? vehicle!.locationInfo.brand,
//                           model:
//                               widget.data![index].model ?? vehicle!.locationInfo.model,
//                           vin: widget.data![index].vin ?? vehicle!.locationInfo.vin,
//                           latitude:
//                               // double.tryParse(
//                               //     widget.data![index].last_location!.latitude!),
//                               widget.data![index].last_location?.latitude != null
//                                   ? double.tryParse(
//                                       widget.data![index].last_location!.latitude!)
//                                   : vehicle!.locationInfo.tracker?.position
//                                           ?.latitude ??
//                                       6.5480551,
//                           longitude:
//                               // double.tryParse(widget.data![index].last_location!.longitude!),
//                               widget.data![index].last_location?.longitude != null
//                                   ? double.tryParse(
//                                       widget.data![index].last_location!.longitude!)
//                                   : vehicle!.locationInfo.tracker?.position
//                                           ?.longitude ??
//                                       3.2839595,
//                           token: token ?? '',
//                           number_plate: widget.data![index].number_plate.toString()
//                           // ?? vehicle!.locationInfo.numberPlate,
//                           ),
//                     ))
//                   : ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Vehicle coordinate is not found!')),
//                     );
//             },
//             child: Row(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.data![index]?.vin == vehicle?.locationInfo.vin ||
//                               vehicle?.locationInfo.tracker?.position?.speed !=
//                                   null
//                           ? vehicle!.locationInfo.tracker!.position!.speed
//                               .toString()
//                           : widget.data![index]?.last_location?.speed?.toString() ??
//                               "0.00",
//                       style: AppStyle.cardTitle,
//                     ),
//                     const Text("KM/H", style: TextStyle(color: Colors.grey)),
//                     Icon(
//                       Icons.local_shipping,
//                       size: 40.0,
//                       color: Colors.grey.shade600,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   child: Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.all(8.0),
//                           padding: const EdgeInsets.all(8.0),
//                           color: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 // '${widget.data![index]!.brand} ${widget.data![index].model}',
//                                 '${widget.data![index]?.brand ?? vehicle!.locationInfo.brand} ${widget.data![index]?.model ?? vehicle!.locationInfo.model}',
//                                 style: AppStyle.cardSubtitle
//                                     .copyWith(fontSize: 12),
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     widget.data![index]?.vin ==
//                                                 vehicle?.locationInfo.vin ||
//                                             vehicle?.locationInfo.tracker
//                                                     ?.status !=
//                                                 null
//                                         ? vehicle!.locationInfo.tracker!.status
//                                             .toString()
//                                         : widget.data![index]?.last_location?.status
//                                                 ?.toString() ??
//                                             "N/A",
//                                     // widget.data![index]?.last_location!.status ?? vehicle!.locationInfo.tracker!.status ?? "N/A",
//                                     //widget.data![index].last_location!.status == null ? "" : widget.data![index].last_location!.status!,
//                                     // widget.data![index]?.last_location?.status ?? "N/A",
//                                     style: AppStyle.cardfooter,
//                                   ),
//                                   Text("7min 20s", style: AppStyle.cardfooter),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 5.0),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Column(
//                                     children: [
//                                       const Icon(Icons.gps_fixed,
//                                           color: Colors.green),
//                                       Text("GPS",
//                                           style: AppStyle.cardfooter
//                                               .copyWith(fontSize: 10)),
//                                     ],
//                                   ),
//                                   const SizedBox(width: 15),
//                                   Column(
//                                     children: [
//                                       const Icon(Icons.wifi,
//                                           color: Colors.green),
//                                       Text("GSM",
//                                           style: AppStyle.cardfooter
//                                               .copyWith(fontSize: 10)),
//                                     ],
//                                   ),
//                                   const SizedBox(width: 15),
//                                   Column(
//                                     children: [
//                                       const Icon(Icons.power,
//                                           color: Colors.green),
//                                       Text("Ignition",
//                                           style: AppStyle.cardfooter
//                                               .copyWith(fontSize: 10)),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   Text("Expires On",
//                                       style: AppStyle.cardfooter),
//                                   Chip(
//                                     backgroundColor: Colors.green.shade200,
//                                     label: Text("Unlimited",
//                                         style: AppStyle.cardfooter
//                                             .copyWith(fontSize: 11)),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
