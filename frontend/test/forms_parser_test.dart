import 'dart:math';

import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_evaluation_keys.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_result.dart';
import 'package:adaptivity_200/domain/google_forms/forms_parser.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  const FileSystem fs = LocalFileSystem();
  late FormsParser sut;

  setUp(() {
    sut = FormsParser();
  });

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

  List<CriterionEvaluationKeys> parseEvaluationCriteria(Map config) {
    final criterionMaskLists = config['question_categories'] as Map;
    final thresholdsMap = config['thresholds'] as Map;
    final parsedCriteria = <CriterionEvaluationKeys>[];
    for (final cat in Criterion.rawCriteria) {
      List<bool?>? mask;
      if (criterionMaskLists.containsKey(cat.key)) {
        final questions = criterionMaskLists[cat.key] as YamlMap;
        mask = parseCriterionMask(questions);
      }

      final thresholds = thresholdsMap.containsKey(cat.key)
          ? (thresholdsMap[cat.key] as List).cast<int>()
          : <int>[];

      parsedCriteria.add(
          CriterionEvaluationKeys(cat, mask, thresholds.reversed.toList()));
    }
    return parsedCriteria;
  }

  int applyMaskAndCount(List<bool> answers, List<bool?> mask) {
    assert(answers.length == mask.length);
    int matchCount = 0;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == mask[i]) matchCount += 1;
    }
    return matchCount;
  }

  int determineTier(int score, List<int> upperTierThresolds) {
    if (score > upperTierThresolds.last) return upperTierThresolds.length;
    if (score <= upperTierThresolds.first) return 0;

    final satisfiedThreshold =
        upperTierThresolds.firstWhere((threshold) => score > threshold);
    return upperTierThresolds.indexOf(satisfiedThreshold) + 1;
  }

  CriterionResult evaluateCriterion(
      CriterionEvaluationKeys keys, List<bool> answers) {
    final score = applyMaskAndCount(answers, keys.evaluationMask!);
    final tier = determineTier(score, keys.tierThresholds);
    return CriterionResult(keys.criterion, score, tier);
  }

  List<CriterionResult> evaluateAnswers(
      List<bool> answers, List<CriterionEvaluationKeys> criteria) {
    final results = criteria.map((e) => evaluateCriterion(e, answers)).toList();

    const adaptivityCriteria = [
      Criterion.behaviorRegulation,
      Criterion.communicationPotential,
      Criterion.militaryPredisposition,
    ];
    final adaptivityScore = results
        .where((r) => adaptivityCriteria.contains(r.criterion))
        .map((r) => r.score)
        .fold(0, (a, b) => a + b);

    const adaptivityTier = 0;

    return [
      CriterionResult(
        Criterion.collectedAdaptivityPotential,
        adaptivityScore,
        adaptivityTier,
      ),
      ...results,
    ];
  }

  group('determine tier', () {
    final tierThresholds = [10, 20];

    final cases = {
      0: 0,
      10: 0,
      11: 1,
      15: 1,
      19: 1,
      20: 1,
      21: 2,
    };

    for (final entry in cases.entries) {
      final score = entry.key;
      final expectedTier = entry.value;
      test('$score -> $expectedTier', () {
        final tier = determineTier(score, tierThresholds);
        expect(tier, expectedTier);
      });
    }
  });

  // test('FormsParser', () async {
  //   final file = fs.file('../test_data/questions.txt');
  //
  //   expect(await file.exists(), isTrue);
  //
  //   final lines = file.readAsLinesSync();
  //   expect(lines.length, 200);
  //
  //   final criteriaFile = fs.file('../test_data/question_categories.yml').readAsStringSync();
  //   final yml = loadYaml(criteriaFile) as YamlMap;
  //   final parsedCriteria = parseEvaluationCriteria(yml);
  //
  //   print(parsedCriteria);
  //
  //   final answers = List.generate(200, (_) => Random().nextInt(1) == 0);
  //
  //
  //   final result = evaluateAnswers(answers);
  //   print(result);
  // });
}
