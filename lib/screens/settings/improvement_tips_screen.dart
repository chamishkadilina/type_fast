// lib/screens/improvement_tips_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/model/improvement_tip.dart';
import '../../providers/theme_provider.dart';
import '../../services/improvement_tips_service.dart';

class CategoryUtils {
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'speed':
        return const Color(0xFF26DE81);
      case 'accuracy':
        return const Color(0xFF54A0FF);
      case 'ergonomics':
        return const Color(0xFFFF9F43);
      case 'technique':
        return const Color(0xFF6C5CE7);
      case 'practice':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF4B7BEC);
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'speed':
        return Icons.speed;
      case 'accuracy':
        return Icons.gps_fixed;
      case 'ergonomics':
        return Icons.chair;
      case 'technique':
        return Icons.keyboard;
      case 'practice':
        return Icons.timer;
      default:
        return Icons.lightbulb_outline;
    }
  }

  static String getImagePath(String category) {
    switch (category.toLowerCase()) {
      case 'speed':
        return 'assets/images/speed.png';
      case 'accuracy':
        return 'assets/images/accuracy.png';
      case 'ergonomics':
        return 'assets/images/ergonomics.png';
      case 'technique':
        return 'assets/images/technique.png';
      case 'practice':
        return 'assets/images/practice.png';
      default:
        return 'assets/images/speed.png';
    }
  }
}

class ImprovementTipsScreen extends StatelessWidget {
  final ImprovementTipsService _tipsService = ImprovementTipsService();

  ImprovementTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final tips = _tipsService.getAllTips();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeProvider.theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: themeProvider.theme.scaffoldBackgroundColor,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white70 : const Color(0xFF2B2D42),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Typing Tips',
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF2B2D42),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? screenWidth * 0.05 : 16,
              vertical: isLandscape ? 16 : 8,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape ? 3 : 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                // Adjust aspect ratio based on orientation
                childAspectRatio: isLandscape ? 0.9 : 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _TipCard(
                  tip: tips[index],
                  color: CategoryUtils.getCategoryColor(tips[index].category),
                  isLandscape: isLandscape,
                ),
                childCount: tips.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: isLandscape ? 12 : 24),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final ImprovementTip tip;
  final Color color;
  final bool isLandscape;

  const _TipCard({
    required this.tip,
    required this.color,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CategoryUtils.getCategoryIcon(tip.category),
                    size: 18,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip.category,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2B2D42),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tip.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: isLandscape ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Image section - Flexible height with expanded
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  CategoryUtils.getImagePath(tip.category),
                  width: double.infinity,
                  // Use appropriate BoxFit to avoid distortion
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
