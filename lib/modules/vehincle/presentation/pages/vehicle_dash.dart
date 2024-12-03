import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../../../map/presentation/widgets/vehicle_dashboard.dart';


class VehicleDashboard extends StatefulWidget {
  final String token, vin;
  const VehicleDashboard({super.key, required this.token, required this.vin});

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


  // _pickCustomDateRange() async {
  //   final pickedFrom = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //
  //   if (pickedFrom != null) {
  //     final pickedTo = await showDatePicker(
  //       context: context,
  //       initialDate: pickedFrom,
  //       firstDate: pickedFrom,
  //       lastDate: DateTime.now(),
  //     );
  //
  //     if (pickedTo != null) {
  //       setState(() {
  //         _customTimeFrom = pickedFrom;
  //         _customTimeTo = pickedTo;
  //         _selectedTabIndex = 4; // Switch to Custom tab
  //       });
  //     }
  //   }
  // }

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
        title: Row(
          children: [
            Text(
              "Dashboard",
              style: AppStyle.cardSubtitle.copyWith(fontSize: 16)
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
                  // onTap: () {
                  //   setState(() {
                  //     _selectedTabIndex = index;
                  //   });
                  // },

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
