import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/modules/dashboard/presentation/widgets/vehicle_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../bloc/dashboard_bloc.dart';


class VehicleSearchDialog {
  static showVehicleSearchDialog(BuildContext context, String? token) {
    final dashVehicleReqEntity = DashVehicleReqEntity(
        token: token ?? "", contentType: 'application/json');

    final TextEditingController searchController = TextEditingController();
    ValueNotifier<String> searchQuery = ValueNotifier('');

    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6),
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Select Vehicles',
                            style: AppStyle.cardSubtitle,
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.cancel_outlined))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Form(
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search for a vehicle...',
                            hintStyle: AppStyle.cardfooter,
                            prefixIcon: const Icon(CupertinoIcons.search),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (value) {
                            searchQuery.value = value.toLowerCase();
                          },
                        ),
                      ),
                      BlocProvider(
                        create: (_) => sl<DashVehiclesBloc>()
                          ..add(DashVehicleEvent(dashVehicleReqEntity)),
                        child: BlocConsumer<DashVehiclesBloc, DashboardState>(
                            builder: (context, state) {
                              if (state is DashboardLoading) {
                                return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.green,
                                      ),
                                    ));
                              } else if (state is DashboardDone) {
                                return ValueListenableBuilder<String>(
                                  valueListenable: searchQuery,
                                  builder: (_, query, __) {
                                    final filteredVehicles = state.resp.data
                                        ?.where((vehicle) =>
                                    (vehicle.brand?.toLowerCase() ?? "")
                                        .contains(query) ||
                                        (vehicle.model?.toLowerCase() ?? "")
                                            .contains(query) ||
                                        (vehicle.number_plate
                                            ?.toLowerCase() ??
                                            "")
                                            .contains(query))
                                        .toList();
                                    return VehicleList(
                                        DashboardDone(state.resp.copyWith(
                                            data: filteredVehicles)),
                                        token);
                                  },
                                );
                              } else {
                                return Center(child: Text('No records found', style: AppStyle.cardfooter,));
                              }
                            },
                            listener: (context, state) {
                              if (state is DashboardFailure) {
                                if(state.message.contains('Unauthenticated')){
                                  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class VehicleList extends StatelessWidget {
  final DashboardDone state;
  final String? token;
  const VehicleList(this.state, this.token, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: state.resp.data == null ? 0 : state.resp.data!.length,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => VehicleInformation(
                          vehicle: state.resp.data![index],
                          token: token,
                        )));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "${state.resp.data![index].brand} "
                      "${state.resp.data![index].model} "
                      "${state.resp.data![index].year} "
                      "(${state.resp.data![index].number_plate})",
                  style: AppStyle.cardfooter.copyWith(color: Colors.green[800]),
                ),
              ),
            );
          }),
    );
  }
}






// class VehicleSearchDialog {
//   static showVehicleSearchDialog(BuildContext context, String? token) {
//     final dashVehicleReqEntity = DashVehicleReqEntity(
//         token: token ?? "", contentType: 'application/json');
//
//     return showGeneralDialog(
//       context: context,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierDismissible: true,
//       // transitionDuration: const Duration(milliseconds: 700),
//       pageBuilder: (_, __, ___) {
//         return Align(
//           alignment: Alignment.center,
//           child: Material(
//             // Added Material widget here
//             color: Colors.transparent,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height *
//                       0.6), // Dynamic height
//               width: 360,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'Select Vehicles',
//                           style: AppStyle.cardSubtitle,
//                         ),
//                         const Spacer(),
//                         IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.cancel_outlined))
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Form(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Search for a vehicle...',
//                           hintStyle: AppStyle.cardfooter,
//                           prefixIcon: const Icon(CupertinoIcons.search),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding:
//                               const EdgeInsets.symmetric(horizontal: 10),
//                         ),
//                       ),
//                     ),
//                     BlocProvider(
//                       create: (_) => sl<DashVehiclesBloc>()
//                         ..add(DashVehicleEvent(dashVehicleReqEntity)),
//                       child: BlocConsumer<DashVehiclesBloc, DashboardState>(
//                           builder: (context, state) {
//                         if (state is DashboardLoading) {
//                           return const Center(
//                               child: Padding(
//                             padding: EdgeInsets.only(top: 20.0),
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.0, color: Colors.green,
//                             ),
//                           ));
//                         } else if (state is DashboardDone) {
//                           return VehicleList(state, token);
//                         } else {
//                           return const Center(child: Text('No records found'));
//                         }
//                       }, listener: (context, state) {
//                         if (state is DashboardFailure) {
//                           //if (state.message.contains("The Token has expired")) {
//                           Navigator.pushNamed(context, "/login");
//                           //}
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(state.message)),
//                           );
//                         }
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class VehicleList extends StatelessWidget {
//   final DashboardDone state;
//   final String? token;
//   const VehicleList(this.state, this.token, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: ListView.builder(
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           itemCount: state.resp.data == null ? 0 : state.resp.data!.length,
//           itemBuilder: (BuildContext context, index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => VehicleInformation(vehicle: state.resp.data![index], token: token,)));
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 padding: const EdgeInsets.all(10.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey.shade300,
//                 ),
//                 child: Text(
//                   "${state.resp.data![index].brand} "
//                   "${state.resp.data![index].model} "
//                   "${state.resp.data![index].year} "
//                   "(${state.resp.data![index].number_plate})",
//                   style: AppStyle.cardfooter.copyWith(color: Colors.green[800]),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
