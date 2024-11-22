

import 'package:equatable/equatable.dart';

class ProfileRespEntity extends Equatable{
  final String message;

  const ProfileRespEntity({
    required this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}
