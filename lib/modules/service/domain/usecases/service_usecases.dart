import 'package:ctntelematics/modules/service/domain/entitties/req_entities/request_service_req_entity.dart';
import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/get_country_state_resp_entity.dart';
import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/get_service_payment_resp_entity.dart';
import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/get_services_entity.dart';
import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/request_service_resp_entity.dart';

import '../../../../core/model/token_req_entity.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/service_repository.dart';

class InitializeServicePaymentUseCase extends UseCase<void, TokenReqEntity> {
  final ServiceRepository repository;
  InitializeServicePaymentUseCase(this.repository);

  @override
  Future<GetServicePaymentRespEntity> call(TokenReqEntity params) {
    // TODO: implement call
    return repository.onInitializePayment(params);
  }
}


class GetServicesUseCase extends UseCase<void, TokenReqEntity> {
  final ServiceRepository repository;
  GetServicesUseCase(this.repository);

  @override
  Future<List<GetServicesRespEntity>> call(TokenReqEntity params) {
    // TODO: implement call
    return repository.onGetServices(params);
  }
}

class GetCountryStatesUseCase extends UseCase<void, TokenReqEntity> {
  final ServiceRepository repository;
  GetCountryStatesUseCase(this.repository);

  @override
  Future<GetCountryStateEntity> call(TokenReqEntity params) {
    // TODO: implement call
    return repository.onGetCountryStates(params);
  }
}

class RequestServiceUseCase extends UseCase<void, RequestServiceReqEntity> {
  final ServiceRepository repository;
  RequestServiceUseCase(this.repository);

  @override
  Future<RequestServiceRespEntity> call(RequestServiceReqEntity params) {
    // TODO: implement call
    return repository.onRequestService(params);
  }
}