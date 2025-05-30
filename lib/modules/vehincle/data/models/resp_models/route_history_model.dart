
import 'dart:convert';

import '../../../domain/entities/resp_entities/route_history_resp_entity.dart';

class VehicleRouteHistoryRespModel extends VehicleRouteHistoryRespEntity{

  const VehicleRouteHistoryRespModel({
    required super.data,
    required super.routeLength,
  });

  factory VehicleRouteHistoryRespModel.fromJson(Map<String, dynamic> json) => VehicleRouteHistoryRespModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      routeLength: json['routeLength']
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "routeLength": routeLength
  };

}

class Datum extends DatumEntity{

  Datum({
    required super.id,
    required super.vehicle_id,
    required super.tracker_id,
    required super.latitude,
    required super.longitude,
    required super.speed,
    required super.speed_unit,
    required super.course,
    required super.fix_time,
    required super.satellite_count,
    required super.active_satellite_count,
    required super.real_time_gps,
    required super.gps_positioned,
    required super.east_longitude,
    required super.north_latitude,
    required super.mcc,
    required super.mnc,
    required super.lac,
    required super.cell_id,
    required super.serial_number,
    required super.error_check,
    required super.event,
    required super.parse_time,
    required super.terminal_info,
    required super.voltage_level,
    required super.gsm_signal_strength,
    required super.response_msg,
    required super.status,
    required super.created_at,
    required super.updated_at,
    required super.connected,
    // required super.stop_duration_minutes
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vehicle_id: json["vehicle_id"],
    tracker_id: json["tracker_id"],
    latitude: json['latitude'],
    longitude: json["longitude"],
    speed: json["speed"],
    speed_unit: json["speed_unit"],
    course: json["course"],
    fix_time: json["fix_time"],
    satellite_count: json["satellite_count"],
    active_satellite_count: json["active_satellite_count"],
    real_time_gps: json["real_time_gps"],
    gps_positioned: json["gps_positioned"],
    east_longitude: json["east_longitude"],
    north_latitude: json["north_latitude"],
    mcc: json["mcc"],
    mnc: json["mnc"],
    lac: json["lac"],
    cell_id: json["cell_id"],
    serial_number: json["serial_number"],
    error_check: json["error_check"],
    event: json["event"] is String
        ? [json["event"]] // Convert String to a single-element List
        : List<dynamic>.from(json["event"] ?? []),
    // event: List<dynamic>.from(json["event"].map((x) => x)),
    parse_time: json["parse_time"],
    terminal_info: json["terminal_info"],
    voltage_level: json["voltage_level"],
    gsm_signal_strength: json["gsm_signal_strength"],
    response_msg: json["response_msg"],
    status: json["status"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
    connected: json["connected"],
      // stop_duration_minutes: json['stop_duration_minutes']
  );

  Map<String, dynamic> toJson() => {
    "vehicle_id": vehicle_id,
    "tracker_id": tracker_id,
    "latitude": latitude,
    "longitude": longitude,
    "speed": speed,
    "speed_unit": speed_unit,
    "course": course,
    "fix_time": fix_time,
    "satellite_count": satellite_count,
    "active_satellite_count": active_satellite_count,
    "real_time_gps": real_time_gps,
    "gps_positioned": gps_positioned,
    "east_longitude": east_longitude,
    "north_latitude": north_latitude,
    "mcc": mcc,
    "mnc": mnc,
    "lac": lac,
    "cellId": cell_id,
    "serial_number": serial_number,
    "error_check": error_check,
    "event": event,
    "parse_time": parse_time,
    "terminal_info": terminal_info,
    "voltage_level": voltage_level,
    "gsm_signal_strength": gsm_signal_strength,
    "response_msg": response_msg,
    "status": status,
    "created_at": created_at,
    "updated_at": updated_at,
    'connected': connected,
    // 'stop_duration_minutes': stop_duration_minutes
  };

}
