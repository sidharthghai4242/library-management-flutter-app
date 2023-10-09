import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;

  ThemeProvider({
    required this.lightColorScheme,
    required this.darkColorScheme,
    bool isDark = false, // Provide an initial value for isDark
  }) : _themeData = isDark ? ThemeData.dark() : ThemeData.light();

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
