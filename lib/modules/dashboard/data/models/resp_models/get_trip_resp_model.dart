
import 'dart:convert';

import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/get_trip_resp_entity.dart';

List<GetTripRespModel> getTripRespModelFromJson(String str) => List<GetTripRespModel>.from(json.decode(str).map((x) => GetTripRespModel.fromJson(x)));

String getTripRespModelToJson(List<GetTripRespModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTripRespModel extends GetTripRespEntity{

  GetTripRespModel({
    required super.id,
    required super.tripId,
    required super.name,
    required super.driverId,
    required super.vehicleVin,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.tripLocations,
  });

  GetTripRespModel copyWith({
    int? id,
    String? tripId,
    String? name,
    int? driverId,
    String? vehicleVin,
    String? description,
    String? createdAt,
    String? updatedAt,
    List<TripLocation>? tripLocations,
  }) =>
      GetTripRespModel(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        name: name ?? this.name,
        driverId: driverId ?? this.driverId,
        vehicleVin: vehicleVin ?? this.vehicleVin,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        tripLocations: tripLocations ?? this.tripLocations,
      );

  factory GetTripRespModel.fromJson(Map<String, dynamic> json) => GetTripRespModel(
    id: json["id"],
    tripId: json["trip_id"],
    name: json["name"],
    driverId: json["driver_id"],
    vehicleVin: json["vehicle_vin"],
    description: json["description"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    tripLocations: json["trip_locations"] != null
        ? List<TripLocation>.from(
      (json["trip_locations"] as List<dynamic>).map(
            (x) => TripLocation.fromJson(x as Map<String, dynamic>),
      ),
    )
        : [], // Default to an empty list if null
    // tripLocations: List<TripLocation>.from(json["trip_locations"].map((x) => TripLocation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trip_id": tripId,
    "name": name,
    "driver_id": driverId,
    "vehicle_vin": vehicleVin,
    "description": description,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "trip_locations": tripLocations,
  };
}

class TripLocation extends TripLocationEntity{

  TripLocation({
    required super.id,
    required super.tripId,
    required super.startLocation,
    required super.startLon,
    required super.startLat,
    required super.endLocation,
    required super.endLat,
    required super.endLon,
    required super.departureTime,
    required super.arrivalTime,
    required super.createdAt,
    required super.updatedAt,
  });

  TripLocation copyWith({
    int? id,
    int? tripId,
    String? startLocation,
    String? startLon,
    String? startLat,
    String? endLocation,
    String? endLat,
    String? endLon,
    String? departureTime,
    String? arrivalTime,
    String? createdAt,
    String? updatedAt,
  }) =>
      TripLocation(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        startLocation: startLocation ?? this.startLocation,
        startLon: startLon ?? this.startLon,
        startLat: startLat ?? this.startLat,
        endLocation: endLocation ?? this.endLocation,
        endLat: endLat ?? this.endLat,
        endLon: endLon ?? this.endLon,
        departureTime: departureTime ?? this.departureTime,
        arrivalTime: arrivalTime ?? this.arrivalTime,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory TripLocation.fromJson(Map<String, dynamic> json) => TripLocation(
    id: json["id"],
    tripId: json["trip_id"],
    startLocation: json["start_location"],
    startLon: json["start_lon"],
    startLat: json["start_lat"],
    endLocation: json["end_location"],
    endLat: json["end_lat"],
    endLon: json["end_lon"],
    departureTime: json["departure_time"],
    arrivalTime: json["arrival_time"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trip_id": tripId,
    "start_location": startLocation,
    "start_lon": startLon,
    "start_lat": startLat,
    "end_location": endLocation,
    "end_lat": endLat,
    "end_lon": endLon,
    "departure_time": departureTime,
    "arrival_time": arrivalTime,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

