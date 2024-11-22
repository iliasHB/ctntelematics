import 'package:equatable/equatable.dart';

class RouteHistoryRespEntity extends Equatable {

  final List<DatumEntity> data;

  const RouteHistoryRespEntity({
    required this.data,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [DatumEntity];
}

class DatumEntity extends Equatable{
  int? id;
  int? vehicle_id;
  int? tracker_id;
  String? latitude;
  String? longitude;
  String? speed;
  String? speed_unit;
  int? course;
  String? fix_time;
  int? satellite_count;
  int? active_satellite_count;
  int? real_time_gps;
  int? gps_positioned;
  int? east_longitude;
  int? north_latitude;
  int? mcc;
  int? mnc;
  int? lac;
  int? cell_id;
  String? serial_number;
  int? error_check;
  List<dynamic> event;
  int? parse_time;
  String? terminal_info;
  String? voltage_level;
  String? gsm_signal_strength;
  dynamic response_msg;
  String? status;
  String? created_at;
  String? updated_at;

  DatumEntity({
    required this.id,
    required this.vehicle_id,
    required this.tracker_id,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.speed_unit,
    required this.course,
    required this.fix_time,
    required this.satellite_count,
    required this.active_satellite_count,
    required this.real_time_gps,
    required this.gps_positioned,
    required this.east_longitude,
    required this.north_latitude,
    required this.mcc,
    required this.mnc,
    required this.lac,
    required this.cell_id,
    required this.serial_number,
    required this.error_check,
    required this.event,
    required this.parse_time,
    required this.terminal_info,
    required this.voltage_level,
    required this.gsm_signal_strength,
    required this.response_msg,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    vehicle_id,
    tracker_id,
    latitude,
    longitude,
    speed,
    speed_unit,
    course,
    fix_time,
    satellite_count,
    active_satellite_count,
    real_time_gps,
    gps_positioned,
    east_longitude,
    north_latitude,
    mcc,
    mnc,
    lac,
    cell_id,
    serial_number,
    error_check,
    event,
    parse_time,
    terminal_info,
    voltage_level,
    gsm_signal_strength,
    response_msg,
    status,
    created_at,
    updated_at,
  ];
}

