import 'package:flutter/material.dart';

class AppColors {
  /// =========================
  /// LIGHT MODE
  /// =========================
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF111827);

  /// =========================
  /// DARK MODE
  /// =========================
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF111827);
  static const Color darkText = Colors.white;

  /// =========================
  /// PRIMARY
  /// =========================
  static const Color primary = Color(0xFF3B82F6);

  /// =========================
  /// DYNAMIC COLORS
  /// =========================
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCard
        : lightCard;
  }

  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkText
        : lightText;
  }

  static Color subtitle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
  }

  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white12
        : Colors.black12;
  }
}
