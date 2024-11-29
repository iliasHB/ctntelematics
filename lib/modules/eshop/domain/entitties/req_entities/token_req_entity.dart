import 'package:equatable/equatable.dart';

class EshopTokenReqEntity extends Equatable{
  final String? token;
  final int? id;
  final String? reference;

  const EshopTokenReqEntity({
    this.token, this.id, this.reference
  });

  @override
  // TODO: implement props
  List<Object?> get props => [token, id, reference];

}