part of 'map_bloc.dart';

abstract class MapEvent extends Equatable{
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LastLocationEvent extends MapEvent {
  final TokenReqEntity tokenReqEntity;

  const LastLocationEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class RouteHistoryEvent extends MapEvent {
  final RouteHistoryReqEntity routeHistoryReqEntity;

  const RouteHistoryEvent(this.routeHistoryReqEntity);

  @override
  List<Object?> get props => [routeHistoryReqEntity];
}

class SendLocationEvent extends MapEvent {
  final SendLocationReqEntity sendLocationReqEntity;

  const SendLocationEvent(this.sendLocationReqEntity);

  @override
  List<Object?> get props => [sendLocationReqEntity];
}