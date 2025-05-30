
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/vehicle_resp_entity.dart';

class VehicleRespModel extends VehicleRespEntity {
  VehicleRespModel({
    required super.current_page,
    required super.data,
    required super.first_page_url,
    required super.from,
    required super.last_page,
    required super.last_page_url,
    required super.links,
    required super.next_page_url,
    required super.path,
    required super.per_page,
    required super.prev_page_url,
    required super.to,
    required super.total,
  });

  factory VehicleRespModel.fromJson(Map<String, dynamic> json) =>
      VehicleRespModel(
        current_page: json["current_page"] ?? 0,
        data: (json['data'] as List).map((data) => Datum.fromJson(data)).toList(),
        first_page_url: json['first_page_url'],
        from: json["from"] ?? 0,
        last_page: json["last_page"] ?? 0,
        last_page_url: json['last_page_url'] ?? "",
        links: json["links"] is List<Map<String, dynamic>>
            ? List<Link>.from(json['links'].map((e) => Link.fromJson(e)))
            : null,
        // (json['links'] as List).map((data) => Link.fromJson(data)).toList(),
        next_page_url: json["next_page_url"] ?? "",
        path: json["path"] ?? "",
        per_page: json['per_page'] ?? 0,
        prev_page_url: json["prev_page_url"] ?? "",
        to: json["to"] ?? 0,
        total: json['total'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "current_page": current_page,
    "data": data,
    "first_page_url": first_page_url,
    "from": from,
    "last_page": last_page,
    "last_page_url": last_page_url,
    "links": links,
    "next_page_url": next_page_url,
    "path": path,
    "per_page": per_page,
    "prev_page_url": prev_page_url,
    "to": to,
    "total": total,
  };
}

class Datum extends DatumEntity {
  Datum({
    required super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.type,
    required super.vin,
    required super.number_plate,
    required super.user_id,
    required super.vehicle_owner_id,
    required super.created_at,
    required super.updated_at,
    required super.driver,
    required super.owner,
    required super.tracker,
    required super.last_location,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? 0,
    brand: json["brand"] ?? "",
    model: json['model'] ?? "",
    year: json["year"] ?? "",
    type: json["type"] ?? "",
    vin: json['vin'] ?? "",
    number_plate: json['number_plate'] ?? "",
    user_id: json["user_id"] ?? 0,
    vehicle_owner_id: json["vehicle_owner_id"] ?? 0,
    created_at: json['created_at'] ?? "",
    updated_at: json["updated_at"] ?? "",
    driver: json["driver"] is Map<String, dynamic>
        ? Driver.fromJson(json["driver"])
        : null,
    owner: json["owner"] is Map<String, dynamic>
        ? Owner.fromJson(json["owner"])
        : null,
    tracker: json["tracker"] is Map<String, dynamic>
        ? Tracker.fromJson(json["tracker"])
        : null,
    last_location: json["tracker"] is Map<String, dynamic>
        ? LastLocation.fromJson(json["last_location"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "model": model,
    "year": year,
    "type": type,
    "vin": vin,
    "number_plate": number_plate,
    "user_id": user_id,
    "vehicle_owner_id": vehicle_owner_id,
    "created_at": created_at,
    "updated_at": updated_at,
    "driver": driver,
    "owner": owner,
    "tracker": tracker,
    "lastLocation": last_location,
  };
}

class Driver extends DriverEntity {
  Driver({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.vehicle_vin,
    required super.vehicle_id,
    required super.pin,
    required super.country,
    required super.licence_number,
    required super.licence_issue_date,
    required super.licence_expiry_date,
    required super.guarantor_name,
    required super.guarantor_phone,
    required super.profile_picture_path,
    required super.driving_licence_path,
    required super.pin_path,
    required super.miscellaneous_path,
    required super.created_at,
    required super.updated_at,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    name: json["name"],
    email: json['email'],
    phone: json["phone"],
    vehicle_vin: json["vehicle_vin"],
    vehicle_id: json["vehicle_id"],
    pin: json['pin'],
    country: json['country'],
    licence_number: json["licence_number"],
    licence_issue_date: json["licence_issue_date"],
    licence_expiry_date: json["licence_expiry_date"],
    guarantor_name: json["guarantor_name"],
    guarantor_phone: json['guarantor_phone'],
    profile_picture_path: json["profile_picture_path"],
    driving_licence_path: json["driving_licence_path"],
    pin_path: json['pin_path'],
    miscellaneous_path: json['miscellaneous_path'],
    created_at: json['created_at'],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "vehicleVin": vehicle_vin,
    "vehicleId": vehicle_id,
    "pin": pin,
    "country": country,
    "licenceNumber": licence_number,
    "licenceIssueDate": licence_issue_date,
    "guarantorName": guarantor_name,
    "guarantorPhone": guarantor_phone,
    "profilePicturePath": profile_picture_path,
    "drivingLicencePath": driving_licence_path,
    "pinPath": pin_path,
    "createdAt": created_at,
    "updatedAt": updated_at,
  };
}

class LastLocation extends LastLocationEntity {
  LastLocation({
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
    // required super.terminal_info,
    required super.voltage_level,
    required super.gsm_signal_strength,
    required super.response_msg,
    required super.status,
    required super.created_at,
    required super.updated_at,
  });

  factory LastLocation.fromJson(Map<String, dynamic> json) => LastLocation(
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
    event: json["event"],
    parse_time: json["parse_time"],
    // terminal_info: json["terminal_info"],
    voltage_level: json["voltage_level"],
    gsm_signal_strength: json["gsm_signal_strength"],
    response_msg: json["response_msg"],
    status: json["status"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
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
    // "terminal_info": terminal_info,
    "voltage_level": voltage_level,
    "gsm_signal_strength": gsm_signal_strength,
    "response_msg": response_msg,
    "status": status,
    "created_at": created_at,
    "updated_at": updated_at,
  };
}

class Owner extends OwnerEntity {
  Owner({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.email,
    required super.phone,
    required super.user_id,
    required super.created_at,
    required super.updated_at,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    first_name: json["first_name"],
    last_name: json['last_name'],
    email: json["email"],
    phone: json["phone"],
    user_id: json["user_id"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": first_name,
    "last_name": last_name,
    "email": email,
    "phone": phone,
    "user_id": user_id,
    "created_at": created_at,
    "updated_at": updated_at,
  };
}

class Tracker extends TrackerEntity {
  Tracker({
    required super.device_id,
    required super.protocol,
    required super.ip,
    required super.sim_no,
    required super.params,
    required super.port,
    required super.network_protocol,
    required super.vehicle_id,
  });
  factory Tracker.fromJson(Map<String, dynamic> json) => Tracker(
    device_id: json["device_id"],
    protocol: json["protocol"],
    ip: json['ip'],
    sim_no: json["sim_no"] ?? "",
    params: json["params"],
    port: json["port"],
    network_protocol: json["network_protocol"] ?? "",
    vehicle_id: json["vehicle_id"],
  );

  Map<String, dynamic> toJson() => {
    "device_id": device_id,
    "protocol": protocol,
    "ip": ip,
    "simNo": sim_no,
    "params": params,
    "port": port,
    "network_protocol": network_protocol,
    "vehicle_id": vehicle_id,
  };
}

class Link extends LinkEntity {
  Link({
    required super.url,
    required super.label,
    required super.active,
  });
  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
