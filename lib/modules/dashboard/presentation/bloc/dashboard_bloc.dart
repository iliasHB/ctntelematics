

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/dash_data_state.dart';
import '../../data/models/resp_models/get_trip_resp_model.dart';
import '../../domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../../domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import '../../domain/entitties/resp_entities/get_trip_resp_entity.dart';
import '../../domain/usecases/dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashVehiclesBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCase dashboardUseCase;

  DashVehiclesBloc(this.dashboardUseCase) : super(DashboardInitial()) {
    on<DashVehicleEvent>((event, emit) => emit.forEach<DashboardState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              DashboardFailure(error.toString()), // Handle error cases
        ));
  }


  Stream<DashboardState> mapEventToState(DashVehicleEvent event) async* {
    yield DashboardLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to vehicleUseCase
      final resp = await dashboardUseCase(DashVehicleReqEntity(
        token: event.dashVehicleReqEntity.token,
        contentType: event.dashVehicleReqEntity.contentType,
      ));
      print('hellllooooooo>>>>>>>>>>');
      yield DashboardDone(resp); // Emit success state after getting the user
      print('hellllooooooo>>ffffffffff>>>>>>>>');

    } catch (error) {
      print('errorr2::::: $error');
      if (error is ApiErrorException) {
        yield DashboardFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield DashboardFailure(error.message); // Emit network failure message
      }
      else {
        yield const DashboardFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}


class VehicleTripBloc extends Bloc<DashboardEvent, DashboardState> {
  final TripsUseCase tripsUseCase;

  VehicleTripBloc(this.tripsUseCase) : super(DashboardInitial()) {
    on<DashVehicleEvent>((event, emit) => emit.forEach<DashboardState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          DashboardFailure(error.toString()), // Handle error cases
    ));
  }


  Stream<DashboardState> mapEventToState(DashVehicleEvent event) async* {
    yield DashboardLoading(); // Emit loading state
    try {

      // Use yield* to delegate stream handling to vehicleUseCase
      final resp = await tripsUseCase(DashVehicleReqEntity(
        token: event.dashVehicleReqEntity.token,
        contentType: event.dashVehicleReqEntity.contentType,
      ));

      yield VehicleTripDone(resp); // Emit success state after getting the user

    } catch (error) {
      print('errorr1::::: $error');
      if (error is ApiErrorException) {
        yield DashboardFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield DashboardFailure(error.message); // Emit network failure message
      }
      else {
        yield const DashboardFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

///--------------------------------------------------------------------
// class DashVehiclesBloc extends Bloc<DashboardEvent, DashboardState> {
//   final DashboardUseCase dashboardUseCase;
//
//   DashVehiclesBloc(this.dashboardUseCase) : super(DashboardInitial()) {
//     on<DashVehicleEvent>((event, emit) async {
//       emit(DashboardLoading());
//       final dataState = await dashboardUseCase(event.dashVehicleReqEntity);
//       try {
//         emit(DashboardDone(dataState));
//       } catch (error) {
//         emit(DashboardFailure(error.toString())); // Emit generic error message
//     }
//
//     });
//   }
// }
