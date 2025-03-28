import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/get_service_payment_resp_entity.dart';
import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/request_service_resp_entity.dart';

import '../../../../core/model/token_req_entity.dart';
import '../entitties/req_entities/request_service_req_entity.dart';
import '../entitties/resp_entities/get_country_state_resp_entity.dart';
import '../entitties/resp_entities/get_services_entity.dart';

abstract class ServiceRepository {
  Future<GetServicePaymentRespEntity> onInitializePayment(TokenReqEntity tokenReqEntity);

  Future<List<GetServicesRespEntity>> onGetServices(TokenReqEntity tokenReqEntity);

  Future<GetCountryStateEntity> onGetCountryStates(TokenReqEntity tokenReqEntity);

  Future<RequestServiceRespEntity> onRequestService(RequestServiceReqEntity requestServiceReqEntity);
}
