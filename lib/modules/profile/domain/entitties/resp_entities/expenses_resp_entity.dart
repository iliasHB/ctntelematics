import 'package:equatable/equatable.dart';

class ExpensesRespEntity extends Equatable{
  final ExpensesEntity expenses;
  final dynamic total_expenses;

  const ExpensesRespEntity({
    required this.expenses,
    required this.total_expenses,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    expenses,
    total_expenses
  ];
}

class ExpensesEntity extends Equatable{
  final dynamic current_page;
  final List<DatumEntity> data;
  final dynamic first_page_url;
  final dynamic from;
  final dynamic last_page;
  final dynamic last_page_url;
  final List<LinkEntity> links;
  final dynamic next_page_url;
  final dynamic path;
  final dynamic per_page;
  final dynamic prev_page_url;
  final dynamic to;
  final dynamic total;

  const ExpensesEntity({
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

class DatumEntity extends Equatable {
  final dynamic id;
  final dynamic veh_id;
  final dynamic expense_name;
  final dynamic expense_amount;
  final dynamic expense_date;
  final dynamic expense_location;
  final dynamic recipient_type;
  final dynamic recipient_name;
  final dynamic receipt;
  final dynamic remarks;
  final dynamic created_at;
  final dynamic updated_at;

  DatumEntity({
    required this.id,
    required this.veh_id,
    required this.expense_name,
    required this.expense_amount,
    required this.expense_date,
    required this.expense_location,
    required this.recipient_type,
    required this.recipient_name,
    required this.receipt,
    required this.remarks,
    required this.created_at,
    required this.updated_at,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    veh_id,
    expense_name,
    expense_amount,
    expense_date,
    expense_location,
    recipient_type,
    recipient_name,
    receipt,
    remarks,
    created_at,
    updated_at
  ];
}

class LinkEntity extends Equatable {
  final dynamic url;
  final dynamic label;
  final bool active;

  LinkEntity({
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
