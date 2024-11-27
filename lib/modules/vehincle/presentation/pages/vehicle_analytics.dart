
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../service_locator.dart';
import '../../../vehincle/domain/entities/req_entities/route_history_req_entity.dart';
import '../../../vehincle/presentation/bloc/vehicle_bloc.dart';


class VehicleAnalytics extends StatefulWidget {
  final String token, vin;
  final int? dashboardRoute;
  const VehicleAnalytics({Key? key, required this.token, required this.vin, this.dashboardRoute})
      : super(key: key);

  @override
  State<VehicleAnalytics> createState() => _VehicleAnalyticsState();
}

class _VehicleAnalyticsState extends State<VehicleAnalytics> {
  final List<String> _tabs = ["Today","Yesterday", "3 Days", "1 Week"];
  int _selectedTabIndex = 0;

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
      default:
        timeFrom = now; // Default to now (should not occur in this context)
    }

    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss'); // Date format

    return {
      "time_from": formatter.format(timeFrom),
      "time_to": formatter.format(timeTo),
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = _getDateRange(_tabs[_selectedTabIndex]);

    final List<Widget> pages = [
      TodayDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token,
          dashboardRoute: widget.dashboardRoute
      ),
      YesterdayDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token,
          dashboardRoute: widget.dashboardRoute
      ),
      ThreeDaysDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token,
          dashboardRoute: widget.dashboardRoute
      ),
      OneWeekDashboardPage(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token,
          dashboardRoute: widget.dashboardRoute
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "Analytics",
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
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
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
  final int? dashboardRoute;

  const TodayDashboardPage({
    Key? key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token, this.dashboardRoute,
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
            vehicle_vin: vin,//'1HGBH41JXMN109186',//
            time_from: timeFrom,//'2024-10-29 11:41:00',//timeFrom,
            time_to: timeFrom,//'2024-10-30 11:42:00',//timeTo,
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
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
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
}

class ThreeDaysDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo, vin, token;
  final int? dashboardRoute;

  const ThreeDaysDashboardPage({
    Key? key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token, this.dashboardRoute,
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
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
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
}

class OneWeekDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo;
  final String vin;
  final String token;
  final int? dashboardRoute;

  const OneWeekDashboardPage({
    Key? key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token, this.dashboardRoute,
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
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
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
}

class YesterdayDashboardPage extends StatelessWidget {
  final String timeFrom;
  final String timeTo, vin, token;
  final int? dashboardRoute;

  const YesterdayDashboardPage({
    Key? key,
    required this.timeFrom,
    required this.timeTo,
    required this.vin,
    required this.token, this.dashboardRoute,
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
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
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
}


class VehicleRouteDataAnalytics extends StatefulWidget {
  final List<DatumEntity> vehicles;
  final String vin;

  const VehicleRouteDataAnalytics({
    super.key,
    required this.vehicles, required this.vin,
  });

  @override
  State<VehicleRouteDataAnalytics> createState() =>
      _VehicleRouteDataAnalyticsState();
}

class _VehicleRouteDataAnalyticsState extends State<VehicleRouteDataAnalytics> {
  Analytics? analytics;

  @override
  void initState() {
    super.initState();
    // Calculate analytics metrics and update state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        analytics = Analytics.fromVehicleData(widget.vehicles);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: analytics == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('VIN: ', style: AppStyle.cardSubtitle,),
                  Text(widget.vin, style: AppStyle.cardfooter,),
                ],
              ),
              const SizedBox(height: 5.0,),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 5,
                  ),
                  const SizedBox(width: 10,),
                  Text('Online',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 14))
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 5,
                  ),
                  const SizedBox(width: 10,),
                  Text('offline',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 14))
                ],
              ),
              const SizedBox(height: 20),
              // Pie chart visualization
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        if (analytics!.onlineCount > 0)
                          PieChartSectionData(
                            value: analytics!.onlineCount.toDouble(),
                            color: Colors.green,
                            title: '${analytics!.onlineCount}',
                            radius: 100,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        if (analytics!.offlineCount > 0)
                          PieChartSectionData(
                            value: analytics!.offlineCount.toDouble(),
                            color: Colors.red,
                            title: '${analytics!.offlineCount}',
                            radius: 100,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        // Fallback for cases where both counts are zero
                        if (analytics!.onlineCount == 0 &&
                            analytics!.offlineCount == 0)
                          PieChartSectionData(
                            value: 1,
                            color: Colors.grey,
                            title: 'No Data',
                            radius: 60,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                  'Vehicle Details:',
                  style:AppStyle.cardSubtitle.copyWith(fontSize: 14)
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: widget.vehicles.length,
                  itemBuilder: (context, index) {
                    var vehicle = widget.vehicles[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title:  Text('Status: ${vehicle.connected}', style: AppStyle.cardfooter,),
                        subtitle: Text('DateTime: '+FormatData.formatTimestamp('${vehicle.created_at}'), style: AppStyle.cardfooter,),
                        trailing: Icon(
                          vehicle.connected == 'online'
                              ? Icons.check_circle
                              : Icons.remove_circle,
                          color: vehicle.connected == 'online'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class Analytics {
  final int onlineCount;
  final int offlineCount;

  Analytics({required this.onlineCount, required this.offlineCount});

  static Analytics fromVehicleData(List<DatumEntity> vehicles) {
    int onlineCount = 0;
    int offlineCount = 0;

    for (var vehicle in vehicles) {
      if (vehicle.connected == 'online') {
        onlineCount++;
      } else if (vehicle.connected == 'offline') {
        offlineCount++;
      }
    }

    return Analytics(onlineCount: onlineCount, offlineCount: offlineCount);
  }
}