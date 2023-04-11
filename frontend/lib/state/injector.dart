import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/repository/evaluation_criteria_repository.dart';
import 'package:adaptivity_200/state/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalStateInjector extends StatefulWidget {
  const GlobalStateInjector({Key? key}) : super(key: key);

  @override
  State<GlobalStateInjector> createState() => _GlobalStateInjectorState();
}

class _GlobalStateInjectorState extends State<GlobalStateInjector> {

  @override
  void initState() {
    super.initState();

    final evaluationCriteria = EvaluationCriteriaRepository().load();
    evaluator = AdaptivityResultEvaluator(criteria: evaluationCriteria);
  }
  late final AdaptivityResultEvaluator evaluator;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      QuizProvider(questions: questions, evaluator: evaluator),

    ]);
  }
}
