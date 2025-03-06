import 'package:equatable/equatable.dart';

class ExpensesReqEntity extends Equatable{
  final String from;
  final String to;
  final String token;

  const ExpensesReqEntity({
    required this.from,
    required this.to,
    required this.token,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [from, to, token];

}


