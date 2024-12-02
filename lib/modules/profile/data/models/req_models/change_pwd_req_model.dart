import 'package:equatable/equatable.dart';

class ChangePwdReqModel extends Equatable{
  final String password;
  final String password_confirmation;
  final String email;
  final String otp;

  const ChangePwdReqModel({
    required this.email,
    required this.password,
    required this.otp,
    required this.password_confirmation
  });

  factory ChangePwdReqModel.fromJson(Map<String, dynamic> json) {
    return ChangePwdReqModel(
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      password_confirmation: json['password_confirmation'] ?? "",
      otp: json['otp'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "otp": otp,
    "password_confirmation":password_confirmation
  };

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, otp, password_confirmation];

}


