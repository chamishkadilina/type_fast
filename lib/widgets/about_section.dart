// lib/widgets/about_section.dart
import 'package:flutter/material.dart';
import 'package:type_fast/widgets/settings_section.dart';
import 'package:type_fast/widgets/typing_mode_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'About TypeFast',
      children: [
        const SizedBox(height: 8),
        TypingModeCard(
          title: 'Easy Mode',
          tag: 'Top 200 Words',
          color: const Color(0xFF388E3C),
          description: '🚀 The Perfect Start for Beginners!',
          benefits: [
            'Master the 200 most commonly used English words with ease!',
            'Build muscle memory with smart finger positioning',
            'Improve accuracy with gradual speed-building exercises',
          ],
        ),
        TypingModeCard(
          title: 'Medium Mode',
          tag: 'Top 500 Words',
          color: const Color(0xFF4258FF),
          description: '🔥 Level Up Your Speed & Accuracy in real life',
          benefits: [
            'Expand your vocabulary with the 500 most essential English words for faster typing!',
            'Practice advanced word combinations & phrases',
            'Train your fingers for fluid and rhythmic typing',
          ],
        ),
        TypingModeCard(
          title: 'Hard Mode',
          tag: 'Top 1000 Words',
          color: const Color(0xFF913AF1),
          description: '💪 Type Like a Pro!',
          benefits: [
            'Challenge yourself by mastering the 1000 most frequently used English words like a pro!',
            'Tackle complex sentence structures with confidence',
            'Sharpen your precision & speed to the max',
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
