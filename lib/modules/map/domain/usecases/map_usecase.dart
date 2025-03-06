import 'package:ctntelematics/core/usecase/usecase.dart';
import 'package:ctntelematics/modules/map/data/models/req_models/send_location_req_model.dart';
import 'package:ctntelematics/modules/map/data/models/resp_models/resp_model.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/send_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/route_history_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/repositories/map_repository.dart';

import '../../../../core/model/token_req_entity.dart';
import '../entitties/req_entities/route_history_req_entity.dart';

class GetLastLocationUseCase extends UseCase<void, TokenReqEntity> {
  final MapRepository repository;
  GetLastLocationUseCase(this.repository);

  @override
  Future<List<LastLocationRespEntity>> call(TokenReqEntity params) {
    // TODO: implement call
    return repository.onGetLastLocation(params);
  }
}

class GetRouteHistoryUseCase extends UseCase<void, RouteHistoryReqEntity> {
  final MapRepository repository;
  GetRouteHistoryUseCase(this.repository);

  @override
  Future<RouteHistoryRespEntity> call(RouteHistoryReqEntity params) {
    // TODO: implement call
    return repository.onGetRouteHistory(params);
  }
}

class SendLocationUseCase extends UseCase<void, SendLocationReqEntity> {
  final MapRepository repository;
  SendLocationUseCase(this.repository);

  @override
  Future<RespEntity> call(SendLocationReqEntity params) {
    // TODO: implement call
    return repository.onSendLocation(params);
  }
}
