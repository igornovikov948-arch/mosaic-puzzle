import 'package:flutter/services.dart';

class HapticManager {
  static bool _enabled = true;

  // Включить/выключить вибрацию
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  // Лёгкий отклик
  static void light() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
  }

  // Средний отклик
  static void medium() {
    if (!_enabled) return;
    HapticFeedback.mediumImpact();
  }

  // Тяжёлый отклик
  static void heavy() {
    if (!_enabled) return;
    HapticFeedback.heavyImpact();
  }
}
