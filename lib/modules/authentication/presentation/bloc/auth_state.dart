
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginDone extends AuthState {
  final LoginRespEntity resp;

  const LoginDone(this.resp);

  @override
  List<Object?> get props => [resp];
}

class AuthDone extends AuthState {
  final AuthRespEntity resp;

  const AuthDone(this.resp);

  @override
  List<Object?> get props => [resp];
}


// class ChangePwdDone extends AuthState {
//   final AuthRespEntity resp;
//
//   const ChangePwdDone(this.resp);
//
//   @override
//   List<Object?> get props => [resp];
// }
//
// class VerifyEmailDone extends AuthState {
//   final AuthRespEntity resp;
//
//   const VerifyEmailDone(this.resp);
//
//   @override
//   List<Object?> get props => [resp];
// }