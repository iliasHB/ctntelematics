import 'package:equatable/equatable.dart';

class EshopTokenReqEntity extends Equatable{
  final String token;
  final int? id;

  const EshopTokenReqEntity({
    required this.token, this.id
  });

  @override
  // TODO: implement props
  List<Object?> get props => [token, id];

}