import 'package:equatable/equatable.dart';

class InitiatePaymentReqModel extends Equatable {
  final String email, contact_phone, delivery_address;
  final String quantity, product_id, location_id;
      // token;

  const InitiatePaymentReqModel(
      {required this.email,
      required this.quantity,
      required this.contact_phone,
      required this.delivery_address,
      required this.location_id,
      required this.product_id,
      // required this.token
      });

  factory InitiatePaymentReqModel.fromJson(Map<String, dynamic> json) {
    return InitiatePaymentReqModel(
        email: json['email'] ?? "",
        quantity: json['quantity'] ?? "",
        contact_phone: json['contact_phone'] ?? "",
        delivery_address: json['delivery_address'] ?? "",
        product_id: json['product_id'] ?? "",
        location_id: json['location_id'] ?? "");
        // token: json['location_id'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'contact_phone': contact_phone,
        'delivery_address': delivery_address,
        'quantity': quantity,
        'product_id': product_id,
        'location_id': location_id,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        contact_phone,
        delivery_address,
        quantity,
        product_id,
        location_id
      ];
}
