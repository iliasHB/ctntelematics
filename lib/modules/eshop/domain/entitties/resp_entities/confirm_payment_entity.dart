import 'package:equatable/equatable.dart';

class ConfirmPaymentRespEntity extends Equatable {

  final String? success;
  final String? message;
  final String? status;

  const ConfirmPaymentRespEntity({
    required this.success,
    required this.message,
    required this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    success,
    message,
    status
  ];
}