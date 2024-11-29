
import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/initiate_payment_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/confirm_payment_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/delivery_location_resp_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_all_product_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_category_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_payment_resp_entity.dart';
import 'package:ctntelematics/modules/eshop/domain/entitties/resp_entities/get_product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/eshop_usecase.dart';

part 'eshop_event.dart';
part 'eshop_state.dart';

class EshopGetAllProductBloc extends Bloc<EshopEvent, EshopState> {
  final GetProductsUseCase getProductsUseCase;

  EshopGetAllProductBloc(this.getProductsUseCase) : super(EshopInitial()) {
    on<EshopGetProductsEvent>((event, emit) => emit.forEach<EshopState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              EshopFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<EshopState> mapEventToState(EshopGetProductsEvent event) async* {
    yield EshopLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await getProductsUseCase(event.eshopTokenReqEntity);
      yield EshopGetProductsDone(resp); // Emit success state after getting the user
    } catch (error) {
      print(":::::::::: all-product-error :::::::::: ${error}");
      // if (error is ApiErrorException) {
      //   yield ProfileFailure(error.message); // Emit API error message
      // } else if (error is NetworkException) {
      //   yield ProfileFailure(error.message); // Emit network failure message
      // } else {
        yield const EshopFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
// }

class EshopGetCategoryBloc extends Bloc<EshopEvent, EshopState> {
  final GetCategoryUseCase getCategoryUseCase;

  EshopGetCategoryBloc(this.getCategoryUseCase) : super(EshopInitial()) {
    on<EshopGetCategoryEvent>((event, emit) => emit.forEach<EshopState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              EshopFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<EshopState> mapEventToState(EshopGetCategoryEvent event) async* {
    yield EshopLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await getCategoryUseCase(event.eshopTokenReqEntity);
      yield EshopGetCategoryDone(resp); // Emit success state after getting the user
    } catch (error) {
      print(":::::::::: category-error :::::::::: ${error}");
      // if (error is ApiErrorException) {
      //   yield ProfileFailure(error.message); // Emit API error message
      // } else if (error is NetworkException) {
      //   yield EshopFailure(error.message); // Emit network failure message
      // } else {
        yield const EshopFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      // }
    }
  }
}

class EshopGetProductBloc extends Bloc<EshopEvent, EshopState> {
  final GetProductUseCase getProductUseCase;

  EshopGetProductBloc(this.getProductUseCase) : super(EshopInitial()) {
    on<EshopGetProductEvent>((event, emit) => emit.forEach<EshopState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          EshopFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<EshopState> mapEventToState(EshopGetProductEvent event) async* {
    yield EshopLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await getProductUseCase(event.eshopTokenReqEntity);
      yield EshopGetProductDone(resp); // Emit success state after getting the user
    } catch (error) {
      print(":::::::::: product-error :::::::::: ${error}");
      // if (error is ApiErrorException) {
      //   yield ProfileFailure(error.message); // Emit API error message
      // } else if (error is NetworkException) {
      //   yield ProfileFailure(error.message); // Emit network failure message
      // } else {
      yield const EshopFailure(
          "An unexpected error occurred. Please try again."); // Emit generic error message
    }
  }
}

class InitiatePaymentBloc extends Bloc<EshopEvent, EshopState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;

  InitiatePaymentBloc(this.initiatePaymentUseCase) : super(EshopInitial()) {
    on<InitiatePaymentEvent>((event, emit) => emit.forEach<EshopState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          EshopFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<EshopState> mapEventToState(InitiatePaymentEvent event) async* {
    yield EshopLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await initiatePaymentUseCase(event.initiatePaymentReqEntity);
      yield InitiatePaymentDone(resp); // Emit success state after getting the user
    } catch (error) {
      print(":::::::::: product-error :::::::::: ${error}");
      // if (error is ApiErrorException) {
      //   yield ProfileFailure(error.message); // Emit API error message
      // } else if (error is NetworkException) {
      //   yield ProfileFailure(error.message); // Emit network failure message
      // } else {
      yield const EshopFailure(
          "An unexpected error occurred. Please try again."); // Emit generic error message
    }
  }
}


class DeliveryLocationBloc extends Bloc<EshopEvent, EshopState> {
  final DeliveryLocationUseCase deliveryLocationUseCase;

  DeliveryLocationBloc(this.deliveryLocationUseCase) : super(EshopInitial()) {
    on<DeliveryLocationEvent>((event, emit) => emit.forEach<EshopState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          EshopFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<EshopState> mapEventToState(DeliveryLocationEvent event) async* {
    yield EshopLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await deliveryLocationUseCase(event.eshopTokenReqEntity);
      yield DeliveryLocationDone(resp); // Emit success state after getting the user
    } catch (error) {
      print(":::::::::: product-error :::::::::: ${error}");
      // if (error is ApiErrorException) {
      //   yield ProfileFailure(error.message); // Emit API error message
      // } else if (error is NetworkException) {
      //   yield ProfileFailure(error.message); // Emit network failure message
      // } else {
      yield const EshopFailure(
          "An unexpected error occurred. Please try again."); // Emit generic error message
    }
  }
}


class ConfirmPaymentBloc extends Bloc<EshopEvent, EshopState> {
  final ConfirmPaymentUseCase confirmPaymentUseCase;

  ConfirmPaymentBloc(this.confirmPaymentUseCase) : super(EshopInitial()) {
    on<ConfirmPaymentEvent>((event, emit) => emit.forEach<EshopState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          EshopFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<EshopState> mapEventToState(ConfirmPaymentEvent event) async* {
    yield EshopLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await confirmPaymentUseCase(event.eshopTokenReqEntity);
      yield ConfirmPaymentDone(resp); // Emit success state after getting the user
    } catch (error) {
      print(":::::::::: product-error :::::::::: ${error}");
      // if (error is ApiErrorException) {
      //   yield ProfileFailure(error.message); // Emit API error message
      // } else if (error is NetworkException) {
      //   yield ProfileFailure(error.message); // Emit network failure message
      // } else {
      yield const EshopFailure(
          "An unexpected error occurred. Please try again."); // Emit generic error message
    }
  }
}
