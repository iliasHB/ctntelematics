import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/initiate_payment_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_category_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_payment_resp_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../entitties/resp_entities/get_all_product_entity.dart';
import '../entitties/resp_entities/get_product_entity.dart';
import '../repositories/eshop_repository.dart';

class GetProductsUseCase extends UseCase<void, EshopTokenReqEntity>{
  final EshopRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<GetAllProductEntity> call(EshopTokenReqEntity params) async {
    return await repository.onGetProducts(params);
  }
}


class GetCategoryUseCase extends UseCase<void, EshopTokenReqEntity> {
  final EshopRepository repository;
  GetCategoryUseCase(this.repository);

  @override
  Future<GetCategoryEntity> call(EshopTokenReqEntity params) {
    // TODO: implement call
    return repository.onGetCategory(params);
  }
}

class GetProductUseCase extends UseCase<void, EshopTokenReqEntity> {
  final EshopRepository repository;
  GetProductUseCase(this.repository);

  @override
  Future<GetProductEntity> call(EshopTokenReqEntity params) {
    // TODO: implement call
    return repository.onGetProduct(params);
  }
}

class InitiatePaymentUseCase extends UseCase<void, InitiatePaymentReqEntity> {
  final EshopRepository repository;
  InitiatePaymentUseCase(this.repository);

  @override
  Future<GetPaymentRespEntity> call(InitiatePaymentReqEntity params) {
    // TODO: implement call
    return repository.onInitiatePayment(params);
  }
}
