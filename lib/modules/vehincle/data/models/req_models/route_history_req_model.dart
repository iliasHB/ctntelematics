

class VehicleRouteHistoryReqModel {
  final String vehicle_vin;
  final String time_from;
  final String time_to;
  final String token;

  VehicleRouteHistoryReqModel({
    required this.vehicle_vin,
    required this.time_from,
    required this.time_to,
    required this.token
  });

  factory VehicleRouteHistoryReqModel.fromJson(Map<String, dynamic> json) {
    return VehicleRouteHistoryReqModel(
      vehicle_vin: json['vehicle_vin'] ?? "",
      time_from: json['time_from'] ?? "",
      time_to: json['time_to'] ?? "",
      token: json['token'] ?? "",
    );
  }

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