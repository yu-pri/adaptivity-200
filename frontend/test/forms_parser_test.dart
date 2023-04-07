

import 'package:adaptivity_200/domain/google_forms/forms_parser.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const FileSystem fs = LocalFileSystem();
  late FormsParser sut;

  setUp(() {
    sut = FormsParser();
  });

  test('FormsParser', () async {
    final file = fs.file('test/test_data/form.csv.zip');

    expect(await file.exists(), isTrue);

    final out = sut.parse(file);
    print(out);
  });
}