import '../../../domain/entitties/resp_entities/confirm_payment_entity.dart';

class ConfirmPaymentRespModel extends ConfirmPaymentRespEntity{

  ConfirmPaymentRespModel({
    required super.success,
    required super.message,
    required super.status,
  });

  factory ConfirmPaymentRespModel.fromJson(Map<String, dynamic> json) => ConfirmPaymentRespModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
  };
}