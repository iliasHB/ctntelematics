// https://cti.maypaseducation.com/api/request/service/initiate/pay
// https://cti.maypaseducation.com/api/services
import 'package:ctntelematics/modules/service/data/models/resp_models/get_country_state_resp_model.dart';
import 'package:ctntelematics/modules/service/data/models/resp_models/get_service_payment_resp_model.dart';
import 'package:ctntelematics/modules/service/data/models/resp_models/get_services_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../../../core/constant/constant.dart';
import '../../models/resp_models/request_service_resp_model.dart';
part 'service_api_client.g.dart';

@RestApi(baseUrl: baseUri)
abstract class ServiceApiClient {
  factory ServiceApiClient(Dio _dio) = _ServiceApiClient;

  @POST("/request/service/initiate/pay")
  @FormUrlEncoded()
  Future<GetServicePaymentRespModel> initializePayment(
      @Field("service_id") String service_id,
      @Header("Authorization") String token);

  @GET("/services")
  @FormUrlEncoded()
  Future<List<GetServicesRespModel>> getServices(
      @Header("Authorization") String token);

  @GET("/request/service/states")
  @FormUrlEncoded()
  Future<GetCountryStateModel> getCountryStates(
      @Header("Authorization") String token);

  @POST("/request/service")
  @FormUrlEncoded()
  Future<RequestServiceRespModel> requestService(
      @Header("Authorization") String token,
      @Field("service_id") String service_id,
      @Field("contact_phone") String contact_phone,
      @Field("location_state") String location_state,
      @Field("location_lgvt") String location_lgvt,
      @Field("payment_ref") String payment_ref,
      @Field("location_address") String location_address);
}
