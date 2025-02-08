// lib/services/app_rating_service.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

class AppRatingService {
  Future<void> rateApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appId = packageInfo.packageName;

    if (Platform.isAndroid) {
      final url = 'market://details?id=$appId';
      final fallbackUrl =
          'https://play.google.com/store/apps/details?id=$appId';
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          final fallbackUri = Uri.parse(fallbackUrl);
          await launchUrl(fallbackUri);
        }
      } catch (e) {
        final fallbackUri = Uri.parse(fallbackUrl);
        await launchUrl(fallbackUri);
      }
    } else if (Platform.isIOS) {
      final url = 'itms-apps://itunes.apple.com/app/id$appId';
      final fallbackUrl = 'https://apps.apple.com/app/id$appId';
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          final fallbackUri = Uri.parse(fallbackUrl);
          await launchUrl(fallbackUri);
        }
      } catch (e) {
        final fallbackUri = Uri.parse(fallbackUrl);
        await launchUrl(fallbackUri);
      }
    }
  }
}
