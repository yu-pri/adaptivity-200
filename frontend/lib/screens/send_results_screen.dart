import 'package:adaptivity_200/core/definitions/model/responder.dart';
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
  final _surnameFieldController = TextEditingController();
  final _fathersNameFieldController = TextEditingController();
  final _nameFieldController = TextEditingController();
  final _rankFieldController = TextEditingController();
  final _positionFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _requireNotEmpty(String? v) {
    const fieldRequired = 'Обовʼязкове поле';
    if (v == null) return fieldRequired;
    if (v.trim().isEmpty) return fieldRequired;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: _surnameFieldController,
                      validator: _requireNotEmpty,
                      decoration: const InputDecoration(
                        label: Text('Прізвище'),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: _requireNotEmpty,
                      controller: _nameFieldController,
                      decoration: const InputDecoration(
                        label: Text('Імʼя'),
                      ),
                    ),
                    TextFormField(
                      controller: _fathersNameFieldController,
                      decoration: const InputDecoration(
                        label: Text('По батькові'),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: _requireNotEmpty,
                      controller: _rankFieldController,
                      decoration: const InputDecoration(
                        label: Text('Звання'),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: _requireNotEmpty,
                      controller: _positionFieldController,
                      decoration: const InputDecoration(
                        label: Text('Посада'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 12)),
            ElevatedButton(
              onPressed: () async {
                final fieldsFilled = _formKey.currentState?.validate() ?? false;
                if (!fieldsFilled) return;
                final responder = Responder(
                  name: _nameFieldController.text,
                  surname: _surnameFieldController.text,
                  fathersName: _fathersNameFieldController.text,
                  rank: _rankFieldController.text,
                  position: _positionFieldController.text,
                );

                final didSend = await showDialog(
                      context: context,
                      builder: (c) => SendConfirmationDialog(
                        responder: responder,
                      ),
                    ) ??
                    false;
                if (mounted && didSend) Navigator.of(context).pop();
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
  final Responder responder;

  const SendConfirmationDialog({
    Key? key,
    required this.responder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultSender>(builder: (context, sender, _) {
      return AlertDialog(
        title: const Text('Надіслати результати?'),
        content: Column(
          children: [
            const Text('Будь ласка, перевірте введені дані:'),
            Text('ПІБ: ${responder.fullName}'),
            Text('Звання: ${responder.rank}'),
            Text('Посада: ${responder.position}'),
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
                sender.share(responder, sender.result);
                context.read<QuizProvider>().clearProgress();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Помилка надсилання.'),
                  ),
                );
              }
              Navigator.of(context).pop(true);
            },
            child: const Text('Надіслати'),
          )
        ],
      );
    });
  }
}
