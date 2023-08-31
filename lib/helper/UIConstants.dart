import 'package:flutter/material.dart';

class UIConstants {
  static const Color colorPrimary = Color(0xFFB2A4FF);
  static const Color colorsecondary = Color(0xFFFFB4B4);
  static const Color colortertiary = Color(0xFFFFDEB4);
  static const Color colorneutral = Color(0xFFFDF7C3);

  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;

  static const double padding8 = 8.0;
  static const double padding12 = 12.0;
  static const double padding16 = 16.0;

  static BoxDecoration boxShadowDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadius12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        spreadRadius: 1,
        blurRadius: 0.5,
        blurStyle: BlurStyle.outer
      )
    ]
  );
}