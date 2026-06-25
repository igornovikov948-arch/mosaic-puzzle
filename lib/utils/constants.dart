import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color surfaceDark = Color(0xFF1B2838);
  static const Color gold = Color(0xFFD4A574);
  static const Color emerald = Color(0xFF52796F);
  static const Color terracotta = Color(0xFFC1665B);
  static const Color textPrimary = Color(0xFFE0E1DD);
  static const Color textSecondary = Color(0xFF9BA4B0);
  static const Color shadowDark = Color(0x40000000);
  static const Color overlayLight = Color(0x1AFFFFFF);
}

class AppSizes {
  AppSizes._();

  static const double snapDistance = 30.0;
  static const double pieceShadow = 4.0;
  static const double pieceBorderRadius = 4.0;
  static const int homeGridColumns = 2;
  static const double homeCardRatio = 1.0;
  static const int minPieces = 12;
  static const int maxPieces = 500;
  static const int defaultPieces = 25;
  static const Duration animShort = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 500);
  static const Duration animLong = Duration(seconds: 2);
  static const Duration splashDuration = Duration(milliseconds: 2500);
}

class AppCurves {
  AppCurves._();

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve bounce = Curves.elasticOut;
  static const Curve snap = Curves.easeOutBack;
}

class AppStorageKeys {
  AppStorageKeys._();

  static const String languageCode = 'language_code';
  static const String soundEnabled = 'sound_enabled';
  static const String hapticEnabled = 'haptic_enabled';
  static const String puzzlesList = 'puzzles_list.json';
  static const String puzzleProgressPrefix = 'puzzle_progress_';
}
