// // To parse this JSON data, do
// //
// //     final expensesRespModel = expensesRespModelFromMap(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// ExpensesRespModel expensesRespModelFromMap(String str) => ExpensesRespModel.fromMap(json.decode(str));
//
// String expensesRespModelToMap(ExpensesRespModel data) => json.encode(data.toMap());

import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/expenses_resp_entity.dart';

class ExpensesRespModel extends ExpensesRespEntity{
  ExpensesRespModel({
    required super.expenses,
    required super.total_expenses,
  });

  factory ExpensesRespModel.fromJson(Map<String, dynamic> json) => ExpensesRespModel(
    expenses: Expenses.fromJson(json["expenses"]),
    total_expenses: json["total_expenses"],
  );

  Map<String, dynamic> toJson() => {
    "expenses": expenses,
    "total_expenses": total_expenses,
  };
}

class Expenses extends ExpensesEntity{

  Expenses({
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

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
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

class Datum extends DatumEntity{

  Datum({
    required super.id,
    required super.veh_id,
    required super.expense_name,
    required super.expense_amount,
    required super.expense_date,
    required super.expense_location,
    required super.recipient_type,
    required super.recipient_name,
    required super.receipt,
    required super.remarks,
    required super.created_at,
    required super.updated_at,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    veh_id: json["veh_id"],
    expense_name: json["expense_name"],
    expense_amount: json["expense_amount"],
    expense_date: json["expense_date"],
    expense_location: json["expense_location"],
    recipient_type: json["recipient_type"],
    recipient_name: json["recipient_name"],
    receipt: json["receipt"],
    remarks: json["remarks"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "veh_id": veh_id,
    "expense_name": expense_name,
    "expense_amount": expense_amount,
    "expense_date": expense_date,
    "expense_location": expense_location,
    "recipient_type": recipient_type,
    "recipient_name": recipient_name,
    "receipt": receipt,
    "remarks": remarks,
    "created_at": created_at,
    "updated_at": updated_at
  };
}

class Link extends LinkEntity {

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
