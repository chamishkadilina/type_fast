import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:type_fast/services/app_rating_service.dart';
import 'package:type_fast/services/share_service.dart';
import 'package:type_fast/services/url_launcher_service.dart';
import 'package:type_fast/screens/improvement_tips_screen.dart';
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
  final UrlLauncherService _urlLauncherService = UrlLauncherService();
  String _currentVersion = '1.0.0';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _currentVersion = packageInfo.version;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentVersion = 'Error';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleShare() async {
    try {
      await _shareService.shareApp();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      await _urlLauncherService
          .launchURL('https://sites.google.com/view/typefast-privacy/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not open privacy policy: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToScreen(Widget screen) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'More',
      children: [
        SettingsTile(
          icon: Icons.trending_up,
          title: 'Improvement Tips',
          onTap: () => _navigateToScreen(ImprovementTipsScreen()),
        ),
        SettingsTile(
          icon: Icons.star,
          title: 'Rate TypeFast',
          onTap: () => _ratingService.rateApp(),
        ),
        SettingsTile(
          icon: Icons.share,
          title: 'Share with Friends',
          onTap: _handleShare,
        ),
        SettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: _openPrivacyPolicy,
        ),
        SettingsTile(
          icon: Icons.info,
          title: 'Version',
          trailing: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _currentVersion,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.7),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
