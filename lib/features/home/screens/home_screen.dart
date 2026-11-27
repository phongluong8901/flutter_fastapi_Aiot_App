import 'package:flutter/material.dart';

import '../../../core/l10n/app_l10n.dart';
import '../../overview/screens/overview_screen.dart';
import '../../devices/screens/devices_screen.dart';
import '../../ai_assistant/screens/ai_screen.dart';
import '../../settings/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onToggleLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OverviewScreen(),
      const DevicesScreen(),
      const AiScreen(),
      SettingsScreen(
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
        onToggleLocale: widget.onToggleLocale,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('app_title')),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: context.tr('tab_overview'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.devices_outlined),
            selectedIcon: const Icon(Icons.devices),
            label: context.tr('tab_devices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome),
            label: context.tr('tab_ai'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.tr('tab_settings'),
          ),
        ],
      ),
    );
  }
}
