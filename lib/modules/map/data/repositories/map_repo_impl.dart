import 'package:ctntelematics/modules/map/data/models/req_models/send_location_req_model.dart';
import 'package:ctntelematics/modules/map/data/models/req_models/token_req_model.dart';
import 'package:ctntelematics/modules/map/data/models/resp_models/resp_model.dart';
import 'package:ctntelematics/modules/map/data/models/resp_models/route_history_model.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/route_history_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/send_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/map_data_state.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/remote/map_api_client.dart';
import '../models/req_models/route_history_req_model.dart';
import '../models/resp_models/last_location_resp_model.dart';

class MapRepositoryImpl extends MapRepository {
  final MapApiClient apiClient;
  MapRepositoryImpl(this.apiClient);

  @override
  Future<List<LastLocationRespModel>> onGetLastLocation(
      TokenReqEntity tokenReqEntity) async {
    TokenReqModel tokenReqModel = TokenReqModel(
        token: tokenReqEntity.token, contentType: tokenReqEntity.contentType);
    try {
      return await handleLastLocationError(apiClient.getLastLocation(
          tokenReqModel.token, tokenReqModel.contentType));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting location.");
    }
  }

  @override
  Future<RouteHistoryRespModel> onGetRouteHistory(
      RouteHistoryReqEntity routeHistoryReqEntity) async {
    RouteHistoryReqModel routeHistoryReqModel = RouteHistoryReqModel(
      vehicle_vin: routeHistoryReqEntity.vehicle_vin,
      time_from: routeHistoryReqEntity.time_from,
      time_to: routeHistoryReqEntity.time_to,
      token: routeHistoryReqEntity.token,
    );
    print("vehicle_vin: ${routeHistoryReqModel.vehicle_vin}");
    print("time_from: ${routeHistoryReqModel.time_from}");
    print("time_to: ${routeHistoryReqModel.time_to}");
    print("token: ${routeHistoryReqModel.token}");
    String contentType = 'application/json';

    try {
      return await handleRouteHistoryError(
         apiClient.getRouteHistory(
          routeHistoryReqModel.vehicle_vin,
          routeHistoryReqModel.time_from,
          routeHistoryReqModel.time_to,
          routeHistoryReqModel.token,
         ));
    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting location.");
    }
  }


  @override
  Future<RespModel> onSendLocation(
      SendLocationReqEntity sendLocationReqEntity) async {
    SendLocationReqModel sendLocationReqModel = SendLocationReqModel(
        email: sendLocationReqEntity.email,
        url: sendLocationReqEntity.url,
        token: sendLocationReqEntity.token,
      contentType: 'application/json',
    );

    try {
      return await handleSendLocationError(
          apiClient.onSendLocation(
            sendLocationReqModel.email,
            sendLocationReqModel.url,
            sendLocationReqModel.token,
            sendLocationReqModel.contentType,
          ));
    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting location.");
    }
  }
}
