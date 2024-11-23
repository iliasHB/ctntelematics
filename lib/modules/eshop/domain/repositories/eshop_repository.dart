import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/token_req_entity.dart';

import '../../data/models/resp_models/get_product_model.dart';
import '../entitties/resp_entities/get_all_product_entity.dart';
import '../entitties/resp_entities/get_category_entity.dart';

abstract class EshopRepository {
  Future<GetAllProductEntity> onGetProducts(EshopTokenReqEntity eshopTokenReqEntity);
  Future<GetCategoryEntity> onGetCategory(EshopTokenReqEntity eshopTokenReqEntity);
  Future<GetProductModel> onGetProduct(EshopTokenReqEntity eshopTokenReqEntity);
}