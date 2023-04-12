import 'package:adaptivity_200/config/routes.dart';
import 'package:adaptivity_200/state/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _highlightUnfilled = false;

  void _checkResults() {
    final qp = context.read<QuizProvider>();

    final quizChecked = qp.evaluateAnswers();
    final questionsUnfilled = qp.quizError == QuizError.questionsUnfilled;
    _highlightUnfilled = !quizChecked && questionsUnfilled;

    if (quizChecked) {
      Navigator.of(context).pushNamed(Routes.sendAnswers);
    }
  }

  void _reset() {
    final qp = context.read<QuizProvider>();
    qp.clearProgress();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 500;
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: _reset,
            child: const Text('Згенерувати інші \nвідповіді'),
          ),
          ElevatedButton(
            onPressed: _checkResults,
            child: const Text('Перевірити'),
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          final questions = quizProvider.questions;
          return ListView.builder(
            shrinkWrap: true,
            // itemExtent: isNarrow ? 150 : 100,
            itemBuilder: (context, index) {
              final question = questions[index];
              final isUnfilled = question.answer == null;
              final shouldHighlight = _highlightUnfilled && isUnfilled;
              return Container(
                decoration: BoxDecoration(
                    color: shouldHighlight ? Colors.red.withOpacity(0.2) : null,
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(
                            question.question,
                          )),
                      Expanded(
                        flex: 1,
                        child: isNarrow
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    _questionToggle(quizProvider, question),
                              )
                            : Row(
                                children:
                                    _questionToggle(quizProvider, question),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: questions.length,
          );
        },
      ),
    );
  }

  List<Widget> _questionToggle(
    QuizProvider quizProvider,
    QuizQuestion question,
  ) {
    return [
      InkWell(
        onTap: () {
          quizProvider.recordAnswer(question.id, true);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6)
          ),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: question.answer,
                onChanged: (_) {},
              ),
              const Text('так'),
            ],
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.all(2)),
      InkWell(
        onTap: () {
          quizProvider.recordAnswer(question.id, false);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Row(
            children: [
              Radio<bool>(
                value: false,
                groupValue: question.answer,
                onChanged: (_) {},
              ),
              const Text('ні'),
            ],
          ),
        ),
      ),
    ];
  }
}
