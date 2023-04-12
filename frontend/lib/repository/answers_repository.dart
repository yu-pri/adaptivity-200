import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class AnswersRepository {
  static const _answersKey = 'quiz_answers';

  static const _storageMapping = {
    true: 't',
    false: 'f',
    null: 'n',
  };

  List<bool> _generateMockAnswers() => List.generate(200, (index) => Random().nextInt(2) == 1);

  Future<List<bool?>?> loadAnswers() async {
    return _generateMockAnswers();
    final decodeMapping =
        _storageMapping.map((key, value) => MapEntry(value, key));
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getString(_answersKey)
        ?.split('')
        .map((e) => decodeMapping[e])
        .toList();
  }

  Future<void> saveAnswers(List<bool?> answers) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized =
        answers.fold('', (accum, e) => accum + _storageMapping[e]!);
    await prefs.setString(_answersKey, serialized);
  }

  Future<void> clearAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_answersKey);
  }
}
