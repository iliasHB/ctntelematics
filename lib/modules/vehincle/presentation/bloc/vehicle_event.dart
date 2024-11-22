part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class GetVehicleEvent extends VehicleEvent {
  final VehicleReqEntity vehicleReqEntity;

  const GetVehicleEvent(this.vehicleReqEntity);

  @override
  List<Object?> get props => [vehicleReqEntity];
}


class VehicleRouteHistoryEvent extends VehicleEvent {
  final VehicleRouteHistoryReqEntity routeHistoryReqEntity;

  const VehicleRouteHistoryEvent(this.routeHistoryReqEntity);

  @override
  List<Object?> get props => [routeHistoryReqEntity];
}
