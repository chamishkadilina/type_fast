// lib/services/statistics_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:type_fast/model/test_result.dart';

class StatisticsService {
  static const String boxName = 'test_results';

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TestResultAdapter());
    await Hive.openBox<TestResult>(boxName);
  }

  Future<void> saveTestResult(TestResult result) async {
    final box = Hive.box<TestResult>(boxName);
    await box.add(result);
  }

  List<TestResult> getAllResults() {
    final box = Hive.box<TestResult>(boxName);
    return box.values.toList();
  }

  Map<String, int> getStatistics() {
    final results = getAllResults();
    if (results.isEmpty) {
      return {
        'testsTaken': 0,
        'lowestWpm': 0,
        'averageWpm': 0,
        'highestWpm': 0,
      };
    }

    final wpms = results.map((r) => r.wpm).toList();
    return {
      'testsTaken': results.length,
      'lowestWpm': wpms.reduce((min, wpm) => wpm < min ? wpm : min),
      'averageWpm': wpms.reduce((a, b) => a + b) ~/ wpms.length,
      'highestWpm': wpms.reduce((max, wpm) => wpm > max ? wpm : max),
    };
  }
}
