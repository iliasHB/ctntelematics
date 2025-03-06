

import '../../../domain/entitties/resp_entities/complete_resp_entity.dart';

class CompleteScheduleRespModel extends CompleteScheduleRespEntity{

  CompleteScheduleRespModel({
    required super.message,
    required super.next_start_date,
  });

  factory CompleteScheduleRespModel.fromJson(Map<String, dynamic> json) => CompleteScheduleRespModel(
    message: json["message"],
    next_start_date: json["next_start_date"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "next_start_date": next_start_date,
  };
}
