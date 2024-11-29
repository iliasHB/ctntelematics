
import '../../../domain/entitties/resp_entities/get_schedule_resp_entity.dart';

class GetScheduleRespModel extends GetScheduleRespEntity{

  GetScheduleRespModel({
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

  GetScheduleRespModel copyWith({
    int? current_page,
    List<Datum>? data,
    String? first_page_url,
    int? from,
    int? last_page,
    String? last_page_url,
    List<Link>? links,
    dynamic next_page_url,
    String? path,
    int? per_page,
    dynamic prev_page_url,
    int? to,
    int? total,
  }) =>
      GetScheduleRespModel(
        current_page: current_page ?? this.current_page,
        data: data ?? this.data,
        first_page_url: first_page_url ?? this.first_page_url,
        from: from ?? this.from,
        last_page: last_page ?? this.last_page,
        last_page_url: last_page_url ?? this.last_page_url,
        links: links ?? this.links,
        next_page_url: next_page_url ?? this.next_page_url,
        path: path ?? this.path,
        per_page: per_page ?? this.per_page,
        prev_page_url: prev_page_url ?? this.prev_page_url,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  factory GetScheduleRespModel.fromJson(Map<String, dynamic> json) => GetScheduleRespModel(
    current_page: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    first_page_url: json["first_page_url"],
    from: json["from"],
    last_page: json["last_page"],
    last_page_url: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
    next_page_url: json["next_page_url"],
    path: json["path"],
    per_page: json["per_page"],
    prev_page_url: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
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

class Datum extends DatumEntity{

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
    required super.maintenance,
    required super.owner,
    required super.tracker,
    required super.last_location,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    brand: json["brand"],
    model: json["model"],
    year: json["year"],
    type: json["type"],
    vin: json["vin"],
    number_plate: json["number_plate"],
    user_id: json["user_id"],
    vehicle_owner_id: json["vehicle_owner_id"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
    driver: json["driver"] is Map<String, dynamic>
        ? Driver.fromMap(json["driver"])
        : null,
    maintenance:
    // json["maintenance"] is List<Map<String, dynamic>>
    //     ? List<Maintenance>.from(json['maintenance'].map((e) => Maintenance.fromMap(e)))
    //     : null,
    List<Maintenance>.from(json["maintenance"].map((x) => Maintenance.fromMap(x))),
    owner: json["owner"] is Map<String, dynamic>
        ? Owner.fromMap(json["owner"])
        : null,
    //Owner.fromMap(json["owner"]),
    tracker: json["tracker"] is Map<String, dynamic>
        ? Tracker.fromMap(json["tracker"])
        : null,
    // Tracker.fromMap(json["tracker"]),
    last_location: json["last_location"] is Map<String, dynamic>
        ? LastLocation.fromMap(json["last_location"])
        : null,
    // LastLocation.fromMap(json["last_location"]),
  );

  Map<String, dynamic> toMap() => {
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
    "maintenance": maintenance,
    "owner": owner,
    "tracker": tracker,
    "last_location": last_location,
  };
}

class Driver extends DriverEntity{

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

  factory Driver.fromMap(Map<String, dynamic> json) => Driver(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    vehicle_vin: json["vehicle_vin"],
    vehicle_id: json["vehicle_id"],
    pin: json["pin"],
    country: json["country"],
    licence_number: json["licence_number"],
    licence_issue_date: json["licence_issue_date"],
    licence_expiry_date: json["licence_expiry_date"],
    guarantor_name: json["guarantor_name"],
    guarantor_phone: json["guarantor_phone"],
    profile_picture_path: json["profile_picture_path"],
    driving_licence_path: json["driving_licence_path"],
    pin_path: json["pin_path"],
    miscellaneous_path: json["miscellaneous_path"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "vehicle_vin": vehicle_vin,
    "vehicle_id": vehicle_id,
    "pin": pin,
    "country": country,
    "licence_number": licence_number,
    "licence_issue_date": licence_issue_date,
    "licence_expiry_date": licence_expiry_date,
    "guarantor_name": guarantor_name,
    "guarantor_phone": guarantor_phone,
    "profile_picture_path": profile_picture_path,
    "driving_licence_path": driving_licence_path,
    "pin_path": pin_path,
    "miscellaneous_path": miscellaneous_path,
    "created_at": created_at,
    "updated_at": updated_at,
  };
}

class LastLocation extends LastLocationEntity{
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
    required super.terminal_info,
    required super.voltage_level,
    required super.gsm_signal_strength,
    required super.response_msg,
    required super.status,
    required super.created_at,
    required super.updated_at,
  });

  factory LastLocation.fromMap(Map<String, dynamic> json) => LastLocation(
    vehicle_id: json["vehicle_id"],
    tracker_id: json["tracker_id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    speed: json["speed"],
    speed_unit: json["speed_unit"],
    course: json["course"],
    fix_time: DateTime.parse(json["fix_time"]),
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
    terminal_info: json["terminal_info"],
    voltage_level: json["voltage_level"],
    gsm_signal_strength: json["gsm_signal_strength"],
    response_msg: json["response_msg"],
    status: json["status"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
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
    "cell_id": cell_id,
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
  };
}

class Maintenance extends MaintenanceEntity{

  Maintenance({
    required super.id,
    required super.description,
    required super.vehicle_vin,
    required super.schedule_type,
    required super.no_time,
    required super.no_kilometer,
    required super.no_hours,
    required super.category_time,
    required super.reminder_advance_days,
    required super.reminder_advance_km,
    required super.reminder_advance_hr,
    required super.start_date,
    required super.created_at,
    required super.updated_at,
  });

  factory Maintenance.fromMap(Map<String, dynamic> json) => Maintenance(
    id: json["id"],
    description: json["description"],
    vehicle_vin: json["vehicle_vin"],
    schedule_type: json["schedule_type"],
    no_time: json["no_time"],
    no_kilometer: json["no_kilometer"],
    no_hours: json["no_hours"],
    category_time: json["category_time"],
    reminder_advance_days: json["reminder_advance_days"],
    reminder_advance_km: json["reminder_advance_km"],
    reminder_advance_hr: json["reminder_advance_hr"],
    start_date: json["start_date"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "description": description,
    "vehicle_vin": vehicle_vin,
    "schedule_type": schedule_type,
    "no_time": no_time,
    "no_kilometer": no_kilometer,
    "no_hours": no_hours,
    "category_time": category_time,
    "reminder_advance_days": reminder_advance_days,
    "reminder_advance_km": reminder_advance_km,
    "reminder_advance_hr": reminder_advance_hr,
    "start_date": "startDate}",
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

  factory Owner.fromMap(Map<String, dynamic> json) => Owner(
    id: json["id"],
    first_name: json["first_name"],
    last_name: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    user_id: json["user_id"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
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

class Tracker extends TrackerEntity{

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

  factory Tracker.fromMap(Map<String, dynamic> json) => Tracker(
    device_id: json["device_id"],
    protocol: json["protocol"],
    ip: json["ip"],
    sim_no: json["sim_no"],
    params: json["params"],
    port: json["port"],
    network_protocol: json["network_protocol"],
    vehicle_id: json["vehicle_id"],
  );

  Map<String, dynamic> toMap() => {
    "device_id": device_id,
    "protocol": protocol,
    "ip": ip,
    "sim_no": sim_no,
    "params": params,
    "port": port,
    "network_protocol": network_protocol,
    "vehicle_id": vehicle_id,
  };
}

class Link extends LinkEntity{
  Link({
    required super.url,
    required super.label,
    required super.active,
  });

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      Link(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );

  factory Link.fromMap(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toMap() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

