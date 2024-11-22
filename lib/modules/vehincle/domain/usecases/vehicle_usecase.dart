

import '../../../../core/usecase/usecase.dart';
import '../entities/req_entities/route_history_req_entity.dart';
import '../entities/req_entities/vehicle_req_entity.dart';
import '../entities/resp_entities/route_history_resp_entity.dart';
import '../entities/resp_entities/vehicle_resp_entity.dart';
import '../repositories/vehicle_repo.dart';

class VehicleUseCase extends UseCase<void, VehicleReqEntity>{
  final VehicleRepository repository;

  VehicleUseCase(this.repository);

  @override
  Future<VehicleRespEntity> call(VehicleReqEntity params) async {
    return await repository.onGetAllVehicles(params);
  }
}


class GetVehicleRouteHistoryUseCase extends UseCase<void, VehicleRouteHistoryReqEntity> {
  final VehicleRepository repository;
  GetVehicleRouteHistoryUseCase(this.repository);

  @override
  Future<VehicleRouteHistoryRespEntity> call(VehicleRouteHistoryReqEntity params) {
    // TODO: implement call
    return repository.onGetRouteHistory(params);
  }
}
