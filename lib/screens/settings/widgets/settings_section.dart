// lib/screens/settings/widgets/settings_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}
