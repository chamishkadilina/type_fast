// lib/widgets/clear_data_dialog.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:type_fast/model/test_result.dart';

class ClearDataDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Clear All Data',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F4050),
            ),
          ),
          content: const Text(
            'Are you sure you want to clear all typing test results? This action cannot be undone.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _clearAllData(context);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'All typing test results have been cleared',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2F4050),
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
