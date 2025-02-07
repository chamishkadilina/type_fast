import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDailyReminder = false;
  double _fontSize = 16.0;
  String _selectedFont = 'Roboto';

  final List<String> _fontOptions = [
    'Roboto',
    'Open Sans',
    'Montserrat',
    'Lato',
    'Nunito'
  ];

  final List<String> _fontSizes = ['Small', 'Medium', 'Large'];
  String _currentVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getAppVersion();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDailyReminder = prefs.getBool('dailyReminder') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
    });
  }

  void _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _currentVersion = packageInfo.version;
    });
  }

  void _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Define pastel colors for each icon type
    Color getIconColor() {
      switch (icon) {
        case Icons.wb_sunny:
          return const Color(0xFFFF9F43);
        case Icons.font_download:
          return const Color(0xFF6C5CE7);
        case Icons.format_size:
          return const Color(0xFF54A0FF);
        case Icons.notifications:
          return const Color(0xFFFF6B6B);
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

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: getIconColor()
              .withValues(alpha: themeProvider.isDarkMode ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: getIconColor(),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
      trailing: trailing ??
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: themeProvider.isDarkMode
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.3),
            ),
          ),
      onTap: onTap,
    );
  }

  Widget _buildTypingModeCard(String title, String tag, Color? color,
      String description, List<String> benefits) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color?.withValues(alpha: themeProvider.isDarkMode ? 0.8 : 0.1) ??
                Colors.transparent,
            color?.withValues(alpha: themeProvider.isDarkMode ? 0.6 : 0.05) ??
                Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              color?.withValues(alpha: themeProvider.isDarkMode ? 0.5 : 0.3) ??
                  Colors.transparent,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : color,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color?.withValues(
                        alpha: themeProvider.isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.isDarkMode ? Colors.white : color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: themeProvider.isDarkMode
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: color?.withValues(
                            alpha: themeProvider.isDarkMode ? 0.9 : 1.0),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: themeProvider.isDarkMode
                                ? Colors.white.withValues(alpha: 0.8)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

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
      body: ListView(
        children: [
          // Premium Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unlock Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enjoy exclusive features:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                ...['Ad Removal', 'Advanced Statistics', 'Daily Notifications']
                    .map((benefit) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                benefit,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement premium upgrade logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                  ),
                  child: const Text('Upgrade Now'),
                ),
              ],
            ),
          ),

          // Customization Section
          _buildSettingsSection(
            'Customization',
            [
              _buildSettingsTile(
                icon: Icons.wb_sunny,
                title: 'Dark Mode',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              _buildSettingsTile(
                icon: Icons.font_download,
                title: 'Font',
                trailing: DropdownButton<String>(
                  value: themeProvider.selectedFont,
                  items: _fontOptions.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(font),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setFont(value);
                    }
                  },
                ),
              ),
              _buildSettingsTile(
                icon: Icons.format_size,
                title: 'Text Size',
                trailing: DropdownButton<String>(
                  value: themeProvider.getFontSizeLabel(), // Use the new method
                  items: _fontSizes.map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setFontSize(value);
                    }
                  },
                ),
              ),
            ],
          ),

          // Notifications Section
          _buildSettingsSection(
            'Notifications',
            [
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Daily Reminder',
                trailing: Switch(
                  value: _isDailyReminder,
                  onChanged: (value) {
                    setState(() {
                      _isDailyReminder = value;
                      _saveSetting('dailyReminder', value);
                    });
                  },
                ),
              ),
            ],
          ),

          // Typing Modes Section
          _buildSettingsSection(
            'About TypeFast',
            [
              const SizedBox(height: 8),
              _buildTypingModeCard(
                'Easy Mode',
                'Top 200 Words',
                const Color(0xFF388E3C),
                '🚀 The Perfect Start for Beginners!',
                [
                  'Master the 200 most commonly used English words with ease!',
                  'Build muscle memory with smart finger positioning',
                  'Improve accuracy with gradual speed-building exercises',
                ],
              ),
              _buildTypingModeCard(
                'Medium Mode',
                'Top 500 Words',
                const Color(0xFF4258FF),
                '🔥 Level Up Your Speed & Accuracy in real life',
                [
                  'Expand your vocabulary with the 500 most essential English words for faster typing!',
                  'Practice advanced word combinations & phrases',
                  'Train your fingers for fluid and rhythmic typing',
                ],
              ),
              _buildTypingModeCard(
                'Hard Mode',
                'Top 1000 Words',
                const Color(0xFF913AF1),
                '💪 Type Like a Pro!',
                [
                  'Challenge yourself by mastering the 1000 most frequently used English words like a pro!',
                  'Tackle complex sentence structures with confidence',
                  'Sharpen your precision & speed to the max',
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),

          // More Section
          _buildSettingsSection(
            'More',
            [
              _buildSettingsTile(
                icon: Icons.trending_up,
                title: 'Improvement Tips',
                onTap: () {
                  // TODO: Implement typing improvement tips
                },
              ),
              _buildSettingsTile(
                icon: Icons.star,
                title: 'Rate TypeFast',
                onTap: () {
                  // TODO: Implement app store rating
                },
              ),
              _buildSettingsTile(
                icon: Icons.share,
                title: 'Share with Friends',
                onTap: () {
                  // TODO: Implement share functionality
                },
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {
                  // TODO: Implement privacy policy URL launch
                },
              ),
              _buildSettingsTile(
                icon: Icons.info,
                title: 'Version',
                trailing: Text(
                  _currentVersion,
                  style: TextStyle(
                    color: context.watch<ThemeProvider>().isDarkMode
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
