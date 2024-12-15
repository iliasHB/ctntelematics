
part of 'map_bloc.dart';

abstract class MapState extends Equatable{
  const MapState();

  @override
  List<Object?> get props => [];
}
// class InitialState extends MapState {
//   // Define properties if needed
// }

class MapInitial extends MapState {}

class MapLoading extends MapState{}

class MapFailure extends MapState{
  final String message;

  const MapFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetLastLocationDone extends MapState{
  final List<LastLocationRespEntity> resp;

  const GetLastLocationDone(this.resp);

  @override
  List<Object?> get props => [resp];

}
class GetRouteHistoryDone extends MapState{
  final RouteHistoryRespEntity resp;

  const GetRouteHistoryDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class SendLocationDone extends MapState{
  final RespEntity resp;

  const SendLocationDone(this.resp);

  @override
  List<Object?> get props => [resp];

}