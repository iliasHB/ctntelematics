import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../../../../service_locator.dart';
import '../../../vehincle/domain/entities/req_entities/route_history_req_entity.dart';
import '../../../vehincle/presentation/bloc/vehicle_bloc.dart';

class VehicleDashboard extends StatefulWidget {
  final String token, vin;
  const VehicleDashboard({Key? key, required this.token, required this.vin})
      : super(key: key);

  @override
  State<VehicleDashboard> createState() => _VehicleDashboardState();
}

class _VehicleDashboardState extends State<VehicleDashboard> {
  final List<String> _tabs = ["Today","Yesterday", "3 Days", "1 Week", "Custom"];
  int _selectedTabIndex = 0;
  DateTime? _customTimeFrom;
  DateTime? _customTimeTo;
  // Function to generate date range for analytics
  Map<String, String> _getDateRange(String tab) {
    final now = DateTime.now();
    DateTime timeFrom;
    DateTime timeTo = DateTime(
        now.year, now.month, now.day, 23, 59, 59); // End of the current day

    switch (tab) {
      case "Today":
        timeFrom =
            DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of today
        break;
      case "Yesterday":
        timeFrom = DateTime(now.year, now.month, now.day, 0, 0, 0).subtract(const Duration(days: 1)); // Start of yesterday
        timeTo = DateTime(now.year, now.month, now.day, 23, 59, 59).subtract(const Duration(days: 1)); // End of yesterday
        break;
      case "3 Days":
        timeFrom = now.subtract(const Duration(days: 3)); // 3 days ago
        break;
      case "1 Week":
        timeFrom = now.subtract(const Duration(days: 7)); // 7 days ago
        break;
      case "Custom":
        timeFrom = _customTimeFrom ?? now.subtract(const Duration(days: 1));
        timeTo = _customTimeTo ?? now;
        break;
      default:
        timeFrom = now; // Default to now (should not occur in this context)
    }

    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss'); // Date format

    return {
      "time_from": formatter.format(timeFrom),
      "time_to": formatter.format(timeTo),
    };
  }

  _pickCustomDateRange() async {
    DateTime? customTimeFrom;
    DateTime? customTimeTo;

    // Pick Start DateTime
    await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        customTimeFrom = date;
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );

    if (customTimeFrom != null) {
      // Pick End DateTime
      await DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        minTime: customTimeFrom,
        maxTime: DateTime.now(),
        onConfirm: (date) {
          customTimeTo = date;
        },
        currentTime: customTimeFrom,
        locale: LocaleType.en,
      );
    }

    if (customTimeFrom != null && customTimeTo != null) {
      setState(() {
        _customTimeFrom = customTimeFrom!;
        _customTimeTo = customTimeTo!;
        _selectedTabIndex = _tabs.indexOf("Custom");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = _getDateRange(_tabs[_selectedTabIndex]);

    final List<Widget> pages = [
      TodayDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token),
      YesterdayDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token),
      ThreeDaysDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token),
      OneWeekDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token),
      FilterByDateTime(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tab Selection (Chips)
          SizedBox(
            height: 50.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (_tabs[index] == "Custom") {
                      await _pickCustomDateRange(); // Ensure the custom picker is invoked
                    } else {
                      setState(() {
                        _selectedTabIndex = index; // Set other tabs as usual
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      side: BorderSide.none,
                      backgroundColor: _selectedTabIndex == index
                          ? Colors.green
                          : Colors.grey.shade200,
                      label: Text(
                        _tabs[index],
                        style: TextStyle(
                          color: _selectedTabIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Display selected page
          Expanded(
            child: pages[_selectedTabIndex],
          ),
        ],
      ),
    );
  }
}

class TodayDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo, vin, token;

  const TodayDashboardPage({
    Key? key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final routeHistoryReqEntity = VehicleRouteHistoryReqEntity(
    //     vehicle_vin: widget.vin!,
    //     time_from:
    //     fromDate.toString().split('.').first ?? "N/A",
    //     time_to: toDate.toString().split('.').first ?? "N/A",
    //     token: widget.token!);

    return BlocProvider(
      create: (_) => sl<VehicleRouteHistoryBloc>()
        ..add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
            vehicle_vin: vin,
            time_from: timeFrom,
            time_to: timeTo,
            token: token))),
      child: BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
        builder: (context, state) {
          print('vin- : $vin');
          print('timeFrom- : $timeFrom');
          print('timeTo- : $timeTo');
          print('token- : $token');
          if (state is VehicleLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.green,),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return DashboardVehicleRouteData(vehicle: state.resp);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
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
}

class ThreeDaysDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo, vin, token;

  const ThreeDaysDashboardPage({
    Key? key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VehicleRouteHistoryBloc>()
        ..add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
            vehicle_vin: vin,
            time_from: timeFrom,
            time_to: timeTo,
            token: token))),
      child: BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
        builder: (context, state) {
          print('vin- : $vin');
          print('timeFrom- : $timeFrom');
          print('timeTo- : $timeTo');
          print('token- : $token');
          if (state is VehicleLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.green,),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return DashboardVehicleRouteData(vehicle: state.resp);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
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
}

class OneWeekDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo;
  final String vin;
  final String token;

  const OneWeekDashboardPage({
    super.key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VehicleRouteHistoryBloc>()
        ..add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
            vehicle_vin: vin,
            time_from: timeFrom,
            time_to: timeTo,
            token: token))),
      child: BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
        builder: (context, state) {
          print('vin- : $vin');
          print('timeFrom- : $timeFrom');
          print('timeTo- : $timeTo');
          print('token- : $token');
          if (state is VehicleLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.green,),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return DashboardVehicleRouteData(vehicle: state.resp);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
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
}

class YesterdayDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo, vin, token;

  const YesterdayDashboardPage({
    super.key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VehicleRouteHistoryBloc>()
        ..add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
            vehicle_vin: vin,
            time_from: timeFrom,
            time_to: timeTo,
            token: token))),
      child: BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
        builder: (context, state) {
          print('vin- : $vin');
          print('timeFrom- : $timeFrom');
          print('timeTo- : $timeTo');
          print('token- : $token');
          if (state is VehicleLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.green,),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return DashboardVehicleRouteData(vehicle: state.resp);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
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
}


class FilterByDateTime extends StatelessWidget {
  final String timeFrom;
  final String timeTo;
  final String vin;
  final String token;

  const FilterByDateTime({
    super.key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VehicleRouteHistoryBloc>()
        ..add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
            vehicle_vin: vin,
            time_from: timeFrom,
            time_to: timeTo,
            token: token))),
      child: BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
        builder: (context, state) {
          print('vin- : $vin');
          print('timeFrom- : $timeFrom');
          print('timeTo- : $timeTo');
          print('token- : $token');
          if (state is VehicleLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.green,),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return DashboardVehicleRouteData(vehicle: state.resp);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
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
}

class GpsProcessor {

  static Map<String, dynamic> calculateMetrics(List<DatumEntity> gpsData) {
    if (gpsData.isEmpty) {
      return {
        'routeStart': 0,
        'routeEnd': 0,
        'moveDuration': 0,
        'stopDuration': 0,
        'maxSpeed': 0.0,
        'averageSpeed': 0.0,
        'stopCount': 0,
      };
    }

    // Filter out stationary data (speed == 0)
    List<DatumEntity> movingData = gpsData.where((data) {
      final speed = double.tryParse(data.speed) ?? 0.0;
      return speed > 0.0;
    }).toList();

    if (movingData.isEmpty) {
      return {
        'routeStart': gpsData.first.created_at,
        'routeEnd': gpsData.last.created_at,
        'moveDuration': 0.0,
        'stopDuration': 0.0,
        'maxSpeed': 0.0,
        'averageSpeed': 0.0,
        'stopCount': gpsData.length,
      };
    }

    // Calculate route start and end
    DateTime routeStart =  DateTime.parse(movingData.first.fix_time);//movingData.first.created_at;
    DateTime routeEnd =  DateTime.parse(movingData.last.fix_time);//movingData.last.created_at;
    Duration moveDuration = routeEnd.difference(routeStart);

    // Maximum speed and average speed
    double maxSpeed = movingData
        .map((data) => double.tryParse(data.speed) ?? 0.0)
        .reduce((a, b) => a > b ? a : b);

    double averageSpeed = movingData
        .map((data) => double.tryParse(data.speed) ?? 0.0)
        .reduce((a, b) => a + b) /
        movingData.length;

    // Count stops and total stop duration
    int stopCount = gpsData.length - movingData.length;
    Duration totalStopDuration = _calculateStopDuration(gpsData);

    return {
      'routeStart': routeStart.toString(),
      'routeEnd': routeEnd.toString(),
      'moveDuration': moveDuration.inMinutes,
      'stopDuration': totalStopDuration.inMinutes,
      'maxSpeed': maxSpeed,
      'averageSpeed': averageSpeed,
      'stopCount': stopCount,
    };
  }

  static Duration _calculateStopDuration(List<DatumEntity> gpsData) {
    Duration totalStopDuration = Duration.zero;
    DateTime? stopStartTime;

    for (int i = 0; i < gpsData.length; i++) {
      final speed = double.tryParse(gpsData[i].speed) ?? 0.0;

      // Parse created_at as DateTime
      final createdAt = DateTime.tryParse(gpsData[i].fix_time);
      if (createdAt == null) {
        throw FormatException('Invalid date format in created_at: ${gpsData[i].fix_time}');
      }

      if (speed == 0.0) {
        // Start tracking stop time if not already tracking
        if (stopStartTime == null) {
          stopStartTime = createdAt;
        }
      } else {
        // If a stop period ends, calculate the duration
        if (stopStartTime != null) {
          totalStopDuration += createdAt.difference(stopStartTime);
          stopStartTime = null; // Reset stop start time
        }
      }
    }

    // If the last entry is a stop, add its duration
    if (stopStartTime != null) {
      final lastCreatedAt = DateTime.tryParse(gpsData.last.fix_time);
      if (lastCreatedAt == null) {
        throw FormatException('Invalid date format in last created_at: ${gpsData.last.fix_time}');
      }
      totalStopDuration += lastCreatedAt.difference(stopStartTime);
    }

    return totalStopDuration;
  }


// static Duration _calculateStopDuration(List<DatumEntity> gpsData) {
  //   Duration totalStopDuration = Duration.zero;
  //
  //   DateTime? stopStartTime;
  //
  //   for (int i = 0; i < gpsData.length; i++) {
  //     final speed = double.tryParse(gpsData[i].speed) ?? 0.0;
  //
  //     if (speed == 0.0) {
  //       // Start tracking stop time if not already tracking
  //       if (stopStartTime == null) {
  //         stopStartTime = gpsData[i].created_at;
  //       }
  //     } else {
  //       // If a stop period ends, calculate the duration
  //       if (stopStartTime != null) {
  //         totalStopDuration += gpsData[i].created_at.difference(stopStartTime);
  //         stopStartTime = null; // Reset stop start time
  //       }
  //     }
  //   }
  //
  //   // If the last entry is a stop, add its duration
  //   if (stopStartTime != null) {
  //     totalStopDuration += gpsData.last.created_at.difference(stopStartTime);
  //   }
  //
  //   return totalStopDuration;
  // }
}

class DashboardVehicleRouteData extends StatefulWidget {
  final VehicleRouteHistoryRespEntity vehicle;

  const DashboardVehicleRouteData({super.key, required this.vehicle});

  @override
  State<DashboardVehicleRouteData> createState() =>
      _DashboardVehicleRouteDataState();
}

class _DashboardVehicleRouteDataState extends State<DashboardVehicleRouteData> {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          mainAxisSpacing: 10, // Adjust spacing between grid items
          crossAxisSpacing: 5, // Adjust spacing between grid items
          childAspectRatio:
              1.5, // Adjust the aspect ratio if necessary to avoid overflow
          children: [
            // Route Start
            _buildMetricCard(
              title: "Route Start",
              value: metrics['routeStart'] != null
                  ? FormatData.formatTimestamp(metrics['routeStart'])
                  : "N/A",
              icon: Icon(
                Icons.route,
                color: Colors.green.shade300,
              ),
            ),

            // Route End
            _buildMetricCard(
              title: "Route End",
              value: metrics['routeEnd'] != null
                  ? FormatData.formatTimestamp(metrics['routeEnd'])
                  : "N/A",
              icon: Icon(
                Icons.route,
                color: Colors.red.shade300,
              ),
            ),

            // Move Duration
            _buildMetricCard(
              title: "Route Length",
              value: widget.vehicle.routeLength != null
                  ? "${widget.vehicle.routeLength?.toStringAsFixed(2)} km"
                  : "N/A",
              icon: Icon(
                Icons.route,
                color: Colors.green.shade300,
              ),
            ),

            // Move Duration
            _buildMetricCard(
              title: "Move Duration",
              value: metrics['moveDuration'] != null
                  ? "${metrics['moveDuration']} mins"
                  : "N/A",
              icon: Icon(
                Icons.av_timer_rounded,
                color: Colors.green.shade300,
              ),
            ),

            // Stop Duration
            _buildMetricCard(
              title: "Stop Duration",
              value: metrics['stopDuration'] != null
                  ? "${metrics['stopDuration']} mins"
                  : "N/A",
              icon: Icon(
                Icons.av_timer_rounded,
                color: Colors.red.shade300,
              ),
            ),
            // Max Speed
            _buildMetricCard(
              title: "Max Speed",
              value: metrics['maxSpeed'] != null
                  ? "${metrics['maxSpeed'].toStringAsFixed(2)} km/h"
                  : "N/A",
              icon: Icon(
                Icons.route,
                color: Colors.green.shade300,
              ),
            ),

            // Stop Count
            _buildMetricCard(
              title: "Stops",
              value: metrics['stopCount']?.toString() ?? "0",
              icon: Icon(
                Icons.hexagon,
                color: Colors.green.shade300,
              ),
            ),
            // Average Speed
            _buildMetricCard(
              title: "Avg Speed",
              value: metrics['averageSpeed'] != null
                  ? "${metrics['averageSpeed'].toStringAsFixed(2)} km/h"
                  : "N/A",
              icon: Icon(
                Icons.timer,
                color: Colors.green.shade300,
              ),
            ),

            // // Average Speed
            // _buildMetricCard(
            //   title: "Over Speeds",
            //   value: metrics['averageSpeed'] != null
            //       ? "${metrics['averageSpeed']} km/h"
            //       : "N/A",
            //   icon: Icon(
            //     Icons.access_time,
            //     color: Colors.green.shade300,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      {required String title, required String value, required Icon icon}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: icon,
                  ),
                ),
                Text(
                  title,
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(value, style: AppStyle.cardfooter.copyWith(fontSize: 12))
              ],
            ),
          ],
        ),
      ),
    );
  }
}






// Page for "Today" analytics
// class TodayRouteHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GridView.count(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         crossAxisCount: 2,
//         mainAxisSpacing: 10, // Adjust spacing between grid items
//         crossAxisSpacing: 5,
//         childAspectRatio: 2.0, //
//         children: [
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Route Start",
//                         style: AppStyle.cardSubtitle.copyWith(fontSize: 14)
//                       ),
//                       Text(
//                         "2024-09-17",
//                         style: AppStyle.cardfooter,
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "00:18:24",
//                         style: AppStyle.cardfooter,
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.route,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Route End",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "2024-09-17",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "00:18:24",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.route,
//                     color: Colors.red.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Route Length",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "20km",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.route,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Move Duration",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "20min 40s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.av_timer_rounded,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Stop Duration",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "11hr 20min 40s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "00:18:24",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.av_timer_rounded,
//                     color: Colors.red.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Stop Count",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "3",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.hexagon,
//                     color: Colors.red.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Top Speed",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "60kph",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.timer,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Average speed",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "30 kph",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.timer_outlined,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Overspeed\nCount",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "60kph",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.access_time,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Fuel\nConsumption",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "0 liters",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.heat_pump_outlined,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Avg. fuel\nConsumption",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "0 liters",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.heat_pump_outlined,
//                     color: Colors.red.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Fuel cost",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "0 USD",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.monetization_on,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Engine Work",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.heat_pump_outlined,
//                     color: Colors.red.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Engine Idle",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.block_sharp,
//                     color: Colors.red.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Odometer",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.timelapse,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Engine hour",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text(
//                         "0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.access_alarms,
//                     color: Colors.green.shade300,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

///---
// class DashboardVehicleRouteData extends StatefulWidget {
// final VehicleRouteHistoryRespEntity vehicle;
//   const DashboardVehicleRouteData({super.key, required this.vehicle,});
//
//   @override
//   State<DashboardVehicleRouteData> createState() => _DashboardVehicleRouteDataState();
// }
//
// class _DashboardVehicleRouteDataState extends State<DashboardVehicleRouteData> {
//   Map<String, dynamic> metrics = {};
//   @override
//   void initState() {
//     super.initState();
//     loadGpsData();
//   }
//
//
//   // Sample data loading function (replace with actual GPS data retrieval)
//   void loadGpsData() {
//     setState(() {
//       metrics = GpsProcessor.calculateMetrics(widget.vehicle.data);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("hhhhhhhhhh------ ${widget.vehicle.data.length}");
//     return Expanded(
//       child: GridView.count(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         crossAxisCount: 2,
//         mainAxisSpacing: 10, // Adjust spacing between grid items
//         crossAxisSpacing: 5,
//         childAspectRatio: 2.0, //
//         children:  [
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Route Start", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text(metrics['routeStart'],
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       // Text("00:18:24",
//                       //   softWrap: true,
//                       //   overflow: TextOverflow.ellipsis,
//                       //   maxLines: 2,
//                       // ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.route,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
///------
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Route End",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text(metrics['routeEnd'],
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       // Text("00:18:24",
//                       //   softWrap: true,
//                       //   overflow: TextOverflow.ellipsis,
//                       //   maxLines: 2,
//                       // ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.route,
//                     color: Colors.red.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Route Length", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("20km",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.route,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Move Duration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("20min 40s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.av_timer_rounded,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Stop Duration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("11hr 20min 40s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text("00:18:24",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.av_timer_rounded,
//                     color: Colors.red.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Stop Count", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("3",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.hexagon,
//                     color: Colors.red.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Top Speed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("60kph",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.timer,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Average speed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("30 kph",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.timer_outlined,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Overspeed\nCount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("60kph",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.access_time,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
///
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Fuel\nConsumption",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text("0 liters",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.heat_pump_outlined,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
//
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Avg. fuel\nConsumption", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("0 liters",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.heat_pump_outlined,
//                     color: Colors.red.shade300,),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Fuel cost",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text("0 USD",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.monetization_on,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
//
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Engine Work", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.heat_pump_outlined,
//                     color: Colors.red.shade300,),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Engine Idle",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text("0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.block_sharp,
//                     color: Colors.red.shade300,),
//                 )
//               ],
//             ),
//           ),
//
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Odometer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                       Text("0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.timelapse,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Engine hour",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                       Text("0s",
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.access_alarms,
//                     color: Colors.green.shade300,),
//                 )
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }
