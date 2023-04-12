import 'dart:typed_data';

import 'package:adaptivity_200/core/definitions/adaptivity_result_evaluator.dart';
import 'package:adaptivity_200/domain/result_encoders/zip/encoder.dart';
import 'package:download/download.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ResultSender extends ChangeNotifier {
  final AdaptivityResult result;
  bool _loading = false;
  bool _error = false;
  String? _message;

  ResultSender({
    required this.result,
  });

  bool get loading => _loading;

  String? get message => _message;

  bool get error => _error;

  Future<ShareResultStatus> _tryShare(String name,
      Uint8List data) async {
    final f = XFile.fromData(
      data,
      name: name,
      mimeType: 'application/zip',
    );

    try {
      final s = await Share.shareXFiles([f]);
      return s.status;
    } catch (e) {
      return ShareResultStatus.unavailable;
    }
  }
  void share(
    String name,
    AdaptivityResult quizResult,
  ) async {
    final encodedResult = AdaptivityResultEncoder().convert(quizResult);
    final now = DateTime.now().toIso8601String();
    final zipname = '$now $name.zip';
    final shareF = _tryShare(zipname, encodedResult);
    _loading = true;
    notifyListeners();

    final shareResult = await shareF;
    if (!hasListeners) return;

    if (shareResult == ShareResultStatus.dismissed) {
      _loading = false;
      notifyListeners();
      return;
    }

    if (shareResult == ShareResultStatus.unavailable) {
      await download(Stream.fromIterable(encodedResult), zipname);
    }

    _loading = false;
    notifyListeners();
  }
}
