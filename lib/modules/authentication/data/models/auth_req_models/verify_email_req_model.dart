import 'package:equatable/equatable.dart';

class VerifyEmailReqModel extends Equatable{
  final String email;
  final String otp;

  const VerifyEmailReqModel({
    required this.email,
    required this.otp,
  });

  factory VerifyEmailReqModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailReqModel(
      email: json['email'] ?? "",
      otp: json['otp'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "otp": otp,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [email, otp,];

}


