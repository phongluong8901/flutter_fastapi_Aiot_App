import 'package:flutter/material.dart';

import 'core/l10n/app_l10n.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';

class AiotApp extends StatefulWidget {
  const AiotApp({super.key});

  @override
  State<AiotApp> createState() => _AiotAppState();
}

class _AiotAppState extends State<AiotApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('vi');

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'vi'
          ? const Locale('en')
          : const Locale('vi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppL10nScope(
      l10n: AppL10n(_locale),
      child: MaterialApp(
        title: 'AIoT Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: HomeScreen(
          isDark: _themeMode == ThemeMode.dark,
          onToggleTheme: _toggleTheme,
          onToggleLocale: _toggleLocale,
        ),
      ),
    );
  }
}
