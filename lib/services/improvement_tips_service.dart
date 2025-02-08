// lib/services/improvement_tips_service.dart
import 'package:type_fast/model/improvement_tip.dart';

class ImprovementTipsService {
  final List<ImprovementTip> _tips = [
    ImprovementTip(
      title: 'Speed Bursts',
      description:
          'Practice typing in short bursts at a speed slightly above your comfort zone. This helps push your limits while maintaining control. Start with 30-second bursts and gradually increase duration.',
      category: 'Speed',
    ),
    ImprovementTip(
      title: 'Accuracy First',
      description:
          'Focus on hitting the right keys rather than typing quickly. Speed will naturally improve as you develop muscle memory. Make it a habit to correct mistakes immediately.',
      category: 'Accuracy',
    ),
    ImprovementTip(
      title: 'Ergonomic Setup',
      description:
          'Position your keyboard at elbow height and keep your wrists straight. Your screen should be at eye level to prevent neck strain. Take regular breaks to stretch your hands and fingers.',
      category: 'Ergonomics',
    ),
    ImprovementTip(
      title: 'Touch Typing',
      description:
          'Master the home row position (ASDF for left hand, JKL; for right hand). Practice reaching other keys without looking at your hands. This is fundamental to building speed and accuracy.',
      category: 'Technique',
    ),
    ImprovementTip(
      title: 'Daily Practice',
      description:
          'Consistency is key. Set aside 15-30 minutes daily for focused practice. Regular, shorter sessions are more effective than occasional long sessions for building muscle memory.',
      category: 'Practice',
    ),
  ];

  List<ImprovementTip> getAllTips() => _tips;
}
