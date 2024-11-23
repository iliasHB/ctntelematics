import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../bloc/dashboard_bloc.dart';

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
          style: AppStyle.cardSubtitle,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Vehicle Info",
              style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailItem(title: "Vehicle", value: widget.vehicle.vin!),
                _DetailItem(title: 'Brand', value: widget.vehicle.brand!),
                _DetailItem(title: "Model", value: widget.vehicle.model!),
                _DetailItem(title: "Type", value: widget.vehicle.type!),
                _DetailItem(
                    title: "Number Plate", value: widget.vehicle.number_plate!),
                _DetailItem(title: "End Latitude", value: "Not Available"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Vehicle Trip",
              style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
              textAlign: TextAlign.left,
            ),
          ),
          BlocProvider(
            create: (_) => sl<VehicleTripBloc>()
              ..add(DashVehicleEvent(DashVehicleReqEntity(
                  token: widget.token ?? "", contentType: 'application/json'))),
            child: BlocConsumer<VehicleTripBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  );
                } else if (state is VehicleTripDone) {
                  if (state.resp == null || state.resp.isEmpty) {
                    return Center(
                      child: Text(
                        'No available Schedule',
                        style: AppStyle.cardfooter,
                      ),
                    );
                  }
                  final filteredReports = state.resp
                      .where(
                          (report) => report.vehicleVin == widget.vehicle.vin)
                      .toList();
                  if (filteredReports.isEmpty) {
                    return const Center(
                      child: Text("No vehicle trip"),
                    );
                  } else {
                    return SizedBox(
                      height: 300, // Constrain height for horizontal scrolling
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
                            width: 350, // Set a width to ensure consistent card size
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      value:
                                          tripLocations[0].startLat.toString()),
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
                  if (state.message.contains("401")) {
                    Navigator.pushNamed(context, "/login");
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

//    BlocProvider(
//             create: (_) => sl<VehicleTripBloc>()
//               ..add(DashVehicleEvent(DashVehicleReqEntity(
//                   token: widget.token ?? "", contentType: 'application/json'))),
//             child: BlocConsumer<VehicleTripBloc, DashboardState>(
//               builder: (context, state) {
//                 if (state is DashboardLoading) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 0.0),
//                       child: CircularProgressIndicator(strokeWidth: 2.0),
//                     ),
//                   );
//                 } else if (state is VehicleTripDone) {
//                   if (state.resp == null || state.resp.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No available Schedule',
//                         style: AppStyle.cardfooter,
//                       ),
//                     );
//                   }
//                   final filteredReports = state.resp
//                       .where((report) => report.vehicleVin == widget.vehicle.vin)
//                       .toList();
//                   if (filteredReports.isEmpty) {
//                     return const Center(
//                       child: Text("No vehicle trip"),
//                     );
//                   } else {
//                     return Expanded( // Wrap with Expanded to constrain height
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         itemCount: filteredReports.length,
//                         itemBuilder: (BuildContext context, index) {
//                           final tripLocations = filteredReports[index].tripLocations;
//
//                           return Container(
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 8.0, horizontal: 10),
//                             padding: const EdgeInsets.all(10.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Colors.grey.shade200,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _DetailItem(
//                                     title: "Vehicle",
//                                     value: filteredReports[index].vehicleVin),
//                                 _DetailItem(
//                                     title: "Driver",
//                                     value: filteredReports[index].name),
//                                 if (tripLocations != null &&
//                                     tripLocations.isNotEmpty) ...[
//                                   _DetailItem(
//                                       title: "Start Time",
//                                       value: FormatData.formatTimeAgo(tripLocations[0].createdAt)),
//                                   _DetailItem(
//                                       title: "Start Location",
//                                       value: tripLocations[0].startLocation),
//                                   _DetailItem(
//                                       title: "End Time",
//                                       value: FormatData.formatTimeAgo(tripLocations[0].arrivalTime)),
//                                   _DetailItem(
//                                       title: "End Location",
//                                       value: tripLocations[0].endLocation),
//                                   _DetailItem(
//                                       title: "Start Latitude",
//                                       value: tripLocations[0].startLat.toString()),
//                                   _DetailItem(
//                                       title: "End Latitude",
//                                       value: tripLocations[0].endLat.toString()),
//                                 ] else ...[
//                                   const _DetailItem(
//                                       title: "Start Time", value: "Not Available"),
//                                   const _DetailItem(
//                                       title: "Start Location",
//                                       value: "Not Available"),
//                                   const _DetailItem(
//                                       title: "End Time", value: "Not Available"),
//                                   const _DetailItem(
//                                       title: "End Location",
//                                       value: "Not Available"),
//                                   const _DetailItem(
//                                       title: "Start Latitude",
//                                       value: "Not Available"),
//                                   const _DetailItem(
//                                       title: "End Latitude", value: "Not Available"),
//                                 ],
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 } else {
//                   return Center(
//                       child: Text(
//                         'No records found',
//                         style: AppStyle.cardfooter,
//                       ));
//                 }
//               },
//               listener: (context, state) {
//                 if (state is DashboardFailure) {
//                   if (state.message.contains("401")) {
//                     Navigator.pushNamed(context, "/login");
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.message)),
//                   );
//                 }
//               },
//             ),
//           ),
