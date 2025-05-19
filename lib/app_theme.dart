import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorSchemeSeed: Colors.deepPurple,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F6FF),
    useMaterial3: true,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  static final darkTheme = ThemeData(
    colorSchemeSeed: Colors.deepPurple,
    brightness: Brightness.dark,
    useMaterial3: true,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
