import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'login_req_model.g.dart';
//
// @JsonSerializable()
class LoginReqModel extends Equatable{
  final String password;
  final String email;

  const LoginReqModel({
    required this.email,
    required this.password,
  });

  factory LoginReqModel.fromJson(Map<String, dynamic> json) {
    return LoginReqModel(
      email: json['email'] ?? "",
      password: json['password'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];

}


