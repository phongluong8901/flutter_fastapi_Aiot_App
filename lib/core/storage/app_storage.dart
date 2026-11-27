import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_env.dart';

class AppStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isDark => _prefs.getBool('is_dark') ?? true;
  static Future<void> setDark(bool value) => _prefs.setBool('is_dark', value);

  static String get lang => _prefs.getString('lang') ?? 'vi';
  static Future<void> setLang(String value) => _prefs.setString('lang', value);

  static String get serverHost =>
      _prefs.getString('server_host') ?? AppEnv.serverHost;
  static Future<void> setServerHost(String value) =>
      _prefs.setString('server_host', value);

  // ★ Mới: Lưu JWT Token
  static String? get token => _prefs.getString('access_token');
  static Future<void> setToken(String value) =>
      _prefs.setString('access_token', value);
  static Future<void> clearToken() => _prefs.remove('access_token');
}
