import 'package:adaptivity_200/core/definitions/model/criterion_result.dart';

abstract class AdaptivityResultEvaluator {
  AdaptivityResult check(List<bool> answers);
}

class AdaptivityResult {
  final List<CriterionResult> results;

  AdaptivityResult(this.results);
}