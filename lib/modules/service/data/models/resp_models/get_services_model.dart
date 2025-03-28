import '../../../domain/entitties/resp_entities/get_services_entity.dart';

class GetServicesRespModel extends GetServicesRespEntity{
  GetServicesRespModel({
    required super.name,
    required super.id,
    required super.charge,
  });

  factory GetServicesRespModel.fromJson(Map<String, dynamic> json) => GetServicesRespModel(
    name: json["name"] ?? "",
    id: json["id"] ?? "",
    charge: ChargeModel.fromJson(json["charge"],)
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "charge": charge,
  };
}

class ChargeModel extends ChargeEntity{
  ChargeModel({
    required super.name,
    required super.fee,
  });

  factory ChargeModel.fromJson(Map<String, dynamic> json) => ChargeModel(
      name: json["name"] ?? "",
      fee: json["fee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "fee": fee,
  };
}
