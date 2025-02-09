// lib/screens/settings/widgets/typing_mode_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';

class TypingModeCard extends StatelessWidget {
  final String title;
  final String tag;
  final Color color;
  final String description;
  final List<String> benefits;

  const TypingModeCard({
    super.key,
    required this.title,
    required this.tag,
    required this.color,
    required this.description,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(themeProvider.isDarkMode ? 0.8 : 0.1),
            color.withOpacity(themeProvider.isDarkMode ? 0.6 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(themeProvider.isDarkMode ? 0.5 : 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : color,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(themeProvider.isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.isDarkMode ? Colors.white : color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: themeProvider.isDarkMode
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: color
                            .withOpacity(themeProvider.isDarkMode ? 0.9 : 1.0),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: themeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
