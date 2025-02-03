import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/typing_test_provider.dart';

class ResultDialog extends StatelessWidget {
  final int wpm;
  final int keystrokes;
  final String accuracy;
  final int correctWords;
  final int wrongWords;
  final double testDurationInMinutes;
  final DifficultyMode currentMode;

  const ResultDialog({
    super.key,
    required this.wpm,
    required this.keystrokes,
    required this.accuracy,
    required this.correctWords,
    required this.wrongWords,
    required this.testDurationInMinutes,
    required this.currentMode,
  });

  // Helper method to get mode text
  String _getModeText(DifficultyMode mode) {
    switch (mode) {
      case DifficultyMode.easy:
        return 'Easy';
      case DifficultyMode.medium:
        return 'Medium';
      case DifficultyMode.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Result',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$wpm WPM',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              '(${testDurationInMinutes.toStringAsFixed(1)} minute ${_getModeText(currentMode)} mode)',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow(
                'Keystrokes',
                '($correctWords | ${wrongWords + correctWords})',
                keystrokes.toString()),
            _buildStatRow('Accuracy', '', '$accuracy%'),
            _buildStatRow('Correct words', '', correctWords.toString()),
            _buildStatRow('Wrong words', '', wrongWords.toString(),
                isError: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<TypingTestProvider>(context, listen: false)
                    .restartTest();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(200, 45),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String subtitle, String value,
      {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isError ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
