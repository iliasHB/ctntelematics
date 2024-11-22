
import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';

import '../repositories/pusher_repository.dart';

class GetVehicleLocationUpdateUseCase {
  final PusherRepository pusherRepository;

  GetVehicleLocationUpdateUseCase(this.pusherRepository);

  /// Starts the connection to the Pusher service and listens for vehicle updates.
  /// Returns a stream of VehicleEntity objects mapped from the raw data.
  Stream<VehicleEntity> call() {
    try {
      pusherRepository.connect(); // Connect to the Pusher service
    } catch (e) {
      print('Error connecting to Pusher: $e');
      // Return an empty stream if connection fails
      return Stream.error(Exception('Failed to connect to Pusher service'));
    }

    return pusherRepository.listenToVehicleUpdates().map((data) {
      try {
        print('Success mapping data to VehicleEntity: $data');
        return VehicleEntity.fromJson(data); // Map raw data to VehicleEntity
      } catch (e) {
        print('Error mapping data to VehicleEntity: $e');
        throw Exception('Data mapping failed'); // Rethrow or handle as necessary
      }
    });
  }

  /// Disconnects from the Pusher service when done.
  void dispose() {
    pusherRepository.disconnect();
  }
}

///-----------------------
// class GetVehicleLocationUpdateUseCase {
//   final PusherRepository pusherRepository;
//
//   GetVehicleLocationUpdateUseCase(this.pusherRepository);
//
//   /// Starts the connection to the Pusher service and listens for vehicle updates.
//   /// Returns a stream of VehicleEntity objects mapped from the raw data.
//   Stream<VehicleEntity?> call() {
//     try {
//       pusherRepository.connect(); // Connect to the Pusher service
//     } catch (e) {
//       print('Error connecting to Pusher: $e');
//       // Optionally, you could return an empty stream or throw an exception
//     }
//
//     return pusherRepository.listenToVehicleUpdates().map((data) {
//       try {
//         print('success mapping data to VehicleEntity: $data');
//         return VehicleEntity.fromJson(data); // Map raw data to VehicleEntity
//       } catch (e) {
//         print('Error mapping data to VehicleEntity: $e');
//         // Handle mapping errors, e.g., returning a default value or skipping invalid data
//         return null; // or handle as per your needs
//       }
//     }).where((vehicle) => vehicle != null); // Filter out null values
//   }
//
//   /// Disconnects from the Pusher service when done.
//   void dispose() {
//     pusherRepository.disconnect();
//   }
// }
