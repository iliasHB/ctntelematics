

import '../../../domain/entitties/resp_entities/profile_resp_entity.dart';

class ProfileRespModel extends ProfileRespEntity {
  const ProfileRespModel({required super.message});

  factory ProfileRespModel.fromJson(Map<String, dynamic> json) {
    return ProfileRespModel(
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
