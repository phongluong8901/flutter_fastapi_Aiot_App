import 'package:flutter/material.dart';

import 'core/l10n/app_l10n.dart';
import 'core/storage/app_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';

class AiotApp extends StatefulWidget {
  const AiotApp({super.key});

  @override
  State<AiotApp> createState() => _AiotAppState();
}

class _AiotAppState extends State<AiotApp> {
  ThemeMode _themeMode = AppStorage.isDark ? ThemeMode.dark : ThemeMode.light;
  Locale _locale = Locale(AppStorage.lang);
  bool _isLoggedIn = AppStorage.token != null;

  void _toggleTheme() {
    final nextDark = _themeMode != ThemeMode.dark;
    AppStorage.setDark(nextDark);
    setState(() => _themeMode = nextDark ? ThemeMode.dark : ThemeMode.light);
  }

  void _toggleLocale() {
    final nextLang = _locale.languageCode == 'vi' ? 'en' : 'vi';
    AppStorage.setLang(nextLang);
    setState(() => _locale = Locale(nextLang));
  }

  void _onLoginSuccess() => setState(() => _isLoggedIn = true);

  @override
  Widget build(BuildContext context) {
    return AppL10nScope(
      l10n: AppL10n(_locale),
      child: MaterialApp(
        title: 'Aiot Duck',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: _isLoggedIn
            ? HomeScreen(
                isDark: _themeMode == ThemeMode.dark,
                onToggleTheme: _toggleTheme,
                onToggleLocale: _toggleLocale,
              )
            : LoginScreen(onLoginSuccess: _onLoginSuccess),
      ),
    );
  }
}
