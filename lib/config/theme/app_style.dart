import 'package:flutter/material.dart';
import '../../core/utils/app_export_util.dart';

class AppStyle {
  static TextStyle headerTitle = GoogleFonts.nobile(
    //color: tertiaryGrey,
    fontSize: getFontSize(12),
    fontWeight: FontWeight.w600
  );

  static TextStyle secondaryText = GoogleFonts.almendra(
    //color: tertiaryWhite,
    fontSize: getFontSize(12),
    fontWeight: FontWeight.w400,
  );

  static TextStyle tertiaryText = GoogleFonts.alice(
    //color: tertiaryGrey,
    fontSize: getFontSize(12),
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400
  );

  static TextStyle tertiaryText_ext = tertiaryText.copyWith(
    //color: secondaryPurple
  );

  static TextStyle pageTitle = GoogleFonts.poppins(
    color: primaryGreen,
    fontSize:getFontSize(16),
    fontWeight: FontWeight.w600
  );

  static TextStyle cardTitle = GoogleFonts.poppins(
    //color: tertiaryWhite,
    fontSize: getFontSize(18),
    fontWeight: FontWeight.w600
  );

  static TextStyle cardSubtitle = GoogleFonts.poppins(
    //color: tertiaryWhite,
    fontSize: 16,
    fontWeight: FontWeight.w600
  );

  static TextStyle cardSubtitle_ext = cardSubtitle.copyWith(
      fontWeight: FontWeight.normal
  );

  static TextStyle cardfooter = GoogleFonts.poppins(
      //color: tertiaryWhite,
      fontSize: 14,
      fontWeight: FontWeight.w400
  );

  // static TextStyle hea = GoogleFonts.poppins(
  //   //color: tertiaryGrey,
  //     fontSize: getFontSize(12),
  //     fontWeight: FontWeight.w600
  // );

}