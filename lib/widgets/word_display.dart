// lib/widgets/word_display.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/typing_test_provider.dart';

class WordDisplay extends StatelessWidget {
  const WordDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TypingTestProvider>(
      builder: (context, provider, _) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 12,
          children: List.generate(
            provider.currentWords.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: index == provider.currentWordIndex
                    ? provider.isCurrentWordCorrect
                        ? Colors.grey[200] // Current word, correct typing
                        : Colors.red.shade200 // Current word, incorrect typing
                    : Colors.transparent, // Not current word
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                provider.currentWords[index],
                style: TextStyle(
                  color: provider.wordStatus[index] == false &&
                          index < provider.currentWordIndex
                      ? Colors.red
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: index == provider.currentWordIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
