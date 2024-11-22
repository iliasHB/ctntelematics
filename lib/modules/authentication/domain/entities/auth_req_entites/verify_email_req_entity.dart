
import 'package:equatable/equatable.dart';

class VerifyEmailReqEntity extends Equatable{
  final String email;
  final String otp;

  const VerifyEmailReqEntity({
    required this.email,
    required this.otp,
  });

  factory VerifyEmailReqEntity.fromJson(Map<String, dynamic> json) {
    return VerifyEmailReqEntity(
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