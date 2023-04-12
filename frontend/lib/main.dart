import 'package:adaptivity_200/config/routes.dart';
import 'package:adaptivity_200/screens/quiz_screen.dart';
import 'package:adaptivity_200/screens/send_results_screen.dart';
import 'package:adaptivity_200/state/injector.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalStateInjector(
      child: MaterialApp(
        initialRoute: Routes.quiz,
        routes: {
          Routes.quiz: (c) => const QuizScreen(),
          Routes.sendAnswers: (c) => const SendResultsScreen(),
        },
      ),
    );
  }
}
