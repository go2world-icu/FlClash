import 'dart:convert';
import 'dart:typed_data';

import 'package:fl_clash/models/models.dart';
import 'package:flutter/foundation.dart';

import 'log_redaction.dart';

Future<Uint8List> encodeLogReport(List<Log> logs) =>
    compute(_encodeReport, logs);

Uint8List _encodeReport(List<Log> logs) =>
    utf8.encode(redactLogMessage(logs.map((log) => log.toString()).join('\n')));
