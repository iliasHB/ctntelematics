import '../../../domain/entities/auth_resp_entities/login_resp_entites.dart';

class LoginRespModel extends LoginRespEntity {

  LoginRespModel({
    required super.message,
    required UserModel super.user,
    required super.token,
  });
  factory LoginRespModel.fromJson(Map<String, dynamic> json) {
    return LoginRespModel(
      message: json['message'],
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user,
    };
  }

}

class UserModel extends UserEntity{

  UserModel({
    required super.first_name,
    required super.last_name,
    required super.middle_name,
    required super.phone,
    required super.user_type,
    required super.status,
    required super.email,
    required super.email_verified_at,
    required super.created_at,
    required super.updated_at,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      first_name: json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      middle_name: json['middle_name'] ?? "",
      phone: json['phone'] ?? "",
      user_type: json['user_type'] ?? "",
      status: json['status'] ?? "",
      email: json['email'] ?? "",
      email_verified_at: json['email_verified_at'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'middle_name': middle_name,
      'phone': phone,
      'user_type': user_type,
      'status': status,
      'email': email,
      'email_verified_at': email_verified_at,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
