import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// CLASSE DE DEFINICAO DOS TEMAS CLARO E ESCURO DO APP, INCLUINDO CORES, TIPOGRAFIAS E ESTILOS DE COMPONENTES PARA GARANTIR UMA APARÊNCIA COERENTE E PERSONALIZADA (nao utulizado no momento)
class AppTheme {

  static const Color backgroundLight = Color(0xFFF6F5F4);
  static const Color foregroundLight = Color(0xFF0A0A0A);

  static const Color cardLight = Color(0xFFEDECEC);
  static const Color primaryLight = Color(0xFF141414);
  static const Color secondaryLight = Color(0xFF3B3B3B);

  static const Color mutedLight = Color(0xFFE0E0E0);
  static const Color accentLight = Color(0xFFBABABA);

  static const Color borderLight = Color(0xFFCCCCCC);
  static const Color surfaceLight = Color(0xFFECECEC);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);


  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color foregroundDark = Color(0xFFF6F5F4);

  static const Color cardDark = Color(0xFF141414);
  static const Color primaryDark = Color(0xFFF6F5F4);
  static const Color secondaryDark = Color(0xFFBABABA);

  static const Color mutedDark = Color(0xFF242424);
  static const Color accentDark = Color(0xFF333333);

  static const Color borderDark = Color(0xFF2A2A2A);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceElevatedDark = Color(0xFF1A1A1A);


  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: backgroundLight,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: backgroundLight,
      secondary: secondaryLight,
      onSecondary: backgroundLight,
      error: Colors.red,
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: foregroundLight,
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(),
      displayMedium: GoogleFonts.spaceGrotesk(),
      titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.spaceGrotesk(),
      bodyMedium: GoogleFonts.spaceGrotesk(),
      labelLarge: GoogleFonts.ibmPlexMono(),
    ),

cardTheme: const CardThemeData(
  color: surfaceElevatedLight,
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
),

    dividerColor: borderLight,
  );


  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: backgroundDark,

 colorScheme: const ColorScheme(
  brightness: Brightness.dark,
  primary: primaryDark,
  onPrimary: backgroundDark,
  secondary: secondaryDark,
  onSecondary: backgroundDark,
  error: Colors.red,
  onError: Colors.white,
  surface: surfaceDark,
  onSurface: foregroundDark,
),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(),
      displayMedium: GoogleFonts.spaceGrotesk(),
      titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.spaceGrotesk(),
      bodyMedium: GoogleFonts.spaceGrotesk(),
      labelLarge: GoogleFonts.ibmPlexMono(),
    ),

cardTheme: const CardThemeData(
  color: surfaceElevatedLight,
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
),

    dividerColor: borderDark,
  );
}