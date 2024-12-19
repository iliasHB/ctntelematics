import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/req_entities/route_history_req_entity.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
import 'package:ctntelematics/modules/vehincle/presentation/bloc/vehicle_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/gps_processor.dart';
import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../bloc/dashboard_bloc.dart';
import 'dash_vehicle_analytics.dart';

class VehicleInformation extends StatefulWidget {
  final DashDatumEntity vehicle;
  final String? token;
  const VehicleInformation({super.key, required this.vehicle, this.token});

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vehicle Information",
          style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 450,
                child: DashVehicleAnalytics(
                  token: widget.token!,
                  vin: widget.vehicle.vin!,
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade200,
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
                        title: 'Vehicle Details',
                        subTitle: 'Basic vehicle information'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailItem(title: "Vehicle", value: widget.vehicle.vin!),
                      _DetailItem(title: 'Brand', value: widget.vehicle.brand!),
                      _DetailItem(title: "Model", value: widget.vehicle.model!),
                      _DetailItem(title: "Type", value: widget.vehicle.type!),
                      _DetailItem(
                          title: "Number Plate",
                          value: widget.vehicle.number_plate!),
                      const _DetailItem(
                          title: "End Latitude", value: "Not Available"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            VehiclePerformance(
                title: 'Vehicle Performance',
                subTitle: 'Vehicle route history',
                vin: widget.vehicle.vin!,
                token: widget.token!),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DashboardComponentTitle(
                  title: 'Vehicle Trip', subTitle: 'Vehicle Trip Details'),
            ),
            BlocProvider(
              create: (_) => sl<VehicleTripBloc>()
                ..add(DashVehicleEvent(DashVehicleReqEntity(
                    token: widget.token ?? "",
                    contentType: 'application/json'))),
              child: BlocConsumer<VehicleTripBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CustomContainerLoadingButton(),
                    );
                  } else if (state is VehicleTripDone) {
                    if (state.resp == null || state.resp.isEmpty) {
                      return Container(
                        height:
                            100, // Set a width to ensure consistent card size
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        child: const Center(child: Text("No available trip")),
                      );
                    }
                    final filteredReports = state.resp
                        .where(
                            (report) => report.vehicleVin == widget.vehicle.vin)
                        .toList();
                    if (filteredReports.isEmpty) {
                      return Container(
                        height:
                            100, // Set a width to ensure consistent card size
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        child: const Center(child: Text("No vehicle trip")),
                      );
                    } else {
                      return SizedBox(
                        height:
                            300, // Constrain height for horizontal scrolling
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Set scroll direction
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          itemCount: filteredReports.length,
                          itemBuilder: (BuildContext context, index) {
                            final tripLocations =
                                filteredReports[index].tripLocations;
                            return Container(
                              width:
                                  350, // Set a width to ensure consistent card size
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade200,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _DetailItem(
                                      title: "Vehicle",
                                      value: filteredReports[index].vehicleVin),
                                  _DetailItem(
                                      title: "Driver",
                                      value: filteredReports[index].name),
                                  if (tripLocations != null &&
                                      tripLocations.isNotEmpty) ...[
                                    _DetailItem(
                                        title: "Start Time",
                                        value: FormatData.formatTimeAgo(
                                            tripLocations[0].createdAt)),
                                    _DetailItem(
                                        title: "Start Location",
                                        value: tripLocations[0].startLocation),
                                    _DetailItem(
                                        title: "End Time",
                                        value: FormatData.formatTimeAgo(
                                            tripLocations[0].arrivalTime)),
                                    _DetailItem(
                                        title: "End Location",
                                        value: tripLocations[0].endLocation),
                                    _DetailItem(
                                        title: "Start Latitude",
                                        value: tripLocations[0]
                                            .startLat
                                            .toString()),
                                    _DetailItem(
                                        title: "End Latitude",
                                        value:
                                            tripLocations[0].endLat.toString()),
                                  ] else ...[
                                    const _DetailItem(
                                        title: "Start Time",
                                        value: "Not Available"),
                                    const _DetailItem(
                                        title: "Start Location",
                                        value: "Not Available"),
                                    const _DetailItem(
                                        title: "End Time",
                                        value: "Not Available"),
                                    const _DetailItem(
                                        title: "End Location",
                                        value: "Not Available"),
                                    const _DetailItem(
                                        title: "Start Latitude",
                                        value: "Not Available"),
                                    const _DetailItem(
                                        title: "End Latitude",
                                        value: "Not Available"),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'No records found',
                        style: AppStyle.cardfooter,
                      ),
                    );
                  }
                },
                listener: (context, state) {
                  if (state is DashboardFailure) {
                    if (state.message.contains("unauthenticated")) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login", (route) => false);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
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

class VehiclePerformance extends StatefulWidget {
  final String title, subTitle, vin, token;
  const VehiclePerformance({
    super.key,
    required this.title,
    required this.subTitle,
    required this.vin,
    required this.token,
  });

  @override
  State<VehiclePerformance> createState() => _VehiclePerformanceState();
}

class _VehiclePerformanceState extends State<VehiclePerformance> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      final now = DateTime.now();
      fromDate = DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of today
      toDate = DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today
    });
  }
  void _setDateRange(int daysAgo) {
    final now = DateTime.now();
    setState(() {
        fromDate = DateTime(now.year, now.month, now.day - daysAgo, 0, 0, 0);
        toDate = DateTime(now.year, now.month, now.day - daysAgo, 23, 59, 59);
    });

  }

  @override
  Widget build(BuildContext context) {
    final vehicleRouteHistory = VehicleRouteHistoryReqEntity(
        vehicle_vin: widget.vin,
        time_from: fromDate.toString().split('.').first ?? "N/A",
        time_to: toDate.toString().split('.').first ?? "N/A",
        token: widget.token);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.car_repair,
                      size: 30,
                      color: Colors.green,
                    ),
                  ),
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
                            widget.title,
                            style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                          ),
                          Text(
                            widget.subTitle,
                            style: AppStyle.cardfooter.copyWith(fontSize: 12),
                            softWrap: true,
                            overflow: TextOverflow
                                .ellipsis, // Adds ellipsis for overflow
                            maxLines: 2, // Restricts to 2 lines
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: PopupMenuButton(
                          icon: const Icon(
                            Icons.filter_alt,
                            color: Colors.green,
                          ),
                          onSelected: (value) {
                            // setState(() {
                              _setDateRange(value as int); // Adjust date range based on selection

                              final vehicleRouteHistory = VehicleRouteHistoryReqEntity(
                                vehicle_vin: widget.vin,
                                time_from: fromDate.toString().split('.').first ?? "N/A",
                                time_to: toDate.toString().split('.').first ?? "N/A",
                                token: widget.token,
                              );

                              BlocProvider.of<VehicleRouteHistoryBloc>(context)
                                  .add(VehicleRouteHistoryEvent(vehicleRouteHistory));
                            // });

                          },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  // onTap: () {
                                  //   _setDateRange(0); // Yesterday
                                  // },
                                  child: Text("Today", style: AppStyle.cardfooter.copyWith(fontSize: 12)),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  // onTap: () {
                                  //   _setDateRange(1); // Yesterday
                                  // },
                                  child: Text("Yesterday", style: AppStyle.cardfooter.copyWith(fontSize: 12)),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  // onTap: () {
                                  //   _setDateRange(2); // 2 days ago
                                  // },
                                  child: Text("2 days ago", style: AppStyle.cardfooter.copyWith(fontSize: 12)),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  // onTap: () {
                                  //   _setDateRange(3); // 3 days ago
                                  // },
                                  child: Text("3 days ago", style: AppStyle.cardfooter.copyWith(fontSize: 12)),
                                ),
                              ]),
                    ),
                  ),

                ],
              )),
          BlocProvider(
            create: (_) => sl<VehicleRouteHistoryBloc>()
              ..add(VehicleRouteHistoryEvent(vehicleRouteHistory)),
            child: BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CustomContainerLoadingButton(),
                        ),
                      ],
                    ),
                  );
                } else if (state is GetVehicleRouteHistoryDone) {

                  // Check if the vehicle data is empty
                  if (state.resp.data == null || state.resp.data.isEmpty) {
                    return Center(
                      child: Text(
                        'No record available',
                        style: AppStyle.cardfooter,
                      ),
                    );
                  }
                  debugPrint('State updated with data: ${state.resp.data}');
                  print(">>>>>> vehicle: ${state.resp.data[1].longitude}");
                  // final vehicleData = state.resp.data;
                  // Update the markers on the map incrementally

                  return VehicleRouteData(
                      key: ValueKey(state.resp.data.hashCode), // Use a unique key for the widget
                      vehicle: state.resp);
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
                            BlocProvider.of<VehicleRouteHistoryBloc>(context)
                                .add(VehicleRouteHistoryEvent(
                                    vehicleRouteHistory));
                          })
                    ],
                  ));
                }
              },
              listener: (context, state) {
                if (state is VehicleFailure) {
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

class VehicleRouteData extends StatefulWidget {
  final VehicleRouteHistoryRespEntity vehicle;

  const VehicleRouteData({super.key, required this.vehicle});

  @override
  State<VehicleRouteData> createState() => _VehicleRouteDataState();
}

class _VehicleRouteDataState extends State<VehicleRouteData> {
  Map<String, dynamic> metrics = {};

  @override
  void initState() {
    super.initState();
    loadGpsData();
  }

  void loadGpsData() {
    setState(() {
      metrics = GpsProcessor.calculateMetrics(widget.vehicle.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailItem(
          title: "Route Start",
          value: metrics['routeStart'] != null
              ? FormatData.formatTimestamp(metrics['routeStart'])
              : "N/A",
        ),
        _DetailItem(
          title: 'Route End',
          value: metrics['routeEnd'] != null
              ? FormatData.formatTimestamp(metrics['routeEnd'])
              : "N/A",
        ),
        _DetailItem(
          title: "Route Length",
          value: widget.vehicle.routeLength != null
              ? "${widget.vehicle.routeLength?.toStringAsFixed(2)} km"
              : "N/A",
        ),
        _DetailItem(
            title: "Move Duration",
            value: FormatData.formatTime(metrics['moveDuration'])),
        _DetailItem(
            title: "Stop Duration",
            value: FormatData.formatTime(metrics['stopDuration'])),
        _DetailItem(
          title: "Max Speed",
          value: metrics['maxSpeed'] != null
              ? "${metrics['maxSpeed'].toStringAsFixed(2)} km/h"
              : "N/A",
        ),
        _DetailItem(
          title: "Average Speed",
          value: metrics['averageSpeed'] != null
              ? "${metrics['averageSpeed'].toStringAsFixed(2)} km/h"
              : "N/A",
        ),
        _DetailItem(
          title: "Stops",
          value: metrics['stopCount']?.toString() ?? "0",
        ),
      ],
    );

  }

}

