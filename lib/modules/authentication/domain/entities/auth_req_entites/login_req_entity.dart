
import 'package:equatable/equatable.dart';

class LoginReqEntity extends Equatable{
  String password;
  String email;

  LoginReqEntity({
    required this.email,
    required this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [password, email];
}


