// lib/screens/statistics/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/model/test_result.dart';
import 'package:type_fast/screens/statistics/widgets/mode_stats_view.dart';
import 'package:type_fast/screens/statistics/widgets/stats_tab_bar.dart';
import 'package:type_fast/services/statistics_service.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/screens/statistics/widgets/clear_data_dialog.dart';

class StatisticsColors {
  static const List<String> modes = ['Easy', 'Medium', 'Hard'];

  static const List<Color> modeColors = [
    Color(0xFF388E3C), // Easy - Professional forest green
    Color(0xFF4258FF), // Medium - Rich blue
    Color(0xFF913AF1), // Hard - Deep purple
  ];

  static const Color lightBackground = Color(0xFFDBEAF9);
  static const Color darkText = Color(0xFF2F4050);
  static const Color indicatorColor = Color(0xFF4A90E2);
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StatisticsService _statisticsService = StatisticsService();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: StatisticsColors.modes.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, Map<String, dynamic>> _getStatsByMode() {
    final results = _statisticsService.getAllResults();
    Map<String, List<TestResult>> resultsByMode = {
      for (var mode in StatisticsColors.modes) mode: [],
    };

    for (var result in results) {
      resultsByMode[result.mode]?.add(result);
    }

    return {
      for (var mode in resultsByMode.keys)
        mode: _calculateModeStats(resultsByMode[mode]!)
    };
  }

  Map<String, dynamic> _calculateModeStats(List<TestResult> modeResults) {
    if (modeResults.isEmpty) {
      return {
        'testsTaken': 0,
        'highestWpm': 0,
        'averageWpm': 0,
        'lowestWpm': 0,
        'recentTests': <TestResult>[],
      };
    }

    final wpms = modeResults.map((r) => r.wpm).toList();
    final recentTests = List<TestResult>.from(modeResults)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return {
      'testsTaken': modeResults.length,
      'highestWpm': wpms.reduce((max, wpm) => wpm > max ? wpm : max),
      'averageWpm': wpms.reduce((a, b) => a + b) ~/ wpms.length,
      'lowestWpm': wpms.reduce((min, wpm) => wpm < min ? wpm : min),
      'recentTests': recentTests.take(10).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final statsByMode = _getStatsByMode();

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black87 : StatisticsColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black87.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white70 : StatisticsColors.darkText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Typing Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white70 : StatisticsColors.darkText,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: isDarkMode ? Colors.white70 : StatisticsColors.darkText,
            ),
            onPressed: () {
              ClearDataDialog.show(context).then((_) => setState(() {}));
            },
            tooltip: 'Clear All Data',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: StatsTabBar(
            tabController: _tabController,
            isDarkMode: isDarkMode,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(StatisticsColors.modes.length, (index) {
          return ModeStatsView(
            mode: StatisticsColors.modes[index],
            stats: statsByMode[StatisticsColors.modes[index]]!,
            modeColor: StatisticsColors.modeColors[index],
            isDarkMode: isDarkMode,
          );
        }),
      ),
    );
  }
}
