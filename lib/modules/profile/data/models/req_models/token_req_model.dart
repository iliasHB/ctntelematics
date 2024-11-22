import 'package:equatable/equatable.dart';

class TokenReqModel extends Equatable{
  final String token;
  final String? contentType;

  const TokenReqModel({
    required this.token, this.contentType
  });

  factory TokenReqModel.fromJson(Map<String, dynamic> json) {
    return TokenReqModel(
      token: json['token'] ?? "",
      contentType: json['contentType'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType];
}
