import 'package:equatable/equatable.dart';

class GetPaymentRespEntity extends Equatable {
  final bool success;
  final String authorization_url;
  final String access_code;
  GetPaymentRespEntity(
      {required this.success,
      required this.authorization_url,
      required this.access_code});

  @override
  // TODO: implement props
  List<Object?> get props => [success, authorization_url, access_code];
}
