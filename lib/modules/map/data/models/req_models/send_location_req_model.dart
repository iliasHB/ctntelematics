import 'package:equatable/equatable.dart';

class SendLocationReqModel extends Equatable {
  final String email;
  final String url;
  final String contentType;
  final String token;

  const SendLocationReqModel(
      {required this.email,
      required this.url,
      required this.contentType,
      required this.token});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
