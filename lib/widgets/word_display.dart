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
                            ? Colors
                                .grey[800] // Dark mode current word, correct
                            : Colors
                                .grey[200] // Light mode current word, correct
                        : isDarkMode
                            ? Colors.red[900]!
                                .withValues(alpha: 0.5) // Dark mode error
                            : Colors.red.shade200 // Light mode error
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                provider.currentWords[index],
                style: TextStyle(
                  color: provider.wordStatus[index] == false &&
                          index < provider.currentWordIndex
                      ? isDarkMode
                          ? Colors.red[300] // Dark mode error text
                          : Colors.red // Light mode error text
                      : isDarkMode
                          ? Colors.white // Dark mode normal text
                          : Colors.black, // Light mode normal text
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
