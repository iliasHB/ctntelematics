import 'dart:async';
import 'dart:convert';

import 'package:ctntelematics/modules/vehincle/data/models/resp_models/route_history_model.dart';
import 'package:ctntelematics/modules/vehincle/data/models/resp_models/vehicles_resp_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../../../../core/utils/app_export_util.dart';

part 'vehicle_api_client.g.dart';

@RestApi(baseUrl: baseUri)
abstract class VehicleApiClient {
  factory VehicleApiClient(Dio dio) = _VehicleApiClient;

  @POST("/view/vehicle")
  Future<VehicleRespModel> getAllVehicles(
      @Header("Authorization") String token,
      @Header("Accept") String contentType,);

  @GET('/location/history')
  Future<VehicleRouteHistoryRespModel> getRouteHistory(
      @Query("vehicle_vin") String vehicle_vin,
      @Query("time_from") String time_from,
      @Query("time_to") String time_to,
      @Header("Authorization") String token,);
}

