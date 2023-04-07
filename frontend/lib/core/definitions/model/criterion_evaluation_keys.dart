import 'package:adaptivity_200/core/definitions/model/criterion.dart';

class CriterionEvaluationKeys {
  final Criterion criterion;
  final List<bool?>? evaluationMask;
  final List<int> tierThresholds;

  CriterionEvaluationKeys(this.criterion, this.evaluationMask, this.tierThresholds);

  @override
  String toString() {
    return '$criterion: ${evaluationMask?.where((v) => v != null).length}, $tierThresholds';
  }
}

