// test/json_parsing_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_de_sorciers/features/quiz/models.dart';
import 'dart:convert';

void main() {
  test('parse assets/questions.json structure', () {
    // Use the string directly (same as asset provided)
    final jsonStr = '''
{
  "version": 1,
  "houses": ["gryffindor","slytherin","ravenclaw","hufflepuff"],
  "questions": [
    {
      "id": 1,
      "text": "Q",
      "icon": "potion",
      "answers": [
        {"key":"A","label":"a","house":"gryffindor"},
        {"key":"B","label":"b","house":"slytherin"},
        {"key":"C","label":"c","house":"ravenclaw"},
        {"key":"D","label":"d","house":"hufflepuff"}
      ]
    }
  ]
}
''';
    final data = QuizData.parse(jsonStr);
    expect(data.version, 1);
    expect(data.houses.length, 4);
    expect(data.questions.length, 1);
    final q = data.questions.first;
    expect(q.answers.length, 4);
  });
}
