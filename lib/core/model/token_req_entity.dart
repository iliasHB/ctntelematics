import 'package:equatable/equatable.dart';

class TokenReqEntity extends Equatable{
  final String token;
  String? contentType;
  String? vehicle_vin;
  String? serviceId;

  TokenReqEntity({
    required this.token, this.contentType, this.vehicle_vin, this.serviceId
  });

  Map<String, dynamic> toJson() => {
    "token": token,
    "contentType": contentType,
    "vehicle_vin": vehicle_vin,
    "serviceId": serviceId
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType, vehicle_vin, serviceId];
}
