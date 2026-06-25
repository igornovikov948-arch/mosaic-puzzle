import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

class MosaicApp extends StatefulWidget {
  const MosaicApp({super.key});

  @override
  State<MosaicApp> createState() => _MosaicAppState();
}

class _MosaicAppState extends State<MosaicApp> {
  Locale _locale = const Locale('ru');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mosaic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.gold,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        fontFamily: 'Handwritten',
        colorScheme: ColorScheme.dark(
          primary: AppColors.gold,
          secondary: AppColors.emerald,
          surface: AppColors.surfaceDark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.backgroundDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.gold,
          thumbColor: AppColors.gold,
          inactiveTrackColor: AppColors.gold.withOpacity(0.3),
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      home: const SplashScreen(),
    );
  }
}
