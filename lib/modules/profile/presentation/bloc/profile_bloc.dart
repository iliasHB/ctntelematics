import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/create_schedule_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/verify_email_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/profile_vehicle_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/usecases/profile_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/profile_data_state.dart';
import '../../../map/presentation/bloc/map_bloc.dart';
import '../../domain/entitties/resp_entities/create_schedule_resp_entity.dart';
import '../../domain/entitties/resp_entities/profile_resp_entity.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileGenerateOtpBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileGenerateOtpUseCase generateOtpUseCase;

  ProfileGenerateOtpBloc(this.generateOtpUseCase) : super(ProfileInitial()) {
    on<ProfileGenOtpEvent>((event, emit) => emit.forEach<ProfileState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              ProfileFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<ProfileState> mapEventToState(ProfileGenOtpEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final user = await generateOtpUseCase(event.genOtpReqEntity);
      yield ProfileDone(user); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      } else {
        yield const ProfileFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class ProfileChangePwdBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileChangePasswordUseCase changePasswordUseCase;

  ProfileChangePwdBloc(this.changePasswordUseCase) : super(ProfileInitial()) {
    on<ProfileChangePwdEvent>((event, emit) => emit.forEach<ProfileState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              ProfileFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<ProfileState> mapEventToState(ProfileChangePwdEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final user = await changePasswordUseCase(event.changePwdReqEntity);
      yield ProfileDone(user); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      } else {
        yield const ProfileFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class ProfileEmailVerifyBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileVerifyEmailUseCase verifyEmailUseCase;

  ProfileEmailVerifyBloc(this.verifyEmailUseCase) : super(ProfileInitial()) {
    on<ProfileVerifyEmailEvent>((event, emit) => emit.forEach<ProfileState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              ProfileFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<ProfileState> mapEventToState(ProfileVerifyEmailEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      final user = await verifyEmailUseCase(event.verifyEmailReqEntity);
      yield ProfileDone(user); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      } else {
        yield const ProfileFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class LogoutBloc extends Bloc<ProfileEvent, ProfileState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc(this.logoutUseCase) : super(ProfileInitial()) {
    on<LogoutEvent>((event, emit) => emit.forEach<ProfileState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              ProfileFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<ProfileState> mapEventToState(LogoutEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      final user = await logoutUseCase(event.tokenReqEntity);
      yield ProfileDone(user); // Emit success state after getting the user
    } catch (error) {
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      } else {
        yield const ProfileFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class GetScheduleBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetScheduleUseCase getScheduleUseCase;

  GetScheduleBloc(this.getScheduleUseCase) : super(ProfileInitial()) {
    on<GetScheduleEvent>((event, emit) => emit.forEach<ProfileState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              ProfileFailure(error.toString()), // Handle error cases
        ));
  }

  Stream<ProfileState> mapEventToState(GetScheduleEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      final user = await getScheduleUseCase(event.tokenReqEntity);
      yield GetScheduleDone(user); // Emit success state after getting the user
    } catch (error) {
      print('rrrrrrr::::: $error');
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      }
      else {
        yield const ProfileFailure("An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class CreateScheduleBloc extends Bloc<ProfileEvent, ProfileState> {
  final CreateScheduleUseCase createScheduleUseCase;

  CreateScheduleBloc(this.createScheduleUseCase) : super(ProfileInitial()) {
    on<CreateScheduleEvent>((event, emit) => emit.forEach<ProfileState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) =>
          ProfileFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<ProfileState> mapEventToState(CreateScheduleEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      final user = await createScheduleUseCase(event.createScheduleReqEntity);
      yield CreateScheduleDone(user); // Emit success state after getting the user
    } catch (error) {
      print('rrrrrrr::::: $error');
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      }
      else {
        yield const ProfileFailure("An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

class ProfileVehiclesBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileVehicleUseCase profileVehicleUseCase;

  ProfileVehiclesBloc(this.profileVehicleUseCase) : super(ProfileInitial()) {
    on<ProfileVehicleEvent>((event, emit) =>
        emit.forEach<ProfileState>(
          mapEventToState(event),
          onData: (state) => state,
          onError: (error, stackTrace) =>
              ProfileFailure(error.toString()), // Handle error cases
        ));
  }


  Stream<ProfileState> mapEventToState(ProfileVehicleEvent event) async* {
    yield ProfileLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to vehicleUseCase
      final resp = await profileVehicleUseCase(TokenReqEntity(
        token: event.tokenReqEntity.token,
        contentType: event.tokenReqEntity.contentType,
      ));

      yield GetVehicleDone(resp); // Emit success state after getting the user


    } catch (error) {
      print("error:: $error");
      if (error is ApiErrorException) {
        yield ProfileFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield ProfileFailure(error.message); // Emit network failure message
      }
      else {
        yield const ProfileFailure(
            "An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}
