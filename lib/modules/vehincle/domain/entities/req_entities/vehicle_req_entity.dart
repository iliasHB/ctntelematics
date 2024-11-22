import 'package:equatable/equatable.dart';

class VehicleReqEntity extends Equatable{
  final String token;
  final String contentType;

  const VehicleReqEntity({
    required this.token,
    required this.contentType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType];

}