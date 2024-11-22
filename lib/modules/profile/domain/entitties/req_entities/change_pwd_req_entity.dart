import 'package:equatable/equatable.dart';

class ChangePwdReqEntity extends Equatable{
  final String password;
  final String passwordConfirmation;
  final String email;
  final String otp;

  const ChangePwdReqEntity({
    required this.email,
    required this.password,
    required this.otp,
    required this.passwordConfirmation
  });

  factory ChangePwdReqEntity.fromJson(Map<String, dynamic> json) {
    return ChangePwdReqEntity(
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      passwordConfirmation: json['passwordConfirmation'] ?? "",
      otp: json['otp'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "otp": otp,
    "passwordConfirmation":passwordConfirmation
  };

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, otp, passwordConfirmation];

}


