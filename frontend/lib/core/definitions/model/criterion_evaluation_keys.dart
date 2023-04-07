import 'package:adaptivity_200/core/definitions/model/criterion.dart';

class CriterionEvaluationKeys {
  final Criterion criterion;
  final List<int> questionIndices;
  final List<int> tierThresholds;

  CriterionEvaluationKeys(this.criterion, this.questionIndices, this.tierThresholds);
}

