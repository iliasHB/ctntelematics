
import '../../../domain/entitties/resp_entities/get_all_product_entity.dart';

class GetAllProductModel extends GetAllProductEntity{
  GetAllProductModel({
    required super.products,
    required super.similar_goods,
  });

  factory GetAllProductModel.fromJson(Map<String, dynamic> json) => GetAllProductModel(
    products: Products.fromJson(json["products"]),
    similar_goods: Products.fromJson(json["similar_goods"]),
  );

  Map<String, dynamic> toJson() => {
    "products": products,
    "similar_goods": similar_goods
  };
}

class Products extends ProductsEntity{

  Products({
    required super.current_page,
    required super.data,
    required super.first_page_url,
    required super.from,
    required super.last_page,
    required super.last_page_url,
    required super.links,
    required super.next_page_url,
    required super.path,
    required super.per_page,
    required super.prev_page_url,
    required super.to,
    required super.total,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    current_page: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    first_page_url: json["first_page_url"],
    from: json["from"],
    last_page: json["last_page"],
    last_page_url: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    next_page_url: json["next_page_url"],
    path: json["path"],
    per_page: json["per_page"],
    prev_page_url: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": current_page,
    "data": data,
    "first_page_url": first_page_url,
    "from": from,
    "last_page": last_page,
    "last_page_url": last_page_url,
    "links": links,
    "next_page_url": next_page_url,
    "path": path,
    "per_page": per_page,
    "prev_page_url": prev_page_url,
    "to": to,
    "total": total,
  };
}

class Datum extends EShopDatumEntity{

  Datum({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.stock_quantity,
    required super.sku,
    required super.image,
    required super.category_id,
    required super.is_active,
    required super.created_at,
    required super.updated_at,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock_quantity: json["stock_quantity"],
    sku: json["sku"],
    image: json["image"],
    category_id: json["category_id"],
    is_active: json["is_active"],
    created_at: json["created_at"],
  updated_at: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock_quantity": stock_quantity,
    "sku": sku,
    "image": image,
    "category_id": category_id,
    "is_active": is_active,
    "created_at": created_at,
    "updated_at": updated_at,
  };
}

class Link extends EshopLinkEntity{
  Link({
    required super.url,
    required super.label,
    required super.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
