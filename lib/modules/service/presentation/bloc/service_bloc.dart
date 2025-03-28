import 'package:ctntelematics/modules/service/domain/entitties/req_entities/request_service_req_entity.dart';
import 'package:ctntelematics/modules/service/domain/entitties/resp_entities/request_service_resp_entity.dart';
import 'package:ctntelematics/modules/service/domain/usecases/service_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/model/token_req_entity.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/service_data_state.dart';
import '../../domain/entitties/resp_entities/get_country_state_resp_entity.dart';
import '../../domain/entitties/resp_entities/get_service_payment_resp_entity.dart';
import '../../domain/entitties/resp_entities/get_services_entity.dart';
part 'service_event.dart';
part 'service_state.dart';

class InitiateServicePaymentBloc extends Bloc<ServiceEvent, ServiceState> {
  final InitializeServicePaymentUseCase initiatePaymentUseCase;

  InitiateServicePaymentBloc(this.initiatePaymentUseCase) : super(ServiceInitial()) {
    on<InitializePaymentEvent>((event, emit) => emit.forEach<ServiceState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          ServiceFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<ServiceState> mapEventToState(InitializePaymentEvent event) async* {
    yield ServiceLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await initiatePaymentUseCase(event.tokenReqEntity);
      yield InitializePaymentDone(resp); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ServiceFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ServiceFailure(error.message); // Emit network failure message
      } else {
        yield const ServiceFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class GetCountryStateBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetCountryStatesUseCase countryStatesUseCase;

  GetCountryStateBloc(this.countryStatesUseCase) : super(ServiceInitial()) {
    on<GetCountryStateEvent>((event, emit) => emit.forEach<ServiceState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          ServiceFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<ServiceState> mapEventToState(GetCountryStateEvent event) async* {
    yield ServiceLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await countryStatesUseCase(event.tokenReqEntity);
      yield GetCountryStateDone(resp); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ServiceFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ServiceFailure(error.message); // Emit network failure message
      } else {
        yield const ServiceFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class GetServicesBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServicesUseCase servicesUseCasesUseCase;

  GetServicesBloc(this.servicesUseCasesUseCase) : super(ServiceInitial()) {
    on<GetServicesEvent>((event, emit) => emit.forEach<ServiceState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          ServiceFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<ServiceState> mapEventToState(GetServicesEvent event) async* {
    yield ServiceLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await servicesUseCasesUseCase(event.tokenReqEntity);
      yield GetServicesDone(resp); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ServiceFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ServiceFailure(error.message); // Emit network failure message
      } else {
        yield const ServiceFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}



class RequestServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final RequestServiceUseCase requestServiceUseCase;

  RequestServiceBloc(this.requestServiceUseCase) : super(ServiceInitial()) {
    on<RequestServiceEvent>((event, emit) => emit.forEach<ServiceState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          ServiceFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<ServiceState> mapEventToState(RequestServiceEvent event) async* {
    yield ServiceLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final resp = await requestServiceUseCase(event.requestServiceReqEntity);
      yield RequestServiceDone(resp); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ServiceFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ServiceFailure(error.message); // Emit network failure message
      } else {
        yield const ServiceFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

