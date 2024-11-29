part of 'eshop_bloc.dart';

abstract class EshopEvent extends Equatable {
  const EshopEvent();

  @override
  List<Object?> get props => [];
}

class EshopGetProductsEvent extends EshopEvent {
  final EshopTokenReqEntity eshopTokenReqEntity;
  const EshopGetProductsEvent(this.eshopTokenReqEntity);

  @override
  List<Object?> get props => [eshopTokenReqEntity];
}

class EshopGetCategoryEvent extends EshopEvent {
  final EshopTokenReqEntity eshopTokenReqEntity;
  const EshopGetCategoryEvent(this.eshopTokenReqEntity);

  @override
  List<Object?> get props => [eshopTokenReqEntity];
}

class EshopGetProductEvent extends EshopEvent {
  final EshopTokenReqEntity eshopTokenReqEntity;
  const EshopGetProductEvent(this.eshopTokenReqEntity);

  @override
  List<Object?> get props => [eshopTokenReqEntity];
}

class InitiatePaymentEvent extends EshopEvent {
  final InitiatePaymentReqEntity initiatePaymentReqEntity;
  const InitiatePaymentEvent(this.initiatePaymentReqEntity);

  @override
  List<Object?> get props => [initiatePaymentReqEntity];
}

class ConfirmPaymentEvent extends EshopEvent {
  final EshopTokenReqEntity eshopTokenReqEntity;
  const ConfirmPaymentEvent(this.eshopTokenReqEntity);

  @override
  List<Object?> get props => [eshopTokenReqEntity];
}


class DeliveryLocationEvent extends EshopEvent {
  final EshopTokenReqEntity eshopTokenReqEntity;
  const DeliveryLocationEvent(this.eshopTokenReqEntity);

  @override
  List<Object?> get props => [eshopTokenReqEntity];
}

