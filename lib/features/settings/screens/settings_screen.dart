import 'package:flutter/material.dart';

import '../../../core/l10n/app_l10n.dart';
import '../../../core/theme/app_sizes.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onToggleLocale,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.lg),
      children: [
        SwitchListTile(
          title: Text(context.tr('dark_mode')),
          value: isDark,
          onChanged: (_) => onToggleTheme(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(context.tr('language')),
          trailing: FilledButton.tonal(
            onPressed: onToggleLocale,
            child: Text(context.tr('lang_name')),
          ),
        ),
      ],
    );
  }
}
