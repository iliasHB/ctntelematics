
import 'package:equatable/equatable.dart';

class GenOtpReqModel extends Equatable{
  final String email;

  const GenOtpReqModel({
    required this.email,
  });

  factory GenOtpReqModel.fromJson(Map<String, dynamic> json) {
    return GenOtpReqModel(
      email: json['email'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [email];

}