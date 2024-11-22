
class VehicleRouteHistoryReqEntity {
  final String vehicle_vin;
  final String time_from;
  final String time_to;
  final String token;

  VehicleRouteHistoryReqEntity({
    required this.vehicle_vin,
    required this.time_from,
    required this.time_to,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
    vehicle_vin: "vehicle_vin",
    time_from: "time_from",
    time_to: "time_to",
    token: "token",
  };

  @override
  // TODO: implement props
  List<Object?> get props => [vehicle_vin, time_from, time_to, token];
}