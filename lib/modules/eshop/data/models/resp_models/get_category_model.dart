// To parse this JSON data, do
//
//     final getCategoryModel = getCategoryModelFromJson(jsonString);

import 'dart:convert';

import '../../../domain/entitties/resp_entities/get_category_entity.dart';

List<GetCategoryModel> getCategoryModelFromJson(String str) => List<GetCategoryModel>.from(json.decode(str).map((x) => GetCategoryModel.fromJson(x)));

String getCategoryModelToJson(List<GetCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCategoryModel extends GetCategoryEntity{

  GetCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.parent_id,
    required super.image,
    required super.is_active,
  });

  factory GetCategoryModel.fromJson(Map<String, dynamic> json) => GetCategoryModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    parent_id: json["parent_id"],
    image: json["image"],
    is_active: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "parent_id": parent_id,
    "image": image,
    "is_active": is_active,
  };
}
