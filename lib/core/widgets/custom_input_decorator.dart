import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String labelText,
  required String hintText,
  Icon? prefixIcon,
  Icon? suffixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintStyle: AppStyle.cardfooter.copyWith(fontSize: 12, color: Colors.grey[600]),
    labelStyle: AppStyle.cardfooter.copyWith(fontSize: 12, color: Colors.green[800]),
    prefixIcon: prefixIcon ?? const Icon(Icons.email_outlined, color: Colors.green),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
}
