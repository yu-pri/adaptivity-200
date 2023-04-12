import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/core/definitions/model/criterion.dart';
import 'package:adaptivity_200/core/definitions/model/criterion_result.dart';
import 'package:archive/archive.dart';
import 'package:collection/collection.dart';

class AdaptivityResultEncoder extends Converter<AdaptivityResult, Uint8List> {
  @override
  Uint8List convert(AdaptivityResult input) {
    final raw = formatRawAnswers(input.rawAnswers);
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

  static String formatRawAnswers(List<bool> answers) {
    final sb = StringBuffer();
    final lines =
        answers.mapIndexed((i, a) => '${i + 1}\t${a ? 'так' : 'ні'}\n');
    sb.writeAll(lines);
    return sb.toString();
  }
}
