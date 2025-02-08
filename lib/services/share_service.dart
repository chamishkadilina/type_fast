// lib/services/share_service.dart
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class ShareService {
  Future<void> shareApp() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;

      const String message = '''
🚀 Check out TypeFast - The Ultimate Typing Practice App!

Master your typing skills with:
• Personalized practice sessions
• Real-time statistics
• Daily challenges
• Multiple difficulty levels

Download now and improve your typing speed!
''';

      String shareText = '$message\n\n';

      if (Platform.isAndroid) {
        shareText +=
            'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      } else if (Platform.isIOS) {
        shareText += 'https://apps.apple.com/app/id${packageInfo.packageName}';
      }

      await Share.share(
        shareText,
        subject: 'Check out $appName!',
      ).catchError((error) {
        print('Share error: $error');
        // Fallback to clipboard if sharing fails
        Clipboard.setData(ClipboardData(text: shareText));
        throw 'Unable to share. Text copied to clipboard instead.';
      });
    } on PlatformException catch (e) {
      print('Platform Exception: $e');
      rethrow;
    } catch (e) {
      print('General Exception: $e');
      rethrow;
    }
  }
}
