// lib/screens/typing_test/widgets/restart_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/typing_test_provider.dart';

class RestartButton extends StatelessWidget {
  const RestartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF4A90E2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Consumer<TypingTestProvider>(
        builder: (context, provider, _) => IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          padding: EdgeInsets.zero,
          onPressed: () => provider.restartTest(),
        ),
      ),
    );
  }
}
