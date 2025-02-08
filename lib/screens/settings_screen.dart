// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/widgets/about_section.dart';
import 'package:type_fast/widgets/customization_section.dart';
import 'package:type_fast/widgets/more_section.dart';
import 'package:type_fast/widgets/notifications_section.dart';
import 'package:type_fast/widgets/premium_banner.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
          statusBarIconBrightness:
              themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
        ),
      ),
      body: const SettingsBody(),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        PremiumBanner(),
        CustomizationSection(),
        NotificationsSection(),
        AboutSection(),
        MoreSection(),
      ],
    );
  }
}
