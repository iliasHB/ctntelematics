
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetScheduleRespEntity extends Equatable{
final int current_page;
final List<DatumEntity> data;
final String? first_page_url;
final int from;
final int last_page;
final String last_page_url;
final List<LinkEntity> links;
final dynamic next_page_url;
final String path;
final int per_page;
final dynamic prev_page_url;
final int to;
final int total;

const GetScheduleRespEntity({
  required this.current_page,
  required this.data,
  required this.first_page_url,
  required this.from,
  required this.last_page,
  required this.last_page_url,
  required this.links,
  required this.next_page_url,
  required this.path,
  required this.per_page,
  required this.prev_page_url,
  required this.to,
  required this.total,
});


  @override
  // TODO: implement props
  List<Object?> get props => [
    current_page,
    data,
    first_page_url,
    from,
    last_page,
    last_page_url,
    links,
    next_page_url,
    path,
    per_page,
    prev_page_url,
    to,
    total,
  ];
}

class DatumEntity extends Equatable{
final int id;
final String brand;
final String model;
final String year;
final String type;
final String vin;
final String number_plate;
final int user_id;
final int vehicle_owner_id;
final String created_at;
final String updated_at;
final DriverEntity driver;
final List<MaintenanceEntity> maintenance;
final OwnerEntity owner;
final TrackerEntity tracker;
final LastLocationEntity last_location;

DatumEntity({
required this.id,
required this.brand,
required this.model,
required this.year,
required this.type,
required this.vin,
required this.number_plate,
required this.user_id,
required this.vehicle_owner_id,
required this.created_at,
required this.updated_at,
required this.driver,
required this.maintenance,
required this.owner,
required this.tracker,
required this.last_location,
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    brand,
    model,
    year,
    type,
    vin,
    number_plate,
    user_id,
    vehicle_owner_id,
    created_at,
    updated_at,
    driver,
    maintenance,
    owner,
    tracker,
    last_location,
  ];

}

class DriverEntity extends Equatable{
final int id;
final String name;
final String email;
final String phone;
final String vehicle_vin;
final int vehicle_id;
final String pin;
final String country;
final String licence_number;
final String licence_issue_date;
final String licence_expiry_date;
final String guarantor_name;
final String guarantor_phone;
final String profile_picture_path;
final String driving_licence_path;
final String pin_path;
final dynamic miscellaneous_path;
final String created_at;
final String updated_at;

DriverEntity({
required this.id,
required this.name,
required this.email,
required this.phone,
required this.vehicle_vin,
required this.vehicle_id,
required this.pin,
required this.country,
required this.licence_number,
required this.licence_issue_date,
required this.licence_expiry_date,
required this.guarantor_name,
required this.guarantor_phone,
required this.profile_picture_path,
required this.driving_licence_path,
required this.pin_path,
required this.miscellaneous_path,
required this.created_at,
required this.updated_at,
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    vehicle_vin,
    vehicle_id,
    pin,
    country,
    licence_number,
    licence_issue_date,
    licence_expiry_date,
    guarantor_name,
    guarantor_phone,
    profile_picture_path,
    driving_licence_path,
    pin_path,
    miscellaneous_path,
    created_at,
    updated_at,
  ];

}

class LastLocationEntity extends Equatable{
final int vehicle_id;
final int tracker_id;
final String latitude;
final String longitude;
final String speed;
final dynamic speed_unit;
final int course;
final DateTime fix_time;
final int satellite_count;
final int active_satellite_count;
final bool real_time_gps;
final bool gps_positioned;
final bool east_longitude;
final bool north_latitude;
final int mcc;
final int mnc;
final int lac;
final int cell_id;
final String serial_number;
final int error_check;
final String event;
final int parse_time;
final String terminal_info;
final String voltage_level;
final String gsm_signal_strength;
final dynamic response_msg;
final String status;
final String created_at;
final String updated_at;

LastLocationEntity({
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

class MaintenanceEntity extends Equatable{
final int id;
final dynamic description;
final dynamic vehicle_vin;
final dynamic schedule_type;
final dynamic no_time;
final dynamic no_kilometer;
final dynamic no_hours;
final dynamic category_time;
final dynamic reminder_advance_days;
final dynamic reminder_advance_km;
final dynamic reminder_advance_hr;
final String start_date;
final String created_at;
final String updated_at;

MaintenanceEntity({
required this.id,
required this.description,
required this.vehicle_vin,
required this.schedule_type,
required this.no_time,
required this.no_kilometer,
required this.no_hours,
required this.category_time,
required this.reminder_advance_days,
required this.reminder_advance_km,
required this.reminder_advance_hr,
required this.start_date,
required this.created_at,
required this.updated_at,
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    description,
    vehicle_vin,
    schedule_type,
    no_time,
    no_kilometer,
    no_hours,
    category_time,
    reminder_advance_days,
    reminder_advance_km,
    reminder_advance_hr,
    start_date,
    created_at,
    updated_at,
  ];

}

class OwnerEntity extends Equatable{
final int id;
final String first_name;
final String last_name;
final String email;
final String phone;
final int user_id;
final String created_at;
final String updated_at;

OwnerEntity({
required this.id,
required this.first_name,
required this.last_name,
required this.email,
required this.phone,
required this.user_id,
required this.created_at,
required this.updated_at,
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    first_name,
    last_name,
    email,
    phone,
    user_id,
    created_at,
    updated_at,
  ];

}

class TrackerEntity extends Equatable {
final String device_id;
final String protocol;
final String ip;
final String sim_no;
final String params;
final String port;
final String network_protocol;
final int vehicle_id;

TrackerEntity({
required this.device_id,
required this.protocol,
required this.ip,
required this.sim_no,
required this.params,
required this.port,
required this.network_protocol,
required this.vehicle_id,
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    device_id,
    protocol,
    ip,
    sim_no,
    params,
    port,
    network_protocol,
    vehicle_id,
  ];

}

class LinkEntity extends Equatable{
final dynamic url;
final String label;
final bool active;

LinkEntity({
required this.url,
required this.label,
required this.active,
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    url,
    label,
    active,
  ];

}

