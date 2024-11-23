
import 'package:equatable/equatable.dart';

class GetCategoryEntity extends Equatable{
  int id;
  String name;
  String slug;
  String description;
  dynamic parent_id;
  dynamic image;
  int is_active;

  GetCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.parent_id,
    required this.image,
    required this.is_active,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
  id,
  name,
  slug,
  description,
  parent_id,
  image,
  is_active,
  ];
}
