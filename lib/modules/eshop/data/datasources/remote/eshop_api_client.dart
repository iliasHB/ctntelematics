import 'package:ctntelematics/core/constant/constant.dart';
import 'package:ctntelematics/modules/eshop/data/models/resp_models/get_all_product_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/resp_models/get_category_model.dart';
import '../../models/resp_models/get_product_model.dart';

part 'eshop_api_client.g.dart';

@RestApi(baseUrl: eShopBaseUri)
abstract class EshopApiClient {
  factory EshopApiClient(Dio dio) = _EshopApiClient;

  @GET("/products")
  Future<GetAllProductModel> getProducts(
      @Header("Authorization") String token,
      @Header("source_code") String sourceCode);


  @GET("/categories")
  Future<GetCategoryModel> getCategory(
      @Header("Authorization") String token);

  @GET("/products/{id}")
  Future<GetProductModel> getProduct(
      @Path("id") int id,
      @Header("Authorization") String token,
      @Header("source_code") String sourceCode,);

}