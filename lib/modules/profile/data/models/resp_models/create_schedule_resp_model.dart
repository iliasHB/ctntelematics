
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/create_schedule_resp_entity.dart';

class CreateScheduleRespModel extends CreateScheduleRespEntity{

  CreateScheduleRespModel({
    required super.message,
    required super.schedule,
  });

  factory CreateScheduleRespModel.fromJson(Map<String, dynamic> json) => CreateScheduleRespModel(
    message: json["message"],
    schedule: Schedule.fromJson(json["schedule"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "schedule": schedule,
  };
}

class Schedule extends ScheduleEntity {

  Schedule({
    required super.vehicle_vin,
    required super.schedule_type,
    required super.start_date,
    required super.no_time,
    required super.no_kilometer,
    required super.no_hours,
    required super.category_time,
    required super.reminder_advance_days,
    required super.reminder_advance_km,
    required super.reminder_advance_hr,
    required super.updated_at,
    required super.created_at,
    required super.id,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    vehicle_vin: json["vehicle_vin"],
    schedule_type: json["schedule_type"],
    start_date: json["start_date"],
    no_time: json["no_time"],
    no_kilometer: json["no_kilometer"],
    no_hours: json["no_hours"],
    category_time: json["category_time"],
    reminder_advance_days: json["reminder_advance_days"],
    reminder_advance_km: json["reminder_advance_km"],
    reminder_advance_hr: json["reminder_advance_hr"],
    updated_at: DateTime.parse(json["updated_at"]),
    created_at: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "vehicle_vin": vehicle_vin,
    "schedule_type": schedule_type,
    "start_date": start_date,
    "no_time": no_time,
    "no_kilometer": no_kilometer,
    "no_hours": no_hours,
    "category_time": category_time,
    "reminder_advance_days": reminder_advance_days,
    "reminder_advance_km": reminder_advance_km,
    "reminder_advance_hr": reminder_advance_hr,
    "updated_at": updated_at,
    "created_at": created_at,
    "id": id,
  };
}
