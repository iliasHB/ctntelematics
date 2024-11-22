
import 'package:ctntelematics/modules/websocket/data/datasources/pusher_service.dart';

import '../../domain/repositories/pusher_repository.dart';


class PusherRepositoryImpl implements PusherRepository {
  final PusherService pusherService;

  PusherRepositoryImpl(this.pusherService);

  /// Connects to the Pusher service to start receiving events.
  @override
  void connect() {
    try {
      pusherService.initializePusher();
    } catch (e) {
      print('Failed to connect to Pusher: $e');
      // Handle error appropriately (e.g., logging to an external service, retrying, etc.)
    }
  }

  /// Disconnects from the Pusher service.
  @override
  void disconnect() {
    try {
      pusherService.dispose(); // Ensure PusherService has a method to cleanly disconnect
    } catch (e) {
      print('Failed to disconnect from Pusher: $e');
      // Handle error appropriately (e.g., logging to an error tracking service)
    }
  }

  /// Listens for vehicle updates from the Pusher service.
  @override
  Stream<Map<String, dynamic>> listenToVehicleUpdates() {
    return pusherService.vehicleUpdates.handleError((error) {
      print('Error listening to vehicle updates: $error');
      // Handle error appropriately, such as notifying listeners or retrying the connection
    });
  }
}


///-------------------------------------------------------------

// class PusherRepositoryImpl implements PusherRepository {
//   final PusherService pusherService;
//
//   PusherRepositoryImpl(this.pusherService);
//
//   /// Connects to the Pusher service to start receiving events.
//   @override
//   void connect() {
//     try {
//       pusherService.initializePusher();
//     } catch (e) {
//       print('Failed to connect to Pusher: $e');
//       // Handle error appropriately (e.g., logging, throwing exceptions, etc.)
//     }
//   }
//
//   /// Disconnects from the Pusher service.
//   @override
//   void disconnect() {
//     try {
//       pusherService.disconnect();
//     } catch (e) {
//       print('Failed to disconnect from Pusher: $e');
//       // Handle error appropriately
//     }
//   }
//
//   /// Listens for vehicle updates from the Pusher service.
//   @override
//   Stream<Map<String, dynamic>> listenToVehicleUpdates() {
//     print('Error listening to vehicle updates: ');
//     return pusherService.getVehicleUpdates().handleError((error) {
//
//       // Handle error appropriately
//     });
//   }
// }


