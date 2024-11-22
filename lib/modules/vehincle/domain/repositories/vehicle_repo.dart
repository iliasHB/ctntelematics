

import '../entities/req_entities/route_history_req_entity.dart';
import '../entities/req_entities/vehicle_req_entity.dart';
import '../entities/resp_entities/route_history_resp_entity.dart';
import '../entities/resp_entities/vehicle_resp_entity.dart';

abstract class VehicleRepository {

  Future<VehicleRespEntity>onGetAllVehicles(VehicleReqEntity vehicleReqEntity);

  Future<VehicleRouteHistoryRespEntity> onGetRouteHistory(
      VehicleRouteHistoryReqEntity routeHistoryReqEntity);
}