
import 'package:equatable/equatable.dart';

class GetAllProductEntity extends Equatable{
  ProductsEntity products;
  ProductsEntity similarGoods;

  GetAllProductEntity({
    required this.products,
    required this.similarGoods,
  });


  @override
  // TODO: implement props
  List<Object?> get props => [
    products,
    similarGoods
  ];
}

class ProductsEntity extends Equatable{
  int currentPage;
  List<EShopDatumEntity> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<EshopLinkEntity> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  ProductsEntity({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    currentPage,
    data,
    firstPageUrl,
    from,
    lastPage,
    lastPageUrl,
    links,
    nextPageUrl,
    path,
    perPage,
    prevPageUrl,
    to,
    total
  ];
}

class EShopDatumEntity extends Equatable{
  int id;
  String name;
  String description;
  String price;
  int stockQuantity;
  String sku;
  String image;
  int categoryId;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  EShopDatumEntity({
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
