// lib/screens/settings/widgets/more_section.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:type_fast/services/app_rating_service.dart';
import 'package:type_fast/services/share_service.dart';
import 'package:type_fast/screens/improvement_tips_screen.dart';
import 'package:type_fast/screens/privacy_policy_screen.dart';
import 'package:type_fast/screens/settings/widgets/settings_section.dart';
import 'package:type_fast/screens/settings/widgets/settings_tile.dart';

class MoreSection extends StatefulWidget {
  const MoreSection({super.key});

  @override
  State<MoreSection> createState() => _MoreSectionState();
}

class _MoreSectionState extends State<MoreSection> {
  final AppRatingService _ratingService = AppRatingService();
  final ShareService _shareService = ShareService();
  String _currentVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() => _currentVersion = packageInfo.version);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'More',
      children: [
        SettingsTile(
          icon: Icons.trending_up,
          title: 'Improvement Tips',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImprovementTipsScreen(),
            ),
          ),
        ),
        SettingsTile(
          icon: Icons.star,
          title: 'Rate TypeFast',
          onTap: () => _ratingService.rateApp(),
        ),
        SettingsTile(
          icon: Icons.share,
          title: 'Share with Friends',
          onTap: () async {
            try {
              await _shareService.shareApp();
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
        ),
        SettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen()),
          ),
        ),
        SettingsTile(
          icon: Icons.info,
          title: 'Version',
          trailing: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Text(
              _currentVersion,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
