import 'dart:async';

import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_vehicle_location_update_usecase.dart';


// class VehicleLocationBloc extends Cubit<List<VehicleEntity>> {
//   final GetVehicleLocationUpdateUseCase _getVehicleLocationUpdateUseCase;
//   StreamSubscription<VehicleEntity>? _vehicleSubscription;
//
//   VehicleLocationBloc(this._getVehicleLocationUpdateUseCase) : super([]) {
//     _startListening();
//   }
//
//   void _startListening() {
//     _vehicleSubscription = _getVehicleLocationUpdateUseCase.call().listen(
//           (vehicle) {
//         // Check if a vehicle with the same VIN already exists
//         final updatedVehicles = List<VehicleEntity>.from(state);
//         final index = updatedVehicles.indexWhere(
//               (v) => v.locationInfo.vin == vehicle.locationInfo.vin,
//         );
//
//         if (index != -1) {
//           // Update the existing vehicle
//           updatedVehicles[index] = vehicle;
//         } else {
//           // Add new vehicle
//           updatedVehicles.add(vehicle);
//         }
//         emit(updatedVehicles);
//       },
//       onError: (error) {
//         print('Error receiving vehicle updates: $error');
//         // Optionally, emit an error state or notify the UI about the issue.
//       },
//     );
//   }
//
//   @override
//   Future<void> close() {
//     _vehicleSubscription?.cancel();
//     _getVehicleLocationUpdateUseCase.dispose();
//     return super.close();
//   }
// }


class VehicleLocationBloc extends Cubit<List<VehicleEntity>> {
  final GetVehicleLocationUpdateUseCase _getVehicleLocationUpdateUseCase;
  StreamSubscription<VehicleEntity>? _vehicleSubscription;

  VehicleLocationBloc(this._getVehicleLocationUpdateUseCase) : super([]) {
    _startListening();
  }

  void _startListening() {
    _vehicleSubscription = _getVehicleLocationUpdateUseCase.call().listen(
          (vehicle) {
        // Create a copy of the current state
        final updatedVehicles = List<VehicleEntity>.from(state);
        final index = updatedVehicles.indexWhere(
              (v) => v.locationInfo.vin == vehicle.locationInfo.vin,
        );

        if (index != -1) {
          // Update existing vehicle data
          updatedVehicles[index] = vehicle;
        } else {
          // Add new vehicle to the list
          updatedVehicles.add(vehicle);
        }
        if (!listEquals(state, updatedVehicles)) {
          emit(updatedVehicles);
        }

        // emit(updatedVehicles); // Emit updated list to the UI
      },
      onError: (error) {
        print('Error receiving vehicle updates: $error');
        // Emit an empty list or error state to notify the UI
        emitErrorState();
      },
    );
  }

  void emitErrorState() {
    // Emit a specific error state, such as an empty list or special message
    emit([]);
    // Optionally notify UI of error state in another way
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    _getVehicleLocationUpdateUseCase.dispose();
    return super.close();
  }
}



///------------
// class VehicleLocationBloc extends Cubit<List<VehicleEntity>> {
//   final GetVehicleLocationUpdateUseCase _getVehicleLocationUpdateUseCase;
//   StreamSubscription<VehicleEntity?>? _vehicleSubscription;
//
//   VehicleLocationBloc(this._getVehicleLocationUpdateUseCase) : super([]) {
//     _startListening();
//   }
//
//   void _startListening() {
//     _vehicleSubscription = _getVehicleLocationUpdateUseCase.call().listen(
//           (vehicle) {
//         if (vehicle != null) {
//           // Check if a vehicle with the same VIN already exists
//           final updatedVehicles = List<VehicleEntity>.from(state);
//           final index = updatedVehicles.indexWhere(
//                 (v) => v.locationInfo.vin == vehicle.locationInfo.vin,
//           );
//
//           if (index != -1) {
//             // Update the existing vehicle
//             updatedVehicles[index] = vehicle;
//           } else {
//             // Add new vehicle
//             updatedVehicles.add(vehicle);
//           }
//           emit(updatedVehicles);
//         }
//       },
//       onError: (error) {
//         print('Error receiving vehicle updates: $error');
//       },
//     );
//   }
//
//   @override
//   Future<void> close() {
//     _vehicleSubscription?.cancel();
//     _getVehicleLocationUpdateUseCase.dispose();
//     return super.close();
//   }
// }

///-----
// class VehicleLocationBloc extends Cubit<VehicleEntity?> {
//   final GetVehicleLocationUpdateUseCase _getVehicleLocationUpdateUseCase;
//
//   VehicleLocationBloc(this._getVehicleLocationUpdateUseCase) : super(null) {
//     _getVehicleLocationUpdateUseCase.call().listen((event) {
//       emit(event);
//     });
//   }
//
//   @override
//   Future<void> close() {
//     _getVehicleLocationUpdateUseCase.dispose();
//     return super.close();
//   }
// }

///------------
// class VehicleLocationBloc extends Bloc<VehicleEvent, VehicleEntity?> {
//   final PusherService pusherService;
//
//   VehicleLocationBloc(this.pusherService) : super(null) {
//     // Listen to updates from the PusherService
//     pusherService.getVehicleUpdates().listen((data) {
//       final vehicleEntity = VehicleEntity.fromMap(data); // Parse to VehicleEntity
//       add(VehicleUpdatedEvent(vehicleEntity));
//     });
//   }
//
//   @override
//   Stream<VehicleEntity?> mapEventToState(VehicleEvent event) async* {
//     if (event is VehicleUpdatedEvent) {
//       yield event.vehicleEntity;
//     }
//   }
// }
//
// // Define the VehicleUpdatedEvent
// class VehicleUpdatedEvent extends VehicleEvent {
//   final VehicleEntity vehicleEntity;
//   VehicleUpdatedEvent(this.vehicleEntity);
// }
