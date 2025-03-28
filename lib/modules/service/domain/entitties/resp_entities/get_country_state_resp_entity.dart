
import 'package:equatable/equatable.dart';

class GetCountryStateEntity extends Equatable{
  final List<LocationEntity> locations;

  const GetCountryStateEntity({
    required this.locations,
  });

  @override
  // TODO: implement props
  List<Object?> get props => locations;

}

class LocationEntity extends Equatable {
  final dynamic state;
  final List<String> localGovt;

  const LocationEntity({
    required this.state,
    required this.localGovt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    state, localGovt
  ];

}
