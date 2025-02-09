// lib/screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final String _privacyPolicyText = '''
# Privacy Policy

Last updated: [Date]

## Introduction
Welcome to TypeFast! This privacy policy explains how we collect, use, and protect your data.

## Information We Collect
- **Usage Data**: Typing speed, accuracy, and progress statistics
- **Device Information**: Device type, operating system
- **Settings**: App preferences and notification settings

## How We Use Your Information
- To provide typing statistics and progress tracking
- To improve app functionality and user experience
- To send notifications (only with your permission)

## Data Storage
All data is stored locally on your device. We do not collect or store personal information on external servers.

## Your Rights
You can:
- Access your data through the app
- Delete your data by clearing app data
- Disable notifications at any time

## Contact Us
If you have questions about this privacy policy, please contact us at:
[Contact Information]
''';

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? screenWidth * 0.05 : 0,
        ),
        child: Markdown(
          data: _privacyPolicyText,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
