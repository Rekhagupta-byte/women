import 'package:flutter/material.dart';
import 'package:women/core/theme/app_pallete.dart';

class AppTheme {
  static _border([
    Color color = AppPallete.borderColor,
  ]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 32, 13, 23),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient3),
    ),
  );
}
