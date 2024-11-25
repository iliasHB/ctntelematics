import 'package:equatable/equatable.dart';

class GetPaymentRespEntity extends Equatable{

  final bool success;
  final String authorization_url;
  GetPaymentRespEntity({
    required this.success,
    required this.authorization_url,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    success, authorization_url
  ];

}