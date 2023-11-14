import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../typography/app_text_theme.dart';

class AppTheme {
  static final lightTheme = _getTheme(brightness: Brightness.light);
  static final darkTheme = _getTheme(brightness: Brightness.dark);
}

final _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.lightest,
  primaryContainer: AppColors.primary.withOpacity(0.2),
  onPrimaryContainer: AppColors.lightest,
  // Secondary
  secondary: AppColors.secondary,
  onSecondary: AppColors.darkest,
  secondaryContainer: AppColors.secondary.withOpacity(0.2),
  onSecondaryContainer: AppColors.darkest,
  // Error
  error: AppColors.red,
  onError: AppColors.lightest,
  // Background
  background: AppColors.background,
  onBackground: AppColors.darkest,
  // Surface
  surface: AppColors.lightest,
  onSurface: AppColors.darkest,
  // Outline
  outline: AppColors.divider,
);

final _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.darkFontColor,
  primaryContainer: AppColors.darkPrimaryContainer,
  onPrimaryContainer: AppColors.darkFontColor,
  // Secondary
  secondary: AppColors.secondary,
  onSecondary: AppColors.lightest,
  secondaryContainer: AppColors.darkSecondaryContainer,
  onSecondaryContainer: AppColors.darkest,
  // Error
  error: AppColors.red,
  onError: AppColors.lightest,
  // Background
  background: AppColors.darkBackground,
  onBackground: AppColors.darkFontColor,
  // Surface
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkFontColor,
  // Outline
  outline: AppColors.darkDivider,
);

ThemeData _getTheme({required Brightness brightness}) {
  final colorScheme = switch (brightness) {
    Brightness.light => _lightColorScheme,
    Brightness.dark => _darkColorScheme,
  };

  final textTheme = getTextTheme(colorScheme);
  final primaryTextTheme = textTheme.apply(
    displayColor: colorScheme.onPrimary,
    bodyColor: colorScheme.onPrimary,
  );

  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  const buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
  final buttonTextStyle = textTheme.titleSmall;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: textTheme,
    primaryTextTheme: primaryTextTheme,
    scaffoldBackgroundColor: colorScheme.background,
    disabledColor: AppColors.disabled,
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      space: 1,
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      labelStyle: textTheme.labelSmall,
      side: const BorderSide(
        width: 0,
      ),
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      color: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.background,
      surfaceTintColor: colorScheme.background,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: false,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: colorScheme.surfaceVariant,
      selectedItemColor: colorScheme.primary,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: textTheme.titleMedium,
      backgroundColor: colorScheme.background,
      centerTitle: true,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: colorScheme.background,
      surfaceTintColor: colorScheme.background,
      titleTextStyle: textTheme.titleLarge,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkest,
      contentTextStyle: primaryTextTheme.bodyLarge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide.none,
      ),
      hintStyle: textTheme.bodyLarge,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: const CircleBorder(),
      elevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: buttonShape,
        padding: buttonPadding,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: buttonTextStyle,
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: buttonShape,
        padding: buttonPadding,
        side: BorderSide(
          color: colorScheme.primary,
          width: 1,
        ),
        foregroundColor: colorScheme.primary,
        textStyle: buttonTextStyle,
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: buttonShape,
        padding: buttonPadding,
        foregroundColor: colorScheme.primary,
        textStyle: buttonTextStyle,
      ),
    ),
  );
}
