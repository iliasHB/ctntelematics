
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';

import '../../modules/dashboard/domain/entitties/resp_entities/dash_vehicle_resp_entity.dart';
import '../../modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';

class VehicleRealTimeStatus {
  static int checkStatusChange(/*List<DashDatumEntity> vehicles,*/List<LastLocationRespEntity> vehicles, List<VehicleEntity> websocketVehicle, String state, int? vehicleCount) {
    print('>>>>>>>> step 1<<<<<<<<<<<<<<<<');
    int totalVehicle = 0;
    for (var currentVehicle in websocketVehicle) {
      print('>>>>>>>> step 2<<<<<<<<<<<<<<<<');
      // Find the previous status of the current vehicle by matching vehicleId
      var previousVehicle = vehicles.firstWhere(
            (vehicle) => vehicle.vehicle?.details?.number_plate == currentVehicle.locationInfo.numberPlate,
        //orElse: () => DashDatumEntity(id: null, brand: '', model: '', year: '', type: '', vin: '', number_plate: '', user_id: null, vehicle_owner_id: null, created_at: '', updated_at: '', driver: null, owner: null, tracker: null, last_location: null), // If no previous vehicle is found, use null
      );

      if (previousVehicle != null) {
        print('>>>>>>>> step 3<<<<<<<<<<<<<<<<');
        // Compare the current status with the previous status
        if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() != previousVehicle.vehicle?.details?.last_location?.status!.toLowerCase()){
          print('>>>>>>>> step 4<<<<<<<<<<<<<<<<');

          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() != state && previousVehicle.vehicle?.details?.last_location?.status!.toLowerCase() == state) {
            totalVehicle = vehicleCount! - websocketVehicle.length;
            print('>>>>>>>> step 5a<<<<<<<<<<<<<<<<');
          } else {
            totalVehicle = vehicleCount!;
            print('>>>>>>>> step 5b<<<<<<<<<<<<<<<<');
          }

        } else {
          if (currentVehicle.locationInfo.vehicleStatus.toLowerCase() == state && previousVehicle.vehicle?.details?.last_location?.status!.toLowerCase() == state) {

            totalVehicle = vehicleCount!;
            print('>>>>>>>> step 6<<<<<<<<<<<<<<<<');
          }
        }
      } else {
        print('>>>>>>>> step 7<<<<<<<<<<<<<<<<');
        if(state == "parked"){
          totalVehicle = vehicleCount!;
          print('>>>>>>>> step 8<<<<<<<<<<<<<<<<');
        }
        if(state == "idling"){
          totalVehicle = vehicleCount!;
          print('>>>>>>>> step 9<<<<<<<<<<<<<<<<');

        }
        if(state == "offline"){
          totalVehicle = vehicleCount!;
          print('>>>>>>>> step 10<<<<<<<<<<<<<<<<');

        }
      }
    }

    // Ensure totalVehicle is never negative
    if (totalVehicle < 0) {
      totalVehicle = totalVehicle.abs();
      print('>>>>>>>> step 11<<<<<<<<<<<<<<<<');
    }
    print('>>>>>>>> step 12<<<<<<<<<<<<<<<<');
    return totalVehicle;
  }
}