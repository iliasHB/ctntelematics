part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final LoginReqEntity loginReqEntity;
  const LoginEvent(this.loginReqEntity);

  @override
  List<Object?> get props => [loginReqEntity];
}

class GenerateOtpEvent extends AuthEvent {
  final GenOtpReqEntity genOtpReqEntity;
  const GenerateOtpEvent(this.genOtpReqEntity);

  @override
  List<Object?> get props => [genOtpReqEntity];
}

// class AuthFailure extends AuthState {
//   final String message;
//
//   const AuthFailure(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }

class ChangePwdEvent extends AuthEvent {
  final ChangePwdReqEntity changePwdReqEntity;
  const ChangePwdEvent(this.changePwdReqEntity);

  @override
  List<Object?> get props => [changePwdReqEntity];
}

class VerifyEmailEvent extends AuthEvent {
  final VerifyEmailReqEntity verifyEmailReqEntity;
  const VerifyEmailEvent(this.verifyEmailReqEntity);

  @override
  List<Object?> get props => [verifyEmailReqEntity];
}

