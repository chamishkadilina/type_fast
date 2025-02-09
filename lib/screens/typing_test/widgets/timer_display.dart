// lib/screens/typing_test/widgets/timer_display.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/typing_test_provider.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TypingTestProvider>(
      builder: (context, provider, _) => GestureDetector(
        onTap: () {
          if (!provider.isTestActive) {
            provider.cycleDuration();
          }
        },
        child: Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              _formatTime(provider.secondsRemaining),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
