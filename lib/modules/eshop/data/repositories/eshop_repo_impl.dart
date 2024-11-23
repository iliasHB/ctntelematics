import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/token_req_entity.dart';

import '../../domain/repositories/eshop_repository.dart';
import '../datasources/remote/eshop_api_client.dart';
import '../models/req_models/token_req_model.dart';
import '../models/resp_models/get_all_product_model.dart';
import '../models/resp_models/get_category_model.dart';
import '../models/resp_models/get_product_model.dart';

const source_code = 'aYlzC1ZpqjBnPfsGRC5dkawZRugvJaZYmL6D9ZZZuhO6wlg7uR';

class EshopRepositoryImpl extends EshopRepository {
  final EshopApiClient apiClient;
  EshopRepositoryImpl(this.apiClient);

  @override
  Future<GetAllProductModel> onGetProducts(
      EshopTokenReqEntity tokenReqEntity) async {
    EshopTokenReqModel tokenReqModel =
        EshopTokenReqModel(token: tokenReqEntity.token);

    try {
      return apiClient.getProducts(tokenReqModel.token, source_code);
      // }
      // on ApiErrorException catch (e) {
      //   throw ApiErrorException(
      //       e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting location.");
    }
  }

  @override
  Future<GetCategoryModel> onGetCategory(
      EshopTokenReqEntity tokenReqEntity) async {
    EshopTokenReqModel tokenReqModel =
    EshopTokenReqModel(token: tokenReqEntity.token);
    try {
      return apiClient.getCategory(tokenReqModel.token);
      // }
      // on ApiErrorException catch (e) {
      //   throw ApiErrorException(
      //       e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting location.");
    }
  }


  @override
  Future<GetProductModel> onGetProduct(EshopTokenReqEntity tokenReqEntity) async {
    EshopTokenReqModel tokenReqModel =
    EshopTokenReqModel(token: tokenReqEntity.token, id: tokenReqEntity.id);
    try {
      return apiClient.getProduct(tokenReqModel.id!, tokenReqModel.token, source_code);
      // }
      // on ApiErrorException catch (e) {
      //   throw ApiErrorException(
      //       e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while getting location.");
    }
  }
}
