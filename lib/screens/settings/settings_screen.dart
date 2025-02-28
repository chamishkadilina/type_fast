// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/screens/settings/widgets/customization_section.dart';
import 'package:type_fast/screens/settings/widgets/more_section.dart';
import 'package:type_fast/screens/settings/widgets/notifications_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? screenWidth * 0.05 : 0,
        ),
        child: const SettingsBody(),
      ),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        // PremiumBanner(),
        CustomizationSection(),
        NotificationsSection(),

        MoreSection(),
      ],
    );
  }
}
