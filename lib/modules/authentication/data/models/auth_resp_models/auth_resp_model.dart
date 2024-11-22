
import '../../../domain/entities/auth_resp_entities/auth_resp_entity.dart';

class AuthRespModel extends AuthRespEntity {
  AuthRespModel({required super.message});

  factory AuthRespModel.fromJson(Map<String, dynamic> json) {
    return AuthRespModel(
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}
