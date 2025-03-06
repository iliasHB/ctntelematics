import 'package:equatable/equatable.dart';

class GetScheduleNoticeRespEntity extends Equatable {
  final dynamic id;
  final dynamic vin;
  final dynamic user_id;
  final dynamic schedule_id;
  final dynamic maintenance_due;
  final dynamic over_due_days;
  final dynamic over_due_km;
  final dynamic description;

  const GetScheduleNoticeRespEntity({
    required this.id,
    required this.vin,
    required this.user_id,
    required this.schedule_id,
    required this.maintenance_due,
    required this.over_due_days,
    required this.over_due_km,
    required this.description,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        vin,
        user_id,
    schedule_id,
        maintenance_due,
        over_due_days,
        over_due_km,
        description,
      ];
}
