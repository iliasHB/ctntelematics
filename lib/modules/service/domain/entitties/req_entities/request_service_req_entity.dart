import 'package:equatable/equatable.dart';

class RequestServiceReqEntity extends Equatable{
  final String service_id;
  final String contact_phone;
  final String location_state;
  final String location_lgvt;
  final String payment_ref;
  final String location_address;
  final String token;

  RequestServiceReqEntity(
      {required this.service_id,
        required this.contact_phone,
        required this.location_state,
        required this.location_lgvt,
        required this.payment_ref,
        required this.location_address,
        required this.token
      });

  Map<String, dynamic> toJson() => {
    "service_id": service_id,
    "contact_phone": contact_phone,
    "location_state": location_state,
    "location_lgvt": location_lgvt,
    "payment_ref": payment_ref,
    "location_address": location_address,
    "token": token
  };

  @override
// TODO: implement props
  List<Object?> get props => [
    service_id,
    contact_phone,
    location_state,
    location_lgvt,
    payment_ref,
    location_address,
    token
  ];
}
