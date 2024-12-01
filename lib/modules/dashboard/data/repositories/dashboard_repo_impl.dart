
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/dash_data_state.dart';
import '../../domain/repositories/dash_vehicle_repo.dart';
import '../datasources/remote/dashboard_api_client.dart';
import '../models/req_models/dash_vehicle_req_model.dart';
import '../models/resp_models/dash_vehicle_resp_model.dart';
import '../../domain/entitties/req_entities/dash_vehicle_req_entity.dart';
import '../models/resp_models/get_trip_resp_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final DashboardApiClient apiClient;
  // String sourceCode = "c085645f276fd835042d3730d6a8fc99f6a3f0e8dd3d3ee73f61bbe9db425f13";
  DashboardRepositoryImpl(this.apiClient);

  @override
  Future<DashVehicleRespModel> onGetAllVehicles(DashVehicleReqEntity dashVehicleReqEntity) async {

    DashVehicleReqModel vehicleReqModel = DashVehicleReqModel(
        token: dashVehicleReqEntity.token,
        contentType: dashVehicleReqEntity.contentType);

    try {
      return await handleDashVehicleErrorHandling(
          apiClient.getAllVehicles(vehicleReqModel.token, vehicleReqModel.contentType)
      );
    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while fetching vehicle.");
    }
  }


  @override
  Future<List<GetTripRespModel>> onGetTrips(DashVehicleReqEntity dashVehicleReqEntity) async {

    DashVehicleReqModel vehicleReqModel = DashVehicleReqModel(
        token: dashVehicleReqEntity.token,
        contentType: dashVehicleReqEntity.contentType);

    try {
      return await handleDashVehicleTripErrorHandling(
          apiClient.getAllTrips(vehicleReqModel.token, vehicleReqModel.contentType)
      );
    } on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while fetching vehicle trip.");
    }
  }

}