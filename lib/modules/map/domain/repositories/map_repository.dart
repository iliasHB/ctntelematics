import 'package:ctntelematics/core/model/token_req_entity.dart';
import 'package:ctntelematics/modules/map/data/models/resp_models/route_history_model.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/route_history_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/send_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/resp_entity.dart';

import '../entitties/resp_entities/last_location_resp_entity.dart';
import '../entitties/resp_entities/route_history_resp_entity.dart';

abstract class MapRepository {
  Future<List<LastLocationRespEntity>> onGetLastLocation(
      TokenReqEntity tokenReqEntity);

  Future<RouteHistoryRespEntity> onGetRouteHistory(
      RouteHistoryReqEntity routeHistoryReqEntity);

  Future<RespEntity> onSendLocation(SendLocationReqEntity params);
}
