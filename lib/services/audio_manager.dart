import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool _soundEnabled = true;

  // Включить/выключить звук
  static void setEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // Звук поднятия кусочка
  static Future<void> playPickup() async {
    if (!_soundEnabled) return;
    try {
      await _player.play(AssetSource('sounds/pickup.wav'));
    } catch (_) {}
  }

  // Звук стыковки
  static Future<void> playSnap() async {
    if (!_soundEnabled) return;
    try {
      await _player.play(AssetSource('sounds/snap.wav'));
    } catch (_) {}
  }

  // Звук завершения пазла
  static Future<void> playComplete() async {
    if (!_soundEnabled) return;
    try {
      await _player.play(AssetSource('sounds/complete.wav'));
    } catch (_) {}
  }
}
