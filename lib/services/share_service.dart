import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class ShareService {
  Future<void> shareApp() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // Construct the download link dynamically
      final String downloadLink = Platform.isAndroid
          ? 'Download here: https://play.google.com/store/apps/details?id=${packageInfo.packageName}'
          : 'Download here: https://apps.apple.com/app/id${packageInfo.packageName}';

      // Main message (more natural & confident)
      final String message = '''
I'm really enjoying TypeFast! 🚀 

Practicing with this app every day has noticeably improved my typing accuracy and speed ⌨️. 

Whether you're a student, programmer, or just want to type faster, TypeFast makes it easy and fun! Works great with external keyboards too.  

$downloadLink

Give it a try and see the difference yourself!
''';

      await Share.share(
        message,
        subject: 'This typing app changed my game! 💯',
      ).catchError((_) {
        // Fallback to clipboard if sharing fails
        Clipboard.setData(ClipboardData(text: message));
        throw 'Couldn\'t share. Message copied to clipboard!';
      });
    } on PlatformException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
