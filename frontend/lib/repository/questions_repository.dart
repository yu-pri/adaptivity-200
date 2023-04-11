import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsRepository {
  Future<List<String>> load() async {
    final file = await rootBundle.loadString('assets/quiz/questions.txt');
    final questions = file.split('\n');
    questions.removeLast();
    return questions;
  }

  static const _orderKey = 'quiz_order';

  Future<List<int>?> loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_orderKey)?.map((e) => int.parse(e)).toList();
  }

  Future<void> saveOrder(List<int> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_orderKey, order.map((e) => '$e').toList());
  }

  Future<void> clearOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_orderKey);
  }
}
