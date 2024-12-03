
import 'package:equatable/equatable.dart';

class CreateScheduleRespEntity extends Equatable{
  final String message;
  final ScheduleEntity schedule;

  CreateScheduleRespEntity({
    required this.message,
    required this.schedule,
  });


  @override
  // TODO: implement props
  List<Object?> get props => [
    message,
    schedule
  ];
}

class ScheduleEntity extends Equatable{
  final String? vehicle_vin;
  final String? schedule_type;
  final String? start_date;
  final String? no_time;
  final String? no_kilometer;
  final String? no_hours;
  final dynamic category_time;
  final String? reminder_advance_days;
  final String? reminder_advance_km;
  final String? reminder_advance_hr;
  final String updated_at;
  final String created_at;
  final int id;

  ScheduleEntity({
    required this.vehicle_vin,
    required this.schedule_type,
    required this.start_date,
    required this.no_time,
    required this.no_kilometer,
    required this.no_hours,
    required this.category_time,
    required this.reminder_advance_days,
    required this.reminder_advance_km,
    required this.reminder_advance_hr,
    required this.updated_at,
    required this.created_at,
    required this.id,
  });



  @override
  // TODO: implement props
  List<Object?> get props => [
    vehicle_vin,
    schedule_type,
    start_date,
    no_time,
    no_hours,
    category_time,
    reminder_advance_days,
    reminder_advance_km,
    reminder_advance_hr,
    created_at,
    updated_at
  ];
}
