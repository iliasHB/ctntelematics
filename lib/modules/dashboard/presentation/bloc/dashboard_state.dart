
part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardDone extends DashboardState {
  final DashVehicleRespEntity resp;

  const DashboardDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class VehicleTripDone extends DashboardState {
  final List<GetTripRespEntity> resp;
  // List<GetTripRespModel> resp;
  const VehicleTripDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class DashboardFailure extends DashboardState {
  final String message;

  const DashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}
