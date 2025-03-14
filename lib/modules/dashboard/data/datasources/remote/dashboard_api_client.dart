import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../../../../core/utils/app_export_util.dart';
import '../../models/resp_models/dash_vehicle_resp_model.dart';
import '../../models/resp_models/get_trip_resp_model.dart';

part 'dashboard_api_client.g.dart';

@RestApi(baseUrl: baseUri)
abstract class DashboardApiClient {
  factory DashboardApiClient(Dio dio) = _DashboardApiClient;

  @POST("/view/vehicle")
  Future<DashVehicleRespModel> getAllVehicles(
      @Header("Authorization") String token,
      @Header("Content-Type") String contentType,
      );

  @GET("/trips")
  Future<List<GetTripRespModel>> getAllTrips(
      @Header("Authorization") String token,
      @Header("Content-Type") String contentType,);

  // @GET("/get/notice")
  // Future<List<GetScheduleNoticeRespModel>> getScheduleNotice(
  //     @Header("Authorization") String token,
  //     @Header("Accept") String contentType,);

}

