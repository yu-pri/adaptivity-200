import 'dart:math';

import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/core/definitions/model/tier_range.dart';
import 'package:adaptivity_200/core/utility/list_order_utils.dart';
import 'package:adaptivity_200/domain/static_parser/parse_questions_static.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  const FileSystem fs = LocalFileSystem();

  group('randomize list order', ()  {
    const input = ['a', 'b', 'c'];
    final cases = [
      [[0, 1, 2], ['a', 'b', 'c']],
      [[2, 1, 0], ['c', 'b', 'a']],
    ];

    for (final testcase in cases) {
      final order = testcase[0] as List<int>;
      final expectedResult = testcase[1];
      test('$order -> $expectedResult', () {
        final result = ListOrderUtils.applyOrder(input, order).toList();
        expect(result, equals(expectedResult));
      });
    }
  });

  group('determine tier', () {
    final tierRanges = [
      TierRange(tier: 0, min: 0, max: 10),
      TierRange(tier: 1, min: 11, max: 20),
      TierRange(tier: 2, min: 21, max: 100),
    ];

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
        final tier = AdaptivityResultEvaluator.determineTier(score, tierRanges);
        expect(tier, expectedTier);
      });
    }
  });

  group('apply mask', () {
    final cases = [
      [
        [true, true, true],
        [true, true, true],
        3
      ],
      [
        [false, false, false],
        [true, true, true],
        0
      ],
      [
        [false, false, false],
        [false, false, false],
        3
      ],
      [
        [true, false, false],
        [true, false, false],
        3
      ],
      [
        [false, true, false],
        [true, false, true],
        0
      ],
      [
        [true, true, true],
        [true, false, false],
        1
      ],
      [
        [true, true, true],
        [true, true, false],
        2
      ],
      [
        [true, true, true],
        [null, true, true],
        2
      ],
      [
        [true, true, true],
        [null, null, true],
        1
      ],
      [
        [true, true, true],
        [null, null, null],
        0
      ],
    ];

    for (final c in cases) {
      final answers = c[0] as List<bool>;
      final mask = c[1] as List<bool?>;
      final expectedCount = c[2] as int;

      test('$answers | $mask -> $expectedCount', () {
        final count = AdaptivityResultEvaluator.applyMaskAndCount(answers, mask);
        expect(count, expectedCount);
      });
    }
  });

  test('E2E randomized', () async {
    final criteriaFile =
        fs.file('../test_data/question_categories.yml').readAsStringSync();
    final yml = loadYaml(criteriaFile) as YamlMap;
    final parsedCriteria = parseEvaluationCriteria(yml);
    final evaluator = AdaptivityResultEvaluator(criteria: parsedCriteria);

    for (int i = 0; i < 10000; i++) {
      final buf = StringBuffer();
      buf.write('$i: ');
      final answers = List.generate(200, (_) => Random().nextInt(3) == 0);

      final result = evaluator.evaluateAnswers(answers);
      for (final e in result.results.entries) {
        buf.write('${e.key.name}: ${e.value.score} : ${e.value.tier} ');
      }
      print(buf.toString());
    }
  });
}
