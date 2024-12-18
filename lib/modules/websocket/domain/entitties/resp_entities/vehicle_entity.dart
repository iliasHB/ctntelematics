

class VehicleEntity {
  final int id;
  final LocationInfo locationInfo;

  VehicleEntity({
    required this.id,
    required this.locationInfo,
  });

  factory VehicleEntity.fromJson(Map<String, dynamic> json) {
    return VehicleEntity(
      id: json['id'],
      locationInfo: LocationInfo.fromJson(json['location_info']),
    );
  }

  VehicleEntity copyWith({
    int? id,
    LocationInfo? locationInfo,
  }) {
    return VehicleEntity(
      id: id ?? this.id,
      locationInfo: locationInfo ?? this.locationInfo,
    );
  }
}

class LocationInfo {
  final int id;
  final String brand;
  final String model;
  final String year;
  final String type;
  final String vin;
  final String numberPlate;
  final int userId;
  final int vehicleOwnerId;
  final String createdAt;
  final String updatedAt;
  final Owner? owner;
  final String? speedLimit;
  final Tracker? tracker;
  final Geofence? withinGeofence;
  final String vehicleStatus;

  LocationInfo({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.type,
    required this.vin,
    required this.numberPlate,
    required this.userId,
    required this.vehicleOwnerId,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
    required this.speedLimit,
    required this.tracker,
    required this.withinGeofence,
    required this.vehicleStatus,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      type: json['type'],
      vin: json['vin'],
      numberPlate: json['number_plate'],
      userId: json['user_id'],
      vehicleOwnerId: json['vehicle_owner_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      owner:  json["owner"] is Map<String, dynamic>
          ? Owner.fromJson(json['owner'])
          : null,
      speedLimit: json['speed_limit'],
      tracker: json["tracker"] is Map<String, dynamic>
          ? Tracker.fromJson(json['tracker'])
          : null,
      withinGeofence: json["within_geofence"] is Map<String, dynamic>
          ? Geofence.fromJson(json['within_geofence'])
          : null,

      vehicleStatus: json['vehicle_status'],
    );
  }

  LocationInfo copyWith({
    int? id,
    String? brand,
    String? model,
    String? year,
    String? type,
    String? vin,
    String? numberPlate,
    int? userId,
    int? vehicleOwnerId,
    String? createdAt,
    String? updatedAt,
    Owner? owner,
    String? speedLimit,
    Tracker? tracker,
    Geofence? withinGeofence,
    String? vehicleStatus,
  }) {
    return LocationInfo(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      type: type ?? this.type,
      vin: vin ?? this.vin,
      numberPlate: numberPlate ?? this.numberPlate,
      userId: userId ?? this.userId,
      vehicleOwnerId: vehicleOwnerId ?? this.vehicleOwnerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      owner: owner ?? this.owner,
      speedLimit: speedLimit ?? this.speedLimit,
      tracker: tracker ?? this.tracker,
      withinGeofence: withinGeofence ?? this.withinGeofence,
      vehicleStatus: vehicleStatus ?? this.vehicleStatus,
    );
  }
}

class Owner {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  Owner({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  Owner copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Owner(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Tracker {
  final String? uniqueId;
  final String? status;
  final String? lastUpdate;
  final int? positionId;
  final Position? position;

  Tracker({
     this.uniqueId,
     this.status,
     this.lastUpdate,
     this.positionId,
     this.position,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      uniqueId: json['uniqueId'],
      status: json['status'],
      lastUpdate: json['lastUpdate'],
      positionId: json['positionId'],
      position: json["position"] is Map<String, dynamic>
          ? Position.fromJson(json['position'])
          : null,

    );
  }

  Tracker copyWith({
    String? uniqueId,
    String? status,
    String? lastUpdate,
    int? positionId,
    Position? position,
  }) {
    return Tracker(
      uniqueId: uniqueId ?? this.uniqueId,
      status: status ?? this.status,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      positionId: positionId ?? this.positionId,
      position: position ?? this.position,
    );
  }
}

class Position {
  final double? latitude;
  final double? longitude;
  final double? speed;
  final int? course;
  final double? altitude;
  final dynamic motion;
  final int? sat;
  final double? distance;
  final double? totalDistance;
  final String? address;
  final String? fixTime;
  final int? batteryLevel;
  final TerminalInfo? terminalInfo;
  final int? gsmRssi;
  final String? parseTime;
  final dynamic ignition;

  Position({
     this.latitude,
     this.longitude,
     this.speed,
     this.course,
     this.altitude,
     this.motion,
     this.sat,
     this.distance,
     this.totalDistance,
     this.address,
     this.fixTime,
     this.batteryLevel,
     this.terminalInfo,
     this.gsmRssi,
     this.parseTime,
     this.ignition,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: json['speed'].toDouble(),
      course: json['course'],
      altitude: json['altitude'].toDouble(),
      motion: json['motion'],
      sat: json['sat'],
      distance: json['distance'].toDouble(),
      totalDistance: json['total_distance'].toDouble(),
      address: json['address'],
      fixTime: json['fix_time'],
      batteryLevel: json['battery_level'],
      terminalInfo: json["terminal_info"] is Map<String, dynamic>
          ? TerminalInfo.fromJson(json['terminal_info'])
          : null,

      gsmRssi: json['gsm_rssi'],
      parseTime: json['parse_time'],
      ignition: json['ignition'],
    );
  }
  Position copyWith({
    double? latitude,
    double? longitude,
    double? speed,
    int? course,
    double? altitude,
    dynamic motion,
    int? sat,
    double? distance,
    double? totalDistance,
    String? address,
    String? fixTime,
    int? batteryLevel,
    TerminalInfo? terminalInfo,
    int? gsmRssi,
    String? parseTime,
    dynamic ignition,
  }) {
    return Position(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      course: course ?? this.course,
      altitude: altitude ?? this.altitude,
      motion: motion ?? this.motion,
      sat: sat ?? this.sat,
      distance: distance ?? this.distance,
      totalDistance: totalDistance ?? this.totalDistance,
      address: address ?? this.address,
      fixTime: fixTime ?? this.fixTime,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      terminalInfo: terminalInfo ?? this.terminalInfo,
      gsmRssi: gsmRssi ?? this.gsmRssi,
      parseTime: parseTime ?? this.parseTime,
      ignition: ignition ?? this.ignition,
    );
  }
}

class TerminalInfo {
  final String radioType;
  final bool considerIp;
  final List<CellTower>? cellTowers;

  TerminalInfo({
    required this.radioType,
    required this.considerIp,
    required this.cellTowers,
  });

  factory TerminalInfo.fromJson(Map<String, dynamic> json) {
    return TerminalInfo(
      radioType: json['radioType'],
      considerIp: json['considerIp'],
      cellTowers: (json['cellTowers'] as List)
          .map((tower) => CellTower.fromJson(tower))
          .toList(),
    );
  }
  TerminalInfo copyWith({
    String? radioType,
    bool? considerIp,
    List<CellTower>? cellTowers,
  }) {
    return TerminalInfo(
      radioType: radioType ?? this.radioType,
      considerIp: considerIp ?? this.considerIp,
      cellTowers: cellTowers ?? this.cellTowers,
    );
  }
}

class CellTower {
  final int cellId;
  final int locationAreaCode;
  final int mobileCountryCode;
  final int mobileNetworkCode;

  CellTower({
    required this.cellId,
    required this.locationAreaCode,
    required this.mobileCountryCode,
    required this.mobileNetworkCode,
  });

  factory CellTower.fromJson(Map<String, dynamic> json) {
    return CellTower(
      cellId: json['cellId'],
      locationAreaCode: json['locationAreaCode'],
      mobileCountryCode: json['mobileCountryCode'],
      mobileNetworkCode: json['mobileNetworkCode'],
    );
  }
  CellTower copyWith({
    int? cellId,
    int? locationAreaCode,
    int? mobileCountryCode,
    int? mobileNetworkCode,
  }) {
    return CellTower(
      cellId: cellId ?? this.cellId,
      locationAreaCode: locationAreaCode ?? this.locationAreaCode,
      mobileCountryCode: mobileCountryCode ?? this.mobileCountryCode,
      mobileNetworkCode: mobileNetworkCode ?? this.mobileNetworkCode,
    );
  }
}

class Geofence {
  final List<Coordinate> coordinates;
  final String zone;
  final bool isInGeofence;
  final CircleData circleData;

  Geofence({
    required this.coordinates,
    required this.zone,
    required this.isInGeofence,
    required this.circleData,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) {
    return Geofence(
      coordinates: (json['coordinates'] as List)
          .map((coord) => Coordinate.fromJson(coord))
          .toList(),
      zone: json['zone'],
      isInGeofence: json['is_in_geofence'],
      circleData: CircleData.fromJson(json['circle_data']),
    );
  }
  Geofence copyWith({
    List<Coordinate>? coordinates,
    String? zone,
    bool? isInGeofence,
    CircleData? circleData,
  }) {
    return Geofence(
      coordinates: coordinates ?? this.coordinates,
      zone: zone ?? this.zone,
      isInGeofence: isInGeofence ?? this.isInGeofence,
      circleData: circleData ?? this.circleData,
    );
  }
}

class Coordinate {
  final double lng;
  final double lat;

  Coordinate({
    required this.lng,
    required this.lat,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      lng: json['lng'],
      lat: json['lat'],
    );
  }

  Coordinate copyWith({
    double? lng,
    double? lat,
  }) {
    return Coordinate(
      lng: lng ?? this.lng,
      lat: lat ?? this.lat,
    );
  }
}

class CircleData {
  final CenterPoint center;
  final double radius;

  CircleData({
    required this.center,
    required this.radius,
  });

  factory CircleData.fromJson(Map<String, dynamic> json) {
    return CircleData(
      center: CenterPoint.fromJson(json['center']),
      radius: json['radius'],
    );
  }

  CircleData copyWith({
    CenterPoint? center,
    double? radius,
  }) {
    return CircleData(
      center: center ?? this.center,
      radius: radius ?? this.radius,
    );
  }
}

class CenterPoint {
  final double lat;
  final double lng;

  CenterPoint({
    required this.lat,
    required this.lng,
  });

  factory CenterPoint.fromJson(Map<String, dynamic> json) {
    return CenterPoint(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
  CenterPoint copyWith({
    double? lat,
    double? lng,
  }) {
    return CenterPoint(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

///-----------------------------
///

// import 'dart:convert';
//
// class VehicleEntity {
//   final int id;
//   final LocationInfo locationInfo;
//
//   VehicleEntity({
//     required this.id,
//     required this.locationInfo,
//   });
//
//   factory VehicleEntity.fromJson(Map<String, dynamic> json) {
//     return VehicleEntity(
//       id: json['id'],
//       locationInfo: LocationInfo.fromJson(json['location_info']),
//     );
//   }
// }
//
// class LocationInfo {
//   final int id;
//   final String brand;
//   final String model;
//   final String year;
//   final String type;
//   final String vin;
//   final String numberPlate;
//   final int userId;
//   final int vehicleOwnerId;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final Owner owner;
//   final String speedLimit;
//   final Tracker tracker;
//
//   LocationInfo({
//     required this.id,
//     required this.brand,
//     required this.model,
//     required this.year,
//     required this.type,
//     required this.vin,
//     required this.numberPlate,
//     required this.userId,
//     required this.vehicleOwnerId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.owner,
//     required this.speedLimit,
//     required this.tracker,
//   });
//
//   factory LocationInfo.fromJson(Map<String, dynamic> json) {
//     return LocationInfo(
//       id: json['id'],
//       brand: json['brand'],
//       model: json['model'],
//       year: json['year'],
//       type: json['type'],
//       vin: json['vin'],
//       numberPlate: json['number_plate'],
//       userId: json['user_id'],
//       vehicleOwnerId: json['vehicle_owner_id'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       owner: Owner.fromJson(json['owner']),
//       speedLimit: json['speed_limit'],
//       tracker: Tracker.fromJson(json['tracker']),
//     );
//   }
// }
//
// class Owner {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//   final int userId;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Owner({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     required this.userId,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Owner.fromJson(Map<String, dynamic> json) {
//     return Owner(
//       id: json['id'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       email: json['email'],
//       phone: json['phone'],
//       userId: json['user_id'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//     );
//   }
// }
//
// class Tracker {
//   final String uniqueId;
//   final String status;
//   final DateTime lastUpdate;
//   final int positionId;
//   final Position position;
//
//   Tracker({
//     required this.uniqueId,
//     required this.status,
//     required this.lastUpdate,
//     required this.positionId,
//     required this.position,
//   });
//
//   factory Tracker.fromJson(Map<String, dynamic> json) {
//     return Tracker(
//       uniqueId: json['uniqueId'],
//       status: json['status'],
//       lastUpdate: DateTime.parse(json['lastUpdate']),
//       positionId: json['positionId'],
//       position: Position.fromJson(json['position']),
//     );
//   }
// }
//
// class Position {
//   final double latitude;
//   final double longitude;
//   final double speed;
//   final int course;
//   final double altitude;
//   final bool? motion;
//   final int sat;
//   final double distance;
//   final double totalDistance;
//   final String address;
//   final DateTime fixTime;
//   final int batteryLevel;
//   final TerminalInfo terminalInfo;
//
//   Position({
//     required this.latitude,
//     required this.longitude,
//     required this.speed,
//     required this.course,
//     required this.altitude,
//     this.motion,
//     required this.sat,
//     required this.distance,
//     required this.totalDistance,
//     required this.address,
//     required this.fixTime,
//     required this.batteryLevel,
//     required this.terminalInfo,
//   });
//
//   factory Position.fromJson(Map<String, dynamic> json) {
//     return Position(
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       speed: json['speed'].toDouble(),
//       course: json['course'],
//       altitude: json['altitude'].toDouble(),
//       motion: json['motion'],
//       sat: json['sat'],
//       distance: json['distance'].toDouble(),
//       totalDistance: json['total_distance'].toDouble(),
//       address: json['address'],
//       fixTime: DateTime.parse(json['fix_time']),
//       batteryLevel: json['battery_level'],
//       terminalInfo: TerminalInfo.fromJson(jsonDecode(json['terminal_info'])),
//     );
//   }
// }
//
// class TerminalInfo {
//   final String radioType;
//   final bool considerIp;
//   final List<CellTower> cellTowers;
//
//   TerminalInfo({
//     required this.radioType,
//     required this.considerIp,
//     required this.cellTowers,
//   });
//
//   factory TerminalInfo.fromJson(Map<String, dynamic> json) {
//     return TerminalInfo(
//       radioType: json['radioType'],
//       considerIp: json['considerIp'],
//       cellTowers: (json['cellTowers'] as List)
//           .map((tower) => CellTower.fromJson(tower))
//           .toList(),
//     );
//   }
// }
//
// class CellTower {
//   final int cellId;
//   final int locationAreaCode;
//   final int mobileCountryCode;
//   final int mobileNetworkCode;
//
//   CellTower({
//     required this.cellId,
//     required this.locationAreaCode,
//     required this.mobileCountryCode,
//     required this.mobileNetworkCode,
//   });
//
//   factory CellTower.fromJson(Map<String, dynamic> json) {
//     return CellTower(
//       cellId: json['cellId'],
//       locationAreaCode: json['locationAreaCode'],
//       mobileCountryCode: json['mobileCountryCode'],
//       mobileNetworkCode: json['mobileNetworkCode'],
//     );
//   }
// }




///-----------------------------

// class VehicleEntity {
//   final int id;
//   final VehicleInfo locationInfo;
//
//   VehicleEntity({
//     required this.id,
//     required this.locationInfo,
//   });
//
//   factory VehicleEntity.fromJson(Map<String, dynamic> json) {
//     return VehicleEntity(
//       id: json['id'],
//       locationInfo: VehicleInfo.fromJson(json['location_info']),
//     );
//   }
// }
//
// class VehicleInfo {
//   final String brand;
//   final String model;
//   final String vin;
//   final String numberPlate;
//   final Tracker tracker;
//   final bool isInGeofence;
//
//   VehicleInfo({
//     required this.brand,
//     required this.model,
//     required this.vin,
//     required this.numberPlate,
//     required this.tracker,
//     required this.isInGeofence,
//   });
//
//   factory VehicleInfo.fromJson(Map<String, dynamic> json) {
//     return VehicleInfo(
//       brand: json['brand'],
//       model: json['model'],
//       vin: json['vin'],
//       numberPlate: json['number_plate'],
//       tracker: Tracker.fromJson(json['tracker']),
//       isInGeofence: json['within_geofence']['is_in_geofence'],
//     );
//   }
// }
//
// class Tracker {
//   final String status;
//   final double latitude;
//   final double longitude;
//   final dynamic speed;
//
//   Tracker({
//     required this.status,
//     required this.latitude,
//     required this.longitude,
//     required this.speed,
//   });
//
//   factory Tracker.fromJson(Map<String, dynamic> json) {
//     return Tracker(
//       status: json['status'],
//       latitude: json['position']['latitude'],
//       longitude: json['position']['longitude'],
//       speed: json['position']['speed'],
//     );
//   }
// }
