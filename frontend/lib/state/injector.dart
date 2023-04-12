import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/repository/answers_repository.dart';
import 'package:adaptivity_200/repository/evaluation_criteria_repository.dart';
import 'package:adaptivity_200/repository/questions_repository.dart';
import 'package:adaptivity_200/state/quiz_provider.dart';
import 'package:adaptivity_200/state/result_sender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalStateInjector extends StatelessWidget {
  final Widget child;

  const GlobalStateInjector({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => QuizProvider(
            questionsRepo: QuestionsRepository(),
            evaluationCriteriaRepository: EvaluationCriteriaRepository(),
            answersRepository: AnswersRepository(),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) {
              final result = context.read<QuizProvider>().result;
              return ResultSender(
                result: result!,
              );
            },
        )      ],
      child: child,
    );
  }
}
