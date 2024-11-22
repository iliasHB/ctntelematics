import 'package:equatable/equatable.dart';

class CreateScheduleReqEntity extends Equatable{
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

  CreateScheduleReqEntity(
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
