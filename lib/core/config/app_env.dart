import 'package:flutter/services.dart';

/// Loads key-value configuration from the bundled `.env` asset.
class AppEnv {
  static final Map<String, String> _values = {};

  static Future<void> init() async {
    try {
      final content = await rootBundle.loadString('.env');
      for (final rawLine in content.split('\n')) {
        final line = rawLine.trim();
        if (line.isEmpty || line.startsWith('#')) continue;
        final idx = line.indexOf('=');
        if (idx <= 0) continue;
        final key = line.substring(0, idx).trim();
        var value = line.substring(idx + 1).trim();
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }
        _values[key] = value;
      }
    } catch (_) {
      // Fallback to defaults if `.env` asset is missing (e.g. in widget tests).
    }
  }

  static String get(String key, {String fallback = ''}) {
    final val = _values[key];
    return (val == null || val.isEmpty) ? fallback : val;
  }

  static String get serverHost =>
      get('SERVER_HOST', fallback: 'http://localhost:8000');

  static String get googleClientId => get('GOOGLE_CLIENT_ID');

  static String get googleServerClientId => get('GOOGLE_SERVER_CLIENT_ID');
}
