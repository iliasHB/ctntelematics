
import 'package:equatable/equatable.dart';

class EshopTokenReqModel extends Equatable{
  final String? token;
  final int? id;
  final String? reference;

  const EshopTokenReqModel({
    this.token, this.id, this.reference
  });

  factory EshopTokenReqModel.fromJson(Map<String, dynamic> json) {
    return EshopTokenReqModel(
      token: json['token'] ?? "",
      id: json['id'] ?? "",
      reference: json['reference'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "id": id,
    "reference": reference,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token,id,reference];

}