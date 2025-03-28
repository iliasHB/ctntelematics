import 'package:equatable/equatable.dart';

class GetServicesRespEntity extends Equatable {
  final dynamic name;
  final dynamic id;
  final ChargeEntity charge;

  const GetServicesRespEntity({
    required this.name,
    required this.id,
    required this.charge,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name, id, charge
  ];
}

class ChargeEntity extends Equatable {
  final dynamic name;
  final dynamic fee;

  const ChargeEntity({
    required this.name,
    required this.fee,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name, fee
  ];

}
