import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_evaluation_keys.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_result.dart';
import 'package:adaptivity_200/core/definitions/model/tier_range.dart';

class AdaptivityResultEvaluator {
  final EvaluationCriteria criteria;

  AdaptivityResultEvaluator({
    required this.criteria,
  });

  static int applyMaskAndCount(List<bool> answers, List<bool?> mask) {
    assert(answers.length == mask.length);
    int matchCount = 0;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == mask[i]) matchCount += 1;
    }
    return matchCount;
  }

  static int determineTier(int score, List<TierRange> upperTierThresholds) =>
      upperTierThresholds
          .firstWhere((range) => range.isScoreInRange(score))
          .tier;

  static CriterionResult evaluateCriterion(
      CriterionEvaluationKeys keys, List<bool> answers) {
    final score = applyMaskAndCount(answers, keys.evaluationMask!);
    final tier = determineTier(score, keys.tierThresholds);
    return CriterionResult(score, tier);
  }

  AdaptivityResult evaluateAnswers(List<bool> answers) {
    final results = Map<Criterion, CriterionResult>.fromEntries(
      criteria.rawCriteriaKeys.map(
        (e) => MapEntry(
          e.criterion,
          evaluateCriterion(e, answers),
        ),
      ),
    );

    const adaptivityCriteria = [
      Criterion.behaviorRegulation,
      Criterion.communicationPotential,
      Criterion.militaryPredisposition,
    ];
    final adaptivityScore = adaptivityCriteria
        .map((c) => results[c]!)
        .map((r) => r.score)
        .fold(0, (a, b) => a + b);

    final adaptivityTier =
        determineTier(adaptivityScore, criteria.adaptivityThresholds);

    results[Criterion.collectedAdaptivityPotential] =
        CriterionResult(adaptivityScore, adaptivityTier);
    return AdaptivityResult(
      rawAnswers: answers,
      results: results,
    );
  }
}

class AdaptivityResult {
  final List<bool> rawAnswers;
  final Map<Criterion, CriterionResult> results;

  AdaptivityResult({
    required this.rawAnswers,
    required this.results,
  });
}
