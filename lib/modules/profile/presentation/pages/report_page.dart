import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/get_trip_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  final List<GetTripRespEntity> report;
  const ReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report - Trip", style: AppStyle.cardSubtitle),
      ),
      body: ListView.builder(
        itemCount: report.length,
        itemBuilder: (BuildContext context, index) {
          final tripLocations = report[index].tripLocations;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Details Section
                _DetailItem(title: "Vehicle", value: report[index].vehicleVin),
                _DetailItem(title: "Driver", value: report[index].name),
                if (tripLocations != null && tripLocations.isNotEmpty) ...[
                  _DetailItem(
                      title: "Start Time", value: tripLocations[0].createdAt),
                  _DetailItem(
                      title: "Start Location",
                      value: tripLocations[0].startLocation),
                  _DetailItem(
                      title: "End Time", value: tripLocations[0].arrivalTime),
                  _DetailItem(
                      title: "End Location",
                      value: tripLocations[0].endLocation),
                  _DetailItem(
                      title: "Start Latitude",
                      value: tripLocations[0].startLat.toString()),
                  _DetailItem(
                      title: "End Latitude",
                      value: tripLocations[0].endLat.toString()),
                ] else ...[
                  // Fallback when tripLocations is empty or null
                  const _DetailItem(
                      title: "Start Time", value: "Not Available"),
                  const _DetailItem(
                      title: "Start Location", value: "Not Available"),
                  const _DetailItem(title: "End Time", value: "Not Available"),
                  const _DetailItem(
                      title: "End Location", value: "Not Available"),
                  const _DetailItem(
                      title: "Start Latitude", value: "Not Available"),
                  const _DetailItem(
                      title: "End Latitude", value: "Not Available"),
                ],
              ],
            ),
          );
        },
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

class MaintenanceReport extends StatelessWidget {
  final List<DatumEntity> report;
  const MaintenanceReport({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Report - Maintenance',
            style: AppStyle.cardSubtitle,
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap:
                        true, // This prevents the ListView from taking infinite height
                    physics:
                        const NeverScrollableScrollPhysics(), // Disables scrolling if ListView is nested
                    itemCount: report.length,
                    itemBuilder: (context, index) {
                      return report.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: report[index].maintenance.isEmpty
                                  ? const BoxDecoration()
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade200,
                                    ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  report[index].maintenance.isEmpty
                                      ? Center(
                                          child: Text(
                                          "No report found for the vehicle",
                                          style: AppStyle.cardfooter,
                                        ))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Title',
                                                  style: AppStyle.cardSubtitle
                                                      .copyWith(fontSize: 14),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  report[index]
                                                          .maintenance
                                                          .isNotEmpty
                                                      ? report[index]
                                                          .maintenance[0]
                                                          .schedule_type
                                                      : "N/A",
                                                  style: AppStyle.cardSubtitle
                                                      .copyWith(fontSize: 14),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  report[index].number_plate ??
                                                      "N/A",
                                                  style: AppStyle.cardfooter,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  report[index]
                                                          .maintenance
                                                          .isNotEmpty
                                                      ? report[index]
                                                          .maintenance
                                                          .length
                                                          .toString()
                                                      : "N/A",
                                                  style: AppStyle.cardfooter,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Overdue',
                                                  style: AppStyle.cardfooter
                                                      .copyWith(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  report[index]
                                                          .maintenance
                                                          .isNotEmpty
                                                      ? report[index]
                                                              .maintenance[0]
                                                              .start_date ??
                                                          "N/A"
                                                      : "N/A", // Fallback value
                                                  style: AppStyle.cardfooter,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  // const SizedBox(height: 20),
                                  // report[index].maintenance.isEmpty ? Container() : Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: OutlinedButton(
                                  //         onPressed: () {
                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //               builder: (_) => const ViewDetails(),
                                  //             ),
                                  //           );
                                  //         },
                                  //         child: Text(
                                  //           'View details',
                                  //           style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: 20),
                                  //     Expanded(
                                  //       child: OutlinedButton(
                                  //         onPressed: () {
                                  //           Navigator.push(context, MaterialPageRoute(builder: (_) => ViewSchedule(state: report[index],)));
                                  //         },
                                  //         child: Text(
                                  //           'View Schedule',
                                  //           style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            )
                          : const Center(
                              child: Text(
                                "No data available",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
