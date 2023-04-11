import 'package:adaptivity_200/state/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          final questions = quizProvider.questions;
          return ListView.separated(
            itemBuilder: (context, index) {
              final question = questions[index];
              bool? _pickedOption = null;
              return ListTile(
                title: Text(question.question),
                trailing: Row(
                  children: [
                    const Text('так'),
                    Radio<bool>(
                      value: true,
                      groupValue: _pickedOption,
                      onChanged: (v) => quizProvider.recordAnswer(question.id, v!),
                    ),
                    const Text('ні'),
                    Radio<bool>(
                      value: false,
                      groupValue: _pickedOption,
                      onChanged: (v) => quizProvider.recordAnswer(question.id, v!),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (c, _) => const Divider(),
            itemCount: questions.length,
          );
        },
      ),
    );
  }
}
