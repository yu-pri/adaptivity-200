import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_result.dart';
import 'package:archive/archive.dart';

class AdaptivityResultEncoder {
  Uint8List convert(DateTime dt, String name, AdaptivityResult input) {
    final raw = formatRawAnswers(dt, name, input.questions, input.rawAnswers);
    final results = formatResults(input.results);

    final archive = Archive();
    [
      _zipStringFile('відповіді.csv', raw),
      _zipStringFile('результат.csv', results),
    ].forEach(archive.addFile);

    return ZipEncoder().encode(archive) as Uint8List;
  }

  ArchiveFile _zipStringFile(String name, String contents) {
    final inputStream = InputStream(const Utf8Encoder().convert(contents));
    return ArchiveFile.stream(name, inputStream.length, inputStream);
  }

  static String formatResults(Map<Criterion, CriterionResult> r) {
    const sortOrder = [
      Criterion.testReliability,
      Criterion.collectedAdaptivityPotential,
      Criterion.behaviorRegulation,
      Criterion.communicationPotential,
      Criterion.moralNormativity,
      Criterion.militaryPredisposition,
      Criterion.deviancy,
      Criterion.suicideRisk,
    ];

    final sb = StringBuffer();
    final header = ['Критерій', 'Бали', 'Стен'].join(',');

    sb.writeln(header);
    for (final c in sortOrder) {
      final result = r[c]!;
      final line = [c.key, result.score, result.tier].join(',');
      sb.writeln(line);
    }
    return sb.toString();
  }

  static String formatRawAnswers(
      DateTime d, String name, List<String> questions, List<bool> answers) {
    assert(questions.length == answers.length);

    final headerRow = ['Час', 'адреса ел. пошти', 'ПІП:Звання:Посада'];
    final dataRow = [d.toIso8601String(), '', name];

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      headerRow.add('"${i + 1}. $q"');
      dataRow.add(answers[i] ? 'ТАК' : 'НІ');
    }

    final sb = StringBuffer();
    for (final row in [headerRow, dataRow]) {
      sb.writeln(row.join(','));
    }
    return sb.toString();
  }
}
