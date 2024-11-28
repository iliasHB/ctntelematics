
import 'package:equatable/equatable.dart';

class DeliveryLocationRespEntity extends Equatable{
  final int? currentPage;
  final List<DeliveryDatumEntity>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<DeliveryLinkEntity>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  DeliveryLocationRespEntity({
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
    total,
  ];

}

class DeliveryDatumEntity extends Equatable{
  final int? id;
  final String? name;
  final String? amount;
  final String? createdAt;
  final String? updatedAt;

  DeliveryDatumEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    name,
    amount,
    createdAt,
    updatedAt
  ];
}

class DeliveryLinkEntity extends Equatable{
  final String? url;
  final String? label;
  final bool? active;

  DeliveryLinkEntity({
    required this.url,
    required this.label,
    required this.active,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    url,
    label,
    active
  ];


}
