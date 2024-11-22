
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/resp_entity.dart';

class RespModel extends RespEntity{

  RespModel({ required super.success, required super.message});

  factory RespModel.fromJson(Map<String, dynamic> json) => RespModel(
    success: json['success'],
    message: json["message"],
  );
  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}