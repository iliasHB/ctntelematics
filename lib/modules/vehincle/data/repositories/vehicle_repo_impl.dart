

import 'package:ctntelematics/modules/vehincle/data/models/req_models/vehicle_req_model.dart';
import 'package:ctntelematics/modules/vehincle/data/models/resp_models/route_history_model.dart';
import 'package:ctntelematics/modules/vehincle/data/models/resp_models/vehicles_resp_model.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/req_entities/vehicle_req_entity.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';

import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/vehicle_data_state.dart';
import '../../domain/entities/req_entities/route_history_req_entity.dart';
import '../../domain/repositories/vehicle_repo.dart';
import '../datasources/remote/vehicle_api_client.dart';
import '../models/req_models/route_history_req_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {

  final VehicleApiClient apiClient;
  // String sourceCode = "c085645f276fd835042d3730d6a8fc99f6a3f0e8dd3d3ee73f61bbe9db425f13";
  VehicleRepositoryImpl(this.apiClient);

  @override
  Future<VehicleRespModel> onGetAllVehicles(VehicleReqEntity vehicleReqEntity) async {

    VehicleReqModel vehicleReqModel = VehicleReqModel(
        token: vehicleReqEntity.token,
        contentType: vehicleReqEntity.contentType);

    print("token: ${vehicleReqModel.token}");
    print("contentType: ${vehicleReqModel.contentType}");
    try {
      return await handleVehicleErrorHandling(
           apiClient.getAllVehicles(vehicleReqModel.token, vehicleReqModel.contentType)
      );
    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    }
    catch (e) {
      print("error:- $e");
      throw Exception("An error occurred while logging in: $e");
    }
  }

  @override
  Future<VehicleRouteHistoryRespModel> onGetRouteHistory(VehicleRouteHistoryReqEntity routeHistoryReqEntity) async {
    VehicleRouteHistoryReqModel routeHistoryReqModel = VehicleRouteHistoryReqModel(
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
      return await handleVehicleRouteHistoryError(
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

  // @override
  // Future<VehicleRouteHistoryRespModel> onGetRouteHistory(
  //     VehicleRouteHistoryReqEntity routeHistoryReqEntity) async {
  //   VehicleRouteHistoryReqModel routeHistoryReqModel = VehicleRouteHistoryReqModel(
  //     vehicle_vin: routeHistoryReqEntity.vehicle_vin,
  //     time_from: routeHistoryReqEntity.time_from,
  //     time_to: routeHistoryReqEntity.time_to,
  //     token: routeHistoryReqEntity.token,
  //   );
  //   print("vehicle_vin: ${routeHistoryReqModel.vehicle_vin}");
  //   print("time_from: ${routeHistoryReqModel.time_from}");
  //   print("time_to: ${routeHistoryReqModel.time_to}");
  //   print("token: ${routeHistoryReqModel.token}");
  //   String contentType = 'application/json';
  //
  //   try {
  //     return await handleVehicleRouteHistoryError(
  //         apiClient.getRouteHistory(
  //           routeHistoryReqModel.vehicle_vin,
  //           routeHistoryReqModel.time_from,
  //           routeHistoryReqModel.time_to,
  //           routeHistoryReqModel.token,
  //         ));
  //   }
  //   on ApiErrorException catch (e) {
  //     throw ApiErrorException(e.message); // Propagate the error with the API message
  //   } on NetworkException catch (e) {
  //     throw NetworkException(); // Propagate network-specific errors
  //   } catch (e) {
  //     throw Exception("An error occurred while getting location.");
  //   }
  // }
}