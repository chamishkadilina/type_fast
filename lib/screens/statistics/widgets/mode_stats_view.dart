// lib/screens/statistics/widgets/mode_stats_view.dart
import 'package:flutter/material.dart';
import 'package:type_fast/model/test_result.dart';
import 'package:type_fast/screens/statistics/widgets/progress_graph.dart';
import 'package:type_fast/screens/statistics/widgets/stat_card.dart';

class ModeStatsView extends StatelessWidget {
  final String mode;
  final Map<String, dynamic> stats;
  final Color modeColor;
  final bool isDarkMode;

  const ModeStatsView({
    super.key,
    required this.mode,
    required this.stats,
    required this.modeColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
                  StatCard(
                    label: 'Tests Taken',
                    value: stats['testsTaken'],
                    icon: Icons.history_rounded,
                    color: modeColor,
                    isDarkMode: isDarkMode,
                  ),
                  StatCard(
                    label: 'Highest WPM',
                    value: stats['highestWpm'],
                    icon: Icons.emoji_events_rounded,
                    color: modeColor,
                    isDarkMode: isDarkMode,
                  ),
                  StatCard(
                    label: 'Average WPM',
                    value: stats['averageWpm'],
                    icon: Icons.speed_rounded,
                    color: modeColor,
                    isDarkMode: isDarkMode,
                  ),
                  StatCard(
                    label: 'Lowest WPM',
                    value: stats['lowestWpm'],
                    icon: Icons.show_chart_rounded,
                    color: modeColor,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ProgressGraph(
                recentTests: stats['recentTests'] as List<TestResult>,
                color: modeColor,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        );
      },
    );
  }
}
