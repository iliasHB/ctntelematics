
// import 'dart:convert';

import '../../../domain/entitties/resp_entities/get_schedule_resp_notice_entity.dart';

// List<GetScheduleNoticeRespModel> getScheduleNoticeRespModelFromMap(String str) => List<GetScheduleNoticeRespModel>.from(json.decode(str).map((x) => GetScheduleNoticeRespModel.fromJson(x)));
//
// String getScheduleNoticeRespModelToMap(List<GetScheduleNoticeRespModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GetScheduleNoticeRespModel extends GetScheduleNoticeRespEntity{
  // final int id;
  // final String vin;
  // final int userId;
  // final bool maintenanceDue;
  // final String description;

  GetScheduleNoticeRespModel({
    required super.id,
    required super.vin,
    required super.user_id,
    required super.schedule_id,
    required super.maintenance_due,
    required super.over_due_days,
    required super.over_due_km,
    required super.description,
  });

  // GetScheduleNoticeRespModel copyWith({
  //   int? id,
  //   String? vin,
  //   int? userId,
  //   bool? maintenanceDue,
  //   String? description,
  // }) =>
  //     GetScheduleNoticeRespModel(
  //       id: id ?? this.id,
  //       vin: vin ?? this.vin,
  //       userId: userId ?? this.userId,
  //       maintenanceDue: maintenanceDue ?? this.maintenanceDue,
  //       description: description ?? this.description,
  //     );

  factory GetScheduleNoticeRespModel.fromJson(Map<String, dynamic> json) => GetScheduleNoticeRespModel(
    id: json["id"] ?? "",
    vin: json["vin"] ?? "",
    user_id: json["user_id"],
    schedule_id: json["schedule_id"],
    maintenance_due: json["maintenance_due"] ?? "",
    over_due_days: json["over_due_days"] ?? "",
    over_due_km: json["over_due_km"] ?? "",
    description: json["description"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vin": vin,
    "user_id": user_id,
    "schedule_id": schedule_id,
    "maintenance_due": maintenance_due,
    "over_due_days": over_due_days,
    "over_due_km": over_due_km,
    "description": description,
  };
}
