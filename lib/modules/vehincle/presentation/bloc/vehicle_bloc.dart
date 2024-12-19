
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exception.dart';
// import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/vehicle_data_state.dart';
import '../../domain/entities/req_entities/route_history_req_entity.dart';
import '../../domain/entities/req_entities/vehicle_req_entity.dart';
import '../../domain/entities/resp_entities/route_history_resp_entity.dart';
import '../../domain/entities/resp_entities/vehicle_resp_entity.dart';
import '../../domain/usecases/vehicle_usecase.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

// class VehiclesBloc extends Bloc<VehicleEvent, VehicleState> {
//   final VehicleUseCase vehicleUseCase;
//
//   VehiclesBloc(this.vehicleUseCase) : super(VehicleInitial()) {
//     on<GetVehicleEvent>((event, emit) =>
//         emit.forEach<VehicleState>(
//           mapEventToState(event),
//           onData: (state) => state,
//           onError: (error, stackTrace) =>
//               VehicleFailure(error.toString()), // Handle error cases
//         ));
//   }
//
//
//   Stream<VehicleState> mapEventToState(GetVehicleEvent event) async* {
//     yield VehicleLoading(); // Emit loading state
//     try {
//       // Use yield* to delegate stream handling to vehicleUseCase
//       final resp = await vehicleUseCase(VehicleReqEntity(
//         token: event.vehicleReqEntity.token,
//         contentType: event.vehicleReqEntity.contentType,
//       ));
//
//       yield VehicleDone(resp); // Emit success state after getting the user
//
//
//     } catch (error) {
//       print("error:: $error");
//       if (error is ApiErrorException) {
//         yield VehicleFailure(error.message); // Emit API error message
//       } else if (error is NetworkException) {
//         yield VehicleFailure(error.message); // Emit network failure message
//       }
//       else {
//         yield const VehicleFailure(
//             "An unexpected error occurred. Please try again."); // Emit generic error message
//       }
//     }
//   }
// }


class VehicleRouteHistoryBloc extends Bloc<VehicleEvent, VehicleState>{

  final GetVehicleRouteHistoryUseCase getRouteHistoryUseCase;

  VehicleRouteHistoryBloc(this.getRouteHistoryUseCase) : super(VehicleInitial()) {
    on<VehicleRouteHistoryEvent>((event, emit) => emit.forEach<VehicleState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => VehicleFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<VehicleState> mapEventToState(VehicleRouteHistoryEvent event) async* {
    yield VehicleLoading();
    try {
      var resp = await getRouteHistoryUseCase(event.routeHistoryReqEntity);
      yield GetVehicleRouteHistoryDone(resp);
    } catch (error) {
      if (error is ApiErrorException) {
        yield VehicleFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield VehicleFailure(error.message); // Emit network failure message
      }
      else {
        yield VehicleFailure(error.toString()); // Emit generic error message
      }
    }
  }
}

// class VehicleRouteHistoryBloc extends Bloc<VehicleEvent, VehicleState> {
//   final GetVehicleRouteHistoryUseCase getRouteHistoryUseCase;
//
//   VehicleRouteHistoryBloc(this.getRouteHistoryUseCase) : super(VehicleInitial()) {
//     on<VehicleRouteHistoryEvent>(_onVehicleRouteHistoryEvent);
//   }
//
//   Future<void> _onVehicleRouteHistoryEvent(
//       VehicleRouteHistoryEvent event, Emitter<VehicleState> emit) async {
//     emit(VehicleLoading()); // Emit loading state
//     try {
//       final resp = await getRouteHistoryUseCase(event.routeHistoryReqEntity);
//       emit(GetVehicleRouteHistoryDone(resp)); // Emit success state
//     } catch (error) {
//       if (error is ApiErrorException) {
//         emit(VehicleFailure(error.message)); // Emit API error state
//       } else if (error is NetworkException) {
//         emit(VehicleFailure(error.message)); // Emit network failure state
//       } else {
//         emit(VehicleFailure(error.toString())); // Emit generic error state
//       }
//     }
//   }
// }


