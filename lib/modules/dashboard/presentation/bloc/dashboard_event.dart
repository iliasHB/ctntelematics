part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashVehicleEvent extends DashboardEvent {
  final DashVehicleReqEntity dashVehicleReqEntity;

  const DashVehicleEvent(this.dashVehicleReqEntity);

  @override
  List<Object?> get props => [dashVehicleReqEntity];
}

