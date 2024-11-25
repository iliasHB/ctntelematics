import 'package:ctntelematics/core/constant/constant.dart';
import 'package:ctntelematics/modules/eshop/data/models/resp_models/get_all_product_model.dart';
import 'package:ctntelematics/modules/eshop/data/models/resp_models/get_payment_resp_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/resp_models/get_category_model.dart';
import '../../models/resp_models/get_product_model.dart';

part 'eshop_api_client.g.dart';

@RestApi(baseUrl: eShopBaseUri)
abstract class EshopApiClient {
  factory EshopApiClient(Dio dio) = _EshopApiClient;

  @GET("/products")
  Future<GetAllProductModel> getProducts(@Header("Authorization") String token,
      @Header("source_code") String sourceCode);

  @GET("/categories")
  Future<GetCategoryModel> getCategory(@Header("Authorization") String token);

  @GET("/products/{id}")
  Future<GetProductModel> getProduct(
    @Path("id") int id,
    @Header("Authorization") String token,
    @Header("source_code") String sourceCode,
  );

  @POST('/payment/initiate')
  @FormUrlEncoded()
  Future<GetPaymentRespModel> initiatePayment(
    @Field('email') String email,
    @Field('contact_phone') String contact_phone,
    @Field('delivery_address') String delivery_address,
    @Field('quantity') String quantity,
    @Field('product_id') String product_id,
    @Field('location_id') String location_id,
    @Header('Authorization') String token,
    @Header('source_code') String sourceCode,
  );
}
