import '../../../domain/entitties/resp_entities/request_service_resp_entity.dart';

class RequestServiceRespModel extends RequestServiceRespEntity{
  RequestServiceRespModel(
      {required super.success,
        required super.message,});

  factory RequestServiceRespModel.fromJson(Map<String, dynamic> json) {
    return RequestServiceRespModel(
      success: json['success'] ?? "",
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };

}
