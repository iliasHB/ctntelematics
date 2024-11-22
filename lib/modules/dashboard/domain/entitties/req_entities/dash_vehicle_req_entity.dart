import 'package:equatable/equatable.dart';

class DashVehicleReqEntity extends Equatable{
  final String token;
  final String contentType;

  const DashVehicleReqEntity({
    required this.token,
    required this.contentType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType];

}