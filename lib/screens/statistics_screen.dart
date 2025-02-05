import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:type_fast/model/test_result.dart';
import 'package:type_fast/services/statistics_service.dart';
import 'package:type_fast/widgets/clear_data_dialog.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _modes = ['Easy', 'Medium', 'Hard'];
  final List<Color> _modeColors = [
    const Color(0xFF388E3C), // Easy - Professional forest green
    const Color(0xFF4258FF), // Medium - Rich blue
    const Color(0xFF913AF1), // Hard - Deep purple
  ];
  final StatisticsService _statisticsService = StatisticsService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _modes.length, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFDBEAF9),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFDBEAF9),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, Map<String, dynamic>> _getStatsByMode() {
    final results = _statisticsService.getAllResults();
    Map<String, List<TestResult>> resultsByMode = {
      'Easy': [],
      'Medium': [],
      'Hard': [],
    };

    for (var result in results) {
      resultsByMode[result.mode]?.add(result);
    }

    Map<String, Map<String, dynamic>> statsByMode = {};

    for (var mode in resultsByMode.keys) {
      final modeResults = resultsByMode[mode]!;
      if (modeResults.isEmpty) {
        statsByMode[mode] = {
          'testsTaken': 0,
          'highestWpm': 0,
          'averageWpm': 0,
          'lowestWpm': 0,
          'recentTests': <TestResult>[],
        };
      } else {
        final wpms = modeResults.map((r) => r.wpm).toList();
        final recentTests = List<TestResult>.from(modeResults)
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        statsByMode[mode] = {
          'testsTaken': modeResults.length,
          'highestWpm': wpms.reduce((max, wpm) => wpm > max ? wpm : max),
          'averageWpm': wpms.reduce((a, b) => a + b) ~/ wpms.length,
          'lowestWpm': wpms.reduce((min, wpm) => wpm < min ? wpm : min),
          'recentTests': recentTests.take(10).toList(),
        };
      }
    }

    return statsByMode;
  }

  Widget _buildStatCard(
      String label, dynamic value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressGraph(List<TestResult> recentTests, Color color) {
    if (recentTests.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart,
                  size: 48, color: color.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No data available yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete some typing tests to see your progress',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Performance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey[200]!, strokeWidth: 1),
                    getDrawingVerticalLine: (value) =>
                        FlLine(color: Colors.grey[200]!, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= recentTests.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              (value.toInt() + 1).toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(recentTests.length, (index) {
                        final reverseIndex = recentTests.length - 1 - index;
                        return FlSpot(
                          index.toDouble(),
                          recentTests[reverseIndex].wpm.toDouble(),
                        );
                      }),
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: color,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsByMode = _getStatsByMode();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFDBEAF9),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFF2F4050)),
            onPressed: () {
              ClearDataDialog.show(context).then((_) {
                // Refresh the UI after dialog is closed
                setState(() {});
              });
            },
            tooltip: 'Clear All Data',
          ),
        ],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2F4050)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Typing Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F4050),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: List.generate(_modes.length, (index) {
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        index == 0
                            ? Icons.keyboard_alt_outlined
                            : index == 1
                                ? Icons.keyboard
                                : Icons.keyboard_double_arrow_right,
                        color: _modeColors[index],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _modes[index],
                        style: TextStyle(
                          color: _modeColors[index],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              indicatorColor: const Color(0xFF4A90E2),
              indicatorWeight: 3,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_modes.length, (index) {
          final stats = statsByMode[_modes[index]]!;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isLandscape ? 4 : 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isLandscape ? 1.5 : 1.2,
                      children: [
                        _buildStatCard(
                          'Tests Taken',
                          stats['testsTaken'],
                          Icons.history_rounded,
                          _modeColors[index],
                        ),
                        _buildStatCard(
                          'Highest WPM',
                          stats['highestWpm'],
                          Icons.emoji_events_rounded,
                          _modeColors[index],
                        ),
                        _buildStatCard(
                          'Average WPM',
                          stats['averageWpm'],
                          Icons.speed_rounded,
                          _modeColors[index],
                        ),
                        _buildStatCard(
                          'Lowest WPM',
                          stats['lowestWpm'],
                          Icons.show_chart_rounded,
                          _modeColors[index],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildProgressGraph(
                      stats['recentTests'],
                      _modeColors[index],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
