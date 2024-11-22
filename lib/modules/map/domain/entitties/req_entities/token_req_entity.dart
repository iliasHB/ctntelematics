import 'package:equatable/equatable.dart';

class TokenReqEntity extends Equatable{
  final String token;
  final String contentType;

  const TokenReqEntity({
    required this.token,
    required this.contentType
  });

  Map<String, dynamic> toJson() => {
    "token": token,
    "contentType": contentType
  };

  @override
  // TODO: implement props
  List<Object?> get props => [token, contentType];
}
