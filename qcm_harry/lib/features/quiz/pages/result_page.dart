// lib/features/quiz/pages/result_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models.dart';
import '../data_source.dart';
import '../score_service.dart';
import '../state.dart';
import '../decors/crest_painter.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  String _houseLabel(String id) {
    switch (id) {
      case 'gryffindor':
        return 'Gryffondor';
      case 'slytherin':
        return 'Serpentard';
      case 'ravenclaw':
        return 'Serdaigle';
      case 'hufflepuff':
        return 'Poufsouffle';
      default:
        return id;
    }
  }

  Color _houseColor(String id) {
    switch (id) {
      case 'gryffindor':
        return const Color(0xFF7F0909);
      case 'slytherin':
        return const Color(0xFF0E1A40);
      case 'ravenclaw':
        return const Color(0xFF2A623D);
      case 'hufflepuff':
        return const Color(0xFFD3A625);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizDataProvider);
    final quizState = ref.watch(quizStateProvider);
    return quizAsync.when(
      data: (quiz) {
        final scorer = ScoreService();
        final scores = scorer.computeScores(quiz, quizState.selections);
        final winnerId = scorer.resolveWinner(quiz, quizState.selections);
        final winnerLabel = _houseLabel(winnerId);
        final color = _houseColor(winnerId);

        return Scaffold(
          appBar: AppBar(title: const Text('Résultat')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text('Vous êtes :', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  // crest
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: CustomPaint(
                      painter: CrestPainter(color: color),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(winnerLabel, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: color)),
                  const SizedBox(height: 18),
                  // scores summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: quiz.houses.map((h) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(child: Text(_houseLabel(h))),
                                Text('${scores[h] ?? 0}/20'),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ref.read(quizStateProvider.notifier).reset();
                          GoRouter.of(context).go('/quiz');
                        },
                        child: const Text('Recommencer'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // maybe share or close - just go to quiz
                          ref.read(quizStateProvider.notifier).reset();
                          GoRouter.of(context).go('/quiz');
                        },
                        child: const Text('Refaire le quiz'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Résultat')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) => Scaffold(
        appBar: AppBar(title: const Text('Résultat')),
        body: Center(child: Text('Erreur: $err')),
      ),
    );
  }
}
