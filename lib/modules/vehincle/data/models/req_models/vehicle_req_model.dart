import 'package:equatable/equatable.dart';

class VehicleReqModel extends Equatable{
  final String token;
  final String contentType;

  const VehicleReqModel({
    required this.token,
    required this.contentType,
  });

  factory VehicleReqModel.fromJson(Map<String, dynamic> json) {
    return VehicleReqModel(
      token: json['token'] ?? "",
      contentType: json['contentType'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "contentType": contentType,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType];

}