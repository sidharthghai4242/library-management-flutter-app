import 'package:flutter/material.dart';

class UIConstants {
  static const Color colorPrimary = Color(0xB2A4FF);
  static const Color colorsecondary = Color(0xFFB4B4);
  static const Color colortertiary = Color(0xFFDEB4);
  static const Color colorneutral = Color(0xFDF7C3);

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