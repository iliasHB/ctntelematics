
import '../../../domain/entitties/resp_entities/get_country_state_resp_entity.dart';

class GetCountryStateModel extends GetCountryStateEntity{

  const GetCountryStateModel({
    required super.locations,
  });

  factory GetCountryStateModel.fromJson(Map<String, dynamic> json) => GetCountryStateModel(
    locations: List<Location>.from(json["locations"].map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "locations": locations
  };
}

class Location extends LocationEntity{

  Location({
    required super.state,
    required super.localGovt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    state: json["state"] ?? "",
    localGovt: List<String>.from(json["localGovt"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "localGovt": List<dynamic>.from(localGovt.map((x) => x)),
  };
}
