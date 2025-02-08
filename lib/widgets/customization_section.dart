// lib/widgets/customization_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/widgets/settings_section.dart';
import 'package:type_fast/widgets/settings_tile.dart';

class CustomizationSection extends StatefulWidget {
  const CustomizationSection({super.key});

  @override
  State<CustomizationSection> createState() => _CustomizationSectionState();
}

class _CustomizationSectionState extends State<CustomizationSection> {
  final List<String> _fontOptions = [
    'Roboto',
    'Open Sans',
    'Montserrat',
    'Lato',
    'Nunito'
  ];
  final List<String> _fontSizes = ['Small', 'Medium', 'Large'];
  String _selectedFont = 'Roboto';

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
    });
  }

  Future<void> _saveFont(String font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font);
  }

  Widget _buildStyledDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: Container(
        constraints: const BoxConstraints(minWidth: 95),
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
            size: 20,
          ),
          isDense: true,
          itemHeight: 48,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[200]
                : Colors.grey[800],
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SettingsSection(
      title: 'Customization',
      children: [
        SettingsTile(
          icon: Icons.wb_sunny,
          title: 'Dark Mode',
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ),
        SettingsTile(
          icon: Icons.font_download,
          title: 'Font',
          trailing: _buildStyledDropdown(
            value: _selectedFont,
            items: _fontOptions,
            onChanged: (value) async {
              if (value != null) {
                setState(() => _selectedFont = value);
                await _saveFont(value);
                themeProvider.setFont(value);
              }
            },
          ),
        ),
        SettingsTile(
          icon: Icons.format_size,
          title: 'Text Size',
          trailing: _buildStyledDropdown(
            value: themeProvider.getFontSizeLabel(),
            items: _fontSizes,
            onChanged: (value) {
              if (value != null) {
                themeProvider.setFontSize(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
