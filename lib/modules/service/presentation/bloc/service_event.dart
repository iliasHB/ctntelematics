
part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class GetServicesEvent extends ServiceEvent {
  final TokenReqEntity tokenReqEntity;
  const GetServicesEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class InitializePaymentEvent extends ServiceEvent {
  final TokenReqEntity tokenReqEntity;
  const InitializePaymentEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class GetCountryStateEvent extends ServiceEvent {
  final TokenReqEntity tokenReqEntity;
  const GetCountryStateEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}


class RequestServiceEvent extends ServiceEvent {
  final RequestServiceReqEntity requestServiceReqEntity;
  const RequestServiceEvent(this.requestServiceReqEntity);

  @override
  List<Object?> get props => [requestServiceReqEntity];
}