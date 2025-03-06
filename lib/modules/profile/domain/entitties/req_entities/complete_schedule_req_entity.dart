import 'package:equatable/equatable.dart';

class CompleteScheduleReqEntity extends Equatable{
  final String vehicle_vin;
  final String schedule_id;
  final String token;

  CompleteScheduleReqEntity(
      {required this.vehicle_vin,
        required this.schedule_id,
        required this.token});

  @override
  // TODO: implement props
  List<Object?> get props => [
    vehicle_vin,
    schedule_id,
    token
  ];
}
