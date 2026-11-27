import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_typography.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String deviceId;
  final String value;

  const MetricCard({
    super.key,
    required this.title,
    required this.deviceId,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: AppStyles.cardDecoration(isDark),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: AppSizes.xs),
              Text(deviceId, style: textTheme.labelSmall),
            ],
          ),
          Text(value, style: AppTypography.metric(AppColors.primary)),
        ],
      ),
    );
  }
}
