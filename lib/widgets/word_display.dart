// lib/widgets/word_desplay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/typing_test_provider.dart';
import '../providers/theme_provider.dart';

class WordDisplay extends StatelessWidget {
  const WordDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Consumer<TypingTestProvider>(
      builder: (context, provider, _) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border:
              isDarkMode ? Border.all(color: Colors.white10, width: 1) : null,
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
                        ? isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200]
                        : isDarkMode
                            ? Colors.red[900]!.withOpacity(0.5)
                            : Colors.red.shade200
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                provider.currentWords[index],
                style: TextStyle(
                  fontFamily: themeProvider.selectedFont,
                  fontSize: themeProvider.fontSize,
                  color: provider.wordStatus[index] == false &&
                          index < provider.currentWordIndex
                      ? isDarkMode
                          ? Colors.red[300]
                          : Colors.red
                      : isDarkMode
                          ? Colors.white
                          : Colors.black,
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
