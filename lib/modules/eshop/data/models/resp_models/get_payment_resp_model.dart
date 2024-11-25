// "success": true,
// "authorization_url": "https://checkout.paystack.com/1sbb174tt651e8e"


import '../../../domain/entitties/resp_entities/get_payment_resp_entity.dart';

class GetPaymentRespModel extends GetPaymentRespEntity{

  GetPaymentRespModel({
    required super.success,
    required super.authorization_url,
  });

  factory GetPaymentRespModel.fromJson(Map<String, dynamic> json) => GetPaymentRespModel(
    success: json["success"],
    authorization_url: json["authorization_url"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "authorization_url": authorization_url,
  };
}