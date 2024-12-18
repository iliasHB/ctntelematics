import 'package:ctntelematics/modules/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/pages/report_page.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/req_entities/route_history_req_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/utils/math_util.dart';
import '../../../../core/utils/pref_util.dart';
import '../../../../core/widgets/alert_message.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../service_locator.dart';
import '../../../dashboard/domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../../../vehincle/presentation/bloc/vehicle_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../pages/route_history_report.dart';

class Report extends StatefulWidget {
  final String? token;
  const Report({super.key, this.token});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final _formKey = GlobalKey<FormState>();
  PrefUtils prefUtils = PrefUtils();
  String? _selectedVendor;
  final TextEditingController _reportTypeController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController timeReminderAdvController =
      TextEditingController();
  final TextEditingController engineHrController = TextEditingController();
  final TextEditingController engineHrReminderAdvController =
      TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController mileageReminderAdvController =
      TextEditingController();
  final TextEditingController _taskController = TextEditingController();

  // Example data for dropdown
  final List<Map<String, String>> reportType = [
    {"value": "Vehicle trip", "label": "Vehicle trip"},
    {"value": "Route history", "label": "Route history"},
    {"value": "Maintenance", "label": "Maintenance"},
  ];
  String? _selectedReportType; // Holds the selected vehicle value
  @override
  Widget build(BuildContext context) {
    // final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report',
          style: AppStyle.cardSubtitle,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input
                Text('Report Type', style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedReportType,
                  items: reportType.map((vehicle) {
                    return DropdownMenuItem<String>(
                      value: vehicle["value"],
                      child: Text(vehicle["label"]!,
                          style: AppStyle.cardfooter // Adjust your style here
                          ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReportType = value; // Update the selected vehicle
                    });
                    // Add any additional logic like fetching data for selected vehicle
                  },
                  decoration: InputDecoration(
                    labelText: 'Choose service type',
                    labelStyle: AppStyle.cardfooter,
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                      prefixIcon: const Icon(CupertinoIcons.selection_pin_in_out, color: Colors.green,)
                  ),
                ),
                const SizedBox(height: 16),
                // Choose Vehicle dropdown
                Text('Choose Vehicle',
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                BlocProvider(
                  create: (_) => sl<ProfileVehiclesBloc>()
                    ..add(ProfileVehicleEvent(TokenReqEntity(
                        token: widget.token ?? "",
                        contentType: 'application/json'))),
                  child: BlocConsumer<ProfileVehiclesBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const CustomContainerLoadingButton();
                      } else if (state is GetVehicleDone) {
                        // Check if vehicle data is null or empty
                        if (state.resp.data == null ||
                            state.resp.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No vehicles available',
                              style: AppStyle.cardfooter,
                            ),
                          );
                        }

                        return DropdownButtonFormField<String>(
                          value: _selectedVendor ??=
                              state.resp.data!.first.vin ??
                                  "Unknown VIN", // Default to the first VIN
                          items: state.resp.data!
                              .map<DropdownMenuItem<String>>((vehicle) {
                            return DropdownMenuItem<String>(
                              value: vehicle.vin, // Pass the VIN to the API
                              child: Text(
                                "${vehicle.brand} ${vehicle.model ?? "Unknown Brand"}", // Display the brand
                                style:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedVendor = value; // Update selected VIN
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Choose vehicle',
                            labelStyle: AppStyle.cardfooter,
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            prefixIcon: const Icon(CupertinoIcons.car_detailed, color: Colors.green,)
                          ),
                        );
                      } else {
                        return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Unable to load vehicles',
                                  style: AppStyle.cardfooter.copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                IconButton(
                                    onPressed: () {
                                      BlocProvider.of<ProfileVehiclesBloc>(context)
                                          .add(ProfileVehicleEvent(TokenReqEntity(
                                          token: widget.token ?? "",
                                          contentType: 'application/json')));
                                    },
                                    icon: const Icon(Icons.refresh, color: Colors.green,))
                                // CustomSecondaryButton(
                                //     label: 'Refresh',
                                //     onPressed: () {
                                //       BlocProvider.of<ProfileVehiclesBloc>(context)
                                //           .add(ProfileVehicleEvent(TokenReqEntity(
                                //           token: widget.token ?? "",
                                //           contentType: 'application/json')));
                                //     })
                              ],
                            ));
                      }
                    },
                    listener: (context, state) async {
                      if (state is ProfileFailure) {
                        await prefUtils.clearPreferencesData();
                        if(state.message.contains('Unauthenticated')){
                          Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 8),
                _selectedReportType != "Route history"
                    ? Container()
                    : DateTimeRangePicker(
                        vin: _selectedVendor,
                        token: widget.token,),

                const SizedBox(
                  height: 10,
                ),
                _selectedReportType == "Vehicle trip" &&
                        _selectedReportType != "Route history"
                    ? BlocConsumer<VehicleTripBloc, DashboardState>(
                        listener: (context, state) {
                          if (state is VehicleTripDone) {
                            // Filter the reports based on the selected VIN
                            final filteredReports = state.resp
                                .where((report) =>
                                    report.vehicleVin == _selectedVendor)
                                .toList();

                            // Check if filteredReports is empty
                            if (filteredReports.isEmpty) {
                              AlertMessage.showAlertMessageModal(
                                  context, 'No trip found for this vehicle');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "No trip found for this vehicle")),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ReportPage(report: filteredReports),
                                ),
                              );
                            }
                          } else if (state is DashboardFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is DashboardLoading) {
                            return Center(child: const CustomLoadingButton());
                          }
                          return Align(
                            alignment: Alignment.center,
                            child: CustomPrimaryButton(
                                label:  'View Report',
                                onPressed: (){
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final dashVehicleReqEntity =
                                    DashVehicleReqEntity(
                                      token: widget.token ?? "",
                                      contentType:
                                      'application/json', // Include the selected VIN
                                    );
                                    context.read<VehicleTripBloc>().add(
                                        DashVehicleEvent(dashVehicleReqEntity));
                                  }
                                }
                            )
                          );
                        },
                      )
                    : _selectedReportType != "Route history"
                        ? BlocConsumer<GetScheduleBloc, ProfileState>(
                            listener: (context, state) {
                              if (state is GetScheduleDone) {
                                // Filter the reports based on the selected VIN
                                final filteredReports = state.resp.data
                                    .where((report) =>
                                        report.vin == _selectedVendor)
                                    .toList();

                                // Check if filteredReports is empty
                                if (filteredReports.isEmpty) {
                                  AlertMessage.showAlertMessageModal(context,
                                      'No service found for this vehicle');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "No service found for this vehicle")),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MaintenanceReport(
                                          report: filteredReports),
                                    ),
                                  );
                                }
                              } else if (state is ProfileFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is ProfileLoading) {
                                return Center(child: const CustomLoadingButton());
                              }
                              return Align(
                                alignment: Alignment.center,
                                child: CustomPrimaryButton(
                                    label: 'View Report',
                                    onPressed: (){
                                          if (_formKey.currentState?.validate() ??
                                              false) {
                                            final getSchedule = TokenReqEntity(
                                                token: widget.token ?? "");
                                            context
                                                .read<GetScheduleBloc>()
                                                .add(GetScheduleEvent(getSchedule));
                                          }
                                    })
                              );
                            },
                          )
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeRangePicker extends StatefulWidget {
  final String? vin, token;
  const DateTimeRangePicker(
      {super.key, required this.vin, required this.token});
  @override
  _DateTimeRangePickerState createState() => _DateTimeRangePickerState();
}

class _DateTimeRangePickerState extends State<DateTimeRangePicker> {
  DateTime? fromDate;
  DateTime? toDate;

  void _setDateRange(int daysAgo) {
    final now = DateTime.now();
    setState(() {
      fromDate = DateTime(now.year, now.month, now.day - daysAgo, 0, 0, 0);
      toDate = DateTime(now.year, now.month, now.day - daysAgo, 23, 59, 59);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From: ',
                    style: AppStyle.cardTitle.copyWith(fontSize: 14),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            // enabled: false,
                            prefixIcon: Icon(CupertinoIcons.calendar, color: Colors.green,),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintStyle: AppStyle.cardfooter,
                            hintText:
                              fromDate == null
                                  ? 'Select Start Date and Time'
                                  : fromDate.toString(),


                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onTap: () {
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) {
                                setState(() {
                                  fromDate = date;
                                });
                              },
                              currentTime: DateTime.now(),
                            );
                          },
                        ),
                      )),
                      const SizedBox(width: 5),
                      // InkWell(
                      //     onTap: () {
                      //       DatePicker.showDateTimePicker(
                      //         context,
                      //         showTitleActions: true,
                      //         onConfirm: (date) {
                      //           setState(() {
                      //             fromDate = date;
                      //           });
                      //         },
                      //         currentTime: DateTime.now(),
                      //       );
                      //     },
                      //     child: const Icon(
                      //       Icons.calendar_month,
                      //       color: Colors.green,
                      //     ))
                    ],
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To: ',
                        style: AppStyle.cardTitle.copyWith(fontSize: 14),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: PopupMenuButton(
                              icon: const Icon(Icons.filter_alt, color: Colors.green,),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    _setDateRange(1); // Yesterday
                                  },
                                  child: const Text("Yesterday"),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  onTap: () {
                                    _setDateRange(2); // 2 days ago
                                  },
                                  child: const Text("2 days ago"),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  onTap: () {
                                    _setDateRange(3); // 3 days ago
                                  },
                                  child: const Text("3 days ago"),
                                ),
                              ]),
                        ),
                      ),
                      //const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            // enabled: false,
                            prefixIcon: Icon(CupertinoIcons.calendar, color: Colors.green,),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintStyle: AppStyle.cardfooter,
                            hintText:
                            // Text(
                              toDate == null
                                  ? 'Select End Date and Time'
                                  : toDate.toString(),
                            // ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onTap: (){
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) {
                                setState(() {
                                  toDate = date;
                                });
                              },
                              currentTime: DateTime.now(),
                            );
                          },
                        ),
                      )),
                      // const SizedBox(width: 5),
                      // InkWell(
                      //     onTap: () {
                      //       DatePicker.showDateTimePicker(
                      //         context,
                      //         showTitleActions: true,
                      //         onConfirm: (date) {
                      //           setState(() {
                      //             toDate = date;
                      //           });
                      //         },
                      //         currentTime: DateTime.now(),
                      //       );
                      //     },
                      //     child: const Icon(
                      //       Icons.calendar_month,
                      //       color: Colors.green,
                      //     ))
                    ],
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 20),
          BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
            listener: (context, state) {
              if (state is GetVehicleRouteHistoryDone) {
                if(state.resp.data.isEmpty){
                  AlertMessage.showAlertMessageModal(context, "No record found");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RouteHistoryReportPage(
                        report: state.resp, vin: widget.vin, ),
                  ),
                );
              } else if (state is VehicleFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is VehicleLoading) {
                return const Center(child: CustomLoadingButton());
              }
              return Align(
                alignment: Alignment.center,
                child: CustomPrimaryButton(
                    label:  'View Report',
                    onPressed: (){
                      final vehicleRouteHistory = VehicleRouteHistoryReqEntity(
                          vehicle_vin: widget.vin!,
                          time_from:
                          fromDate.toString().split('.').first ?? "N/A",
                          time_to: toDate.toString().split('.').first ?? "N/A",
                          token: widget.token!);
                      context
                          .read<VehicleRouteHistoryBloc>()
                          .add(VehicleRouteHistoryEvent(vehicleRouteHistory));
                    })
              );
            },
          )
        ],
      ),
    );
  }
}
