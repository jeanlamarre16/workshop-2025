// test/score_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_de_sorciers/features/quiz/models.dart';
import 'package:tri_de_sorciers/features/quiz/score_service.dart';

void main() {
  test('score computation and tie-break', () {
    final quiz = QuizData(version: 1, houses: ['gryffindor','slytherin','ravenclaw','hufflepuff'],
        questions: List.generate(4, (i) => Question(id: i+1, text: 'q', icon: 'star', answers: [
          Answer(key: 'A', label: 'a', house: 'gryffindor'),
          Answer(key: 'B', label: 'b', house: 'slytherin'),
          Answer(key: 'C', label: 'c', house: 'ravenclaw'),
          Answer(key: 'D', label: 'd', house: 'hufflepuff'),
        ])));
    final service = ScoreService();
    final selections = List<String?>.filled(4, null);
    selections[0] = 'gryffindor';
    selections[1] = 'slytherin';
    selections[2] = 'gryffindor';
    selections[3] = 'slytherin';
    final scores = service.computeScores(quiz, selections);
    expect(scores['gryffindor'], 2);
    expect(scores['slytherin'], 2);
    // tie-break should inspect recent answers: last is slytherin, so slytherin wins
    final winner = service.resolveWinner(quiz, selections);
    expect(winner, 'slytherin');
  });
}
