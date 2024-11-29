import 'package:ctntelematics/modules/eshop/data/models/resp_models/get_payment_resp_model.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/initiate_payment_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/confirm_payment_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/delivery_location_resp_entity.dart';

import '../../data/models/resp_models/get_product_model.dart';
import '../entitties/resp_entities/get_all_product_entity.dart';
import '../entitties/resp_entities/get_category_entity.dart';
import '../entitties/resp_entities/get_payment_resp_entity.dart';
import '../entitties/resp_entities/get_product_entity.dart';

abstract class EshopRepository {
  Future<GetAllProductEntity> onGetProducts(EshopTokenReqEntity eshopTokenReqEntity);
  Future<GetCategoryEntity> onGetCategory(EshopTokenReqEntity eshopTokenReqEntity);
  Future<GetProductEntity> onGetProduct(EshopTokenReqEntity eshopTokenReqEntity);
  Future<GetPaymentRespEntity> onInitiatePayment(InitiatePaymentReqEntity initiatePaymentReqEntity);
  Future<ConfirmPaymentRespEntity> onConfirmPayment(EshopTokenReqEntity eshopTokenReqEntity);
  Future<DeliveryLocationRespEntity> onDeliveryLocation();
}