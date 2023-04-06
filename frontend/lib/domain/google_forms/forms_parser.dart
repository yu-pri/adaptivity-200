import 'dart:convert';

import 'package:adaptivity_200/core/definitions/model/answers.dart';
import 'package:archive/archive.dart';
import 'package:file/file.dart';

class FormsParser {
  List<Answers> parse(File f) {
    
    for (final f in ZipDecoder().decodeBytes(f.readAsBytesSync()).files) {
    }
    return f.readAsLinesSync().skip(1).map(AnswerFormData().convert).toList();
  }
}

class AnswerFormData extends Converter<String, Answers> {
  @override
  Answers convert(String input) {
    final fields = input.split(',');

    final ts = DateTime.parse(fields[0]);
    final email = fields[1];

    final answers = fields.skip(2).map((a) => a == 'так').toList();

    return Answers(email: email, timestamp: ts, questions: answers);
  }

}