//
// import 'package:ctntelematics/core/widgets/format_data.dart';
// import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../config/theme/app_style.dart';
// import '../../../../service_locator.dart';
// import '../../../vehincle/domain/entities/req_entities/route_history_req_entity.dart';
// import '../../../vehincle/presentation/bloc/vehicle_bloc.dart';






///----

// class VehicleAnalysisPage extends StatefulWidget {
//   @override
//   _VehicleAnalysisPageState createState() => _VehicleAnalysisPageState();
// }
//
// class _VehicleAnalysisPageState extends State<VehicleAnalysisPage> {
//   List<DeviceStatus> deviceStatuses = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _generateSampleData();
//   }
//
//   void _generateSampleData() {
//     // Hardcoded device status data for demonstration purposes
//     deviceStatuses.addAll([
//       DeviceStatus(
//           'Device 1', 'ONLINE', DateTime.now().subtract(const Duration(days: 1))),
//       DeviceStatus('Device 1', 'OFFLINE',
//           DateTime.now().subtract(const Duration(days: 1, hours: 5))),
//       DeviceStatus(
//           'Device 2', 'ONLINE', DateTime.now().subtract(const Duration(days: 2))),
//       DeviceStatus('Device 2', 'OFFLINE',
//           DateTime.now().subtract(const Duration(days: 2, hours: 4))),
//       DeviceStatus(
//           'Device 3', 'ONLINE', DateTime.now().subtract(const Duration(days: 3))),
//       DeviceStatus('Device 3', 'OFFLINE',
//           DateTime.now().subtract(const Duration(days: 3, hours: 6))),
//       DeviceStatus('Device 1', 'ONLINE',
//           DateTime.now().subtract(const Duration(days: 1, hours: 10))),
//       DeviceStatus(
//           'Device 2', 'ONLINE', DateTime.now().subtract(const Duration(hours: 6))),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20.0),
//       child: Scaffold(
//         appBar: AppBar(
//             title: Row(
//           children: [
//             Text(
//               'Analytics',
//               style: AppStyle.cardSubtitle,
//             ),
//           ],
//         )),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text('Fuel cost (\$)', style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 200, child: _buildHistogram()),
//                 const SizedBox(height: 20),
//                 const Text('Vehicle Status Indicator',
//                     style: TextStyle(fontSize: 16)),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: SizedBox(height: 200, child: _buildPieChart())),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Recent Alert",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const Row(
//                           children: [
//                             Icon(CupertinoIcons.map_pin_ellipse, color: Colors.red,),
//                             Text(
//                               "Geofencing Branches",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 20.0),
//                           child: Text(
//                               "Alert Vehicle XYZ has breached the geofencing boundary at 3:00PM, existing the designation area"),
//                         ),
//                         Row(
//                           children: [
//                             ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
//                                 ),
//                                 onPressed: (){}, child: const Text("Deny", style: TextStyle(color: Colors.white),)),
//                             const SizedBox(width: 10,),
//                             ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//                                 ),
//                                 onPressed: (){}, child: const Text("Allow",  style: TextStyle(color: Colors.white),))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//
//                 // SizedBox(height: 20),
//                 // Text('Usage Statistics by Device (Bar Chart)',
//                 //     style: TextStyle(fontSize: 18)),
//                 // SizedBox(height: 200, child: _buildBarChart()),
//                 // SizedBox(height: 20),
//                 // Text('Historical Status Tracking (Line Chart)',
//                 //     style: TextStyle(fontSize: 18)),
//                 // SizedBox(height: 200, child: _buildLineChart()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Pie Chart: Device Status Distribution (ONLINE vs OFFLINE)
//   Widget _buildPieChart() {
//     int onlineCount =
//         deviceStatuses.where((status) => status.status == 'ONLINE').length;
//     int offlineCount =
//         deviceStatuses.where((status) => status.status == 'OFFLINE').length;
//     int totalCount = onlineCount + offlineCount;
//
//     // Calculate percentages
//     double onlinePercentage =
//         (totalCount == 0) ? 0 : (onlineCount / totalCount) * 100;
//     double offlinePercentage =
//         (totalCount == 0) ? 0 : (offlineCount / totalCount) * 100;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 PieChartSectionData(
//                   value: onlineCount.toDouble(),
//                   color: Colors.green,
//                   title:
//                       '${onlinePercentage.toStringAsFixed(1)}%', // Display percentage
//                   radius: 100,
//                   // showTitle: true,
//                   // badgeWidget: Text("data"),
//                   titleStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 PieChartSectionData(
//                   value: offlineCount.toDouble(),
//                   color: Colors.red,
//                   title:
//                       '${offlinePercentage.toStringAsFixed(1)}%', // Display percentage
//                   radius: 100,
//                   titleStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLegendItem(
//               Colors.green,
//               'Online',
//             ),
//             const SizedBox(width: 20), // Space between the legends
//             _buildLegendItem(Colors.red, 'Offline'),
//           ],
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
//
// // Helper widget to build the legend items for ONLINE and OFFLINE statuses
//   Widget _buildLegendItem(Color color, String text) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Padding(
//           padding: const EdgeInsets.only(right: 10.0),
//           child: Text(
//             text,
//             style: AppStyle.cardfooter,
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _buildHistogram() {
//     Map<String, int> activityCount = {
//       'Day 1': 0,
//       'Day 2': 0,
//       'Day 3': 0,
//     };
//
//     for (var status in deviceStatuses) {
//       String dayKey =
//           'Day ${DateTime.now().difference(status.timestamp).inDays + 1}';
//       if (activityCount.containsKey(dayKey)) {
//         activityCount[dayKey] = activityCount[dayKey]! + 1;
//       }
//     }
//
//     return BarChart(
//       BarChartData(
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, _) {
//                   switch (value.toInt()) {
//                     case 0:
//                       return const Text('Day 1');
//                     case 1:
//                       return const Text('Day 2');
//                     case 2:
//                       return const Text('Day 3');
//                   }
//                   return const Text('');
//                 }),
//           ),
//         ),
//         barGroups: [
//           BarChartGroupData(x: 0, barRods: [
//             BarChartRodData(
//                 toY: activityCount['Day 1']!.toDouble(), color: Colors.blue)
//           ]),
//           BarChartGroupData(x: 1, barRods: [
//             BarChartRodData(
//                 toY: activityCount['Day 2']!.toDouble(), color: Colors.blue)
//           ]),
//           BarChartGroupData(x: 2, barRods: [
//             BarChartRodData(
//                 toY: activityCount['Day 3']!.toDouble(), color: Colors.blue)
//           ]),
//         ],
//       ),
//     );
//   }
//   //
//   // // Line Chart: Historical Status Tracking
//   // Widget _buildLineChart() {
//   //   List<FlSpot> spots = deviceStatuses
//   //       .asMap()
//   //       .entries
//   //       .map((entry) => FlSpot(
//   //       entry.key.toDouble(), entry.value.status == 'ONLINE' ? 1 : 0))
//   //       .toList();
//   //
//   //   return LineChart(
//   //     LineChartData(
//   //       titlesData: FlTitlesData(show: true),
//   //       borderData: FlBorderData(show: true),
//   //       gridData: FlGridData(show: true),
//   //       lineBarsData: [
//   //         LineChartBarData(
//   //           spots: spots,
//   //           isCurved: true,
//   //           color: Colors.blue,
//   //           dotData: FlDotData(show: false),
//   //           belowBarData: BarAreaData(show: false),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
// // // Bar Chart: Usage Statistics by Device
// // Widget _buildBarChart() {
// //   Map<String, Map<String, int>> usageStats = {
// //     'Device 1': {'ONLINE': 0, 'OFFLINE': 0},
// //     'Device 2': {'ONLINE': 0, 'OFFLINE': 0},
// //     'Device 3': {'ONLINE': 0, 'OFFLINE': 0},
// //   };
// //
// //   for (var status in deviceStatuses) {
// //     usageStats[status.deviceName]![status.status] =
// //         usageStats[status.deviceName]![status.status]! + 1;
// //   }
// //
// //   return Column(
// //     children: [
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildLegendItem(Colors.green, 'Online',),
// //           SizedBox(width: 20), // Space between the legends
// //           _buildLegendItem(Colors.red, 'Offline'),
// //         ],
// //       ),
// //       Expanded(
// //         child: BarChart(
// //           BarChartData(
// //             titlesData: FlTitlesData(
// //               bottomTitles: AxisTitles(
// //                 sideTitles: SideTitles(
// //                     showTitles: true,
// //                     getTitlesWidget: (value, _) {
// //                       switch (value.toInt()) {
// //                         case 0:
// //                           return Text('Device 1');
// //                         case 1:
// //                           return Text('Device 2');
// //                         case 2:
// //                           return Text('Device 3');
// //
// //                       }
// //                       return Text('');
// //                     }),
// //               ),
// //             ),
// //             barGroups: [
// //               BarChartGroupData(
// //                 x: 0,
// //                 barRods: [
// //                   BarChartRodData(
// //                     toY: usageStats['Device 1']!['ONLINE']!.toDouble(),
// //                     color: Colors.green,
// //                   ),
// //                   BarChartRodData(
// //                       toY: usageStats['Device 1']!['OFFLINE']!.toDouble(),
// //                       color: Colors.red),
// //                 ],
// //               ),
// //               BarChartGroupData(
// //                 x: 1,
// //                 barRods: [
// //                   BarChartRodData(
// //                       toY: usageStats['Device 2']!['ONLINE']!.toDouble(),
// //                       color: Colors.green),
// //                   BarChartRodData(
// //                       toY: usageStats['Device 2']!['OFFLINE']!.toDouble(),
// //                       color: Colors.red),
// //                 ],
// //               ),
// //               BarChartGroupData(
// //                 x: 2,
// //                 barRods: [
// //                   BarChartRodData(
// //                       toY: usageStats['Device 3']!['ONLINE']!.toDouble(),
// //                       color: Colors.green),
// //                   BarChartRodData(
// //                       toY: usageStats['Device 3']!['OFFLINE']!.toDouble(),
// //                       color: Colors.red),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     ],
// //   );
// // }
// //
// // // Histogram: Device Activity
// }
//
// // lib/models/device_status.dart
// class DeviceStatus {
//   final String deviceName;
//   final String status; // 'ONLINE' or 'OFFLINE'
//   final DateTime timestamp;
//
//   DeviceStatus(this.deviceName, this.status, this.timestamp);
// }
