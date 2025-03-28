import 'package:equatable/equatable.dart';

class TokenReqModel extends Equatable{
  final String token;
  final String? contentType;
  final String? vehicle_vin;
  final String? serviceId;

  const TokenReqModel({
    required this.token, this.contentType, this.vehicle_vin, this.serviceId
  });

  factory TokenReqModel.fromJson(Map<String, dynamic> json) {
    return TokenReqModel(
      token: json['token'] ?? "",
      contentType: json['contentType'] ?? "",
      vehicle_vin: json['vehicle_vin'] ?? "",
      serviceId: json['serviceId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "contentType": contentType,
    "vehicle_vin": vehicle_vin,
    "serviceId": serviceId
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType, vehicle_vin];
}
