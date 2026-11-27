import 'package:flutter/material.dart';

class AppL10n {
  final Locale locale;
  const AppL10n(this.locale);

  static const Map<String, Map<String, String>> _values = {
    'vi': {
      'app_title': 'AIoT Hub',
      'tab_overview': 'Tổng quan',
      'tab_devices': 'Thiết bị',
      'tab_ai': 'Gemini AI',
      'tab_settings': 'Cài đặt',
      'system_status': 'Trạng thái hệ thống',
      'room_temp': 'Nhiệt độ phòng',
      'search_hint': 'Thử gõ lệnh hoặc tìm thiết bị...',
      'dark_mode': 'Giao diện tối (Dark Mode)',
      'language': 'Ngôn ngữ',
      'lang_name': 'Tiếng Việt',
    },
    'en': {
      'app_title': 'AIoT Hub',
      'tab_overview': 'Overview',
      'tab_devices': 'Devices',
      'tab_ai': 'Gemini AI',
      'tab_settings': 'Settings',
      'system_status': 'System Status',
      'room_temp': 'Room Temperature',
      'search_hint': 'Type a command or search devices...',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'lang_name': 'English',
    },
  };

  String tr(String key) {
    return _values[locale.languageCode]?[key] ?? key;
  }
}

class AppL10nScope extends InheritedWidget {
  final AppL10n l10n;

  const AppL10nScope({super.key, required this.l10n, required super.child});

  static AppL10n of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppL10nScope>();
    return scope?.l10n ?? const AppL10n(Locale('vi'));
  }

  @override
  bool updateShouldNotify(AppL10nScope oldWidget) {
    return oldWidget.l10n.locale != l10n.locale;
  }
}

extension L10nContext on BuildContext {
  String tr(String key) => AppL10nScope.of(this).tr(key);
}
