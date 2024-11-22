
import 'package:equatable/equatable.dart';


import 'package:equatable/equatable.dart';

class VehicleRespEntity extends Equatable{
  int? current_page;
  List<DatumEntity>? data;
  String? first_page_url;
  int? from;
  int? last_page;
  String? last_page_url;
  List<LinkEntity>? links;
  String? next_page_url;
  String? path;
  int? per_page;
  String? prev_page_url;
  int? to;
  int? total;

  VehicleRespEntity({
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
  int? id;
  String? brand;
  String? model;
  String? year;
  String? type;
  String? vin;
  String? number_plate;
  int? user_id;
  int? vehicle_owner_id;
  String? created_at;
  String? updated_at;
  DriverEntity? driver;
  OwnerEntity? owner;
  TrackerEntity? tracker;
  LastLocationEntity? last_location;

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
    owner,
    tracker,
    last_location,
  ];

}

class DriverEntity extends Equatable{
  int? id;
  String? name;
  String? email;
  String? phone;
  String? vehicle_vin;
  int? vehicle_id;
  String? pin;
  String? country;
  String? licence_number;
  String? licence_issue_date;
  String? licence_expiry_date;
  String? guarantor_name;
  String? guarantor_phone;
  String? profile_picture_path;
  String? driving_licence_path;
  String? pin_path;
  String? miscellaneous_path;
  String? created_at;
  String? updated_at;

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

class LastLocationEntity extends Equatable {
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
  bool? real_time_gps;
  bool? gps_positioned;
  bool? east_longitude;
  bool? north_latitude;
  int? mcc;
  int? mnc;
  int? lac;
  int? cell_id;
  String? serial_number;
  int? error_check;
  String? event;
  int? parse_time;
  String? terminal_info;
  String? voltage_level;
  String? gsm_signal_strength;
  String? response_msg;
  String? status;
  String? created_at;
  String? updated_at;

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

class OwnerEntity extends Equatable{
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? phone;
  int? user_id;
  String? created_at;
  String? updated_at;

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
  String? device_id;
  String? protocol;
  String? ip;
  String? sim_no;
  String? params;
  String? port;
  String? network_protocol;
  int? vehicle_id;

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
  String? url;
  String? label;
  bool? active;

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
    active
  ];

}

