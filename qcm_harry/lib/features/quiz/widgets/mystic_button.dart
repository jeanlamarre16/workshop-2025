// lib/features/quiz/widgets/mystic_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';

typedef OnSelect = void Function(String key, String houseId);

class MysticButton extends StatelessWidget {
  final Answer answer;
  final bool selected;
  final OnSelect onSelect;
  final IconData icon;

  const MysticButton({
    super.key,
    required this.answer,
    required this.selected,
    required this.onSelect,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.06);
    final border = selected ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 2) : null;
    return ElevatedButton(
      onPressed: () => onSelect(answer.key, answer.house),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        elevation: selected ? 6 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(answer.key, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(answer.label, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          if (selected)
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary)
              .animate()
              .fade(duration: 180.ms)
              .scale(duration: 200.ms),
        ],
      ),
    ).animate().fadeIn(duration: 180.ms);
  }
}
