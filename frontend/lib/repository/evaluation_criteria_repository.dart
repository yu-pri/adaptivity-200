import 'package:adaptivity_200/core/definitions/model/criterion_evaluation_keys.dart';
import 'package:adaptivity_200/domain/static_parser/parse_questions_static.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class EvaluationCriteriaRepository {
  Future<EvaluationCriteria> load() async {
    final file = await rootBundle.loadString('assets/quiz/question_categories.yml');
    final m = loadYaml(file);
    return parseEvaluationCriteria(m);
  }
}