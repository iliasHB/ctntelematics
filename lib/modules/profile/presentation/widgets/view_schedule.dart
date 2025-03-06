import 'package:ctntelematics/core/model/token_req_entity.dart';
import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/complete_schedule_req_entity.dart';
import '../../domain/entitties/resp_entities/get_schedule_resp_notice_entity.dart';

class ViewSchedule extends StatelessWidget {
  // final GetScheduleRespEntity state;
  final DatumEntity state;
  final MaintenanceEntity maintenance;
  final String token;
  const ViewSchedule({super.key, required this.state, required this.maintenance, required this.token, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'View Schedule',
              style: AppStyle.pageTitle,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule:',
              style: AppStyle.cardSubtitle,
            ),
            Text(
              maintenance.schedule_type ?? "N/A",
              style: AppStyle.cardSubtitle.copyWith(color: Colors.green.shade800, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              state.number_plate.isEmpty ? "" : state.number_plate ?? "N/A",
              style: AppStyle.cardSubtitle
                  .copyWith(color: Colors.green, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Service Tasks:',
              style: AppStyle.cardSubtitle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green.shade50),
                  child: Text(
                    maintenance.description ?? "No service tasks",
                    style: AppStyle.cardfooter.copyWith(color: Colors.green[900]),
                  ),
                ),
                // const SizedBox(
                //   width: 20,
                // ),
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50),
                //       color: Colors.green.shade50),
                //   child: Text(
                //     'Task; Oil replacement',
                //     style: AppStyle.cardfooter.copyWith(color: Colors.green[900]),
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Service Reminder',
              style: AppStyle.cardSubtitle,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.green.shade200,
                              child: Text(
                                'Tasks',
                                style: AppStyle.cardSubtitle,
                              ))),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.green.shade200,
                              child: Text(
                                'Status',
                                style: AppStyle.cardSubtitle,
                              ))),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.green.shade200,
                              child: Text(
                                'Date',
                                style: AppStyle.cardSubtitle,
                              )
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                maintenance.description ?? "N/A",
                                style: AppStyle.cardfooter,
                              ))),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: _fetchMaintenanceStatus(vin: state.vin, scheduleId: maintenance.id.toString(),)
                          )),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                state.maintenance.isNotEmpty ? state.maintenance[0].start_date ?? "" : "",
                                style: AppStyle.cardfooter,
                              )
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            BlocConsumer<CompleteScheduleBloc, ProfileState>(
              listener: (context, state) {
                if (state is CompleteScheduleDone) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.resp.message)));
                } else if (state is ProfileFailure) {
                  if (state.message.contains("Unauthenticated")) {
                  Navigator.pushNamed(context, "/login");
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CustomLoadingButton());
                }
                return Row(
                  children: [
                    Expanded(
                      child: CustomSecondaryButton(
                        label: 'Completed',
                        onPressed: () {
                            final loginReqEntity = CompleteScheduleReqEntity(
                                vehicle_vin: maintenance.vehicle_vin, schedule_id: maintenance.id.toString(), token: token
                            );
                            context.read<CompleteScheduleBloc>().add(CompleteScheduleEvent(loginReqEntity));
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fetchMaintenanceStatus({required String vin, required String scheduleId}) {
    debugPrint("Checking Maintenance Status for VIN: $vin, Schedule ID: $scheduleId");
    debugPrint("ScheduleNoticeEvent Dispatched: Token - ${token ?? "No token"}");
    return BlocProvider(
      create: (_) => sl<GetSingleScheduleNoticeBloc>()
        ..add(SingleScheduleNoticeEvent(TokenReqEntity(
            token: token ?? "", contentType: 'application/json', vehicle_vin: vin))),
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
            //
            // // Debugging: Print received data
            // debugPrint("Received resp: ${state.resp}");
            //
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
                              TokenReqEntity(token: token)));
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


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "Due":
        return Colors.yellow;
      case "Overdue":
        return Colors.redAccent;
      case "Completed":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}

// Widget _fetchMaintenanceStatus({required String vin, required String scheduleId}) {
//   debugPrint("Checking Maintenance Status for VIN: $vin, Schedule ID: $scheduleId");
//   return BlocProvider(
//     create: (_) => sl<GetScheduleNoticeBloc>()
//       ..add(ScheduleNoticeEvent(TokenReqEntity(
//           token: token ?? "", contentType: 'application/json'))),
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
//                             TokenReqEntity(token: token)));
//                   },
//                   child: const Icon(Icons.refresh, color: Colors.blue),
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