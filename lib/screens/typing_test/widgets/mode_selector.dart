// lib/screens/typing_test/widgets/mode_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/typing_test_provider.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TypingTestProvider>(
      builder: (context, provider, _) => Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: provider.currentMode.color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextButton(
          onPressed: () {
            if (!provider.isTestActive) {
              provider.cycleMode();
            }
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            provider.currentMode.displayText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
