// lib/features/quiz/pages/quiz_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../data_source.dart';
import '../score_service.dart';
import '../state.dart';
import '../widgets/question_card.dart';
import '../widgets/progress_bar.dart';
import '../decors/parchment_painter.dart';
import '../decors/stars_painter.dart';
import 'package:go_router/go_router.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  late Future<QuizData> _loaderFuture;
  final DataSourceAdapter _adapter = DataSourceAdapter();

  @override
  void initState() {
    super.initState();
    _loaderFuture = QuizDataSource().load();
  }

  IconData _mapIcon(String name) {
    switch (name) {
      case 'potion':
        return Icons.local_drink;
      case 'castle':
        return Icons.category;
      case 'star':
        return Icons.star;
      case 'book':
        return Icons.book;
      case 'owl':
        return Icons.flutter_dash; // no owl native, use placeholder
      case 'hands':
        return Icons.handshake;
      case 'wand':
        return Icons.auto_awesome;
      case 'shield':
        return Icons.shield;
      case 'quill':
        return Icons.create;
      case 'scroll':
        return Icons.description;
      case 'broom':
        return Icons.airline_seat_recline_extra;
      case 'scale':
        return Icons.balance;
      case 'sparkles':
        return Icons.auto_awesome_motion;
      case 'mask':
        return Icons.theater_comedy;
      case 'stag':
        return Icons.pets;
      case 'group':
        return Icons.group;
      case 'riddle':
        return Icons.psychology;
      case 'leaf':
        return Icons.eco;
      case 'lock':
        return Icons.lock;
      case 'hall':
        return Icons.event_seat;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuizData>(
      future: _loaderFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tri de Sorciers')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Erreur de chargement: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loaderFuture = QuizDataSource().load();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tri de Sorciers')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final quiz = snapshot.data!;
        // Initialize state provider with proper length if needed
        final quizNotifier = ref.read(quizStateProvider.notifier);
        if (quizNotifier.state.selections.length != quiz.questions.length) {
          // Recreate selections length by resetting provider state
          quizNotifier.reset();
          // reinitialize length properly:
          final newSelections = List<String?>.filled(quiz.questions.length, null);
          ref.read(quizStateProvider.notifier).state =
              ref.read(quizStateProvider.notifier).state.copyWith(selections: newSelections, currentIndex: 0);
        }

        final state = ref.watch(quizStateProvider);

        final currentQuestion = quiz.questions[state.currentIndex];
        final selectedHouse = state.selections[state.currentIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tri de Sorciers'),
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            children: [
              // parchment background
              Positioned.fill(
                child: CustomPaint(
                  painter: ParchmentPainter(base: Theme.of(context).colorScheme.background ?? Colors.white),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: StarsPainter(count: 60, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // question header + progress
                      Row(
                        children: [
                          Expanded(child: QuizProgressBar(current: state.currentIndex + 1, total: quiz.questions.length)),
                          const SizedBox(width: 12),
                          Text('Question ${state.currentIndex + 1}/${quiz.questions.length}', style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // question card
                      Expanded(
                        child: QuestionCard(
                          question: currentQuestion,
                          selectedHouse: selectedHouse,
                          onSelect: (k, h) {
                            ref.read(quizStateProvider.notifier).selectAnswer(state.currentIndex, h);
                          },
                          iconMap: Map.fromEntries(quiz.questions.map((q) => MapEntry(q.icon, _mapIcon(q.icon)))),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: state.currentIndex > 0
                                ? () {
                                    ref.read(quizStateProvider.notifier).previous();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Précédent'),
                          ).animate().fadeIn(duration: 160.ms),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: state.selections[state.currentIndex] != null
                                ? () {
                                    if (state.currentIndex + 1 >= quiz.questions.length) {
                                      // compute result and navigate
                                      final scoreService = ScoreService();
                                      final winner = scoreService.resolveWinner(quiz, state.selections);
                                      // store or use provider for result - navigate to result page
                                      // We keep quiz state in provider and ResultPage will compute using data loaded again
                                      GoRouter.of(context).go('/result');
                                    } else {
                                      ref.read(quizStateProvider.notifier).next();
                                    }
                                  }
                                : null,
                            child: Text(state.currentIndex + 1 >= quiz.questions.length ? 'Terminer' : 'Suivant'),
                          ).animate().fadeIn(duration: 160.ms),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Adapter used to hint types; simple placeholder to please analyzer
class DataSourceAdapter {}
