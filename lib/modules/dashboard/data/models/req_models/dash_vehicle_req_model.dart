import 'package:equatable/equatable.dart';

class DashVehicleReqModel extends Equatable{
  final String token;
  final String contentType;

  const DashVehicleReqModel({
    required this.token,
    required this.contentType,
  });

  factory DashVehicleReqModel.fromJson(Map<String, dynamic> json) {
    return DashVehicleReqModel(
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