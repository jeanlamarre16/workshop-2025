// lib/features/quiz/score_service.dart
import 'models.dart';

class ScoreService {
  /// Computes map houseId -> score
  Map<String, int> computeScores(QuizData data, List<String?> selections) {
    final scores = <String, int>{};
    for (final h in data.houses) {
      scores[h] = 0;
    }
    for (int i = 0; i < selections.length; i++) {
      final house = selections[i];
      if (house != null && scores.containsKey(house)) {
        scores[house] = (scores[house] ?? 0) + 1;
      }
    }
    return scores;
  }

  /// Tie-breaker: if multiple houses share max score, prefer the one appearing most frequently in the most recent answers;
  /// i.e. iterate selections from last to first, keep counts among tied houses and pick highest; if still tie, use deterministic order:
  /// Gryffondor > Serpentard > Serdaigle > Poufsouffle (mapping to ids)
  String resolveWinner(QuizData data, List<String?> selections) {
    final scores = computeScores(data, selections);
    final maxScore = scores.values.isEmpty ? 0 : scores.values.reduce((a, b) => a > b ? a : b);
    final tied = scores.entries.where((e) => e.value == maxScore).map((e) => e.key).toSet();

    if (tied.length == 1) return tied.first;

    // count occurrences in recent answers among tied houses
    final recentCounts = <String, int>{};
    for (final h in tied) recentCounts[h] = 0;
    for (final s in selections.reversed) {
      if (s != null && recentCounts.containsKey(s)) {
        recentCounts[s] = recentCounts[s]! + 1;
      }
    }
    final maxRecent = recentCounts.values.reduce((a, b) => a > b ? a : b);
    final recentTied = recentCounts.entries.where((e) => e.value == maxRecent).map((e) => e.key).toList();
    if (recentTied.length == 1) return recentTied.first;

    // deterministic order mapping
    final priority = ['gryffindor', 'slytherin', 'ravenclaw', 'hufflepuff'];
    for (final p in priority) {
      if (recentTied.contains(p)) return p;
    }

    // fallback
    return priority.first;
  }
}
