
import 'package:equatable/equatable.dart';

class CompleteScheduleRespEntity extends Equatable{
  final String message;
  final String next_start_date;

  CompleteScheduleRespEntity({
  required this.message, required this.next_start_date

});
  @override
  // TODO: implement props
  List<Object?> get props => [
    message,
    next_start_date
  ];

}