// lib/features/quiz/data_source.dart
import 'package:flutter/services.dart';
import 'models.dart';

class QuizDataSource {
  static const _assetPath = 'assets/questions.json';

  Future<QuizData> load() async {
    try {
      final jsonStr = await rootBundle.loadString(_assetPath);
      final quizData = QuizData.parse(jsonStr);
      return quizData;
    } on FormatException catch (e) {
      throw Exception('Invalid quiz JSON: ${e.message}');
    } catch (e) {
      throw Exception('Asset loading failed or unknown error: $e');
    }
  }
}
