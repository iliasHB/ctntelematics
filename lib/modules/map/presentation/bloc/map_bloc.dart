
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/route_history_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/route_history_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/usecases/map_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/map_data_state.dart';
import '../../domain/entitties/req_entities/send_location_resp_entity.dart';
import '../../domain/entitties/resp_entities/resp_entity.dart';

part 'map_event.dart';
part 'map_state.dart';

class LastLocationBloc extends Bloc<MapEvent, MapState>{

  final GetLastLocationUseCase getLastLocationUseCase;

  LastLocationBloc(this.getLastLocationUseCase) : super(MapInitial()) {
    on<LastLocationEvent>((event, emit) => emit.forEach<MapState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => MapFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<MapState> mapEventToState(LastLocationEvent event) async* {
    yield MapLoading();
    try {
      var resp = await getLastLocationUseCase(event.tokenReqEntity);
      yield GetLastLocationDone(resp);
    } catch (error) {
      print('error>>>>>>>000000: $error');
      if (error is ApiErrorException) {
        yield MapFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield MapFailure(error.message); // Emit network failure message
      }
      else {
        yield MapFailure(error.toString()); // Emit generic error message
      }
    }
  }
}


// class RouteHistoryBloc extends Bloc<MapEvent, MapState>{
//
//   final GetRouteHistoryUseCase getRouteHistoryUseCase;
//
//   RouteHistoryBloc(this.getRouteHistoryUseCase) : super(MapInitial()) {
//     on<RouteHistoryEvent>((event, emit) => emit.forEach<MapState>(
//       mapEventToState(event),
//       onData: (state) => state,
//       onError: (error, stackTrace) => MapFailure(error.toString()), // Handle error cases
//     ));
//   }
//
//   Stream<MapState> mapEventToState(RouteHistoryEvent event) async* {
//     yield MapLoading();
//     try {
//       var resp = await getRouteHistoryUseCase(event.routeHistoryReqEntity);
//       yield GetRouteHistoryDone(resp);
//     } catch (error) {
//       if (error is ApiErrorException) {
//         yield MapFailure(error.message); // Emit API error message
//       } else if (error is NetworkException) {
//         yield MapFailure(error.message); // Emit network failure message
//       }
//       else {
//         yield MapFailure(error.toString()); // Emit generic error message
//       }
//     }
//   }
// }


class SendLocationBloc extends Bloc<MapEvent, MapState>{

  final SendLocationUseCase sendLocationUseCase;

  SendLocationBloc(this.sendLocationUseCase) : super(MapInitial()) {
    on<SendLocationEvent>((event, emit) => emit.forEach<MapState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => MapFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<MapState> mapEventToState(SendLocationEvent event) async* {
    yield MapLoading();
    try {
      var resp = await sendLocationUseCase(event.sendLocationReqEntity);
      yield SendLocationDone(resp);
    } catch (error) {
      if (error is ApiErrorException) {
        yield MapFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield MapFailure(error.message); // Emit network failure message
      }
      else {
        yield MapFailure(error.toString()); // Emit generic error message
      }
    }
  }
}