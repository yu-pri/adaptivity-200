import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class QuizProvider extends ChangeNotifier {
  final AdaptivityResultEvaluator _resultEvaluator;
  final List<QuizQuestion> _questions;
  final List<bool?> _answers = List.generate(200, (_) => null);

  AdaptivityResult? _result;

  QuizProvider({
    required List<String> questions,
    required AdaptivityResultEvaluator evaluator,
  })  : _resultEvaluator = evaluator,
        _questions = questions
            .mapIndexed((index, question) =>
                QuizQuestion(id: index, question: question))
            .toList() {
    _questions.shuffle();
  }

  AdaptivityResult? get result => _result;

  List<QuizQuestion> get questions => _questions;

  List<QuizAnswer> get answers => _answers
      .mapIndexed((index, answer) => QuizAnswer(id: index, answer: answer))
      .toList();

  void recordAnswer(int questionId, bool answer) {
    _answers[questionId] = answer;
    notifyListeners();
  }

  void evaluateAnswers() {
    if (!_answers.contains(null)) {
      _result = _resultEvaluator.evaluateAnswers(_answers as List<bool>);
    }
    notifyListeners();
  }
}

class QuizAnswer {
  final int id;
  final bool? answer;

  QuizAnswer({
    required this.id,
    required this.answer,
  });
}

class QuizQuestion {
  final int id;
  final String question;

  QuizQuestion({
    required this.id,
    required this.question,
  });
}
