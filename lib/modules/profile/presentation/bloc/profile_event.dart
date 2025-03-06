part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileGenOtpEvent extends ProfileEvent {
  final GenOtpReqEntity genOtpReqEntity;
  const ProfileGenOtpEvent(this.genOtpReqEntity);

  @override
  List<Object?> get props => [genOtpReqEntity];
}

class ProfileChangePwdEvent extends ProfileEvent {
  final ChangePwdReqEntity changePwdReqEntity;
  const ProfileChangePwdEvent(this.changePwdReqEntity);

  @override
  List<Object?> get props => [changePwdReqEntity];
}

class ProfileVerifyEmailEvent extends ProfileEvent {
  final VerifyEmailReqEntity verifyEmailReqEntity;
  const ProfileVerifyEmailEvent(this.verifyEmailReqEntity);

  @override
  List<Object?> get props => [verifyEmailReqEntity];
}

class LogoutEvent extends ProfileEvent {
  final TokenReqEntity tokenReqEntity;
  const LogoutEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class GetScheduleEvent extends ProfileEvent {
  final TokenReqEntity tokenReqEntity;
  const GetScheduleEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}


class CreateScheduleEvent extends ProfileEvent {
  final CreateScheduleReqEntity createScheduleReqEntity;
  const CreateScheduleEvent(this.createScheduleReqEntity);

  @override
  List<Object?> get props => [createScheduleReqEntity];
}

class ProfileVehicleEvent extends ProfileEvent {
  final TokenReqEntity tokenReqEntity;
  const ProfileVehicleEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class ScheduleNoticeEvent extends ProfileEvent {
  final TokenReqEntity tokenReqEntity;
  const ScheduleNoticeEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class SingleScheduleNoticeEvent extends ProfileEvent {
  final TokenReqEntity tokenReqEntity;
  const SingleScheduleNoticeEvent(this.tokenReqEntity);

  @override
  List<Object?> get props => [tokenReqEntity];
}

class CompleteScheduleEvent extends ProfileEvent {
  final CompleteScheduleReqEntity completeScheduleReqEntity;
  const CompleteScheduleEvent(this.completeScheduleReqEntity);

  @override
  List<Object?> get props => [completeScheduleReqEntity];
}

class ExpensesEvent extends ProfileEvent {
  final ExpensesReqEntity expensesReqEntity;
  const ExpensesEvent(this.expensesReqEntity);

  @override
  List<Object?> get props => [expensesReqEntity];
}
