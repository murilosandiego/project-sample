import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  static const primary = Colors.indigo;
  static const secondary = Colors.amber;
  static const background = Color(0xFFF5F5F5);
  static const lightest = Colors.white;
  static const darkest = Colors.black;
  static const darker = Colors.black87;
  static const divider = Colors.grey;
  static const disabled = Colors.grey;
  static const red = Colors.red;
  static const darkFontColor = Colors.white;
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkDivider = Colors.grey;
  static final darkPrimaryContainer = primary.withOpacity(0.2);
  static final darkSecondaryContainer = secondary.withOpacity(0.2);
}
