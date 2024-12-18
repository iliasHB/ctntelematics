
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/widgets/custom_button.dart';
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
      FilterByDateTime(
          timeFrom: dateRange["time_from"]!,
          timeTo: dateRange["time_to"]!,
          vin: widget.vin,
          token: widget.token),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Analytics",
              style: AppStyle.cardSubtitle
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
          print('today_vin- : $vin');
          print('today_timeFrom- : $timeFrom');
          print('today_timeTo- : $timeTo');
          print('today_token- : $token');
          if (state is VehicleLoading) {
            return const Center(
              child: CustomContainerLoadingButton()
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Unable to fetch data, Please try again", style: AppStyle.cardfooter.copyWith(fontSize: 12),),
                SizedBox(height: 10,),
                CustomSecondaryButton(
                    label: 'Refresh',
                    onPressed: () {
                      BlocProvider.of<VehicleRouteHistoryBloc>(context)
                          .add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
                          vehicle_vin: vin,//'1HGBH41JXMN109186',//vin,
                          time_from: timeFrom,//'2024-10-29 11:41:00',//timeFrom,
                          time_to: timeTo,//'2024-10-30 11:42:00',//timeTo,
                          token: token)));
                    }),
              ],
            );
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
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
              child: CustomContainerLoadingButton()
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Unable to fetch data, Please try again", style: AppStyle.cardfooter.copyWith(fontSize: 12),),
                SizedBox(height: 10,),
                CustomSecondaryButton(
                    label: 'Refresh',
                    onPressed: () {
                      BlocProvider.of<VehicleRouteHistoryBloc>(context)
                          .add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
                          vehicle_vin: vin,//'1HGBH41JXMN109186',//vin,
                          time_from: timeFrom,//'2024-10-29 11:41:00',//timeFrom,
                          time_to: timeTo,//'2024-10-30 11:42:00',//timeTo,
                          token: token)));
                    }),
              ],
            );
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
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
              child:CustomContainerLoadingButton()
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Unable to fetch data, Please try again", style: AppStyle.cardfooter.copyWith(fontSize: 12),),
                SizedBox(height: 10,),
                CustomSecondaryButton(
                    label: 'Refresh',
                    onPressed: () {
                      BlocProvider.of<VehicleRouteHistoryBloc>(context)
                          .add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
                          vehicle_vin: vin,//'1HGBH41JXMN109186',//vin,
                          time_from: timeFrom,//'2024-10-29 11:41:00',//timeFrom,
                          time_to: timeTo,//'2024-10-30 11:42:00',//timeTo,
                          token: token)));
                    }),
              ],
            );
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
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
              child: CustomContainerLoadingButton()
            );
          } else if (state is GetVehicleRouteHistoryDone) {
            return VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Unable to fetch data, Please try again", style: AppStyle.cardfooter.copyWith(fontSize: 12),),
                SizedBox(height: 10,),
                CustomSecondaryButton(
                    label: 'Refresh',
                    onPressed: () {
                      BlocProvider.of<VehicleRouteHistoryBloc>(context)
                          .add(VehicleRouteHistoryEvent(VehicleRouteHistoryReqEntity(
                          vehicle_vin: vin,//'1HGBH41JXMN109186',//vin,
                          time_from: timeFrom,//'2024-10-29 11:41:00',//timeFrom,
                          time_to: timeTo,//'2024-10-30 11:42:00',//timeTo,
                          token: token)));
                    }),
              ],
            );
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
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
            return  VehicleRouteDataAnalytics(vehicles: state.resp.data, vin: vin,);
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is VehicleFailure) {
            if (state.message.contains("Unauthenticated")) {
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
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
            ? const Center(child: CustomContainerLoadingButton())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('VIN: ', style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                Text(widget.vin, style: AppStyle.cardfooter),
              ],
            ),
            const SizedBox(height: 5.0,),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 5,
                ),
                const SizedBox(width: 10,),
                Text('Offline ',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                Text('(${analytics!.offlinePercentage.toStringAsFixed(1)}%)',
                    style: AppStyle.cardfooter.copyWith(fontSize: 14))
              ],
            ),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 5,
                ),
                const SizedBox(width: 10,),
                Text('Moving ',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                Text('(${analytics!.movingPercentage.toStringAsFixed(1)}%)',
                    style: AppStyle.cardfooter.copyWith(fontSize: 14))
              ],
            ),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 5,
                ),
                const SizedBox(width: 10,),
                Text('Parked ',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                Text('(${analytics!.parkedPercentage.toStringAsFixed(1)}%)',
                    style: AppStyle.cardfooter.copyWith(fontSize: 14))
              ],
            ),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 5,
                ),
                const SizedBox(width: 10,),
                Text('Idle ',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                Text('(${analytics!.idlePercentage.toStringAsFixed(1)}%)',
                    style: AppStyle.cardfooter.copyWith(fontSize: 14))
              ],
            ),

            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      if (analytics!.idleCount > 0)
                        PieChartSectionData(
                          value: analytics!.idlePercentage,
                          color: Colors.yellow,
                          title: '',//'${analytics!.idlePercentage.toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      if (analytics!.offlineCount > 0)
                        PieChartSectionData(
                          value: analytics!.offlinePercentage,
                          color: Colors.red,
                          title: "",//'${analytics!.offlinePercentage.toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      if (analytics!.movingCount > 0)
                        PieChartSectionData(
                          value: analytics!.movingPercentage,
                          color: Colors.green,
                          title: '',//'${analytics!.movingPercentage.toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      if (analytics!.parkedCount > 0)
                        PieChartSectionData(
                          value: analytics!.parkedPercentage,
                          color: Colors.blueGrey,
                          title: '',//'${analytics!.parkedPercentage.toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      // Fallback for cases where all counts are zero
                      if (analytics!.idleCount == 0 &&
                          analytics!.offlineCount == 0 &&
                          analytics!.movingCount == 0 &&
                          analytics!.parkedCount == 0)
                        PieChartSectionData(
                          value: 1,
                          color: Colors.grey,
                          title: 'No Data',
                          radius: 60,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Analysis Details:',
              style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 10),
            // Use Flexible or define a height for the ListView.builder
            Flexible(
              child: ListView.builder(
                itemCount: widget.vehicles.length,
                itemBuilder: (context, index) {
                  var vehicle = widget.vehicles[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Status: ${vehicle.status.toString().toLowerCase() ?? "N/A"}',
                        style: AppStyle.cardfooter,
                      ),
                      subtitle: Text(
                        'DateTime: ${FormatData.formatTimestamp(
                                '${vehicle.fix_time ?? vehicle.updated_at}')}',
                        style: AppStyle.cardfooter,
                      ),
                      trailing: Icon(
                        vehicle.status.toString().toLowerCase() == 'moving'
                            || vehicle.status.toString().toLowerCase() == 'parked'
                            || vehicle.status.toString().toLowerCase() == 'idling'
                            || vehicle.status.toString().toLowerCase() == 'offline'
                            ? Icons.check_circle
                            : Icons.remove_circle,
                        color: vehicle.status.toString().toLowerCase() == 'moving'
                            ? Colors.green
                            : vehicle.status.toString().toLowerCase() == 'parked'
                            ? Colors.blueGrey
                            : vehicle.status.toString().toLowerCase() == 'idling'
                            ? Colors.yellow
                            : vehicle.status.toString().toLowerCase() == 'offline'
                            ? Colors.red : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}


class Analytics {
  final int idleCount;
  final int offlineCount;
  final int movingCount;
  final int parkedCount;

  Analytics({
    required this.idleCount,
    required this.offlineCount,
    required this.movingCount,
    required this.parkedCount,
  });

  int get totalCount => idleCount + offlineCount + movingCount + parkedCount;

  double get idlePercentage => totalCount > 0 ? (idleCount / totalCount) * 100 : 0;
  double get offlinePercentage => totalCount > 0 ? (offlineCount / totalCount) * 100 : 0;
  double get movingPercentage => totalCount > 0 ? (movingCount / totalCount) * 100 : 0;
  double get parkedPercentage => totalCount > 0 ? (parkedCount / totalCount) * 100 : 0;

  static Analytics fromVehicleData(List<DatumEntity> vehicles) {
    int idleCount = 0;
    int offlineCount = 0;
    int movingCount = 0;
    int parkedCount = 0;

    for (var vehicle in vehicles) {
      switch (vehicle.status.toString().toLowerCase()) {
        case 'idling':
          idleCount++;
          break;
        case 'offline':
          offlineCount++;
          break;
        case 'moving':
          movingCount++;
          break;
        case 'parked':
          parkedCount++;
          break;
        default:
          break;
      }
    }

    return Analytics(
      idleCount: idleCount,
      offlineCount: offlineCount,
      movingCount: movingCount,
      parkedCount: parkedCount,
    );
  }
}

// class Analytics {
//   final int onlineCount;
//   final int offlineCount;
//
//   Analytics({required this.onlineCount, required this.offlineCount});
//
//   static Analytics fromVehicleData(List<DatumEntity> vehicles) {
//     int onlineCount = 0;
//     int offlineCount = 0;
//
//
//     for (var vehicle in vehicles) {
//       print('fffffffff: ${vehicle.connected}');
//       if (vehicle.connected == 'online' || vehicle.connected == 'Online') {
//         onlineCount++;
//       } else if (vehicle.connected == 'offline' || vehicle.connected == 'Offline') {
//         offlineCount++;
//       }
//     }
//
//     return Analytics(onlineCount: onlineCount, offlineCount: offlineCount);
//   }
// }