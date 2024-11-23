

import 'package:equatable/equatable.dart';

class GetProductEntity extends Equatable{
  int id;
  String name;
  String description;
  String price;
  int stockQuantity;
  String sku;
  String image;
  int categoryId;
  int isActive;
  String createdAt;
  String updatedAt;

  GetProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.sku,
    required this.image,
    required this.categoryId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    stockQuantity,
    sku,
    image,
    categoryId,
    isActive,
    createdAt,
    updatedAt,
  ];

}
