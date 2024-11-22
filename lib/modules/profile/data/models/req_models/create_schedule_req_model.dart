import 'package:equatable/equatable.dart';

class CreateScheduleReqModel extends Equatable{
  final String description;
  final String vehicle_vin;
  final String schedule_type;
  final String start_date;
  final String number_kilometer;
  final String number_time;
  final String category_time;
  final String number_hour;
  final String reminder_advance_days;
  final String reminder_advance_hr;
  final String reminder_advance_km;
  final String token;

  CreateScheduleReqModel(
      {required this.description,
      required this.vehicle_vin,
      required this.schedule_type,
      required this.start_date,
      required this.number_kilometer,
      required this.number_time,
      required this.category_time,
      required this.number_hour,
      required this.reminder_advance_days,
      required this.reminder_advance_hr,
      required this.reminder_advance_km,
      required this.token});

  factory CreateScheduleReqModel.fromJson(Map<String, dynamic> json) {
    return CreateScheduleReqModel(
      description: json['description'] ?? "",
      vehicle_vin: json['vehicle_vin'] ?? "",
      schedule_type: json['schedule_type'] ?? "",
      start_date: json['start_date'] ?? "",
      number_kilometer: json['number_kilometer'] ?? "",
      number_time: json['number_time'] ?? "",
      category_time: json['category_time'] ?? "",
      number_hour: json['number_hour'] ?? "",
      reminder_advance_days: json['reminder_advance_days'] ?? "",
      reminder_advance_hr: json['reminder_advance_hr'] ?? "",
      reminder_advance_km: json['reminder_advance_km'] ?? "",
      token: json['token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "vehicle_vin": vehicle_vin,
        "schedule_type": schedule_type,
        "start_date": start_date,
        "number_kilometer": number_kilometer,
        "number_time": number_time,
        "category_time": category_time,
        "number_hour": number_hour,
        "reminder_advance_days": reminder_advance_days,
        "reminder_advance_hr": reminder_advance_hr,
        "reminder_advance_km": reminder_advance_km,
        "token": token
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        description,
        vehicle_vin,
        schedule_type,
        start_date,
        number_kilometer,
        number_time,
        category_time,
        number_hour,
        reminder_advance_days,
        reminder_advance_hr,
        reminder_advance_km,
        token
      ];
}
