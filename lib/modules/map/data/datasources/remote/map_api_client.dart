
import 'package:ctntelematics/core/constant/constant.dart';
import 'package:ctntelematics/modules/map/data/models/resp_models/resp_model.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/route_history_resp_entity.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/resp_models/last_location_resp_model.dart';
import '../../models/resp_models/route_history_model.dart';

part 'map_api_client.g.dart';

@RestApi(baseUrl: baseUri)
abstract class MapApiClient {
  factory MapApiClient(Dio dio) = _MapApiClient;

  @POST('/get/location')
  Future<List<LastLocationRespModel>> getLastLocation(
      @Header("Authorization") String token,
      @Header("Content-Type") String contentType,);

  @GET('/location/history')
  Future<RouteHistoryRespModel> getRouteHistory(
      @Query("vehicle_vin") String vehicle_vin,
      @Query("time_from") String time_from,
      @Query("time_to") String time_to,
      @Header("Authorization") String token,);

  @POST('/send/location')
  @FormUrlEncoded()
  Future<RespModel> onSendLocation(
      @Field('email') String email,
      @Field('url') String url,
      @Header('Authorization') String token,
      @Header("Content-Type") String contentType);
}