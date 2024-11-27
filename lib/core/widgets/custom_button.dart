import 'package:flutter/material.dart';

import '../../config/theme/app_style.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double borderRadius;

  const CustomPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
    this.textStyle,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.green[500], // Default here
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          label,
          style: textStyle ?? AppStyle.cardSubtitle.copyWith(color: Colors.white, fontSize: 14)
        ),
      ),
    );
  }
}
///

class CustomSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  // final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double borderRadius;

  const CustomSecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    // this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
    this.textStyle,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
        child: Padding(
          padding: padding,
          child: Text(
            label,
              style: textStyle ?? AppStyle.cardSubtitle.copyWith(color: Colors.green[800], fontSize: 14)
          ),
        ),
    );
  }
}
