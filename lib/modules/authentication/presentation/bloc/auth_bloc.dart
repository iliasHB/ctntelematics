import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/change_pwd_req_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/auth_req_entites/login_req_entity.dart';
import '../../domain/entities/auth_req_entites/gen_otp_req_entity.dart';
import '../../domain/entities/auth_req_entites/verify_email_req_entity.dart';
import '../../domain/entities/auth_resp_entities/login_resp_entites.dart';
import '../../domain/entities/auth_resp_entities/auth_resp_entity.dart';
import '../../domain/usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class LoginBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) => emit.forEach<AuthState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => AuthFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<AuthState> mapEventToState(LoginEvent event) async* {
    yield AuthLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final user = await loginUseCase(LoginReqEntity(
        email: event.loginReqEntity.email,
        password: event.loginReqEntity.password,
      ));
      yield LoginDone(user); // Emit success state after getting the user
      ///------------------------------------------------
      // Use yield* to delegate stream handling to loginUseCase
      // await for (final user in loginUseCase(LoginReqEntity(
      //   email: event.loginReqEntity.email,
      //   password: event.loginReqEntity.password,
      // ))) {
      //   yield LoginDone(user); // Emit success state with the user data
      // }

    } catch (error) {
      if (error is ApiErrorException) {
        yield AuthFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield AuthFailure(error.message); // Emit network failure message
      }
      else {
        yield const AuthFailure("An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}


class GenerateOtpBloc extends Bloc<AuthEvent, AuthState> {
  final GenerateOtpUseCase generateOtpUseCase;

  GenerateOtpBloc(this.generateOtpUseCase) : super(AuthInitial()) {
    on<GenerateOtpEvent>((event, emit) => emit.forEach<AuthState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => AuthFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<AuthState> mapEventToState(GenerateOtpEvent event) async* {
    yield AuthLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final user = await generateOtpUseCase(event.genOtpReqEntity);
      yield AuthDone(user); // Emit success state after getting the user

    } catch (error) {
      if (error is ApiErrorException) {
        yield AuthFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield AuthFailure(error.message); // Emit network failure message
      }
      else {
        yield const AuthFailure("An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}

// class GenerateOtpBloc extends Bloc<AuthEvent, AuthState> {
//   final GenerateOtpUseCase generateOtpUseCase;
//
//   GenerateOtpBloc(this.generateOtpUseCase) : super(AuthInitial()) {
//     on<GenerateOtpEvent>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         final dataState = await generateOtpUseCase(event.genOtpReqEntity);
//         emit(GenerateOtpDone(dataState));
//       } catch (e) {
//         print("error: $e");
//         emit(AuthFailure(e.toString()));
//       }
//     });
//   }
// }


class ChangePwdBloc extends Bloc<AuthEvent, AuthState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePwdBloc(this.changePasswordUseCase) : super(AuthInitial()) {
    on<ChangePwdEvent>((event, emit) => emit.forEach<AuthState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => AuthFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<AuthState> mapEventToState(ChangePwdEvent event) async* {
    yield AuthLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final user = await changePasswordUseCase(event.changePwdReqEntity);
      yield AuthDone(user); // Emit success state after getting the user

    } catch (error) {
      if (error is ApiErrorException) {
        yield AuthFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield AuthFailure(error.message); // Emit network failure message
      }
      else {
        yield const AuthFailure("An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}


class EmailVerifyBloc extends Bloc<AuthEvent, AuthState> {
  final VerifyEmailUseCase verifyEmailUseCase;

  EmailVerifyBloc(this.verifyEmailUseCase) : super(AuthInitial()) {
    on<VerifyEmailEvent>((event, emit) => emit.forEach<AuthState>(
      mapEventToState(event),
      onData: (state) => state,
      onError: (error, stackTrace) => AuthFailure(error.toString()), // Handle error cases
    ));
  }

  Stream<AuthState> mapEventToState(VerifyEmailEvent event) async* {
    yield AuthLoading(); // Emit loading state
    try {
      // Use yield* to delegate stream handling to loginUseCase
      final user = await verifyEmailUseCase(event.verifyEmailReqEntity);
      yield AuthDone(user); // Emit success state after getting the user

    } catch (error) {
      if (error is ApiErrorException) {
        yield AuthFailure(error.message); // Emit API error message
      } else if (error is NetworkException) {
        yield AuthFailure(error.message); // Emit network failure message
      }
      else {
        yield const AuthFailure("An unexpected error occurred. Please try again."); // Emit generic error message
      }
    }
  }
}