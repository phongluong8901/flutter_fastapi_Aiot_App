import 'package:flutter/material.dart';

import '../../../core/l10n/app_l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/metric_card.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.lg),
      children: [
        Text(context.tr('system_status'), style: textTheme.headlineSmall),
        const SizedBox(height: AppSizes.xs),
        Text('Orange Pi 6 • Local Hub', style: textTheme.bodyMedium),
        const SizedBox(height: AppSizes.lg),
        MetricCard(
          title: context.tr('room_temp'),
          deviceId: 'esp32s3_desk_01',
          value: '26.5 °C',
        ),
        const SizedBox(height: AppSizes.md),
        const Row(
          children: [
            StatusBadge(label: 'ONLINE', color: AppColors.online),
            SizedBox(width: AppSizes.sm),
            StatusBadge(label: 'WARNING', color: AppColors.warning),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        TextField(
          decoration: InputDecoration(
            hintText: context.tr('search_hint'),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
