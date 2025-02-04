// lib/models/test_result.dart
import 'package:hive/hive.dart';

part 'test_result.g.dart';

@HiveType(typeId: 0)
class TestResult extends HiveObject {
  @HiveField(0)
  final int wpm;

  @HiveField(1)
  final String mode;

  @HiveField(2)
  final DateTime timestamp;

  TestResult({
    required this.wpm,
    required this.mode,
    required this.timestamp,
  });
}
