// lib/screens/typing_test/typing_test_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/screens/typing_test/widgets/app_header.dart';
import 'package:type_fast/screens/typing_test/widgets/test_controls.dart';
import 'package:type_fast/screens/typing_test/widgets/word_display.dart';

class TypingTestScreen extends StatelessWidget {
  const TypingTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: const [
              AppHeader(),
              SizedBox(height: 16),
              WordDisplay(),
              SizedBox(height: 16),
              TestControls(),
            ],
          ),
        ),
      ),
    );
  }
}
