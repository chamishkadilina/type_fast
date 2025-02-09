// lib/screens/typing_test/widgets/app_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/screens/settings/settings_screen.dart';
import 'package:type_fast/screens/statistics/statistics_screen.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'TypeFast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF2F4050),
            ),
          ),
          const Spacer(),
          _buildActionButtons(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: () => _navigateToStatistics(context),
          icon: Icon(
            Icons.bar_chart,
            color: isDarkMode ? Colors.white70 : const Color(0xFF2F4050),
          ),
          label: Text(
            'Statistics',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : const Color(0xFF2F4050),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _navigateToSettings(context),
          icon: Icon(
            Icons.settings,
            color: isDarkMode ? Colors.white70 : const Color(0xFF2F4050),
          ),
        ),
      ],
    );
  }

  void _navigateToStatistics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatisticsScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }
}
