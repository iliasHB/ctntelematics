import 'package:equatable/equatable.dart';

class ExpensesReqModel extends Equatable{
  final String from;
  final String to;
  final String token;

  const ExpensesReqModel({
    required this.from,
    required this.to,
    required this.token,
  });

  factory ExpensesReqModel.fromJson(Map<String, dynamic> json) {
    return ExpensesReqModel(
      from: json['from'] ?? "",
      to: json['to'] ?? "",
      token: json['token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to,
    "token": token,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [from, to, token];

}


