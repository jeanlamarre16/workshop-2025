// lib/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tri_de_sorciers/features/quiz/pages/quiz_page.dart';
import 'package:tri_de_sorciers/features/quiz/pages/result_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/quiz',
  routes: <GoRoute>[
    GoRoute(
      path: '/quiz',
      name: 'quiz',
      builder: (context, state) => const QuizPage(),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
        // result expects args via state.extra or providers compute from state
        return const ResultPage();
      },
    ),
  ],
);
