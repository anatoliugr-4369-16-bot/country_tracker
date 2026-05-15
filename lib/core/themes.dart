import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

ThemeData appTheme() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(AppColors.creamBackground),
    primaryColor: const Color(AppColors.primaryBrown),
    colorScheme: const ColorScheme.light(
      primary: Color(AppColors.primaryBrown),
      secondary: Color(AppColors.accentGold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(AppColors.primaryBrown),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(AppColors.primaryBrown)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(AppColors.darkBrown),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      titleLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(AppColors.primaryText),
      ),
      titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Color(AppColors.secondaryText),
      ),
    ),
  );
}
