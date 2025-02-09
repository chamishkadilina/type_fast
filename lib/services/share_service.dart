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
• Advanced statistics
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
      ).catchError((_) {
        // Fallback to clipboard if sharing fails
        Clipboard.setData(ClipboardData(text: shareText));
        throw 'Unable to share. Text copied to clipboard instead.';
      });
    } on PlatformException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
