import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/repository/evaluation_criteria_repository.dart';
import 'package:adaptivity_200/repository/questions_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('loads questions', () async {
    final qs = await QuestionsRepository().load();
    expect(qs.length, 200);

    expect(qs.first, 'Буває, що я серджуся');
    expect(qs.last,
        'Я думаю, що будь-яке положення законів і військових статутів можна тлумачити двояко');
  });

  test('saves order', () async {
    const input = [1, 2, 0];
    final qs = QuestionsRepository();

    await qs.saveOrder(input);
    final savedOrder = await qs.loadOrder();
    expect(input, savedOrder);

    await qs.clearOrder();
    final cleared = await qs.loadOrder();
    expect(cleared, isNull);
  });
}
