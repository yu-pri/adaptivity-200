import 'package:adaptivity_200/state/quiz_provider.dart';
import 'package:adaptivity_200/state/result_sender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendResultsScreen extends StatefulWidget {
  const SendResultsScreen({Key? key}) : super(key: key);

  @override
  State<SendResultsScreen> createState() => _SendResultsScreenState();
}

class _SendResultsScreenState extends State<SendResultsScreen> {
  final _nameFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _nameFieldController,
              decoration: const InputDecoration(
                label: Text('ПІБ'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (c) => SendConfirmationDialog(
                    name: _nameFieldController.text,
                  ),
                );
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Надіслати'),
            ),
          ],
        ),
      ),
    );
  }
}

class SendConfirmationDialog extends StatelessWidget {
  final String name;

  const SendConfirmationDialog({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultSender>(builder: (context, sender, _) {
      return AlertDialog(
        title: const Text('Надіслати результати?'),
        content: Column(
          children: [
            const Text('Будь ласка, перевірте введені дані:'),
            Text('ПІБ: $name'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Відміна'),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                sender.share(name, sender.result);
                context.read<QuizProvider>().clearProgress();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Помилка надсилання.'),
                  ),
                );
              }
              Navigator.of(context).pop();
            },
            child: const Text('Надіслати'),
          )
        ],
      );
    });
  }
}
