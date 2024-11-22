

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
