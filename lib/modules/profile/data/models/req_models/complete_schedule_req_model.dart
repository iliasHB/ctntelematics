

import 'package:equatable/equatable.dart';

import '../../../domain/entitties/resp_entities/complete_resp_entity.dart';

class CompleteScheduleReqModel extends Equatable{
  final String vehicle_vin;
  final String schedule_id;
  final String token;
  const CompleteScheduleReqModel({
    required this.vehicle_vin,
    required this.schedule_id,
    required this.token,
  });

  factory CompleteScheduleReqModel.fromJson(Map<String, dynamic> json) => CompleteScheduleReqModel(
    vehicle_vin: json["vehicle_vin"],
    schedule_id: json["schedule_id"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "vehicle_vin": vehicle_vin,
    "schedule_id": schedule_id,
    "token": token
  };

  @override
  // TODO: implement props
  List<Object?> get props => [
    vehicle_vin,
    schedule_id,
    token
  ];
}
