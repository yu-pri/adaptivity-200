import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/repository/evaluation_criteria_repository.dart';
import 'package:adaptivity_200/repository/questions_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('loads questions', () async {
    final qs = await QuestionsRepository().load();
    expect(qs.length, 200);

    expect(qs.first, 'Буває, що я серджуся');
    expect(qs.last,
        'Я думаю, що будь-яке положення законів і військових статутів можна тлумачити двояко');
  });

  test('loads evaluation mask', () async {
    final ev = await EvaluationCriteriaRepository().load();

    expect(
      ev.rawCriteriaKeys.map((e) => e.criterion).toSet(),
      Criterion.rawCriteria.toSet(),
    );
  });
}
