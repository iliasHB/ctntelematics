
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

