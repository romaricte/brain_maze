import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Fond principal (dégradé sombre)
  static const Color background1 = Color(0xFF0A0E21);
  static const Color background2 = Color(0xFF1A1A2E);

  // Néon
  static const Color neonBlue = Color(0xFF00D4FF);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonGreen = Color(0xFF00FF87);
  static const Color neonYellow = Color(0xFFFFE66D);
  static const Color neonPurple = Color(0xFFBD00FF);

  // UI
  static const Color surface = Color(0xFF16213E);
  static const Color surfaceLight = Color(0xFF1A1A40);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color starGold = Color(0xFFFFD700);

  // Niveaux de difficulté
  static const Color easy = Color(0xFF00FF87);
  static const Color medium = Color(0xFFFFE66D);
  static const Color hard = Color(0xFFFF006E);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [background1, background2],
  );

  static const LinearGradient neonButtonGradient = LinearGradient(
    colors: [neonBlue, neonPurple],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background1,
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonBlue,
        secondary: AppColors.neonPink,
        surface: AppColors.surface,
      ),
    );
  }
}