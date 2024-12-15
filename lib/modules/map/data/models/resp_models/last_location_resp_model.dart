import 'dart:convert';

import '../../../domain/entitties/resp_entities/last_location_resp_entity.dart';

List<LastLocationRespModel> lastLocationRespModelFromJson(String str) =>
    List<LastLocationRespModel>.from(
        json.decode(str).map((x) => LastLocationRespModel.fromJson(x)));

String lastLocationRespModelToJson(List<LastLocationRespModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LastLocationRespModel extends LastLocationRespEntity {
  LastLocationRespModel({
    required super.vehicle,
  });

  factory LastLocationRespModel.fromJson(Map<String, dynamic> json) =>
      LastLocationRespModel(
        vehicle: json["vehicle"] is Map<String, dynamic> ? VehicleModel.fromJson(json["vehicle"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "vehicle": vehicle,
      };
}

class VehicleModel extends MapVehicleEntity {
  VehicleModel({
    required super.id,
    required super.details,
    required super.driver,
    required super.address,
    required super.geofence,
    required super.connected_status,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        details: json["details"] is Map<String, dynamic>
            ? DetailsModel.fromJson(json["details"])
            : null,
        driver: json["driver"] is Map<String, dynamic>
            ? DriverModel.fromJson(json["driver"])
            : null,
        address: json['address'],
        geofence: json["geofence"] is Map<String, dynamic>
            ? GeofenceModel.fromJson(json["geofence"])
            : null,
        connected_status: json["connected_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "details": details,
        "driver": driver,
        "address": address,
        "geofence": geofence,
        "connected_status": connected_status,
      };
}

class DetailsModel extends MapDetailsEntity {
  DetailsModel({
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
    required super.owner,
    required super.tracker,
    required super.last_location,
    required super.speed_limit,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
        id: json["id"],
        brand: json["brand"],
        model: json['model'],
        year: json["year"],
        type: json["type"],
        vin: json['vin'],
        number_plate: json['number_plate'],
        user_id: json["user_id"],
        vehicle_owner_id: json["vehicle_owner_id"],
        created_at: json['created_at'],
        updated_at: json["updated_at"],
        owner: json["owner"] is Map<String, dynamic>
            ? OwnerModel.fromJson(json["owner"])
            : null,

        tracker: json["tracker"] is Map<String, dynamic>
            ? TrackerModel.fromJson(json["tracker"])
            : null,

        last_location: json["last_location"] is Map<String, dynamic>
            ? LastLocationModel.fromJson(json["last_location"])
            : null,

        speed_limit: json["speed_limit"] is Map<String, dynamic>
            ? SpeedLimitModel.fromJson(json["speed_limit"])
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
        "owner": owner,
        "tracker": tracker,
        "lastLocation": last_location,
        "speed_limit": speed_limit
      };
}

class LastLocationModel extends MapLastLocationEntity {
  LastLocationModel({
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
  factory LastLocationModel.fromJson(Map<String, dynamic> json) =>
      LastLocationModel(
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

class OwnerModel extends MapOwnerEntity {
  OwnerModel({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.email,
    required super.phone,
    required super.user_id,
    required super.created_at,
    required super.updated_at,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
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

class SpeedLimitModel extends MapSpeedLimitEntity {
  // String speedLimit;

  SpeedLimitModel({
    required super.speed_limit,
  });

  factory SpeedLimitModel.fromJson(Map<String, dynamic> json) =>
      SpeedLimitModel(
        speed_limit: json["speed_limit"],
      );

  Map<String, dynamic> toJson() => {
        "speed_limit": speed_limit,
      };
}

class TrackerModel extends MapTrackerEntity {
  TrackerModel({
    required super.device_id,
    required super.protocol,
    required super.ip,
    required super.sim_no,
    required super.params,
    required super.port,
    required super.network_protocol,
    required super.vehicle_id,
  });

  factory TrackerModel.fromJson(Map<String, dynamic> json) => TrackerModel(
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

class DriverModel extends MapDriverEntity {
  DriverModel({
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

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
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

class GeofenceModel extends MapGeofenceEntity {
  GeofenceModel({
    required super.coordinates,
    required super.zone,
    required super.is_in_geofence,
    required super.circle_data,
  });

  factory GeofenceModel.fromJson(Map<String, dynamic> json) => GeofenceModel(
        coordinates: (json['coordinates'] as List).map((data) => CenterModel.fromJson(data)).toList(),
        // json["coordinates"] is List<Map<String, dynamic>>
        //     ? List<CenterModel>.from(json["coordinates"].map((x) => CenterModel.fromJson(x)))
        //     : null,
        zone: json["zone"],
        is_in_geofence: json['is_in_geofence'],
        circle_data: json["circle_data"] is Map<String, dynamic>
            ? CircleDataModel.fromJson(json["circle_data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates,
        "zone": zone,
        "is_in_geofence": is_in_geofence,
        "circle_data": circle_data,
      };
}

class CircleDataModel extends MapCircleDataEntity {
  CircleDataModel({
    required super.center,
    required super.radius,
  });

  factory CircleDataModel.fromJson(Map<String, dynamic> json) =>
      CircleDataModel(
        radius: json["radius"],
        center: json["center"] is Map<String, dynamic>
            ? CenterModel.fromJson(json["center"] ?? "")
            : null,
      );

  Map<String, dynamic> toJson() => {
        "radius": radius,
        "center": center,
      };
}

class CenterModel extends MapCenterEntity {
  CenterModel({
    required super.lng,
    required super.lat,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) => CenterModel(
        lng: json["lng"],
        lat: json["lat"],
      );

  Map<String, dynamic> toJson() => {
        "lng": lng,
        "lat": lat,
      };
}
