// lib/features/quiz/models.dart
import 'dart:convert';

class Answer {
  final String key; // A|B|C|D
  final String label;
  final String house; // id of house

  Answer({required this.key, required this.label, required this.house});

  factory Answer.fromJson(Map<String, dynamic> json) {
    if (json['key'] == null || json['label'] == null || json['house'] == null) {
      throw FormatException('Invalid Answer JSON schema');
    }
    return Answer(
      key: json['key'] as String,
      label: json['label'] as String,
      house: json['house'] as String,
    );
  }
}

class Question {
  final int id;
  final String text;
  final String icon;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.text,
    required this.icon,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['text'] == null || json['icon'] == null || json['answers'] == null) {
      throw FormatException('Invalid Question JSON schema');
    }
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      icon: json['icon'] as String,
      answers: (json['answers'] as List).map((e) => Answer.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class QuizData {
  final int version;
  final List<String> houses;
  final List<Question> questions;

  QuizData({required this.version, required this.houses, required this.questions});

  factory QuizData.fromJson(Map<String, dynamic> json) {
    if (json['version'] == null || json['houses'] == null || json['questions'] == null) {
      throw FormatException('Invalid QuizData JSON schema');
    }
    final houses = (json['houses'] as List).map((e) => e as String).toList();
    final questions = (json['questions'] as List).map((e) => Question.fromJson(e as Map<String, dynamic>)).toList();
    if (houses.length != 4) {
      throw FormatException('There must be exactly 4 houses');
    }
    if (questions.length != 20) {
      throw FormatException('There must be exactly 20 questions');
    }
    return QuizData(version: json['version'] as int, houses: houses, questions: questions);
  }

  static QuizData parse(String jsonStr) {
    final Map<String, dynamic> map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return QuizData.fromJson(map);
  }
}
