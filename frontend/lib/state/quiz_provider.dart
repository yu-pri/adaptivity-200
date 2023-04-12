import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/core/utility/list_order_utils.dart';
import 'package:adaptivity_200/repository/answers_repository.dart';
import 'package:adaptivity_200/repository/evaluation_criteria_repository.dart';
import 'package:adaptivity_200/repository/questions_repository.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class QuizProvider extends ChangeNotifier {
  final QuestionsRepository _questionsRepository;
  final EvaluationCriteriaRepository _evaluationCriteriaRepository;
  final AnswersRepository _answersRepository;
  List<QuizQuestion> _questionsShuffled = [];
  List<bool?> _answers = [];
  AdaptivityResultEvaluator? _resultEvaluator;
  AdaptivityResult? _result;
  bool _disposed = false;
  QuizError? _quizError;

  QuizProvider({
    required QuestionsRepository questionsRepo,
    required EvaluationCriteriaRepository evaluationCriteriaRepository,
    required AnswersRepository answersRepository,
  })  : _questionsRepository = questionsRepo,
        _evaluationCriteriaRepository = evaluationCriteriaRepository,
        _answersRepository = answersRepository {
    _init();
  }

  Future<void> _init() async {
    final questions = await _questionsRepository.load();
    final evalCriteria = await _evaluationCriteriaRepository.load();
    final storedOrder = await _questionsRepository.loadOrder();
    final answers = await _answersRepository.loadAnswers();
    if (_disposed) return;

    _answers = answers ?? List.generate(questions.length, (_) => null);
    _questionsShuffled = questions
        .mapIndexed((i, q) => QuizQuestion(id: i, question: q, answer: _answers[i]))
        .toList();
    final order =
        storedOrder ?? ListOrderUtils.generateRandomOrder(questions.length);
    _questionsShuffled = ListOrderUtils.applyOrder(_questionsShuffled, order).toList();
    notifyListeners();

    _resultEvaluator = AdaptivityResultEvaluator(criteria: evalCriteria);

    await _questionsRepository.saveOrder(order);
    notifyListeners();
  }

  QuizError? get quizError => _quizError;

  AdaptivityResult? get result => _result;

  List<QuizQuestion> get questions => UnmodifiableListView(_questionsShuffled);

  void recordAnswer(int questionId, bool answer) async {
    final q = _questionsShuffled.firstWhere((q) => q.id == questionId);
    q.answer = answer;
    _answers[questionId] = answer;
    await _answersRepository.saveAnswers(_answers);
    notifyListeners();
  }

  bool evaluateAnswers() {
    bool ok = false;
    if (!_answers.contains(null)) {
      final answers = _answers.cast<bool>();
      _result = _resultEvaluator?.evaluateAnswers(answers);
      ok = true;
    } else {
      _quizError = QuizError.questionsUnfilled;
    }
    notifyListeners();
    return ok;
  }

  Future<void> clearProgress() async {
    await _questionsRepository.clearOrder();
    await _answersRepository.clearAnswers();
    await _init();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

enum QuizError {
  questionsUnfilled,
  unknown,
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
  bool? answer;

  QuizQuestion({
    required this.id,
    required this.question,
    this.answer,
  });
}
