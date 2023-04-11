import 'package:file/file.dart';

abstract class FileRepository<T> {
  T decode(File f);
}