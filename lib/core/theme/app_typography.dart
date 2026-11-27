import 'package:flutter/material.dart';

import 'app_sizes.dart';

class AppTypography {
  AppTypography._();

  // Đổi thành 'Inter' hoặc 'Roboto' nếu bạn khai báo trong pubspec.yaml
  static const String fontFamily = 'Roboto';
  static const String monoFamily =
      'monospace'; // Dùng cho device_id, IP, thông số sensor

  static TextTheme textTheme(Color textColor, Color subColor) {
    return TextTheme(
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontXl,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontSm,
        fontWeight: FontWeight.w400,
        color: subColor,
      ),
      labelSmall: TextStyle(
        fontFamily: monoFamily,
        fontSize: AppSizes.fontXs,
        fontWeight: FontWeight.w500,
        color: subColor,
      ),
    );
  }

  // Style riêng cho số liệu sensor (nhiệt độ, độ ẩm, điện áp...)
  static TextStyle metric(Color color) => TextStyle(
    fontFamily: monoFamily,
    fontSize: AppSizes.fontMetric,
    fontWeight: FontWeight.w700,
    color: color,
  );
}
