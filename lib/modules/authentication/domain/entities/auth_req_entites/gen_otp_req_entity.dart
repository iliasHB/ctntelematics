
import 'package:equatable/equatable.dart';

class GenOtpReqEntity extends Equatable{
  final String email;

  const GenOtpReqEntity({
    required this.email,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [email];

}