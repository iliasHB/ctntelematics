
import 'package:ctntelematics/modules/dashboard/domain/entitties/resp_entities/get_trip_resp_entity.dart';

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

class TripsUseCase extends UseCase<void, DashVehicleReqEntity>{
  final DashboardRepository repository;

  TripsUseCase(this.repository);

  @override
  Future<List<GetTripRespEntity>> call(DashVehicleReqEntity params) async {
    return await repository.onGetTrips(params);
  }
}