// lib/features/quiz/state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'data_source.dart';
import 'score_service.dart';

final quizDataProvider = FutureProvider<QuizData>((ref) async {
  final ds = QuizDataSource();
  return ds.load();
});

class QuizState {
  final int currentIndex; // 0-based
  final List<String?> selections; // house ids per question or null
  final bool loading;
  final String? error;

  QuizState({
    required this.currentIndex,
    required this.selections,
    this.loading = false,
    this.error,
  });

  QuizState copyWith({
    int? currentIndex,
    List<String?>? selections,
    bool? loading,
    String? error,
  }) {
    return QuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      selections: selections ?? List<String?>.from(this.selections),
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizData? quizData;
  QuizNotifier({this.quizData})
      : super(
          QuizState(
            currentIndex: 0,
            selections: List<String?>.filled(quizData?.questions.length ?? 20, null),
            loading: false,
          ),
        );

  void selectAnswer(int questionIndex, String houseId) {
    final s = List<String?>.from(state.selections);
    s[questionIndex] = houseId;
    state = state.copyWith(selections: s);
  }

  void next() {
    if (state.currentIndex < state.selections.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previous() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void goToIndex(int idx) {
    if (idx >= 0 && idx < state.selections.length) {
      state = state.copyWith(currentIndex: idx);
    }
  }

  void reset() {
    state = QuizState(currentIndex: 0, selections: List<String?>.filled(state.selections.length, null));
  }

  bool isAnswered(int idx) {
    if (idx < 0 || idx >= state.selections.length) return false;
    return state.selections[idx] != null;
  }
}

final quizStateProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  // Wait for quizDataProvider externally in pages and recreate provider there if needed.
  // Provide a default to allow tests / previews
  final quizData = null;
  return QuizNotifier(quizData: quizData);
});
