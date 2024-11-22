import 'package:flutter/cupertino.dart';
import '../../core/utils/app_export_util.dart';

class AppDecoration {
  static BoxDecoration get darkContainer => BoxDecoration(
    color: containerColor,
    borderRadius: BorderRadius.circular(10)
  );
  static BoxDecoration get lightContainer => BoxDecoration(
    border: Border.all(color: tertiaryGrey.withOpacity(0.2), width: 1),
      //color: containerColor,
      borderRadius: BorderRadius.circular(10)
  );

  static BoxDecoration get dividerContainer => BoxDecoration(
      border: Border.all(color: tertiaryGrey.withOpacity(1), width: 1),
      //color: containerColor,
      borderRadius: BorderRadius.circular(10)
  );

  static BoxDecoration get containerTag => BoxDecoration(
      color: tertiaryGrey,
      borderRadius: BorderRadius.circular(10)
  );

}