import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:type_fast/constants/difficulty_mode.dart';

class ShareResultService {
  Future<void> shareResults(
    BuildContext context, {
    required int wpm,
    required String accuracy,
    required int correctWords,
    required double testDurationInMinutes,
    required DifficultyMode currentMode,
  }) async {
    // Capture the context's state before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String appName = packageInfo.appName;

      // Simple emoji based on performance tier
      String emoji = '⌨️';

      // Get the difficulty mode text
      final String modeText = _getModeText(currentMode);

      // Get store link based on platform
      String storeLink = '';
      if (Platform.isAndroid) {
        storeLink =
            'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      } else if (Platform.isIOS) {
        storeLink = 'https://apps.apple.com/app/id${packageInfo.packageName}';
      } else {
        // Add a generic website link for other platforms
        storeLink = 'https://typefast.app';
      }

      // Create a more genuine message about their typing performance
      String message = '''
$emoji Hit $wpm WPM in TypeFast ($accuracy% accuracy) on $modeText mode

${_getPersonalizedComment(wpm)} Typed $correctWords correct words in ${testDurationInMinutes.toStringAsFixed(1)} minutes.

$storeLink

Check it out if you're into improving your typing speed!
''';

      await Share.share(
        message,
        subject: 'My typing progress with $appName',
      );
    } catch (e) {
      // Check if the widget is still in the tree before showing a snackbar
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Unable to share results: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Returns a personalized comment based on WPM performance
  String _getPersonalizedComment(int wpm) {
    if (wpm > 80) {
      return "Pretty happy with my progress!";
    } else if (wpm > 60) {
      return "Getting better each day.";
    } else if (wpm > 40) {
      return "Still improving, but it's fun to track progress.";
    } else {
      return "Just starting out, but enjoying the journey.";
    }
  }

  String _getModeText(DifficultyMode mode) {
    switch (mode) {
      case DifficultyMode.easy:
        return 'Easy';
      case DifficultyMode.medium:
        return 'Medium';
      case DifficultyMode.hard:
        return 'Hard';
    }
  }
}
