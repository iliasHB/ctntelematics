
import 'package:equatable/equatable.dart';

class AuthRespEntity extends Equatable{
  final String message;

  const AuthRespEntity({
    required this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}