import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';

import '../../modules/dashboard/domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import '../../modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';


class VehicleRealTimeStatus {
  static int checkStatusChange(
      List<LastLocationRespEntity> vehicles,
      List<VehicleEntity> websocketVehicle,
      String state,
      int? vehicleCount) {
    // Create a map for quick lookup of previous statuses by number plate
    final previousStatusMap = {
      for (var vehicle in vehicles)
        vehicle.vehicle?.details?.number_plate:
        vehicle.vehicle?.details?.last_location?.status?.toLowerCase()
    };

    int totalVehicle = vehicleCount ?? 0;

    // Track vehicles that have exceeded the 25-second timeout
    final DateTime now = DateTime.now();
    Map<String, DateTime> vehicleLastUpdateTime = {};

    for (var currentVehicle in websocketVehicle) {
      String? currentPlate = currentVehicle.locationInfo.numberPlate;
      String? currentStatus = currentVehicle.locationInfo.vehicleStatus.toLowerCase();
      DateTime? lastUpdateTime = vehicleLastUpdateTime[currentPlate];

      // Check if the vehicle is moving
      if (currentStatus == 'moving') {
        print(":::::::> currentStatus: $currentStatus <::::::");
        // Handle timeout logic for moving vehicles
        if (lastUpdateTime != null && now.difference(lastUpdateTime).inSeconds > 120) {
          print("::::::: lastUpdateTime: $lastUpdateTime ::::::");
          // Vehicle timeout
          currentStatus = 'Parked'; // Assuming 'parked' as the default state for timeout
        } else {
          // Update last update time
          vehicleLastUpdateTime[currentPlate] = now;
          print(":::::::> vehicleLastUpdateTime: $vehicleLastUpdateTime <::::::");
        }

        String? previousStatus = previousStatusMap[currentPlate];

        if (previousStatus != null) {
          if (currentStatus != previousStatus) {
            if (currentStatus != state && previousStatus == state) {
              totalVehicle -= 1;
            } else if (currentStatus == state && previousStatus != state) {
              totalVehicle += 1;
            }
          }
        } else {
          if (currentStatus == state) {
            totalVehicle += 1;
          }
        }
      }
    }

    return totalVehicle < 0 ? 0 : totalVehicle;
  }
}

