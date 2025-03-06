import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_notice_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/create_schedule.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/create_service.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/view_details.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/view_schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/model/token_req_entity.dart';
import '../../../../service_locator.dart';

class Maintenance extends StatefulWidget {
  final String? token;
  const Maintenance({super.key, this.token});

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  PrefUtils prefUtils = PrefUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maintenance',
          style: AppStyle.pageTitle.copyWith(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildLegendRow(),
            const SizedBox(height: 10),

            /// Button Section
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateScheduleWidget(token: widget.token),
                  ),
                );
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: Colors.green,
                        )),
                    child: Text("Create Schedule",
                        style: AppStyle.cardSubtitle
                            .copyWith(color: Colors.green[800], fontSize: 14))),
              ),
            ),
            const SizedBox(height: 20),

            /// BlocConsumer for fetching schedules
            BlocProvider(
              create: (_) => sl<GetScheduleBloc>()
                ..add(GetScheduleEvent(
                    TokenReqEntity(token: widget.token ?? ""))),
              child: BlocConsumer<GetScheduleBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CustomContainerLoadingButton();
                  } else if (state is GetScheduleDone) {
                    if (state.resp.data == null || state.resp.data.isEmpty) {
                      return _buildNoDataMessage('No available schedule');
                    }

                    return ListView.builder(
                      shrinkWrap: true, // Allows the list to take only the required space
                      physics: const NeverScrollableScrollPhysics(), // Prevents scrolling conflicts
                      itemCount: state.resp.data.length,
                      itemBuilder: (context, index) {
                        var vehicle = state.resp.data[index];
                        return _buildVehicleSchedule(vehicle);
                      },
                    );
                  } else {
                    return _buildNoDataMessage('No records found');
                  }
                },
                listener: (context, state) {
                  if (state is ProfileFailure) {
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
      ),
    );
  }


  /// Builds the vehicle maintenance schedule
  Widget _buildVehicleSchedule(vehicle) {
    var maintenanceList = vehicle.maintenance ?? [];

    return maintenanceList.isEmpty
        ? Container(padding: EdgeInsets.zero, margin: EdgeInsets.zero) : Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: Column(
        children: [
          ...maintenanceList.map((maintenance) {
            debugPrint("Processing VIN: ${maintenance.vehicle_vin}, Schedule ID: ${maintenance.id}");
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleText('Vehicle model'),
                          const SizedBox(height: 10),
                          _buildTitleText('Vehicle Number'),
                          const SizedBox(height: 10),
                          _buildTitleText('Service Type'),
                          const SizedBox(height: 10),
                          _buildTitleText('Status'),
                          const SizedBox(height: 10),
                          _buildTitleText('Description'),
                          const SizedBox(height: 10),
                          _buildTitleText('Start Date'),
                          const SizedBox(height: 10),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ViewSchedule(
                                      state: vehicle,
                                      maintenance: maintenance,
                                      token: widget.token!,
                                    ),
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Colors.green)),
                              child: Text('View Schedule',
                                  style: AppStyle.cardSubtitle.copyWith(
                                      color: Colors.green[800], fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildValueText(vehicle.vin == maintenance.vehicle_vin ? "${vehicle.brand} ${vehicle.model}" : "N/A"),
                          const SizedBox(height: 10),
                          _buildValueText(vehicle.vin == maintenance.vehicle_vin ? vehicle.number_plate : "N/A"),
                          const SizedBox(height: 10),
                          _buildValueText(maintenance.schedule_type ?? "N/A"),
                          const SizedBox(height: 10),
                          _fetchMaintenanceStatus(
                            vin: maintenance.vehicle_vin,
                            scheduleId: maintenance.id.toString(),
                          ),
                          const SizedBox(height: 10),
                          _buildValueText(maintenance.description ?? "N/A"),
                          const SizedBox(height: 10),
                          _buildValueText(maintenance.start_date ?? "N/A"),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 0, color: Colors.grey.shade200,)),
                            child: Text('',
                                style: AppStyle.cardSubtitle.copyWith(
                                    color: Colors.grey.shade200,),)
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 2),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Fetches the maintenance status for a vehicle
  Widget _fetchMaintenanceStatus({required String vin, required String scheduleId}) {
    debugPrint("Checking Maintenance Status for VIN: $vin, Schedule ID: $scheduleId");
    debugPrint("ScheduleNoticeEvent Dispatched: Token - ${widget.token ?? "No token"}");
    return BlocProvider(
      create: (_) => sl<GetSingleScheduleNoticeBloc>()
        ..add(SingleScheduleNoticeEvent(TokenReqEntity(
            token: widget.token ?? "", contentType: 'application/json', vehicle_vin: vin))),
      child: BlocConsumer<GetSingleScheduleNoticeBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const CustomContainerLoadingButton();
          } else if (state is GetSingleScheduleNoticeDone) {
            if (state.resp == null || state.resp == "") {
              return Text(
                "No notices available",
                style: AppStyle.cardfooter,
              );
            }
            final vehicle = state.resp;

            // Debugging: Print received data
            debugPrint("Received resp: ${state.resp}");

            // // Get the first matching vehicle
            // GetScheduleNoticeRespEntity? vehicle;
            // try {
            //   vehicle = state.resp.firstWhere(
            //         (v) {
            //       debugPrint("Checking: VIN(${v.vin}) == VIN($vin), ScheduleID(${v.schedule_id}) == ScheduleID($scheduleId)");
            //       return v.vin == vin && (v.schedule_id ?? "N/A") == scheduleId;
            //     },
            //   );
            // } catch (e) {
            //   vehicle = null; // If no matching record is found
            // }

            // Determine the maintenance status

            String statusText = vehicle.maintenance_due == true &&
                (vehicle.over_due_days == 0 || vehicle.over_due_km == 0)
                ? "Due"
                : vehicle.maintenance_due == true &&
                (vehicle.over_due_days > 0 || vehicle.over_due_km > 0)
                ? "Overdue"
                : "Not Due";

            return Text(
              statusText,
              style: AppStyle.cardfooter,
            );
          } else {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unable to load status',
                    style: AppStyle.cardfooter.copyWith(fontSize: 12),
                  ),
                  const SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<ProfileVehiclesBloc>(context).add(
                          ProfileVehicleEvent(
                              TokenReqEntity(token: widget.token!)));
                    },
                    child: const Icon(Icons.refresh, color: Colors.blue),
                  ),
                ],
              ),
            );
          }
        },
        listener: (context, state) {
          if (state is ProfileFailure) {
            if (state.message.contains("401")) {
              Navigator.pushNamed(context, "/login");
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }
  ///
  // Widget _fetchMaintenanceStatus({required String vin, required String scheduleId}) {
  //   debugPrint("Checking Maintenance Status for VIN: $vin, Schedule ID: $scheduleId");
  //   return BlocProvider(
  //     create: (_) => sl<GetScheduleNoticeBloc>()
  //       ..add(ScheduleNoticeEvent(TokenReqEntity(
  //           token: widget.token ?? "", contentType: 'application/json'))),
  //     child: BlocConsumer<GetScheduleNoticeBloc, ProfileState>(
  //       builder: (context, state) {
  //         if (state is ProfileLoading) {
  //           return const CustomContainerLoadingButton();
  //         } else if (state is GetScheduleNoticeDone) {
  //           if (state.resp == null || state.resp.isEmpty) {
  //             return Text(
  //               "No notices available",
  //               style: AppStyle.cardfooter,
  //             );
  //           }
  //
  //           // Debugging: Print received data
  //           debugPrint("Received resp: ${state.resp}");
  //
  //           final vehicle = state.resp.where((v) {
  //             debugPrint("Checking: VIN(${v.vin}) == VIN($vin), ScheduleID(${v.schedule_id}) == ScheduleID($scheduleId)");
  //             return v.vin == vin && (v.schedule_id ?? "N/A") == scheduleId;
  //           }).toList();
  //
  //           if (vehicle.isEmpty) {
  //             return Text(
  //               "Status not found",
  //               style: AppStyle.cardfooter,
  //             );
  //           }
  //
  //           // Iterate over the filtered list
  //           return Column(
  //             children: vehicle.map((v) {
  //               String statusText = v.maintenance_due == true &&
  //                   (v.over_due_days == 0 || v.over_due_km == 0)
  //                   ? "Due"
  //                   : v.maintenance_due == true &&
  //                   (v.over_due_days > 0 || v.over_due_km > 0)
  //                   ? "Overdue"
  //                   : "Completed";
  //
  //               Color statusColor = _getStatusColor(statusText);
  //
  //               return Text(
  //                 statusText,
  //                 style: AppStyle.cardSubtitle.copyWith(
  //                     fontSize: 12, color: statusColor),
  //               );
  //             }).toList(),
  //           );
  //         } else {
  //           return Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Unable to load status',
  //                   style: AppStyle.cardfooter.copyWith(fontSize: 12),
  //                 ),
  //                 const SizedBox(width: 5.0),
  //                 InkWell(
  //                   onTap: () {
  //                     BlocProvider.of<ProfileVehiclesBloc>(context).add(
  //                         ProfileVehicleEvent(
  //                             TokenReqEntity(token: widget.token!)));
  //                   },
  //                   child: Icon(Icons.refresh, color: Colors.blue),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       },
  //       listener: (context, state) {
  //         if (state is ProfileFailure) {
  //           if (state.message.contains("401")) {
  //             Navigator.pushNamed(context, "/login");
  //           }
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(state.message)),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }


  /// Builds the legend row
  Widget _buildLegendRow() {
    return Row(
      children: [
        _buildLegendItem(Colors.grey, 'All'),
        _buildLegendItem(Colors.yellow, 'Due'),
        _buildLegendItem(Colors.redAccent, 'Overdue'),
        _buildLegendItem(Colors.greenAccent, 'Completed'),
      ],
    );
  }
  /// Builds a single legend item
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 8, backgroundColor: color),
        const SizedBox(width: 5),
        Text(label, style: AppStyle.cardSubtitle.copyWith(fontSize: 12)),
        const SizedBox(width: 10),
      ],
    );
  }


  /// Displays a no-data message
  Widget _buildNoDataMessage(String message) {
    return Center(child: Text(message, style: AppStyle.cardfooter));
  }

  /// Builds title text
  Widget _buildTitleText(String text) {
    return Text(text,
        style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold));
  }

  /// Builds value text
  Widget _buildValueText(String text) {
    return Text(text, style: AppStyle.cardfooter);
  }
  /// Determines the color for a status
  Color _getStatusColor(String status) {
    switch (status) {
      case "Overdue":
        return Colors.redAccent;
      case "Due":
        return Colors.yellow;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}



// class Maintenance extends StatefulWidget {
//   final String? token;
//   const Maintenance({super.key, this.token});
//
//   @override
//   State<Maintenance> createState() => _MaintenanceState();
// }
//
// class _MaintenanceState extends State<Maintenance> {
//   PrefUtils prefUtils = PrefUtils();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Maintenance',
//           style: AppStyle.pageTitle.copyWith(fontSize: 16),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: Column(
//           children: [
//             _buildLegendRow(),
//             const SizedBox(height: 10),
//
//             /// Button Section
//             ///
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CreateScheduleWidget(token: widget.token),
//                   ),
//                 );
//               },
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(
//                           width: 1,
//                           color: Colors.green,
//                         )),
//                     child: Text("Create Schedule",
//                         style: AppStyle.cardSubtitle
//                             .copyWith(color: Colors.green[800], fontSize: 14))),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             /// BlocConsumer for fetching schedules
//             BlocProvider(
//               create: (_) => sl<GetScheduleBloc>()
//                 ..add(GetScheduleEvent(
//                     TokenReqEntity(token: widget.token ?? ""))),
//               child: BlocConsumer<GetScheduleBloc, ProfileState>(
//                 builder: (context, state) {
//                   if (state is ProfileLoading) {
//                     return const CustomContainerLoadingButton();
//                   } else if (state is GetScheduleDone) {
//                     if (state.resp.data == null || state.resp.data.isEmpty) {
//                       return _buildNoDataMessage('No available schedule');
//                     }
//
//                     return SizedBox(
//                       height: 500, // Prevent infinite height issue
//                       child: ListView.builder(
//                         itemCount: state.resp.data.length,
//                         itemBuilder: (context, index) {
//                           var vehicle = state.resp.data[index];
//                           return _buildVehicleSchedule(vehicle);
//                         },
//                       ),
//                     );
//                   } else {
//                     return _buildNoDataMessage('No records found');
//                   }
//                 },
//                 listener: (context, state) {
//                   if (state is ProfileFailure) {
//                     if (state.message.contains("401")) {
//                       Navigator.pushNamed(context, "/login");
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.message)),
//                     );
//                   }
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   /// Builds the legend row
//   Widget _buildLegendRow() {
//     return Row(
//       children: [
//         _buildLegendItem(Colors.grey, 'All'),
//         _buildLegendItem(Colors.yellow, 'Due'),
//         _buildLegendItem(Colors.redAccent, 'Overdue'),
//         _buildLegendItem(Colors.greenAccent, 'Completed'),
//       ],
//     );
//   }
//
//   /// Builds a single legend item
//   Widget _buildLegendItem(Color color, String label) {
//     return Row(
//       children: [
//         CircleAvatar(radius: 8, backgroundColor: color),
//         const SizedBox(width: 5),
//         Text(label, style: AppStyle.cardSubtitle.copyWith(fontSize: 12)),
//         const SizedBox(width: 10),
//       ],
//     );
//   }
//
//   /// Displays a no-data message
//   Widget _buildNoDataMessage(String message) {
//     return Center(child: Text(message, style: AppStyle.cardfooter));
//   }
//
//   /// Builds the vehicle maintenance schedule
//   Widget _buildVehicleSchedule(vehicle) {
//     var maintenanceList = vehicle.maintenance ?? [];
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(10.0),
//       decoration: maintenanceList.isNotEmpty
//           ? BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.grey.shade200,
//             )
//           : null,
//       child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// List all maintenance records
//           ...maintenanceList.map((maintenance) {
//             debugPrint("Processing VIN: ${maintenance.vehicle_vin}, Schedule ID: ${maintenance.id}");
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           _buildTitleText('Vehicle Number'),
//                           const SizedBox(height: 10),
//                           _buildTitleText('Service Type'),
//                           const SizedBox(height: 10),
//                           _buildTitleText('Status'),
//                           const SizedBox(height: 10),
//                           _buildTitleText('description'),
//                           const SizedBox(height: 10),
//                           _buildTitleText('Start Date'),
//                           const SizedBox(height: 10),
//
//                           /// View Schedule Button (Pass Single Maintenance)
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ViewSchedule(
//                                       state: vehicle,
//                                       maintenance:
//                                           maintenance, // Pass only the selected record
//                                       token: widget.token!,
//                                     ),
//                                   ));
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   border: Border.all(
//                                       width: 1, color: Colors.green)),
//                               child: Text('View Schedule',
//                                   style: AppStyle.cardSubtitle.copyWith(
//                                       color: Colors.green[800], fontSize: 12)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildValueText(maintenance.vehicle_vin ?? "N/A"),
//                           const SizedBox(height: 10),
//                           _buildValueText(maintenance.schedule_type ?? "N/A"),
//                           const SizedBox(height: 10),
//                           // _buildValueText(maintenance.schedule_type ?? "N/A"),
//                           _fetchMaintenanceStatus(
//                             vin: maintenance.vehicle_vin,
//                             scheduleId: maintenance.id.toString(),
//                           ),
//                           const SizedBox(height: 10),
//                           _buildValueText(maintenance.description ?? "N/A"),
//                           const SizedBox(height: 10),
//                           _buildValueText(maintenance.start_date ?? "N/A"),
//                           // const SizedBox(height: 10),
//                           Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Colors.grey.shade200,
//                                 )),
//                             child: Text('',
//                                 style: AppStyle.cardSubtitle.copyWith(
//                                     color: Colors.grey.shade200, fontSize: 12)),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Divider(
//                     height: 2,
//                   )
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   /// Builds title text
//   Widget _buildTitleText(String text) {
//     return Text(text,
//         style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold));
//   }
//
//   /// Builds value text
//   Widget _buildValueText(String text) {
//     return Text(text, style: AppStyle.cardfooter);
//   }
//
// /// Mock function for maintenance status
//   _fetchMaintenanceStatus({required String vin, required String scheduleId}) {
//   debugPrint("Checking Maintenance Status for VIN: $vin, Schedule ID: $scheduleId");
//   return BlocProvider(
//     create: (_) => sl<GetScheduleNoticeBloc>()
//       ..add(ScheduleNoticeEvent(TokenReqEntity(
//           token: widget.token ?? "", contentType: 'application/json'))),
//     child: BlocConsumer<GetScheduleNoticeBloc, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileLoading) {
//           return const CustomContainerLoadingButton();
//         } else if (state is GetScheduleNoticeDone) {
//           if (state.resp == null || state.resp.isEmpty) {
//             return Text(
//               "No notices available",
//               style: AppStyle.cardfooter,
//             );
//           }
//
//           // 🔍 Debugging: Print received data
//           debugPrint("Received resp: ${state.resp}");
//
//           final vehicle = state.resp.where((v) {
//             debugPrint("Checking: VIN(${v.vin}) == VIN($vin), ScheduleID(${v.schedule_id}) == ScheduleID($scheduleId)");
//             return v.vin == vin && (v.schedule_id ?? "N/A") == scheduleId;
//           }).toList();
//
//           if (vehicle.isEmpty) {
//             return Text(
//               "Notice not found",
//               style: AppStyle.cardfooter,
//             );
//           }
//
//           // ✅ Iterate over the filtered list
//           return Column(
//             children: vehicle.map((v) {
//               String statusText = v.maintenance_due == true &&
//                   (v.over_due_days == 0 || v.over_due_km == 0)
//                   ? "Due"
//                   : v.maintenance_due == true &&
//                   (v.over_due_days > 0 || v.over_due_km > 0)
//                   ? "Overdue"
//                   : "Completed";
//
//               Color statusColor = _getStatusColor(statusText);
//
//               return Text(
//                 statusText,
//                 style: AppStyle.cardSubtitle.copyWith(
//                     fontSize: 12, color: statusColor),
//               );
//             }).toList(),
//           );
//         } else {
//           return Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Unable to load status',
//                     style: AppStyle.cardfooter.copyWith(fontSize: 12),
//                   ),
//                   const SizedBox(width: 5.0),
//                   InkWell(
//                     onTap: () {
//                       BlocProvider.of<ProfileVehiclesBloc>(context).add(
//                           ProfileVehicleEvent(TokenReqEntity(
//                               token: widget.token ?? "",
//                               contentType: 'application/json')));
//                     },
//                     child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                               width: 1,
//                               color: Colors.grey.shade200,
//                             )),
//                         child: const Icon(
//                           Icons.refresh,
//                           color: Colors.green,
//                         )),
//                   ),
//                 ],
//               ));
//         }
//       },
//       listener: (context, state) async {
//         if (state is ProfileFailure) {
//           await prefUtils.clearPreferencesData();
//           if (state.message.contains('Unauthenticated')) {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, "/login", (route) => false);
//           }
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//     ),
//   );
// }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case "Due":
//         return Colors.yellow;
//       case "Overdue":
//         return Colors.redAccent;
//       case "Completed":
//         return Colors.greenAccent;
//       default:
//         return Colors.grey;
//     }
//   }
// }

///

//  Widget _fetchMaintenanceStatus({required String vin, required String scheduleId}) {
//     debugPrint("Checking Maintenance Status for VIN: $vin, Schedule ID: $scheduleId");
//
//     return BlocBuilder<GetScheduleNoticeBloc, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileLoading) {
//           return const CustomContainerLoadingButton();
//         } else if (state is GetScheduleNoticeDone) {
//           if (state.resp == null || state.resp.isEmpty) {
//             return Text("No notices available", style: AppStyle.cardfooter);
//           }
//
//           // 🔍 Debugging: Print received data
//           debugPrint("Received resp: ${state.resp}");
//
//           final vehicle = state.resp.where((v) {
//             debugPrint("Checking: VIN(${v.vin}) == VIN($vin), ScheduleID(${v.schedule_id}) == ScheduleID($scheduleId)");
//             return v.vin == vin && (v.schedule_id ?? "N/A") == scheduleId;
//           }).toList();
//
//           if (vehicle.isEmpty) {
//             return Text("Notice not found", style: AppStyle.cardfooter);
//           }
//
//           // ✅ Iterate over the filtered list
//           return Column(
//             children: vehicle.map((v) {
//               String statusText = v.maintenance_due == true &&
//                   (v.over_due_days == 0 || v.over_due_km == 0)
//                   ? "Due"
//                   : v.maintenance_due == true &&
//                   (v.over_due_days > 0 || v.over_due_km > 0)
//                   ? "Overdue"
//                   : "Completed";
//
//               Color statusColor = _getStatusColor(statusText);
//
//               return Text(
//                 statusText,
//                 style: AppStyle.cardSubtitle.copyWith(fontSize: 12, color: statusColor),
//               );
//             }).toList(),
//           );
//         } else {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Unable to load status', style: AppStyle.cardfooter.copyWith(fontSize: 12)),
//               const SizedBox(width: 5.0),
//               InkWell(
//                 onTap: () {
//                   BlocProvider.of<GetScheduleNoticeBloc>(context).add(
//                     ScheduleNoticeEvent(
//                       TokenReqEntity(token: widget.token ?? "", contentType: 'application/json'),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(width: 1, color: Colors.grey.shade200),
//                   ),
//                   child: const Icon(Icons.refresh, color: Colors.green),
//                 ),
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

///
// class Maintenance extends StatefulWidget {
//   final String? token;
//   const Maintenance({super.key, this.token});
//
//   @override
//   State<Maintenance> createState() => _MaintenanceState();
// }
//
// class _MaintenanceState extends State<Maintenance> {
//   PrefUtils prefUtils = PrefUtils();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text(
//               'Maintenance',
//               style: AppStyle.pageTitle.copyWith(fontSize: 16),
//             )
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 8,
//                     backgroundColor: Colors.grey,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     'All',
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   const CircleAvatar(
//                     radius: 8,
//                     backgroundColor: Colors.yellow,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     'Due',
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   const CircleAvatar(
//                     radius: 8,
//                     backgroundColor: Colors.redAccent,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     'Overdue',
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   const CircleAvatar(
//                     radius: 8,
//                     backgroundColor: Colors.greenAccent,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     'Completed',
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 height: 50.0,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 1,
//                   itemBuilder: (context, index) {
//                     return Row(
//                       children: [
//                         CustomSecondaryButton(
//                           label: "Create Schedule",
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => CreateScheduleWidget(
//                                         token: widget.token)));
//                           },
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               BlocProvider(
//                 create: (_) => sl<GetScheduleBloc>()
//                   ..add(GetScheduleEvent(
//                       TokenReqEntity(token: widget.token ?? ""))),
//                 child: BlocConsumer<GetScheduleBloc, ProfileState>(
//                   builder: (context, state) {
//                     if (state is ProfileLoading) {
//                       return const CustomContainerLoadingButton();
//                     } else if (state is GetScheduleDone) {
//                       if (state.resp.data == null || state.resp.data.isEmpty) {
//                         return Center(
//                           child: Text('No available schedule',
//                               style: AppStyle.cardfooter),
//                         );
//                       }
//                       return Column(
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(
//                                height: 500,
//                                 child: ListView.builder(
//                                   itemCount: state.resp.data.length,
//                                   shrinkWrap: true, // This prevents the ListView from taking infinite height
//                                   itemBuilder: (context, index) {
//
//                                     var vehicle = state.resp.data[index];
//                                     var maintenanceList = vehicle.maintenance ?? [];
//                                     return Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 8.0),
//                                         padding: const EdgeInsets.all(10.0),
//                                         decoration: maintenanceList.isNotEmpty
//                                             ? BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 color: Colors.grey.shade200,
//                                               )
//                                             : null,
//                                         child: Column(
//                                           children: [
//                                             Expanded(
//                                               child: ListView.builder(
//                                                 itemCount: state.resp.data.length,
//                                                 itemBuilder: (context, index) {
//                                                   var vehicle = state.resp.data[index];
//                                                   var maintenanceList = vehicle.maintenance ?? [];
//
//                                                   return Container(
//                                                     margin:
//                                                         const EdgeInsets.symmetric(
//                                                             vertical: 8.0),
//                                                     padding:
//                                                         const EdgeInsets.all(10.0),
//                                                     decoration: maintenanceList
//                                                             .isNotEmpty
//                                                         ? BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(5),
//                                                             color: Colors
//                                                                 .grey.shade200,
//                                                           )
//                                                         : null,
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment.start,
//                                                       children: [
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 _buildTitleText('Vehicle Number'),
//                                                                 // _buildTitleText('Total Services'),
//                                                               ],
//                                                             ),
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 _buildValueText(
//                                                                     vehicle.number_plate ?? "N/A"),
//                                                                 // _buildValueText(maintenanceList.length.toString()),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const SizedBox(height: 10),
//
//                                                         /// List all maintenance records
//                                                         ...maintenanceList
//                                                             .map((maintenance) {
//                                                           return Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .symmetric(
//                                                                     vertical: 10.0),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Divider(
//                                                                     color: Colors
//                                                                         .grey
//                                                                         .shade400),
//                                                                 _buildTitleText(
//                                                                     'Service Type'),
//                                                                 _buildValueText(
//                                                                     maintenance.schedule_type ?? "N/A"),
//
//                                                                 _buildTitleText('Status'),
//                                                                 _buildValueText(_buildMaintenanceStatus(
//                                                                     vin: maintenance.vehicle_vin,
//                                                                     scheduleId: maintenance.id)),
//
//                                                                 _buildTitleText('Start Date'),
//                                                                 _buildValueText(
//                                                                     maintenance.start_date ?? "N/A"),
//
//                                                                 /// View Schedule Button (Pass Single Maintenance)
//                                                                 const SizedBox(
//                                                                     height: 10),
//                                                                 CustomSecondaryButton(
//                                                                   label: 'View Schedule',
//                                                                   onPressed: () {
//                                                                     Navigator.push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                         builder: (_) =>
//                                                                             ViewSchedule(
//                                                                           state: vehicle,
//                                                                           maintenance: maintenance, // Pass only the selected record
//                                                                               token: widget.token!
//                                                                         ),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         }).toList(),
//                                                       ],
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ));
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     } else {
//                       return Center(
//                         child: Text('No records found',
//                             style: AppStyle.cardfooter),
//                       );
//                     }
//                   },
//                   listener: (context, state) {
//                     if (state is ProfileFailure) {
//                       if (state.message.contains("401")) {
//                         Navigator.pushNamed(context, "/login");
//                       }
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(state.message)),
//                       );
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Helper widgets for styling
//   Widget _buildTitleText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(text, style: AppStyle.cardfooter),
//     );
//   }
//
//   Widget _buildValueText(String text, {bool isStatus = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(
//         text,
//         style: AppStyle.cardfooter.copyWith(
//           color: isStatus ? Colors.redAccent : null,
//         ),
//       ),
//     );
//   }
//
//   _buildMaintenanceStatus({required String vin, required String scheduleId}) {
//     return BlocProvider(
//       create: (_) => sl<GetScheduleNoticeBloc>()
//         ..add(ScheduleNoticeEvent(TokenReqEntity(
//             token: widget.token ?? "",
//             contentType: 'application/json'))),
//       child: BlocConsumer<ProfileVehiclesBloc, ProfileState>(
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const CustomContainerLoadingButton();
//           } else if (state is GetScheduleNoticeDone) {
//               final vehicle = state.resp.firstWhere(
//                     (v) => v.vin == vin && v.schedule_id == scheduleId,
//                 // orElse: () => null,
//               );
//
//               if (vehicle == null) {
//                 return Text(
//                   "Notice not found",
//                   style: AppStyle.cardfooter,
//                 );
//               }
//
//               String statusText = vehicle.maintenance_due == true &&
//                   (vehicle.over_due_days == 0 || vehicle.over_due_km == 0)
//                   ? "Due"
//                   : vehicle.maintenance_due == true &&
//                   (vehicle.over_due_days > 0 || vehicle.over_due_km > 0)
//                   ? "Overdue"
//                   : "Completed";
//               Color statusColor = _getStatusColor(statusText);
//
//               return Text(
//                 statusText,
//                 style: AppStyle.cardSubtitle
//                     .copyWith(fontSize: 12, color: statusColor),
//               );
//           } else {
//             return Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Unable to load vehicles',
//                       style: AppStyle.cardfooter.copyWith(fontSize: 12),
//                     ),
//                     const SizedBox(
//                       width: 10.0,
//                     ),
//                     IconButton(
//                         onPressed: () {
//                           BlocProvider.of<ProfileVehiclesBloc>(context)
//                               .add(ProfileVehicleEvent(TokenReqEntity(
//                               token: widget.token ?? "",
//                               contentType: 'application/json')));
//                         },
//                         icon: const Icon(Icons.refresh, color: Colors.green,))
//                     // CustomSecondaryButton(
//                     //     label: 'Refresh',
//                     //     onPressed: () {
//                     //       BlocProvider.of<ProfileVehiclesBloc>(context)
//                     //           .add(ProfileVehicleEvent(TokenReqEntity(
//                     //           token: widget.token ?? "",
//                     //           contentType: 'application/json')));
//                     //     })
//                   ],
//                 ));
//           }
//         },
//         listener: (context, state) async {
//           if (state is ProfileFailure) {
//             await prefUtils.clearPreferencesData();
//             if(state.message.contains('Unauthenticated')){
//               Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
//             }
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//       ),
//     );
//
//     //   BlocBuilder<GetScheduleNoticeBloc, ProfileState>(
//     //   builder: (context, state) {
//     //     if (state is ProfileLoading) {
//     //       return const Center(child: CircularProgressIndicator());
//     //     } else if (state is GetScheduleNoticeDone) {
//     //       final vehicle = state.resp.firstWhere(
//     //             (v) => v.vin == vin && v.schedule_id == scheduleId,
//     //         // orElse: () => null,
//     //       );
//     //
//     //       if (vehicle == null) {
//     //         return Text(
//     //           "Notice not found",
//     //           style: AppStyle.cardfooter,
//     //         );
//     //       }
//     //
//     //       String statusText = vehicle.maintenance_due == true &&
//     //           (vehicle.over_due_days == 0 || vehicle.over_due_km == 0)
//     //           ? "Due"
//     //           : vehicle.maintenance_due == true &&
//     //           (vehicle.over_due_days > 0 || vehicle.over_due_km > 0)
//     //           ? "Overdue"
//     //           : "Completed";
//     //       Color statusColor = _getStatusColor(statusText);
//     //
//     //       return Text(
//     //         statusText,
//     //         style: AppStyle.cardSubtitle
//     //             .copyWith(fontSize: 12, color: statusColor),
//     //       );
//     //     } else {
//     //       return Text("Failed to load status.", style: AppStyle.cardfooter);
//     //     }
//     //   },
//     // );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case "Due":
//         return Colors.yellow;
//       case "Overdue":
//         return Colors.redAccent;
//       case "Completed":
//         return Colors.greenAccent;
//       default:
//         return Colors.grey;
//     }
//   }
// }

///
// class MaintenanceListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Maintenance List"),
//       ),
//       body: BlocBuilder<GetScheduleNoticeBloc, ProfileState>(
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is GetScheduleNoticeDone) {
//             final vehicleList = state.resp;
//
//             if (vehicleList.isEmpty) {
//               return const Center(child: Text("No maintenance records found."));
//             }
//
//             return ListView.builder(
//               padding: const EdgeInsets.all(10.0),
//               itemCount: vehicleList.length,
//               itemBuilder: (context, index) {
//                 var vehicle = vehicleList[index];
//                 var maintenance = vehicle ?? [];
//
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   padding: const EdgeInsets.all(10.0),
//                   decoration:
//                   // maintenanceList.isNotEmpty ?
//                   BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.grey.shade200,
//                   ),
//                       // : null,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildTitleText('Vehicle Number'),
//                               _buildTitleText('Total Services'),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildValueText(vehicle.number_plate ?? "N/A"),
//                               _buildValueText(maintenanceList.length.toString()),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Divider(color: Colors.grey.shade400),
//                           _buildTitleText('Service Type'),
//                           _buildValueText(maintenance.schedule_type ?? "N/A"),
//                           _buildTitleText('Reminder in days'),
//                           _buildValueText(maintenance.reminder_advance_days?.toString() ?? "N/A"),
//                           _buildTitleText('Reminder in km'),
//                           _buildValueText(maintenance.reminder_advance_km?.toString() ?? "N/A"),
//                           _buildTitleText('Reminder in Hr'),
//                           _buildValueText(maintenance.reminder_advance_hr?.toString() ?? "N/A"),
//                           _buildTitleText('Start Date'),
//                           _buildValueText(maintenance.start_date ?? "N/A"),
//                         ],
//                       ),
//                     );
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomSecondaryButton(
//                               label: 'View Schedule',
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ViewSchedule(state: vehicle),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text("Failed to load maintenance records."));
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildTitleText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//     );
//   }
//
//   Widget _buildValueText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//     );
//   }
// }

///

// BlocProvider(
//   create: (_) => sl<GetScheduleBloc>()
//     ..add(GetScheduleEvent(TokenReqEntity(token: widget.token ?? ""))),
//   child: BlocConsumer<GetScheduleBloc, ProfileState>(
//     builder: (context, state) {
//       if (state is ProfileLoading) {
//         return const CustomContainerLoadingButton();
//       } else if (state is GetScheduleDone) {
//         if (state.resp.data == null || state.resp.data.isEmpty) {
//           return Center(
//             child: Text('No available schedule', style: AppStyle.cardfooter),
//           );
//         }
//
//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: state.resp.data.length,
//                 itemBuilder: (context, index) {
//                   var vehicle = state.resp.data[index];
//                   var maintenanceList = vehicle.maintenance ?? [];
//
//                   return Container(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     padding: const EdgeInsets.all(10.0),
//                     decoration: maintenanceList.isNotEmpty
//                         ? BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Colors.grey.shade200,
//                     )
//                         : null,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildTitleText('Vehicle Number'),
//                                 _buildTitleText('Total Services'),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildValueText(vehicle.number_plate ?? "N/A"),
//                                 _buildValueText(maintenanceList.length.toString()),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//
//                         /// List all maintenance records
//                         ...maintenanceList.map((maintenance) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Divider(color: Colors.grey.shade400),
//                                 _buildTitleText('Service Type'),
//                                 _buildValueText(maintenance.schedule_type ?? "N/A"),
//
//                                 // _buildTitleText('Status'),
//                                 // _buildValueText(
//                                 //   maintenance.status ?? "N/A",
//                                 //   isStatus: true,
//                                 // ),
//                                 _buildTitleText('Reminder in days'),
//                                 _buildValueText(
//                                   maintenance.reminder_advance_days ?? "N/A",
//                                   isStatus: true,
//                                 ),
//                                 _buildTitleText('Reminder in km'),
//                                 _buildValueText(
//                                   maintenance.reminder_advance_km ?? "N/A",
//                                   isStatus: true,
//                                 ),
//                                 _buildTitleText('Reminder in Hr'),
//                                 _buildValueText(
//                                   maintenance.reminder_advance_hr ?? "N/A",
//                                   isStatus: true,
//                                 ),
//
//                                 _buildTitleText('Start Date'),
//                                 _buildValueText(maintenance.start_date ?? "N/A"),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomSecondaryButton(
//                                 label: 'View Schedule',
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => ViewSchedule(state: vehicle),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//
//       } else {
//         return Center(
//           child: Text('No records found', style: AppStyle.cardfooter),
//         );
//       }
//     },
//     listener: (context, state) {
//       if (state is ProfileFailure) {
//         if (state.message.contains("401")) {
//           Navigator.pushNamed(context, "/login");
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(state.message)),
//         );
//       }
//     },
//   ),
// ),

///

// BlocProvider(
//             create: (_) => sl<GetScheduleBloc>()
//               ..add(GetScheduleEvent(
//                   TokenReqEntity(token: widget.token ?? ""))),
//             child: BlocConsumer<GetScheduleBloc, ProfileState>(
//               builder: (context, state) {
//                 if (state is ProfileLoading) {
//                   return const CustomContainerLoadingButton();
//                 } else if (state is GetScheduleDone) {
//                   // Check if the schedule data is empty
//                   if (state.resp.data == null || state.resp.data.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No available schedule',
//                         style: AppStyle.cardfooter,
//                       ),
//                     );
//                   }
//
//                   return Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ListView.builder(
//                               shrinkWrap: true, // This prevents the ListView from taking infinite height
//                               physics:
//                                   const NeverScrollableScrollPhysics(), // Disables scrolling if ListView is nested
//                               itemCount: state.resp.data.length,
//                               itemBuilder: (context, index) {
//                                 return state.resp.data.isNotEmpty
//                                     ? Container(
//                                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                                         padding: const EdgeInsets.all(10.0),
//                                         decoration: state.resp.data[index]
//                                                 .maintenance!.isEmpty
//                                             ? const BoxDecoration()
//                                             : BoxDecoration(
//                                           borderRadius: BorderRadius.circular(5),
//                                                 color: Colors.grey.shade200,
//                                               ),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             'Title',
//                                                             style: AppStyle
//                                                                 .cardSubtitle
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14),
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             'Vehicle Number',
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             'Service Task',
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             'Status',
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             'Date',
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             state
//                                                                     .resp
//                                                                     .data[
//                                                                         index]
//                                                                     .maintenance!
//                                                                     .isNotEmpty
//                                                                 ? state
//                                                                     .resp
//                                                                     .data[
//                                                                         index]
//                                                                     .maintenance![
//                                                                         0]
//                                                                     .schedule_type
//                                                                 : "N/A",
//                                                             style: AppStyle
//                                                                 .cardSubtitle
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14),
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             state
//                                                                     .resp
//                                                                     .data[
//                                                                         index]
//                                                                     .number_plate ??
//                                                                 "N/A",
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             state
//                                                                     .resp
//                                                                     .data[
//                                                                         index]
//                                                                     .maintenance!
//                                                                     .isNotEmpty
//                                                                 ? state
//                                                                     .resp
//                                                                     .data[
//                                                                         index]
//                                                                     .maintenance!
//                                                                     .length
//                                                                     .toString()
//                                                                 : "N/A",
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             'Overdue',
//                                                             style: AppStyle
//                                                                 .cardfooter
//                                                                 .copyWith(
//                                                               color: Colors
//                                                                   .redAccent,
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 10),
//                                                           Text(
//                                                             state
//                                                                     .resp
//                                                                     .data[
//                                                                         index]
//                                                                     .maintenance!
//                                                                     .isNotEmpty
//                                                                 ? state
//                                                                         .resp
//                                                                         .data[index]
//                                                                         .maintenance![0]
//                                                                         .start_date ??
//                                                                     "N/A"
//                                                                 : "N/A", // Fallback value
//                                                             style: AppStyle
//                                                                 .cardfooter,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                             const SizedBox(height: 20),
//                                             Row(
//                                                     children: [
//                                                       Container(),
//                                                       const SizedBox(
//                                                           width: 20),
//                                                       Expanded(
//                                                           child:
//                                                               CustomSecondaryButton(
//                                                                   label:
//                                                                       'View Schedule',
//                                                                   onPressed:
//                                                                       () {
//                                                                     Navigator.push(
//                                                                         context,
//                                                                         MaterialPageRoute(
//                                                                             builder: (_) => ViewSchedule(
//                                                                                   state: state.resp.data[index],
//                                                                                 )));
//                                                                   })
//                                                           ),
//                                                     ],
//                                                   ),
//                                           ],
//                                         ),
//                                       )
//                                     : const Center(
//                                         child: Text(
//                                           "No data available",
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.grey),
//                                         ),
//                                       );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 } else {
//                   return Center(
//                       child: Text(
//                     'No records found',
//                     style: AppStyle.cardfooter,
//                   ));
//                 }
//               },
//               listener: (context, state) {
//                 if (state is ProfileFailure) {
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

///
///
// class Maintenance extends StatefulWidget {
//   final String? token;
//   const Maintenance({super.key, this.token});
//
//   @override
//   State<Maintenance> createState() => _MaintenanceState();
// }
//
// class _MaintenanceState extends State<Maintenance> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Maintenance',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Due'),
//             Tab(text: 'Overdue'),
//             Tab(text: 'Completed'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           MaintenanceList(status: 'All', token: widget.token!),
//           DueMaintenanceList(status: 'Due', token: widget.token!),
//           OverdueMaintenanceList(status: 'Overdue'),
//           CompletedMaintenanceList(status: 'Completed'),
//         ],
//       ),
//     );
//   }
// }
//
// class MaintenanceList extends StatelessWidget {
//   final String status, token;
//   const MaintenanceList({super.key, required this.status, required this.token});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//               create: (_) => sl<GetScheduleBloc>()
//                 ..add(GetScheduleEvent(TokenReqEntity(token: token ?? ""))),
//               child: BlocConsumer<GetScheduleBloc, ProfileState>(
//                 builder: (context, state) {
//                   if (state is ProfileLoading) {
//                     return const CustomContainerLoadingButton();
//                   } else if (state is GetScheduleDone) {
//                     if (state.resp.data == null || state.resp.data.isEmpty) {
//                       return Center(
//                         child: Text('No available schedule', style: AppStyle.cardfooter),
//                       );
//                     }
//
//                     return Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: state.resp.data.length,
//                             itemBuilder: (context, index) {
//                               var vehicle = state.resp.data[index];
//                               var maintenanceList = vehicle.maintenance ?? [];
//
//                               return Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 8.0),
//                                 padding: const EdgeInsets.all(10.0),
//                                 decoration: maintenanceList.isNotEmpty
//                                     ? BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.grey.shade200,
//                                 )
//                                     : null,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             _buildTitleText('Vehicle Number'),
//                                             _buildTitleText('Total Services'),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             _buildValueText(vehicle.number_plate ?? "N/A"),
//                                             _buildValueText(maintenanceList.length.toString()),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//
//                                     /// List all maintenance records
//                                     ...maintenanceList.map((maintenance) {
//                                       return Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Divider(color: Colors.grey.shade400),
//                                             _buildTitleText('Service Type'),
//                                             _buildValueText(maintenance.schedule_type ?? "N/A"),
//
//                                             _buildTitleText('Status'),
//                                             // _buildValueText(
//                                             //   maintenance.status ?? "N/A",
//                                             //   isStatus: true,
//                                             // ),
//
//                                             _buildTitleText('Start Date'),
//                                             _buildValueText(maintenance.start_date ?? "N/A"),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//
//                                     const SizedBox(height: 20),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: CustomSecondaryButton(
//                                             label: 'View Schedule',
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) => ViewSchedule(state: vehicle),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//
//                   } else {
//                     return Center(
//                       child: Text('No records found', style: AppStyle.cardfooter),
//                     );
//                   }
//                 },
//                 listener: (context, state) {
//                   if (state is ProfileFailure) {
//                     if (state.message.contains("401")) {
//                       Navigator.pushNamed(context, "/login");
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.message)),
//                     );
//                   }
//                 },
//               ),
//             );
//
//   }
//
//   /// Helper widgets for styling
//   Widget _buildTitleText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(text, style: AppStyle.cardfooter),
//     );
//   }
//
//   Widget _buildValueText(String text, {bool isStatus = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(
//         text,
//         style: AppStyle.cardfooter.copyWith(
//           color: isStatus ? Colors.redAccent : null,
//         ),
//       ),
//     );
// }
// }
//
// class DueMaintenanceList extends StatelessWidget {
//   final String status, token;
//   const DueMaintenanceList({super.key, required this.status, required this.token});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GetScheduleNoticeBloc, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is GetScheduleNoticeDone) {
//           final vehicleList = state.resp;
//
//           if (vehicleList.isEmpty) {
//             return const Center(child: Text("No maintenance records found."));
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(10.0),
//             itemCount: vehicleList.length,
//             itemBuilder: (context, index) {
//               // var vehicle = vehicleList[index];
//               var maintenanceList = vehicleList[index];
//               // var maintenanceList = vehicle.maintenance ?? [];
//
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 8.0),
//                 padding: const EdgeInsets.all(10.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey.shade200,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildTitleText('Vehicle Number'),
//                             _buildTitleText('Total Services'),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildValueText(maintenanceList.vin ?? "N/A"),
//                             _buildValueText(maintenanceList.length.toString()),
//                           ],
//                         ),
//
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Divider(color: Colors.grey.shade400),
//                           _buildTitleText('Reminder in days'),
//                           _buildValueText(maintenanceList.over_due_days.reminder_advance_days?.toString() ?? "N/A"),
//                           _buildTitleText('Reminder in km'),
//                           _buildValueText(maintenance.reminder_advance_km?.toString() ?? "N/A"),
//                           _buildTitleText('Reminder in Hr'),
//                           _buildValueText(maintenance.reminder_advance_hr?.toString() ?? "N/A"),
//                           _buildTitleText('Start Date'),
//                           _buildValueText(maintenance.start_date ?? "N/A"),
//                         ],
//                       ),
//                     )
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomSecondaryButton(
//                             label: 'View Schedule',
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => ViewSchedule(state: vehicle),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         } else {
//           return const Center(child: Text("Failed to load maintenance records."));
//         }
//       },
//     );
//   }
//
//   Widget _buildTitleText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//     );
//   }
//
//   Widget _buildValueText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//     );
//   }
// }
//
// class OverdueMaintenanceList extends StatelessWidget {
//   final String status;
//   const OverdueMaintenanceList({super.key, required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Displaying $status maintenance items'),
//     );
//   }
// }
//
//
// class CompletedMaintenanceList extends StatelessWidget {
//   final String status;
//   const CompletedMaintenanceList({super.key, required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Displaying $status maintenance items'),
//     );
//   }
// }
