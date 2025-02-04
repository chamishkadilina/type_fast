// lib/widgets/statistics_dialog.dart
import 'package:flutter/material.dart';
import '../services/statistics_service.dart';

class StatisticsDialog extends StatelessWidget {
  const StatisticsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = StatisticsService().getStatistics();

    Widget _buildStatCard(String label, int value, IconData icon, Color color) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Your Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'Tests Taken',
                  stats['testsTaken']!,
                  Icons.history,
                  const Color(0xFF4A90E2),
                ),
                _buildStatCard(
                  'Highest WPM',
                  stats['highestWpm']!,
                  Icons.arrow_upward,
                  const Color(0xFF388E3C),
                ),
                _buildStatCard(
                  'Average WPM',
                  stats['averageWpm']!,
                  Icons.speed,
                  const Color(0xFF4258FF),
                ),
                _buildStatCard(
                  'Lowest WPM',
                  stats['lowestWpm']!,
                  Icons.arrow_downward,
                  const Color(0xFF913AF1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
