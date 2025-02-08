// lib/models/improvement_tip.dart
class ImprovementTip {
  final String title;
  final String description;
  final String category;

  const ImprovementTip({
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  String toString() {
    return 'ImprovementTip(title: $title, category: $category)';
  }
}
