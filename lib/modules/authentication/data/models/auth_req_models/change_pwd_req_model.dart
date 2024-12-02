import 'package:equatable/equatable.dart';

class ChangePwdReqModel extends Equatable{
  final String password;
  final String passwordConfirmation;
  final String email;
  final String otp;

  const ChangePwdReqModel({
    required this.email,
    required this.password,
    required this.otp,
    required this.passwordConfirmation
  });

  factory ChangePwdReqModel.fromJson(Map<String, dynamic> json) {
    return ChangePwdReqModel(
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      passwordConfirmation: json['password_confirmation'] ?? "",
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


