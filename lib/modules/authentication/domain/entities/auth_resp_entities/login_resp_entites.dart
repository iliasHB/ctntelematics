import 'package:equatable/equatable.dart';

class LoginRespEntity extends Equatable{
  String message;
  UserEntity user;
  String token;

  LoginRespEntity({
    required this.message,
    required this.user,
    required this.token,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, user, token];

}

class UserEntity extends Equatable{
  int id;
  String first_name;
  String last_name;
  String middle_name;
  String phone;
  String user_type;
  String status;
  String email;
  String email_verified_at;
  String created_at;
  String updated_at;

  UserEntity({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.middle_name,
    required this.phone,
    required this.user_type,
    required this.status,
    required this.email,
    required this.email_verified_at,
    required this.created_at,
    required this.updated_at,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, first_name, last_name, middle_name, phone, user_type, status, email, email_verified_at, updated_at, created_at];

}