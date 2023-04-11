import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/core/definitions/model/tier_range.dart';

class EvaluationCriteria {
  final List<TierRange> adaptivityThresholds;
  final List<CriterionEvaluationKeys> rawCriteriaKeys;

  EvaluationCriteria({
    required this.adaptivityThresholds,
    required this.rawCriteriaKeys,
  });
}

class CriterionEvaluationKeys {
  final Criterion criterion;
  final List<bool?>? evaluationMask;
  final List<TierRange> tierThresholds;

  CriterionEvaluationKeys(
      this.criterion, this.evaluationMask, this.tierThresholds);

  @override
  String toString() {
    return '$criterion: ${evaluationMask?.where((v) => v != null).length}, $tierThresholds';
  }
}
