import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteHistoryReportPage extends StatelessWidget {
  final VehicleRouteHistoryRespEntity report;
  final String? vin;
  const RouteHistoryReportPage({super.key, required this.report, this.vin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report - Route History',
          style: AppStyle.cardSubtitle,
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
              itemCount: report.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
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
                              title: 'Route History', subTitle: ''),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Details Section
                            _DetailItem(title: "Vehicle", value: vin!),
                            _DetailItem(
                                title: "Route Length",
                                value: (report.routeLength ?? 0.00).toString()),
                            _DetailItem(
                                title: "Status",
                                value: report.data[index].connected == null ? "N/A" : report.data[index].connected),
                            _DetailItem(
                                title: "Latitude",
                                value: report.data[index].latitude),
                            _DetailItem(
                                title: "End Latitude",
                                value: report.data[index].longitude),
                            _DetailItem(
                                title: "DateTime",
                                value: FormatData.formatTimestamp(
                                    report.data[index].created_at)),
                            // _DetailItem(title: "Number of Event", value: ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget DashboardComponentTitle(
      {required String title, required String subTitle}) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.directions,
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
                  title,
                  style: AppStyle.cardSubtitle,
                ),
                Text(
                  subTitle,
                  style: AppStyle.cardfooter.copyWith(fontSize: 12),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
                  maxLines: 2, // Restricts to 2 lines
                ),
              ],
            ),
          ),
        ),
      ],
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
