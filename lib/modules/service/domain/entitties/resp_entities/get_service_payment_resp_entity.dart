import 'package:equatable/equatable.dart';

class GetServicePaymentRespEntity extends Equatable {
  final bool success;
  final String authorization_url;
  final String access_code;
  final String reference;
  GetServicePaymentRespEntity(
      {required this.success,
      required this.authorization_url,
      required this.access_code,
      required this.reference});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [success, authorization_url, access_code, reference];
}
