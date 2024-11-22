
import 'package:equatable/equatable.dart';

class RespEntity extends Equatable {
  bool? success;
  String? message;

  RespEntity({this.message, this.success});

  @override
  // TODO: implement props
  List<Object?> get props => [
    success,
    message
  ];
}