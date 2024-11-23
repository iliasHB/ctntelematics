

import '../../../domain/entitties/resp_entities/get_product_entity.dart';

class GetProductModel extends GetProductEntity{

  GetProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.stockQuantity,
    required super.sku,
    required super.image,
    required super.categoryId,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GetProductModel.fromJson(Map<String, dynamic> json) => GetProductModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stockQuantity: json["stock_quantity"],
    sku: json["sku"],
    image: json["image"],
    categoryId: json["category_id"],
    isActive: json["is_active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock_quantity": stockQuantity,
    "sku": sku,
    "image": image,
    "category_id": categoryId,
    "is_active": isActive,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
