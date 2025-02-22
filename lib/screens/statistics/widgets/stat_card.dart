// lib/screens/statistics/widgets/stat_card.dart
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final dynamic value;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Container(
        padding: EdgeInsets.all(isLandscape ? 12 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? color.withValues(alpha: 0.2)
                : color.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isLandscape ? 24 : 28),
            SizedBox(height: isLandscape ? 8 : 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: isLandscape ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: isLandscape ? 6 : 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isLandscape ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
