// lib/screens/typing_test_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/screens/statistics_screen.dart';
import '../providers/typing_test_provider.dart';
import '../widgets/word_display.dart';

class TypingTestScreen extends StatefulWidget {
  const TypingTestScreen({super.key});

  @override
  State<TypingTestScreen> createState() => _TypingTestScreenState();
}

class _TypingTestScreenState extends State<TypingTestScreen> {
  final TextEditingController _controller = TextEditingController();

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String getModeText(DifficultyMode mode) {
    switch (mode) {
      case DifficultyMode.easy:
        return 'Easy';
      case DifficultyMode.medium:
        return 'Med';
      case DifficultyMode.hard:
        return 'Hard';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBEAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Brand Show
                    Text(
                      'TypeFast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    // Statistics and Settings
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StatisticsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.bar_chart,
                            color: Color(0xFF2F4050),
                          ),
                          label: const Text(
                            'Statistics',
                            style: TextStyle(
                              color: Color(0xFF2F4050),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.settings,
                            color: Color(0xFF2F4050),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const WordDisplay(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Consumer<TypingTestProvider>(
                        builder: (context, provider, _) => TextField(
                          controller: _controller,
                          autofocus: true,
                          onChanged: (value) {
                            provider.checkWord(value);
                            if (value.endsWith(' ') && provider.isTestActive) {
                              _controller.clear();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Start typing..',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer<TypingTestProvider>(
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
                          color: const Color(0xFF2F4050),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            formatTime(provider.secondsRemaining),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Mode selector button
                  Consumer<TypingTestProvider>(
                    builder: (context, provider, _) => Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: provider.currentMode == DifficultyMode.easy
                            ? const Color(
                                0xFF388E3C) // Easy - Professional forest green
                            : provider.currentMode == DifficultyMode.medium
                                ? const Color(0xFF4258FF) // Medium - Rich blue
                                : const Color(0xFF913AF1), // Hard - Deep purple
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (!provider.isTestActive) {
                            provider.cycleMode();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          getModeText(provider.currentMode),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
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
                        onPressed: () {
                          provider.restartTest();
                          _controller.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
