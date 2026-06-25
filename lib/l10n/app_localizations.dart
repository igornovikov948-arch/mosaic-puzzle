import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _strings;

  AppLocalizations(this.locale);

  // Загрузка переводов из JSON-файлов
  static Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    final jsonString = await rootBundle.loadString(
      'assets/l10n/app_${locale.languageCode}.arb',
    );
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    localizations._strings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    return localizations;
  }

  // Метод для получения перевода
  String translate(String key, {Map<String, String>? args}) {
    String? value = _strings[key];
    if (value == null) return key;
    if (args != null) {
      args.forEach((k, v) {
        value = value!.replaceAll('{$k}', v);
      });
    }
    return value!;
  }

  // Статический делегат
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

// Удобный доступ из контекста
extension AppLocalizationsX on BuildContext {
  AppLocalizations get loc =>
      Localizations.of<AppLocalizations>(this, AppLocalizations)!;
}
