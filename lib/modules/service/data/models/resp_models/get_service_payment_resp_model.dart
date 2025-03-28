
import '../../../domain/entitties/resp_entities/get_service_payment_resp_entity.dart';

class GetServicePaymentRespModel extends GetServicePaymentRespEntity{

  GetServicePaymentRespModel({
    required super.success,
    required super.authorization_url,
    required super.access_code,
    required super.reference,
  });

  factory GetServicePaymentRespModel.fromJson(Map<String, dynamic> json) => GetServicePaymentRespModel(
    success: json["success"],
    authorization_url: json["authorization_url"],
    access_code: json["access_code"],
    reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "authorization_url": authorization_url,
    "access_code": access_code,
    "reference": reference
  };
}