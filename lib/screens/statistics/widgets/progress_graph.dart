// lib/screens/statistics/widgets/progress_graph.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:type_fast/model/test_result.dart';

class ProgressGraph extends StatelessWidget {
  final List<TestResult> recentTests;
  final Color color;
  final bool isDarkMode;

  const ProgressGraph({
    super.key,
    required this.recentTests,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (recentTests.isEmpty) {
      return Container(
        height: isLandscape ? 180 : 256,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? color.withValues(alpha: 0.2)
                : color.withValues(alpha: 0.1),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart,
                  size: isLandscape ? 40 : 48,
                  color: color.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No data available yet',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: isLandscape ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete some typing tests to see your progress',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  fontSize: isLandscape ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(isLandscape ? 12 : 16),
        height: isLandscape ? 180 : 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Performance',
              style: TextStyle(
                fontSize: isLandscape ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            SizedBox(height: isLandscape ? 12 : 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: _buildTitlesData(),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [_buildLineChartBarData()],
                  minY: 0,
                  backgroundColor:
                      isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
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
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
    );
  }

  LineChartBarData _buildLineChartBarData() {
    return LineChartBarData(
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
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          strokeWidth: 2,
          strokeColor: color,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.1),
      ),
    );
  }
}
