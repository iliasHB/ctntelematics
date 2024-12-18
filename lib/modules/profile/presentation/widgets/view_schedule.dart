import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../config/theme/app_style.dart';

class ViewSchedule extends StatelessWidget {
  // final GetScheduleRespEntity state;
  final DatumEntity state;
  const ViewSchedule({super.key, required this.state, /*required this.state*/});

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
              state.maintenance!.isNotEmpty
                  ? state.maintenance![0].schedule_type ?? "N/A"
                  : "N/A",
              style: AppStyle.cardSubtitle.copyWith(color: Colors.green.shade800, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              state.number_plate.isEmpty ? "" : state.number_plate,
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
            const SizedBox(
              height: 10,
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
                    state.maintenance!.isNotEmpty ? state.maintenance[0].description ?? "" : "",
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
                              ))),

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                state.maintenance!.isNotEmpty ? state.maintenance![0].description ?? "" : "",
                                style: AppStyle.cardfooter,
                              ))),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                state.maintenance!.isNotEmpty ? "upcoming" : "",
                                style: AppStyle.cardfooter,
                              ))),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                state.maintenance.isNotEmpty ? state.maintenance[0].start_date ?? "" : "",
                                style: AppStyle.cardfooter,
                              ))),

                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Text(
                  //               'Task; Oil change',
                  //               style: AppStyle.cardfooter,
                  //             ))),
                  //     Expanded(
                  //         child: Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Text(
                  //               'Overdue',
                  //               style: AppStyle.cardfooter,
                  //             ))),
                  //     Expanded(
                  //         child: Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Text(
                  //               'September 26, 2024',
                  //               style: AppStyle.cardfooter,
                  //             ))),
                  //
                  //   ],
                  // ),
                ],
              ),
            ),
             const Spacer(),
            Row(
              children: [
                Expanded(
                  child: CustomSecondaryButton(
                      label: 'Done',
                      onPressed: ()=>Navigator.pop(context)),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: OutlinedButton(
            //           onPressed: (){},
            //           child: Text('Done', style: AppStyle.cardSubtitle.copyWith(fontSize: 14),)),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
