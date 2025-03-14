import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/model/token_req_entity.dart';
import '../../../../core/usecase/databse_helper.dart';
import '../../../../core/utils/pref_util.dart';
import '../../../../core/widgets/alert_message.dart';
import '../../../../core/widgets/format_data.dart';
import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/create_schedule_req_entity.dart';
import '../bloc/profile_bloc.dart';

final List<String> period = ['days', 'months', 'years'];
final List<String> reminderPeriod = ['days', 'week', 'month'];
final List<String> data = ['Brake pad', 'Car oil', 'Gear oil', 'Hydraulic', 'Motor coolant', 'Tire', 'Wheel balancing'];
List<String> selectedItems = [];
class CreateScheduleWidget extends StatefulWidget {
  final String? token;
  const CreateScheduleWidget({super.key, this.token});

  @override
  State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
}

class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceTitleController = TextEditingController();
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

  String dropdownValue2 = period.first;
  String dropdownValue1 = period[1];
  String dropdownValue3 = reminderPeriod[0];
  bool isSwitchedByTime = false;
  bool isSwitchedByEngineHr = false;
  bool isSwitchedByMileage = false;
  String? _selectedVendor;
  String selectedSchedule = 'recurring'; // Default selected value
  DB_schedule db_schedule = DB_schedule();

  // PrefUtils prefUtils = PrefUtils();
  // // Function to save auth_user into SharedPreferences
  // Future<void> scheduleUpdate(
  //     String byTime,
  //     String byTimeReminder,
  //     String vehicle_vin,
  //     String byHour,
  //     String byHourReminder,
  //     String no_kilometer,
  //     String reminder_advance_km) async {
  //   await prefUtils.setStringList('schedule', <String>[
  //     byTime,
  //     byTimeReminder,
  //     vehicle_vin,
  //     byHour,
  //     byHourReminder,
  //     no_kilometer,
  //     reminder_advance_km
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create schedule',
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
                Text(
                  'Title',
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _serviceTitleController,
                  decoration: InputDecoration(
                    hintText: 'Routine Service',
                    hintStyle: AppStyle.cardfooter,
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: AppStyle.cardfooter, // Style for user input text
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title can not be empty";
                    }
                    return null;
                  },
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
                        return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const CustomContainerLoadingButton());
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
                          ),
                        );
                      } else {
                        return Center(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
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
                                            icon: const Icon(Icons.refresh, color: Colors.green,)
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ));
                      }
                    },
                    listener: (context, state) {
                      if (state is ProfileFailure) {
                        if (state.message.contains("Unauthenticated")) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/login", (route) => false);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Service Tasks section
                const Text('Service Tasks',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showMultiSelectDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          selectedItems.isEmpty
                              ? "Select Options"
                              : selectedItems.join(", "),
                          style: AppStyle.cardfooter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: DropdownMenu<String>(
                //         initialSelection: data[1],
                //         inputDecorationTheme: InputDecorationTheme(
                //           border: InputBorder.none, // Removes the border
                //           filled: true,
                //           fillColor: Colors.grey[200],
                //         ),
                //         textStyle:
                //         AppStyle.cardfooter.copyWith(fontSize: 12),
                //         onSelected: (String? value) {
                //           // This is called when the user selects an item.
                //           setState(() {
                //             dropdownValue1 = value!;
                //           });
                //         },
                //
                //         dropdownMenuEntries: data
                //             .map<DropdownMenuEntry<String>>((String value) {
                //           return DropdownMenuEntry<String>(
                //               value: value, label: value);
                //         }).toList(),
                //       ),
                //     ),
                //   ],
                // ),
                ///
                // TextFormField(
                //   controller: _taskController,
                //   decoration: InputDecoration(
                //     hintText: 'e.g; Oil Change, Oil Filter Replacement',
                //     hintStyle: AppStyle.cardfooter,
                //     border:
                //         const OutlineInputBorder(borderSide: BorderSide.none),
                //     filled: true,
                //     fillColor: Colors.grey[200],
                //   ),
                //   style: AppStyle.cardfooter, // Style for user input text
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Task can not be empty";
                //     }
                //     return null;
                //   },
                // ),

                const SizedBox(height: 16),
                // Schedule Options
                Text(
                  'Schedule',
                  style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'Recurring',
                          style: AppStyle.cardfooter,
                        ),
                        leading: Radio(
                          value: 'recurring',
                          groupValue: selectedSchedule,
                          onChanged: (value) {
                            setState(() {
                              selectedSchedule =
                                  value!; // Update the selected value
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'Custom',
                          style: AppStyle.cardfooter,
                        ),
                        leading: Radio(
                          value: 'custom',
                          groupValue: selectedSchedule,
                          onChanged: (value) {
                            setState(() {
                              selectedSchedule =
                                  value!; // Update the selected value
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                // Schedule Options By Time, Engine Hours, Mileage
                Text(
                  'Recurring service will be due either by time, by mileage, or by engine running hours whichever comes first',
                  style: AppStyle.cardfooter.copyWith(
                      fontSize: 12,
                      color: Colors.red), // Style for user input text
                ),
                const SizedBox(height: 16),
                // By Time Section
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey[300]!),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'By Time',
                            style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                          ),
                          Switch(
                            value: isSwitchedByTime,
                            onChanged: (bool value) {
                              setState(() {
                                isSwitchedByTime = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: timeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabled:
                                    isSwitchedByTime == true ? true : false,
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Every',
                                labelStyle:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                // suffixText: '3',
                              ),
                              style: AppStyle
                                  .cardfooter, // Style for user input text
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: DropdownMenu<String>(
                            initialSelection: period[1],
                            inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none, // Removes the border
                              filled: true, // Enables the background color
                              fillColor: Colors.white, // Removes the border
                            ),
                            textStyle:
                                AppStyle.cardfooter.copyWith(fontSize: 12),
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue1 = value!;
                              });
                            },
                            dropdownMenuEntries: period
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: timeReminderAdvController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabled:
                                    isSwitchedByTime == true ? true : false,
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Reminder in Advance',
                                labelStyle:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                // suffixText: '3',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: DropdownMenu<String>(
                            initialSelection: reminderPeriod.first,
                            inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none, // Removes the border
                              filled: true, // Enables the background color
                              fillColor: Colors.white, // Removes the border
                            ),
                            textStyle: AppStyle.cardfooter.copyWith(fontSize: 12),
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue1 = value!;
                              });
                            },
                            dropdownMenuEntries: reminderPeriod
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // By Engine Hours Section
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey[300]!),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'By Engine Hours',
                            style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                          ),
                          Switch(
                            value: isSwitchedByEngineHr,
                            onChanged: (bool value) {
                              setState(() {
                                isSwitchedByEngineHr = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextField(
                              controller: engineHrController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabled:
                                    isSwitchedByEngineHr == true ? true : false,
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Every',
                                labelStyle:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                // suffixText: '3',
                              ),
                              style: AppStyle
                                  .cardfooter, // Style for user input text
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                              flex: 1,
                              child: Text(
                                'Hrs',
                                style:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                              )),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 6,
                            child: TextField(
                              controller: engineHrReminderAdvController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Reminder in Advance',
                                labelStyle:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                // suffixText: '3',
                              ),
                              style: AppStyle
                                  .cardfooter, // Style for user input text
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                              flex: 1,
                              child: Text(
                                'Hrs',
                                style:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // By Mileage Section
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey[300]!),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'By Mileage',
                            style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                          ),
                          Switch(
                            value: isSwitchedByMileage,
                            onChanged: (bool value) {
                              setState(() {
                                isSwitchedByMileage = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextField(
                                controller: mileageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  enabled: isSwitchedByMileage == true
                                      ? true
                                      : false,
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Every',
                                  labelStyle: AppStyle.cardfooter
                                      .copyWith(fontSize: 12),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // suffixText: '3',
                                ),
                                style: AppStyle.cardfooter),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                              flex: 1,
                              child: Text(
                                'Km',
                                style:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                              )),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 5,
                            child: TextField(
                              controller: mileageReminderAdvController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Reminder in Advance',
                                labelStyle:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                // suffixText: '3',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                              flex: 1,
                              child: Text(
                                'Km',
                                style:
                                    AppStyle.cardfooter.copyWith(fontSize: 12),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                BlocConsumer<CreateScheduleBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is CreateScheduleDone) {
                      saveScheduleType(
                          '${state.resp.schedule.no_time} $dropdownValue1',
                          '${state.resp.schedule.reminder_advance_days} $dropdownValue2',
                            state.resp.schedule.vehicle_vin ?? "",
                          state.resp.schedule.no_hours ?? "0",
                          state.resp.schedule.reminder_advance_hr ?? "0",
                          state.resp.schedule.no_kilometer ?? "",
                          state.resp.schedule.reminder_advance_km ?? "",
                          state.resp.schedule.start_date ?? "",
                          state.resp.schedule.schedule_type ?? "",
                          selectedItems.join(", "));
                          // FormatData.convertDurationToDate(
                          //     '${state.resp.schedule.no_time} $dropdownValue1'),
                          // FormatData.convertDurationToDate(
                          //     '${state.resp.schedule.reminder_advance_days} $dropdownValue2'),
                          // FormatData.calculateReminderTime(
                          //     int.parse(state.resp.schedule.no_hours ?? "0")),
                          // FormatData.calculateReminderTime(int.parse(
                          //     state.resp.schedule.reminder_advance_hr ?? "0")),
                          // state.resp.schedule.no_kilometer ?? "",
                          // state.resp.schedule.reminder_advance_km ?? "",
                          // state.resp.schedule.start_date ?? "",
                          // state.resp.schedule.schedule_type ?? "",
                          // selectedItems.join(", "));

                      AlertMessage.showAlertMessageModal(context, state.resp.message);

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.resp.message)));
                    } else if (state is ProfileFailure) {
                      if (state.message.contains("Unauthenticated")) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (route) => false);
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                      // return null;
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(
                        child: CustomContainerLoadingButton()
                      );
                    }
                    return Align(
                        alignment: Alignment.center,
                        child: CustomPrimaryButton(
                          label: 'Save Record',
                          onPressed: () {
                            print("dropdownValue1:::: ${dropdownValue1}");
                            print("dropdownValue2:::: ${dropdownValue2}");
                            print("_selectedVendor:::: ${_selectedVendor}");
                            print("selectedSchedule:::: ${selectedSchedule}");
                            print(
                                "start_date:::: ${DateTime.now().toString()}");
                            print(
                                "number_kilometer:::: ${mileageController.text.trim()}");
                            print(
                                "number_time:::: ${timeController.text.trim()}");
                            print(
                                "number_hour:::: ${engineHrController.text.trim()}");
                            print(
                                "reminder_advance_days:::: ${timeReminderAdvController.text}");
                            print(
                                "reminder_advance_hr:::: ${engineHrReminderAdvController.text}");
                            print(
                                "reminder_advance_km:::: ${mileageReminderAdvController.text.trim()}");
                            print("token:::: ${widget.token}");

                            if (_formKey.currentState?.validate() ?? false) {
                              final createScheduleReqEntity =
                                  CreateScheduleReqEntity(
                                      description: selectedItems.join(", "),
                                      vehicle_vin: _selectedVendor!,
                                      schedule_type: selectedSchedule,
                                      start_date: FormatData.formatTimestampToDate(DateTime.now().toString()),
                                      number_kilometer:
                                          mileageController.text.trim(),
                                      number_time: timeController.text.trim(),
                                      category_time: "",
                                      number_hour: engineHrController.text.trim(),
                                      reminder_advance_days: timeReminderAdvController.text,
                                      reminder_advance_hr:
                                          engineHrReminderAdvController.text
                                              .toString(),
                                      reminder_advance_km:
                                          mileageReminderAdvController.text
                                              .trim(),
                                      token: widget.token!);
                              context.read<CreateScheduleBloc>().add(
                                  CreateScheduleEvent(createScheduleReqEntity));
                            }
                          },
                        )

                        // ElevatedButton(
                        //   onPressed: () {
                        //     print("dropdownValue1:::: ${dropdownValue1}");
                        //     print("dropdownValue2:::: ${dropdownValue2}");
                        //     print("_selectedVendor:::: ${_selectedVendor}");
                        //     print("selectedSchedule:::: ${selectedSchedule}");
                        //     print("start_date:::: ${DateTime.now().toString()}");
                        //     print("number_kilometer:::: ${mileageController.text.trim()}");
                        //     print("number_time:::: ${timeController.text.trim()}");
                        //     print("number_hour:::: ${engineHrController.text.trim()}");
                        //     print("reminder_advance_days:::: ${timeReminderAdvController.text}");
                        //     print("reminder_advance_hr:::: ${engineHrReminderAdvController.text}");
                        //     print("reminder_advance_km:::: ${mileageReminderAdvController.text.trim()}");
                        //     print("token:::: ${widget.token}");
                        //
                        //     if (_formKey.currentState?.validate() ?? false) {
                        //       final createScheduleReqEntity =
                        //           CreateScheduleReqEntity(
                        //               description: '',
                        //               vehicle_vin: _selectedVendor!,
                        //               schedule_type: selectedSchedule!,
                        //               start_date: DateTime.now().toString(),
                        //               number_kilometer:
                        //                   mileageController.text.trim(),
                        //               number_time: timeController.text.trim(),
                        //               category_time: '2',
                        //               number_hour: engineHrController.text.trim(),
                        //               reminder_advance_days:
                        //                   timeReminderAdvController.text,
                        //               reminder_advance_hr:
                        //                   engineHrReminderAdvController.text
                        //                       .toString(),
                        //               reminder_advance_km:
                        //                   mileageReminderAdvController.text
                        //                       .trim(),
                        //               token: widget.token!);
                        //       context.read<CreateScheduleBloc>().add(
                        //           CreateScheduleEvent(createScheduleReqEntity));
                        //     }
                        //   },
                        //   child: Text(
                        //     'Save Record',
                        //     style: AppStyle.cardfooter.copyWith(fontSize: 14),
                        //   ),
                        // ),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveScheduleType(
      String no_time,
      String reminder_advance_days,
      String vehicle_vin,
      String no_hours,
      String reminder_advance_hr,
      String no_kilometer,
      String reminder_advance_km,
      String start_date,
      String schedule_type,
      String service_task) async {
    bool isSaved = await db_schedule.saveSchedule(
        vehicle_vin,
        service_task,
        schedule_type,
        no_time,
        reminder_advance_days,
        no_hours,
        reminder_advance_hr,
        no_kilometer,
        reminder_advance_km,
        start_date,
    );

    if (isSaved) {
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Schedule created successfully!',
            style: AppStyle.cardfooter,
          ),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      // Show failure feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create schedule'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showMultiSelectDialog(BuildContext context) async {
    List<String> tempSelected = List.from(selectedItems);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Options", style: AppStyle.cardSubtitle,),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: data.map((item) {
                  return CheckboxListTile(
                    title: Text(item),
                    value: tempSelected.contains(item),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          tempSelected.add(item);
                        } else {
                          tempSelected.remove(item);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedItems = List.from(tempSelected);
                });
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

