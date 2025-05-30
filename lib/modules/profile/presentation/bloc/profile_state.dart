
part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileDone extends ProfileState {
  final ProfileRespEntity resp;

  const ProfileDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class GetScheduleDone extends ProfileState {
  final GetScheduleRespEntity resp;

  const GetScheduleDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class CreateScheduleDone extends ProfileState {
  final CreateScheduleRespEntity resp;

  const CreateScheduleDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class GetVehicleDone extends ProfileState {
  final ProfileVehicleRespEntity resp;

  const GetVehicleDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class GetScheduleNoticeDone extends ProfileState {
  final List<GetScheduleNoticeRespEntity> resp;

  const GetScheduleNoticeDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class GetSingleScheduleNoticeDone extends ProfileState {
  final GetScheduleNoticeRespEntity resp;

  const GetSingleScheduleNoticeDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class CompleteScheduleDone extends ProfileState {
  final CompleteScheduleRespEntity resp;

  const CompleteScheduleDone(this.resp);

  @override
  List<Object?> get props => [resp];
}


class ExpensesDone extends ProfileState {
  final ExpensesRespEntity resp;

  const ExpensesDone(this.resp);

  @override
  List<Object?> get props => [resp];
}


