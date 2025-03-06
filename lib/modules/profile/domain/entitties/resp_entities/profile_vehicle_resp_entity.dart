
import 'package:equatable/equatable.dart';


import 'package:equatable/equatable.dart';

class ProfileVehicleRespEntity extends Equatable{
  dynamic current_page; //int?
  List<DatumEntity>? data;
  dynamic first_page_url; // String?
  dynamic from; //int?
  dynamic last_page; //int?
  dynamic last_page_url; //String?
  // List<LinkEntity>? links;
  dynamic next_page_url; //String?
  dynamic path; //String?
  dynamic per_page; //int?
  dynamic prev_page_url; //String?
  dynamic to; //int?
  dynamic total; //int?

  ProfileVehicleRespEntity({
    required this.current_page,
    required this.data,
    required this.first_page_url,
    required this.from,
    required this.last_page,
    required this.last_page_url,
    // required this.links,
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
    // links,
    next_page_url,
    path,
    per_page,
    prev_page_url,
    to,
    total,
  ];

}

class DatumEntity extends Equatable{
  dynamic id; // int?
  dynamic brand; //String?
  dynamic model; //String?
  dynamic year; //String?
  dynamic type; //String?
  dynamic vin; //String?
  dynamic number_plate; //String?
  dynamic user_id; //int?
  dynamic vehicle_owner_id; //int?
  dynamic created_at; //String?
  dynamic updated_at; //String?
  // DriverEntity? driver;
  // OwnerEntity? owner;
  // TrackerEntity? tracker;
  // LastLocationEntity? last_location;

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
    // required this.driver,
    // required this.owner,
    // required this.tracker,
    // required this.last_location,
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
    // driver,
    // owner,
    // tracker,
    // last_location,
  ];

}

class DriverEntity extends Equatable{
  dynamic id; //int?
  dynamic name; //String?
  dynamic email; //String?
  dynamic phone; //String?
  dynamic vehicle_vin; //String?
  dynamic vehicle_id; //int?
  dynamic pin; //String?
  dynamic country; //String?
  dynamic licence_number; //String?
  dynamic licence_issue_date; //String?
  dynamic licence_expiry_date; //String?
  dynamic guarantor_name; //String?
  dynamic guarantor_phone; //String?
  dynamic profile_picture_path; //String?
  dynamic driving_licence_path; //String?
  dynamic pin_path; //String?
  dynamic miscellaneous_path; // String?
  dynamic created_at; //String?
  dynamic updated_at; //String?

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
  dynamic vehicle_id; //int?
  dynamic tracker_id; //int?
  dynamic latitude; //String?
  dynamic longitude; //String
  dynamic speed; //String
  dynamic speed_unit; //String
  dynamic course; //int?
  dynamic fix_time; //String
  dynamic satellite_count; //int?
  dynamic active_satellite_count; //int?
  dynamic real_time_gps; //bool?
  dynamic gps_positioned; //bool?
  dynamic east_longitude; //bool?
  dynamic north_latitude; //bool?
  dynamic mcc; //int?
  dynamic mnc; //int?
  dynamic lac; //int?
  dynamic cell_id; //int?
  dynamic serial_number; //String
  dynamic error_check; //int?
  dynamic event; //String
  dynamic parse_time; //int?
  // String? terminal_info;
  dynamic voltage_level; //String?
  dynamic gsm_signal_strength; //String?
  dynamic response_msg; //String?
  dynamic status;  //String?
  dynamic created_at; //String?
  dynamic updated_at; //String?

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
    // required this.terminal_info,
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
    // terminal_info,
    voltage_level,
    gsm_signal_strength,
    response_msg,
    status,
    created_at,
    updated_at,
  ];

}

class OwnerEntity extends Equatable{
  dynamic id; //int?
  dynamic first_name; //String?
  dynamic last_name; //String?
  dynamic email; //String?
  dynamic phone; //String?
  dynamic user_id; //int?
  dynamic created_at; //String?
  dynamic updated_at; //String?

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
  dynamic device_id; //String?
  dynamic protocol;// String?
  dynamic ip; //String?
  dynamic sim_no;//String?
  dynamic params;//String?
  dynamic port;//String?
  dynamic network_protocol;//String?
  dynamic vehicle_id;//int?

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
  dynamic url;//String?
  dynamic label;//String?
  dynamic active; //bool?

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

