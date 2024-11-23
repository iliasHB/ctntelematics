

import 'package:equatable/equatable.dart';

class GetTripRespEntity extends Equatable {
  final dynamic id;
  final dynamic tripId;
  final dynamic name;
  final dynamic driverId;
  final dynamic vehicleVin;
  final dynamic description;
  final dynamic createdAt;
  final dynamic updatedAt;
  final List<TripLocationEntity> tripLocations;

  GetTripRespEntity({
    required this.id,
    required this.tripId,
    required this.name,
    required this.driverId,
    required this.vehicleVin,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.tripLocations,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
  id,
  tripId,
  name,
  driverId,
  vehicleVin,
  description,
  createdAt,
  updatedAt,
  tripLocations,
  ];

}

class TripLocationEntity extends Equatable{
  final int id;
  final int tripId;
  final String startLocation;
  final String startLon;
  final String startLat;
  final String endLocation;
  final String endLat;
  final String endLon;
  final String departureTime;
  final String arrivalTime;
  final String createdAt;
  final String updatedAt;

  TripLocationEntity({
    required this.id,
    required this.tripId,
    required this.startLocation,
    required this.startLon,
    required this.startLat,
    required this.endLocation,
    required this.endLat,
    required this.endLon,
    required this.departureTime,
    required this.arrivalTime,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
  id,
  tripId,
  startLocation,
    startLon,
  startLat,
  endLocation,
  endLat,
  endLon,
  departureTime,
  arrivalTime,
  createdAt,
  updatedAt,
  ];
}