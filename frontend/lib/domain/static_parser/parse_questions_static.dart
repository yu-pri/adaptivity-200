
import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_evaluation_keys.dart';
import 'package:adaptivity_200/core/definitions/model/tier_range.dart';
import 'package:yaml/yaml.dart';

List<bool?> parseCriterionMask(YamlMap mapping) {
  final mask = List<bool?>.generate(200, (_) => null);

  final pos = mapping['pos'] ?? [];
  for (final questionIdx in pos) {
    mask[questionIdx - 1] = true;
  }

  final neg = mapping['neg'] ?? [];
  for (final questionIdx in neg) {
    mask[questionIdx - 1] = false;
  }

  return mask;
}

TierRange parseTierEntry(MapEntry entry) {
  final tier = entry.key;
  final range = entry.value as YamlList;

  final int min = range[0];
  final int max = range.length == 1 ? min : range[1];

  return TierRange(tier: tier, min: min, max: max);
}

List<TierRange> parseTierRanges(dynamic data) {
  return (data as YamlMap).entries.map(parseTierEntry).toList();
}

EvaluationCriteria parseEvaluationCriteria(Map config) {
  final criterionMaskLists = config['question_categories'] as Map;
  final thresholdsMap = config['thresholds'] as Map;
  final parsedCriteria = <CriterionEvaluationKeys>[];
  for (final cat in Criterion.rawCriteria) {
    List<bool?>? mask;
    if (criterionMaskLists.containsKey(cat.key)) {
      final questions = criterionMaskLists[cat.key] as YamlMap;
      mask = parseCriterionMask(questions);
    }

    final thresholds = parseTierRanges(thresholdsMap[cat.key]);

    parsedCriteria.add(
        CriterionEvaluationKeys(cat, mask, thresholds.reversed.toList()));
  }

  final adaptivityTiers = parseTierRanges(config['adaptivity_thresholds']);

  return EvaluationCriteria(
    adaptivityThresholds: adaptivityTiers,
    rawCriteriaKeys: parsedCriteria,
  );
}

