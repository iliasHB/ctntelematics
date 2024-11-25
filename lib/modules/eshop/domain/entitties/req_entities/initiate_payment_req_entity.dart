import 'package:equatable/equatable.dart';

class InitiatePaymentReqEntity extends Equatable {
  final String email, contact_phone, delivery_address;
  final String quantity, product_id, location_id, token;

  const InitiatePaymentReqEntity(
      {required this.email,
      required this.quantity,
      required this.contact_phone,
      required this.delivery_address,
      required this.location_id,
      required this.product_id, required this.token});

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        contact_phone,
        delivery_address,
        quantity,
        product_id,
        location_id,
    token
      ];
}
