// lib/screens/settings/widgets/settings_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.iconColor,
  });

  Color _getIconColor(BuildContext context) {
    if (iconColor != null) return iconColor!;

    switch (icon) {
      case Icons.wb_sunny:
        return const Color(0xFFFF9F43);
      case Icons.font_download:
        return const Color(0xFF6C5CE7);
      case Icons.format_size:
        return const Color(0xFF54A0FF);
      case Icons.notifications:
        return const Color(0xFFFF6B6B);
      case Icons.access_time:
        return const Color(0xFF2BCBBA);
      case Icons.calendar_today:
        return const Color(0xFF4B7BEC);
      case Icons.trending_up:
        return const Color(0xFF26DE81);
      case Icons.star:
        return const Color(0xFFFECA57);
      case Icons.share:
        return const Color(0xFF4B7BEC);
      case Icons.privacy_tip:
        return const Color(0xFF2BCBBA);
      case Icons.info:
        return const Color(0xFFA5B1C2);
      default:
        return const Color(0xFF54A0FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Color iconBaseColor = _getIconColor(context);

    return ListTile(
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? iconBaseColor.withValues(
                  alpha: themeProvider.isDarkMode ? 0.15 : 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: enabled ? iconBaseColor : Colors.grey,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled
              ? (themeProvider.isDarkMode ? Colors.white : Colors.black87)
              : Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
      trailing: trailing ?? _buildDefaultTrailing(context),
      onTap: enabled ? onTap : null,
    );
  }

  Widget _buildDefaultTrailing(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: enabled
            ? (themeProvider.isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03))
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.chevron_right,
        size: 16,
        color: enabled
            ? (themeProvider.isDarkMode
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.3))
            : Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }
}
