// lib/constants/difficulty_mode.dart
import 'dart:ui';

enum DifficultyMode {
  easy,
  medium,
  hard;

  String get displayText {
    switch (this) {
      case DifficultyMode.easy:
        return 'Easy';
      case DifficultyMode.medium:
        return 'Med';
      case DifficultyMode.hard:
        return 'Hard';
    }
  }

  Color get color {
    switch (this) {
      case DifficultyMode.easy:
        return const Color(0xFF388E3C);
      case DifficultyMode.medium:
        return const Color(0xFF4258FF);
      case DifficultyMode.hard:
        return const Color(0xFF913AF1);
    }
  }
}
