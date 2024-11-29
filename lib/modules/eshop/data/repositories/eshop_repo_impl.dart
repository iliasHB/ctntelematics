import 'package:ctntelematics/modules/eshop/data/models/resp_models/confirm_payment_resp_model.dart';
import 'package:ctntelematics/modules/eshop/data/models/resp_models/get_payment_resp_model.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/delivery_location_resp_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_payment_resp_entity.dart';

import '../../domain/entitties/req_entities/initiate_payment_req_entity.dart';
import '../../domain/repositories/eshop_repository.dart';
import '../datasources/remote/eshop_api_client.dart';
import '../models/req_models/initiate_payment_req_model.dart';
import '../models/req_models/token_req_model.dart';
import '../models/resp_models/delivery_location_resp_model.dart';
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
      return apiClient.getProducts(tokenReqModel.token!, source_code);
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
      return apiClient.getCategory(tokenReqModel.token!);
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
      return apiClient.getProduct(tokenReqModel.id!, tokenReqModel.token!, source_code);
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
  Future<GetPaymentRespModel> onInitiatePayment(InitiatePaymentReqEntity initiatePaymentReqEntity) async {
    InitiatePaymentReqModel initiatePaymentReqModel =
    InitiatePaymentReqModel(email: initiatePaymentReqEntity.email,
        quantity: initiatePaymentReqEntity.quantity,
        contact_phone: initiatePaymentReqEntity.contact_phone,
        delivery_address: initiatePaymentReqEntity.delivery_address,
        location_id: initiatePaymentReqEntity.location_id,
        product_id: initiatePaymentReqEntity.product_id,
        // token: initiatePaymentReqEntity.token

    );
    try {
      return apiClient.initiatePayment(
          initiatePaymentReqModel.email,
          initiatePaymentReqModel.contact_phone,
          initiatePaymentReqModel.delivery_address,
          initiatePaymentReqModel.quantity,
          initiatePaymentReqModel.product_id,
          initiatePaymentReqModel.location_id, source_code);

      // }
      // on ApiErrorException catch (e) {
      //   throw ApiErrorException(
      //       e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while initiating payment.");
    }
  }



  @override
  Future<ConfirmPaymentRespModel> onConfirmPayment(EshopTokenReqEntity tokenReqEntity) async {
    EshopTokenReqModel tokenReqModel =
    EshopTokenReqModel(reference: tokenReqEntity.reference,);
    try {
      return apiClient.confirmPayment(tokenReqModel.reference!, source_code);
      // }
      // on ApiErrorException catch (e) {
      //   throw ApiErrorException(
      //       e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while confirming payment.");
    }
  }


  @override
  Future<DeliveryLocationRespModel> onDeliveryLocation() async {
    // EshopTokenReqModel tokenReqModel =
    // EshopTokenReqModel(token: tokenReqEntity.token);
    try {
      return apiClient.getDeliveryLocation(source_code);
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

  // @override
  // Future<DeliveryLocationRespEntity> onDeliveryLocation(EshopTokenReqEntity eshopTokenReqEntity) {
  //   // TODO: implement onDeliveryLocation
  //   throw UnimplementedError();
  // }



}
