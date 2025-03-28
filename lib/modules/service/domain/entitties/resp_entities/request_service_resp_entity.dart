import 'package:equatable/equatable.dart';

class RequestServiceRespEntity extends Equatable{
  final dynamic success;
  final dynamic message;
  RequestServiceRespEntity(
      {required this.success,
        required this.message,});

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };

  @override
// TODO: implement props
  List<Object?> get props => [
    success,
    message,
  ];
}
