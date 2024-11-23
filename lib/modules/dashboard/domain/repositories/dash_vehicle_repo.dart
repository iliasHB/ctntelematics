
import '../../data/models/resp_models/get_trip_resp_model.dart';
import '../entitties/req_entities/dash_vehicle_req_entity.dart';
import '../entitties/resp_entities/dash_vehicle_resp_entity.dart';

abstract class DashboardRepository {

  Future<DashVehicleRespEntity>onGetAllVehicles(DashVehicleReqEntity dashVehicleReqEntity);

  Future<List<GetTripRespModel>>onGetTrips(DashVehicleReqEntity dashVehicleReqEntity);

}