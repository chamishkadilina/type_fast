// lib/screens/statistics/widgets/clear_data_dialog.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/model/test_result.dart';
import 'package:type_fast/providers/theme_provider.dart';

class ClearDataDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDarkMode = themeProvider.isDarkMode;

        return AlertDialog(
          backgroundColor: themeProvider.theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Clear All Data',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.9)
                  : const Color(0xFF2F4050),
            ),
          ),
          content: Text(
            'Are you sure you want to clear all typing test results? This action cannot be undone.',
            style: TextStyle(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.9)
                  : Colors.black87,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _clearAllData(context);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text(
                'Clear Data',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _clearAllData(BuildContext context) async {
    final box = Hive.box<TestResult>('test_results');
    await box.clear();

    if (context.mounted) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final isDarkMode = themeProvider.isDarkMode;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All typing test results have been cleared',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.white,
            ),
          ),
          backgroundColor:
              isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFF2F4050),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
