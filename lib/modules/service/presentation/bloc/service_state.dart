part of 'service_bloc.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceFailure extends ServiceState {
  final String message;

  const ServiceFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetServicesDone extends ServiceState {
  final List<GetServicesRespEntity> resp;

  const GetServicesDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class InitializePaymentDone extends ServiceState {
  final GetServicePaymentRespEntity resp;

  const InitializePaymentDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class GetCountryStateDone extends ServiceState {
  final GetCountryStateEntity resp;

  const GetCountryStateDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class RequestServiceDone extends ServiceState {
  final RequestServiceRespEntity resp;

  const RequestServiceDone(this.resp);

  @override
  List<Object?> get props => [resp];
}