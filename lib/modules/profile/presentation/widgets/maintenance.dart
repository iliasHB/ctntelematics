import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
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
import '../../../../service_locator.dart';

// contentType: 'application/json'
class Maintenance extends StatefulWidget {
  final String? token;
  const Maintenance({super.key, this.token});

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Maintenance',
              style: AppStyle.pageTitle.copyWith(fontSize: 16),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'All',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.redAccent,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Overdue',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.yellow,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Overdue',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.greenAccent,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Completed',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateScheduleWidget(token: widget.token)));
                              // showModalBottomSheet(
                              //     context: context,
                              //     isDismissible: false,
                              //     isScrollControlled: true,
                              //     //useSafeArea: true,
                              //     shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.only(
                              //           topLeft: Radius.circular(20),
                              //           topRight: Radius.circular(20)),
                              //     ),
                              //     builder: (BuildContext context) {
                              //       return CreateScheduleWidget();
                              //     });
                            },
                            child: Text(
                              "Create Schedule",
                              style: AppStyle.cardfooter,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        // OutlinedButton(
                        //     onPressed: () => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (_) => CreateService())),
                        //     child: Text(
                        //       "Add Service",
                        //       style: AppStyle.cardfooter,
                        //     )),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        // OutlinedButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       "View Schedule",
                        //       style: AppStyle.cardfooter,
                        //     )),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // BlocConsumer<GetScheduleBloc, ProfileState>(
              //   listener: (context, state) {
              //     if (state is GetScheduleDone) {
              //       Navigator.push(context, MaterialPageRoute(builder: (_) => ViewSchedule(state: state.resp)));
              //     } else if (state is ProfileFailure) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(content: Text(state.message)));
              //     }
              //   },
              //   builder: (context, state) {
              //     if (state is ProfileLoading) {
              //       const CircularProgressIndicator(
              //         strokeWidth: 2,
              //         strokeAlign: -10.0,
              //       );
              //     }
              //     return Expanded(
              //       child: OutlinedButton(
              //         onPressed: () {
              //           final getScheduleReqEntity =
              //           TokenReqEntity(token: widget.token.toString());
              //           context.read<GetScheduleBloc>().add(
              //               GetScheduleEvent(getScheduleReqEntity));
              //           // },
              //           // Navigator.pushNamed(context, "/report");
              //           // showModalBottomSheet(
              //           //     context: context,
              //           //     isDismissible: false,
              //           //     isScrollControlled: true,
              //           //     //useSafeArea: true,
              //           //     shape: const RoundedRectangleBorder(
              //           //       borderRadius: BorderRadius.only(
              //           //           topLeft: Radius.circular(20),
              //           //           topRight: Radius.circular(20)),
              //           //     ),
              //           //     builder: (BuildContext context) {
              //           //       return const ViewSchedule();
              //           //     });
              //         },
              //         child: Text(
              //           'View Schedule',
              //           style: AppStyle.cardSubtitle
              //               .copyWith(fontSize: 14),
              //         ),
              //
              //         // Text('View schedule', style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
              //       ),
              //     );
              //
              //     //   Container(
              //     //   padding: const EdgeInsets.symmetric(vertical: 10),
              //     //   child: Row(
              //     //     children: [
              //     //       const Icon(
              //     //         Icons.lock_outline,
              //     //         color: Colors.green,
              //     //         size: 20,
              //     //       ),
              //     //       const SizedBox(
              //     //         width: 10,
              //     //       ),
              //     //       Text("Logout",
              //     //           style: AppStyle.cardfooter),
              //     //       const Spacer(),
              //     //       InkWell(
              //     //         onTap: () {
              //     //           final tokenReqEntity =
              //     //           TokenReqEntity(token: token.toString());
              //     //           context
              //     //               .read<LogoutBloc>()
              //     //               .add(LogoutEvent(tokenReqEntity));
              //     //         },
              //     //         child: const Icon(
              //     //           Icons.arrow_forward_ios_sharp,
              //     //           size: 15,
              //     //         ),
              //     //       )
              //     //     ],
              //     //   ),
              //     // );
              //   },
              // ),

              BlocProvider(
                create: (_) => sl<GetScheduleBloc>()
                  ..add(GetScheduleEvent(
                      TokenReqEntity(token: widget.token ?? ""))),
                child: BlocConsumer<GetScheduleBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      );
                    } else if (state is GetScheduleDone) {
                      // Check if the schedule data is empty
                      if (state.resp.data == null || state.resp.data.isEmpty) {
                        return Center(
                          child: Text(
                            'No available Schedule',
                            style: AppStyle.cardfooter,
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true, // This prevents the ListView from taking infinite height
                                  physics: const NeverScrollableScrollPhysics(), // Disables scrolling if ListView is nested
                                  itemCount: state.resp.data.length,
                                  itemBuilder: (context, index) {
                                    return state.resp.data.isNotEmpty
                                        ? Container(
                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: state.resp.data[index].maintenance.isEmpty ? const BoxDecoration() : BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          state.resp.data[index].maintenance.isEmpty ? Container() : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Title',
                                                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Vehicle Number',
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Service Task',
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Status',
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Date',
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.resp.data[index].maintenance.isNotEmpty
                                                        ? state.resp.data[index].maintenance[0].schedule_type
                                                        : "N/A",
                                                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    state.resp.data[index].number_plate ?? "N/A",
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    state.resp.data[index].maintenance.isNotEmpty
                                                        ? state.resp.data[index].maintenance.length.toString()
                                                        : "N/A",
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Overdue',
                                                    style: AppStyle.cardfooter.copyWith(
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    state.resp.data[index].maintenance.isNotEmpty
                                                        ? state.resp.data[index].maintenance[0].start_date ?? "N/A"
                                                        : "N/A", // Fallback value
                                                    style: AppStyle.cardfooter,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          state.resp.data[index].maintenance.isEmpty ? Container() : Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => const ViewDetails(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View details',
                                                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => ViewSchedule(state: state.resp.data[index],)));
                                                  },
                                                  child: Text(
                                                    'View Schedule',
                                                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                        : const Center(
                                      child: Text(
                                        "No data available",
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    );

                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );

                    } else {
                      return Center(
                          child: Text(
                        'No records found',
                        style: AppStyle.cardfooter,
                      ));
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

              // SizedBox(
              //   height: 50.0,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: _tabs.length,
              //     itemBuilder: (context, index) {
              //       return GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             _selectedTabIndex = index;
              //           });
              //         },
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //           child: Chip(
              //             side: BorderSide.none,
              //             backgroundColor: _selectedTabIndex == index
              //                 ? Colors.green
              //                 : Colors.grey.shade200,
              //             label: Text(
              //               _tabs[index],
              //               style: TextStyle(
              //                 color: _selectedTabIndex == index ? Colors.white : Colors.black,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
