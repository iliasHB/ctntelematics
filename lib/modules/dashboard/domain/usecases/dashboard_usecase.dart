
import '../../../../core/usecase/usecase.dart';
import '../entitties/req_entities/dash_vehicle_req_entity.dart';
import '../entitties/resp_entities/dash_vehicle_resp_entity.dart';
import '../repositories/dash_vehicle_repo.dart';

class DashboardUseCase extends UseCase<void, DashVehicleReqEntity>{
  final DashboardRepository repository;

  DashboardUseCase(this.repository);

  @override
  Future<DashVehicleRespEntity> call(DashVehicleReqEntity params) async {
    return await repository.onGetAllVehicles(params);
  }
}