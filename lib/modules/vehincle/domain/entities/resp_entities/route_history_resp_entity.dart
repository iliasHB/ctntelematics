import 'package:equatable/equatable.dart';

class VehicleRouteHistoryRespEntity extends Equatable {

  final List<DatumEntity> data;
  final dynamic routeLength;

  const VehicleRouteHistoryRespEntity({
    required this.data,
    required this.routeLength,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [DatumEntity, routeLength];
}

class DatumEntity extends Equatable{
  dynamic id;
  dynamic vehicle_id;
  dynamic tracker_id;
  dynamic latitude;
  dynamic longitude;
  dynamic speed;
  dynamic speed_unit;
  dynamic course;
  dynamic fix_time;
  dynamic satellite_count;
  dynamic active_satellite_count;
  dynamic real_time_gps;
  dynamic gps_positioned;
  dynamic east_longitude;
  dynamic north_latitude;
  dynamic mcc;
  dynamic mnc;
  dynamic lac;
  dynamic cell_id;
  dynamic serial_number;
  dynamic error_check;
  List<dynamic> event;
  dynamic parse_time;
  dynamic terminal_info;
  dynamic voltage_level;
  dynamic gsm_signal_strength;
  dynamic response_msg;
  dynamic status;
  dynamic created_at;
  dynamic updated_at;
  dynamic connected;
  // dynamic stop_duration_minutes;

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
    required this.connected,
    // this.stop_duration_minutes
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
    connected,
    // stop_duration_minutes
  ];
}

