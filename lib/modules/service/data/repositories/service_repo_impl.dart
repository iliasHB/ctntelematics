import 'package:ctntelematics/modules/service/data/datasources/remote/service_api_client.dart';
import 'package:ctntelematics/modules/service/data/models/resp_models/request_service_resp_model.dart';

import '../../../../core/model/token_req_entity.dart';
import '../../../../core/model/token_req_model.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/service_data_state.dart';
import '../../domain/entitties/req_entities/request_service_req_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../models/req_models/request_service_req_model.dart';
import '../models/resp_models/get_country_state_resp_model.dart';
import '../models/resp_models/get_service_payment_resp_model.dart';
import '../models/resp_models/get_services_model.dart';

class ServiceRepositoryImpl extends ServiceRepository {
  final ServiceApiClient apiClient;
  ServiceRepositoryImpl(this.apiClient);

  @override
  Future<GetServicePaymentRespModel> onInitializePayment(
      TokenReqEntity tokenReqEntity) async {
    TokenReqModel tokenReqModel = TokenReqModel(
        token: tokenReqEntity.token, serviceId: tokenReqEntity.serviceId);
    try {
      return await handleInitializePaymentError(apiClient.initializePayment(
          tokenReqModel.serviceId!, tokenReqModel.token));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while initializing payment.");
    }
  }

  @override
  Future<List<GetServicesRespModel>> onGetServices(
      TokenReqEntity tokenReqEntity) async {
    TokenReqModel tokenReqModel = TokenReqModel(
      token: tokenReqEntity.token,
    );
    try {
      return await handleGetServiceError(
          apiClient.getServices(tokenReqModel.token));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting services.");
    }
  }

  @override
  Future<GetCountryStateModel> onGetCountryStates(
      TokenReqEntity tokenReqEntity) async {
    TokenReqModel tokenReqModel = TokenReqModel(
      token: tokenReqEntity.token,
    );
    try {
      return await handleCountryStateError(
          apiClient.getCountryStates(tokenReqModel.token));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting States.");
    }
  }

  @override
  Future<RequestServiceRespModel> onRequestService(
      RequestServiceReqEntity requestServiceReqEntity) async {
    RequestServiceReqModel rs = RequestServiceReqModel(
        service_id: requestServiceReqEntity.service_id,
        contact_phone: requestServiceReqEntity.contact_phone,
        location_state: requestServiceReqEntity.location_state,
        location_lgvt: requestServiceReqEntity.location_lgvt,
        payment_ref: requestServiceReqEntity.payment_ref,
        location_address: requestServiceReqEntity.location_address,
        token: requestServiceReqEntity.token);
    try {
      // return await handleCountryStateError(
      return apiClient.requestService(
          rs.token,
          rs.service_id,
          rs.contact_phone,
          rs.location_state,
          rs.location_lgvt,
          rs.payment_ref,
          rs.location_address);
      // );
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while requesting service.");
    }
  }
}
