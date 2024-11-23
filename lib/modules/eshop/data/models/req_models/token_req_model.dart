
import 'package:equatable/equatable.dart';

class EshopTokenReqModel extends Equatable{
  final String token;
  final int? id;

  const EshopTokenReqModel({
    required this.token, this.id
  });

  factory EshopTokenReqModel.fromJson(Map<String, dynamic> json) {
    return EshopTokenReqModel(
      token: json['token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token,];

}