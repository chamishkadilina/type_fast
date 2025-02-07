import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/model/test_result.dart';
import 'package:type_fast/services/statistics_service.dart';
import '../providers/typing_test_provider.dart';
import '../providers/theme_provider.dart';

class ResultDialog extends StatelessWidget {
  final int wpm;
  final int keystrokes;
  final String accuracy;
  final int correctWords;
  final int wrongWords;
  final double testDurationInMinutes;
  final DifficultyMode currentMode;

  ResultDialog({
    super.key,
    required this.wpm,
    required this.keystrokes,
    required this.accuracy,
    required this.correctWords,
    required this.wrongWords,
    required this.testDurationInMinutes,
    required this.currentMode,
  }) {
    StatisticsService().saveTestResult(
      TestResult(
        wpm: wpm,
        mode: _getModeText(currentMode),
        timestamp: DateTime.now(),
      ),
    );
  }

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

  Color _getModeColor(DifficultyMode mode, bool isDarkMode) {
    switch (mode) {
      case DifficultyMode.easy:
        return isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF388E3C);
      case DifficultyMode.medium:
        return isDarkMode ? const Color(0xFF5C6BC0) : const Color(0xFF4258FF);
      case DifficultyMode.hard:
        return isDarkMode ? const Color(0xFFAB47BC) : const Color(0xFF913AF1);
    }
  }

  Color _getSecondaryColor(DifficultyMode mode, bool isDarkMode) {
    switch (mode) {
      case DifficultyMode.easy:
        return isDarkMode ? const Color(0xFF81C784) : const Color(0xFF66BB6A);
      case DifficultyMode.medium:
        return isDarkMode ? const Color(0xFF7986CB) : const Color(0xFF7986FF);
      case DifficultyMode.hard:
        return isDarkMode ? const Color(0xFFBA68C8) : const Color(0xFFA674F2);
    }
  }

  Color _getAccuracyColor(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF388E3C);
  Color _getKeystrokesColor(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF5C6BC0) : const Color(0xFF4258FF);
  Color _getCorrectColor(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF388E3C);
  Color _getWrongColor(bool isDarkMode) =>
      isDarkMode ? const Color(0xFFAB47BC) : const Color(0xFF913AF1);

  Widget _buildStatCard(
    String label,
    String value, {
    String? subtitle,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
    bool small = false,
  }) {
    final backgroundColor = isDarkMode
        ? color.withValues(alpha: 0.15)
        : color.withValues(alpha: 0.08);
    final borderColor = isDarkMode
        ? color.withValues(alpha: 0.3)
        : color.withValues(alpha: 0.12);
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      padding: EdgeInsets.all(small ? 12 : 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: small ? 20 : 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: small ? 12 : 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: small ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = isLandscape ? screenWidth * 0.85 : screenWidth * 0.85;
    final dialogHeight = isLandscape ? screenHeight * 0.8 : null;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: isLandscape
            ? _buildLandscapeLayout(isDarkMode)
            : _buildPortraitLayout(isDarkMode),
      ),
    );
  }

  Widget _buildLandscapeLayout(bool isDarkMode) {
    return Builder(builder: (context) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getModeColor(currentMode, isDarkMode),
                    _getSecondaryColor(currentMode, isDarkMode),
                  ],
                ),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
              ),
              child: _buildScoreSection(isDarkMode),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildStatsSection(isDarkMode, context),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPortraitLayout(bool isDarkMode) {
    return Builder(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getModeColor(currentMode, isDarkMode),
                  _getSecondaryColor(currentMode, isDarkMode),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: _buildScoreSection(isDarkMode),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildStatsSection(isDarkMode, context),
          ),
        ],
      );
    });
  }

  Widget _buildScoreSection(bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  '$wpm',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const Text(
                  'WPM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            '${testDurationInMinutes.toStringAsFixed(1)} min ${_getModeText(currentMode)} mode',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(bool isDarkMode, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(
          'Accuracy',
          '$accuracy%',
          icon: Icons.precision_manufacturing_outlined,
          color: _getAccuracyColor(isDarkMode),
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          'Keystrokes',
          keystrokes.toString(),
          subtitle: '($correctWords | ${wrongWords + correctWords})',
          icon: Icons.keyboard_alt_outlined,
          color: _getKeystrokesColor(isDarkMode),
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Correct',
                correctWords.toString(),
                icon: Icons.check_circle_outline,
                color: _getCorrectColor(isDarkMode),
                isDarkMode: isDarkMode,
                small: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Wrong',
                wrongWords.toString(),
                icon: Icons.error_outline,
                color: _getWrongColor(isDarkMode),
                isDarkMode: isDarkMode,
                small: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<TypingTestProvider>(context, listen: false)
                      .restartTest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getModeColor(currentMode, isDarkMode),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: _getModeColor(currentMode, isDarkMode)
                    .withValues(alpha: isDarkMode ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share_rounded,
                  color: isDarkMode ? Colors.white : null,
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
