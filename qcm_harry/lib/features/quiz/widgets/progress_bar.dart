// lib/features/quiz/widgets/progress_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizProgressBar extends StatelessWidget {
  final int current; // 1-based
  final int total;

  const QuizProgressBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = (current / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$current/$total', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(value: percent, minHeight: 10)
              .animate()
              .fadeIn(duration: 200.ms)
              .slideY(begin: 0.1, duration: 200.ms),
        ),
      ],
    );
  }
}
