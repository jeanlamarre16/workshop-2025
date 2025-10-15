// lib/features/quiz/widgets/question_card.dart
import 'package:flutter/material.dart';
import '../models.dart';
import 'mystic_button.dart';

typedef AnswerCallback = void Function(String key, String houseId);

class QuestionCard extends StatelessWidget {
  final Question question;
  final String? selectedHouse;
  final AnswerCallback onSelect;
  final Map<String, IconData> iconMap;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedHouse,
    required this.onSelect,
    required this.iconMap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // question header
            Row(
              children: [
                Icon(iconMap[question.icon] ?? Icons.help_outline, size: 28, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.text,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // answers
            Column(
              children: question.answers.map((a) {
                final isSelected = selectedHouse != null && selectedHouse == a.house;
                final icon = iconMap[question.icon] ?? Icons.auto_awesome;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: MysticButton(answer: a, selected: isSelected, onSelect: (k, h) => onSelect(k, h), icon: icon),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
