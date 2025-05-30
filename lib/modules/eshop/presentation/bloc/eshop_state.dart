
part of 'eshop_bloc.dart';

abstract class EshopState extends Equatable {
  const EshopState();

  @override
  List<Object?> get props => [];
}

class EshopInitial extends EshopState {}

class EshopLoading extends EshopState {}

class EshopFailure extends EshopState {
  final String message;

  const EshopFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class EshopGetProductsDone extends EshopState {
  final GetAllProductEntity resp;

  const EshopGetProductsDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class EshopGetCategoryDone extends EshopState {
  final GetCategoryEntity resp;

  const EshopGetCategoryDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class EshopGetProductDone extends EshopState {
  final GetProductEntity resp;

  const EshopGetProductDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class InitiatePaymentDone extends EshopState {
  final GetPaymentRespEntity resp;

  const InitiatePaymentDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class ConfirmPaymentDone extends EshopState {
  final ConfirmPaymentRespEntity resp;

  const ConfirmPaymentDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class DeliveryLocationDone extends EshopState {
  final DeliveryLocationRespEntity resp;

  const DeliveryLocationDone(this.resp);

  @override
  List<Object?> get props => [resp];
}



