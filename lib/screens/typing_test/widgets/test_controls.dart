// lib/screens/typing_test/widgets/test_controls.dart
import 'package:flutter/material.dart';
import 'typing_input.dart';
import 'timer_display.dart';
import 'mode_selector.dart';
import 'restart_button.dart';

class TestControls extends StatelessWidget {
  const TestControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: TypingInput()),
        SizedBox(width: 8),
        TimerDisplay(),
        SizedBox(width: 8),
        ModeSelector(),
        SizedBox(width: 8),
        RestartButton(),
      ],
    );
  }
}
