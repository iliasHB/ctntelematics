
import 'package:equatable/equatable.dart';

class GetAllProductEntity extends Equatable{
  ProductsEntity products;
  ProductsEntity similar_goods;

  GetAllProductEntity({
    required this.products,
    required this.similar_goods,
  });


  @override
  // TODO: implement props
  List<Object?> get props => [
    products,
    similar_goods
  ];
}

class ProductsEntity extends Equatable{
  int current_page;
  List<EShopDatumEntity> data;
  String first_page_url;
  int from;
  int last_page;
  String last_page_url;
  List<EshopLinkEntity> links;
  dynamic next_page_url;
  String path;
  int per_page;
  dynamic prev_page_url;
  int to;
  int total;

  ProductsEntity({
    required this.current_page,
    required this.data,
    required this.first_page_url,
    required this.from,
    required this.last_page,
    required this.last_page_url,
    required this.links,
    required this.next_page_url,
    required this.path,
    required this.per_page,
    required this.prev_page_url,
    required this.to,
    required this.total,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    current_page,
    data,
    first_page_url,
    from,
    last_page,
    last_page_url,
    links,
    next_page_url,
    path,
    per_page,
    prev_page_url,
    to,
    total
  ];
}

class EShopDatumEntity extends Equatable{
  int id;
  String name;
  String description;
  String price;
  int stock_quantity;
  String sku;
  String image;
  int category_id;
  int is_active;
  String created_at;
  String updated_at;

  EShopDatumEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock_quantity,
    required this.sku,
    required this.image,
    required this.category_id,
    required this.is_active,
    required this.created_at,
    required this.updated_at,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
  id,
  name,
  description,
  price,
  stock_quantity,
  sku,
  image,
  category_id,
  is_active,
  created_at,
  updated_at,
  ];

}

class EshopLinkEntity extends Equatable{
  String? url;
  String label;
  bool active;

  EshopLinkEntity({
    required this.url,
    required this.label,
    required this.active,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
  url,
  label,
  active,
  ];
}
