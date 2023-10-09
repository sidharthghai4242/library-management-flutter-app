import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFFF69B4), // Pink
  onPrimary: Color(0xFFFFFFFF), // White
  primaryContainer: Color(0xFFFFD6E4), // Light Pink
  onPrimaryContainer: Color(0xFF000000), // Black
  secondary: Color(0xFF00BFFF), // Sky Blue
  onSecondary: Color(0xFF000000), // Black
  secondaryContainer: Color(0xFFB3E0FF), // Light Blue
  onSecondaryContainer: Color(0xFF000000), // Black
  tertiary: Color(0xFFFFD700), // Yellow
  onTertiary: Color(0xFF000000), // Black
  tertiaryContainer: Color(0xFFFFF176), // Light Yellow
  onTertiaryContainer: Color(0xFF000000), // Black
  error: Color(0xFFFF0000), // Red
  errorContainer: Color(0xFFFFCCCC), // Light Red
  onError: Color(0xFF000000), // Black
  onErrorContainer: Color(0xFFFFEBEE), // Very Light Pink
  background: Color(0xFFFFFFFF), // White
  onBackground: Color(0xFF000000), // Black
  surface: Color(0xFFFFFFFF), // White
  onSurface: Color(0xFF000000), // Black
  surfaceVariant: Color(0xFFF5F5F5), // Light Gray
  onSurfaceVariant: Color(0xFF000000), // Black
  outline: Color(0xFFBDBDBD), // Gray
  onInverseSurface: Color(0xFFFAFAFA), // Very Light Gray
  inverseSurface: Color(0xFF000000), // Black
  inversePrimary: Color(0xFFFF6B81), // Dark Pink
  shadow: Color(0xFF000000), // Black
  surfaceTint: Color(0xFFFF69B4), // Pink
  outlineVariant: Color(0xFFB0BEC5), // Light Blue-Gray
  scrim: Color(0x99000000), // Semi-transparent Black
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFF69B4), // Pink
  onPrimary: Color(0xFFFFFFFF), // White
  primaryContainer: Color(0xFFE91E63), // Pink
  onPrimaryContainer: Color(0xFFF5F5F5), // White
  secondary: Color(0xFF00BFFF), // Sky Blue
  onSecondary: Color(0xFF000000), // Black
  secondaryContainer: Color(0xFF009688), // Teal
  onSecondaryContainer: Color(0xFFF5F5F5), // White
  tertiary: Color(0xFFFFD700), // Yellow
  onTertiary: Color(0xFF000000), // Black
  tertiaryContainer: Color(0xFFFBC02D), // Amber
  onTertiaryContainer: Color(0xFF212121), // Black
  error: Color(0xFFFF0000), // Red
  errorContainer: Color(0xFFD32F2F), // Red
  onError: Color(0xFFD50000), // Dark Red
  onErrorContainer: Color(0xFFF5F5F5), // White
  background: Color(0xFF121212), // Dark Gray
  onBackground: Color(0xFFF5F5F5), // White
  surface: Color(0xFF212121), // Black
  onSurface: Color(0xFFF5F5F5), // White
  surfaceVariant: Color(0xFF303030), // Slightly Lighter Black
  onSurfaceVariant: Color(0xFFCCCCCC), // Light Gray
  outline: Color(0xFF757575), // Medium Gray
  onInverseSurface: Color(0xFF212121), // Black
  inverseSurface: Color(0xFFF5F5F5), // White
  inversePrimary: Color(0xFFFF4081), // Hot Pink
  shadow: Color(0xFF000000), // Black
  surfaceTint: Color(0xFFFFB74D), // Orange
  outlineVariant: Color(0xFF616161), // Slightly Darker Gray
  scrim: Color(0x99000000), // Semi-transparent Black
);
