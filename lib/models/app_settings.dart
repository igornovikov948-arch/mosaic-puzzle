class AppSettings {
  final String languageCode;
  final bool soundEnabled;
  final bool hapticEnabled;

  const AppSettings({
    this.languageCode = 'ru',
    this.soundEnabled = true,
    this.hapticEnabled = true,
  });

  AppSettings copyWith({
    String? languageCode,
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }
}
