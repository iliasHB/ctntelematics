import 'package:equatable/equatable.dart';

class LastLocationRespEntity extends Equatable {
  MapVehicleEntity? vehicle;

  LastLocationRespEntity({
    required this.vehicle,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [vehicle];
}

class MapVehicleEntity extends Equatable {
  int? id;
  DetailsEntity? details;
  DriverEntity? driver;
  String? address;
  GeofenceEntity? geofence;
  String? connected_status;

  MapVehicleEntity({
    required this.id,
    required this.details,
    required this.driver,
    required this.address,
    required this.geofence,
    required this.connected_status,
  });

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id,
        details,
        driver,
        address,
        // geofence,
        connected_status];
}

class DetailsEntity extends Equatable {
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
  OwnerEntity? owner;
  TrackerEntity? tracker;
  LastLocationEntity? last_location;
  SpeedLimitEntity? speed_limit;

  DetailsEntity({
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
    required this.owner,
    required this.tracker,
    required this.last_location,
    required this.speed_limit,
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
        owner,
        tracker,
        last_location,
        speed_limit
      ];
}

class LastLocationEntity extends Equatable{
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
  // String? terminal_info;
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

class OwnerEntity extends Equatable {
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
        updated_at
      ];
}

class SpeedLimitEntity extends Equatable {
  String speed_limit;

  SpeedLimitEntity({
    required this.speed_limit,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [speed_limit];
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
        vehicle_id
      ];
}

class DriverEntity extends Equatable {
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
  dynamic miscellaneous_path;
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

class GeofenceEntity extends Equatable {
  List<CenterEntity> coordinates;
  String? zone;
  bool? is_in_geofence;
  CircleDataEntity? circle_data;

  GeofenceEntity({
    required this.coordinates,
    required this.zone,
    required this.is_in_geofence,
    required this.circle_data,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    coordinates,
    zone,
    is_in_geofence,
    circle_data
  ];
}

class CircleDataEntity extends Equatable {
  CenterEntity? center;
  double? radius;

  CircleDataEntity({
    required this.center,
    required this.radius,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    center,
    radius
  ];
}

class CenterEntity extends Equatable{
  double lng;
  double lat;

  CenterEntity({
    required this.lng,
    required this.lat,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    lng,
    lat
  ];
}
