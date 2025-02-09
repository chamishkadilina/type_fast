// lib/screens/statistics/widgets/stats_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:type_fast/screens/statistics/statistics_screen.dart';

class StatsTabBar extends StatelessWidget {
  final TabController tabController;
  final bool isDarkMode;

  const StatsTabBar({
    super.key,
    required this.tabController,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        right: isLandscape ? screenWidth * 0.05 : 16,
        left: isLandscape ? 0 : screenWidth * 0.05,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black87.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.5),
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.grey[800]!
                  : Colors.grey.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: TabBar(
          controller: tabController,
          tabs: List.generate(StatisticsColors.modes.length, (index) {
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
                    color: StatisticsColors.modeColors[index],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    StatisticsColors.modes[index],
                    style: TextStyle(
                      color: StatisticsColors.modeColors[index],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
          indicatorColor: StatisticsColors.indicatorColor,
          indicatorWeight: 3,
        ),
      ),
    );
  }
}
