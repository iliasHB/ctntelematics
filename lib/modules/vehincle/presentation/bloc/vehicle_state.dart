
part of 'vehicle_bloc.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleFailure extends VehicleState {
  final String message;

  const VehicleFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleDone extends VehicleState {
  final VehicleRespEntity resp;

  const VehicleDone(this.resp);

  @override
  List<Object?> get props => [resp];
}


class GetVehicleRouteHistoryDone extends VehicleState{
  final VehicleRouteHistoryRespEntity resp;

  const GetVehicleRouteHistoryDone(this.resp);

  @override
  List<Object?> get props => [resp];
}